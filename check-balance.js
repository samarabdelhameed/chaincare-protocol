const { ApiPromise, WsProvider } = require('@polkadot/api');
const fs = require('fs');

async function checkBalance() {
  // Load .env
  const envContent = fs.readFileSync('.env', 'utf8');
  const rpcUrl = envContent.match(/RPC_URL=(.+)/)[1].trim();
  const address = envContent.match(/ADDRESS=(.+)/)[1].trim();
  
  console.log('🔍 Checking balance...');
  console.log('🌐 RPC:', rpcUrl);
  console.log('👤 Address:', address);
  console.log('');
  
  const provider = new WsProvider(rpcUrl);
  const api = await ApiPromise.create({ provider });
  
  try {
    const accountInfo = await api.query.system.account(address);
    const balance = accountInfo.data.free;
    const balanceFormatted = balance.toHuman();
    
    console.log('✅ Balance found!');
    console.log('💰 Balance:', balanceFormatted);
    console.log('');
    
    // Check if balance is sufficient (at least 0.1 WND)
    const balanceNumber = parseFloat(balanceFormatted.replace(/[^\d.]/g, ''));
    if (balanceNumber < 0.1) {
      console.log('⚠️  Warning: Balance is low!');
      console.log('   You need at least 0.1 WND for deployment.');
      console.log('   Get tokens from: https://faucet.polkadot.io/');
    } else {
      console.log('✅ Balance is sufficient for deployment!');
    }
  } catch (error) {
    console.error('❌ Error:', error.message);
  } finally {
    await api.disconnect();
  }
}

checkBalance().catch(console.error);
