From: Behan Webster <behanw@converseincode.com>
Subject: [PATCH] Removing the use of VLAIS from the Linux Kernel
Date: Tue, 30 Oct 2012 14:40:03 -0400
Message-ID: <1351622404-18214-1-git-send-email-behanw@converseincode.com>
Cc: linux-ext4@vger.kernel.org,
	Behan Webster <behanw@converseincode.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58819 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab2J3Sjs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Oct 2012 14:39:48 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so885286iea.19
        for <linux-ext4@vger.kernel.org>; Tue, 30 Oct 2012 11:39:47 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
precludes the use of compilers which don't implement VLAIS (for instance the
Clang compiler). The LLVMLinux Project is working towards the ability of
providing the Linux kernel developer the choice of using the Clang compiler
toolchain. This is a part of a series of patches which remove the use of VLAIS
from crypto code, dm-crypt, jbd2, libcrc32c, netfilter, and usb gadget. Other
patches to allow Clang to be used will follow.


Mark Charlebois (1):
  Remove VLAIS usage from JBD2 code

 include/linux/jbd2.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
1.7.9.5

