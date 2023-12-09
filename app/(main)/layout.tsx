import Navbar from "@/components/navbar";
import React from "react";

const Layout = ({ children }: { children: React.ReactNode }) => {
  return (
    <div className="min-h-screen flex flex-col gap-4">
      <Navbar />
      <div className="">{children}</div>
    </div>
  );
};

export default Layout;
