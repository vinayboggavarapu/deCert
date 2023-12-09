"use client";
import { useWeb3Modal } from "@web3modal/wagmi/react";
import Link from "next/link";
import React, { useEffect } from "react";
// import { useWindowScroll } from "react-use";
import { useAccount, useDisconnect } from "wagmi";

const Navbar = () => {
  const { open } = useWeb3Modal();
  const { disconnect } = useDisconnect();
  const { address } = useAccount();
  const [isMounted, setIsMounted] = React.useState(false);
  useEffect(() => {
    setIsMounted(true);
  }, []);
  if (!isMounted) {
    return null;
  }
  return (
    <div className="flex sticky top-0 z-[1000] bg-white justify-between items-center p-2">
      <Link href="/">
        <h1 className="text-2xl cursor-pointer">Decert.</h1>
      </Link>
      <ul className="hidden md:flex border-black border gap-10 py-2.5 px-10 rounded-full">
        <Link href="/">Home</Link>
        <Link href="/user">
          <button>User</button>
        </Link>
        <Link href="/issuer">
          <button>Issuer</button>
        </Link>
      </ul>
      <>
        {!address ? (
          <button
            className="text-md py-2.5 px-6 rounded-full bg-black text-[#cccc]"
            onClick={() => {
              open();
            }}
          >
            Connect Wallet
          </button>
        ) : (
          <button
            className="text-md py-2 px-6 rounded-full bg-blue-600 text-white"
            onClick={() => {
              disconnect();
            }}
          >
            Logout
          </button>
        )}
      </>
    </div>
  );
};

export default Navbar;
