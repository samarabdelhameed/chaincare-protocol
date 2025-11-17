#!/usr/bin/env python3
import asyncio, json, datetime, os
from substrateinterface import SubstrateInterface, Keypair
from bleak import BleakClient

RPC_URL   = os.getenv("RPC_URL", "wss://ws.paseo.ara.io")
MNEMONIC  = os.getenv("MNEMONIC")
CONTRACT  = "5Go...med_reminder"  # Update after deployment
UUID      = "00002a00-0000-1000-8000-00805f9b34fb"

keypair   = Keypair.create_from_uri(MNEMONIC)
substrate = SubstrateInterface(url=RPC_URL)

def handle_data(sender, data):
    if data == b"taken":
        call = substrate.compose_call(
            call_module="MedReminder",
            call_function="check_in",
            call_params={"timestamp": int(datetime.datetime.utcnow().timestamp())}
        )
        extrinsic = substrate.create_signed_extrinsic(call, keypair)
        receipt = substrate.submit_extrinsic(extrinsic, wait_for_inclusion=True)
        print("MedTaken tx:", receipt.extrinsic_hash)

async def main():
    async with BleakClient(UUID) as client:
        await client.start_notify(UUID, handle_data)
        await asyncio.sleep(3600)

if __name__ == "__main__":
    asyncio.run(main())
