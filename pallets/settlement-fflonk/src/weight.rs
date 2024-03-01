
//! Autogenerated weights for `pallet_settlement_fflonk`
//!
//! THIS FILE WAS AUTO-GENERATED USING THE SUBSTRATE BENCHMARK CLI VERSION 31.0.0
//! DATE: 2024-02-22, STEPS: `50`, REPEAT: `30`, LOW RANGE: `[]`, HIGH RANGE: `[]`
//! WORST CASE MAP SIZE: `1000000`
//! HOSTNAME: `giacomo-Virtual-Machine`, CPU: `11th Gen Intel(R) Core(TM) i7-11800H @ 2.30GHz`
//! WASM-EXECUTION: `Compiled`, CHAIN: `Some("dev")`, DB CACHE: `1024`

// Executed Command:
// ./target/production/nh-node
// benchmark
// pallet
// --chain
// dev
// --execution=wasm
// --wasm-execution=compiled
// --pallet
// pallet_settlement_fflonk
// --extrinsic
// *
// --steps
// 50
// --repeat
// 30
// --output
// pallets/settlement-fflonk/src/weight.rs
// --template
// node/frame-weight-template.hbs

#![cfg_attr(rustfmt, rustfmt_skip)]
#![allow(unused_parens)]
#![allow(unused_imports)]
#![allow(missing_docs)]

use frame_support::{traits::Get, weights::{Weight, constants::RocksDbWeight}};
use core::marker::PhantomData;

/// Weight functions needed for `pallet_settlement_fflonk`.
pub trait WeightInfo {
	fn submit_proof() -> Weight;
}

/// Weights for `pallet_settlement_fflonk` using the Substrate node and recommended hardware.
pub struct SubstrateWeight<T>(PhantomData<T>);
impl<T: frame_system::Config> WeightInfo for SubstrateWeight<T> {
	fn submit_proof() -> Weight {
		// Proof Size summary in bytes:
		//  Measured:  `0`
		//  Estimated: `0`
		// Minimum execution time: 15_835_193_000 picoseconds.
		Weight::from_parts(15_965_294_000, 0)
	}
}

// For backwards compatibility and tests.
impl WeightInfo for () {
	fn submit_proof() -> Weight {
		// Proof Size summary in bytes:
		//  Measured:  `0`
		//  Estimated: `0`
		// Minimum execution time: 15_835_193_000 picoseconds.
		Weight::from_parts(15_965_294_000, 0)
	}
}