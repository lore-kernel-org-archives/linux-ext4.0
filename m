From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [regression][dev] IO failure is hitted by xfstest 083
Date: Thu, 11 Apr 2013 20:17:40 +0800
Message-ID: <20130411121740.GA3388@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58685 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933510Ab3DKMAl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Apr 2013 08:00:41 -0400
Received: by mail-pd0-f177.google.com with SMTP id u11so813627pdi.22
        for <linux-ext4@vger.kernel.org>; Thu, 11 Apr 2013 05:00:41 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I run xfstests #083 against dev branch of ext4 tree, and a regression is
hitted.  This file system is with bigalloc feature.  The error msg looks
like the following.  I found the regression is introduced by this
commit: d7ddbabdf6e771b9793aaa7da9c3e9dc4cd376ab
    ext4: move quota initialization out of inode allocation transaction

But I doubt this isn't the root cause.

Regards,
                                                - Zheng

wenqing: run xfstest 083
kernel: EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: acl,user_xattr
kernel: EXT4-fs error (device sda2) in ext4_reserve_inode_write:4955: IO failure
kernel: EXT4-fs error (device sda2) in ext4_reserve_inode_write:4955: IO failure
kernel: EXT4-fs error (device sda2) in ext4_reserve_inode_write:4955: IO failure
kernel: EXT4-fs warning (device sda2): ext4_evict_inode:257: couldn't mark inode dirty (err -5)
kernel: EXT4-fs warning (device sda2): ext4_evict_inode:257: couldn't mark inode dirty (err -5)
kernel: EXT4-fs warning (device sda2): ext4_evict_inode:257: couldn't mark inode dirty (err -5)
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: JBD2: Spotted dirty metadata buffer (dev = sda2, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: EXT4-fs error (device sda2): ext4_free_inode:319: comm fsstress: bit already cleared for inode 1592
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: EXT4-fs error (device sda2): ext4_free_inode:319: comm fsstress: bit already cleared for inode 699
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: JBD2: Spotted dirty metadata buffer (dev = sda2, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: EXT4-fs error (device sda2): ext4_free_inode:319: comm fsstress: bit already cleared for inode 1592
kernel: EXT4-fs error (device sda2): ext4_free_inode:319: comm fsstress: bit already cleared for inode 1592
kernel: JBD2: Spotted dirty metadata buffer (dev = sda2, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: JBD2: Spotted dirty metadata buffer (dev = sda2, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: EXT4-fs error (device sda2): ext4_free_inode:319: comm fsstress: bit already cleared for inode 1592
kernel: EXT4-fs error (device sda2): ext4_free_inode:319: comm fsstress: bit already cleared for inode 1592
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: JBD2: Spotted dirty metadata buffer (dev = sda2, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
kernel: EXT4-fs error (device sda2): ext4_free_inode:319: comm fsstress: bit already cleared for inode 699
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: JBD2: Spotted dirty metadata buffer (dev = sda2, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
kernel: JBD2: Spotted dirty metadata buffer (dev = sda2, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: JBD2: Spotted dirty metadata buffer (dev = sda2, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
kernel: EXT4-fs error (device sda2): ext4_free_inode:319: comm fsstress: bit already cleared for inode 699
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: JBD2: Spotted dirty metadata buffer (dev = sda2, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: JBD2: Spotted dirty metadata buffer (dev = sda2, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: JBD2: Spotted dirty metadata buffer (dev = sda2, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
kernel: EXT4-fs error (device sda2): ext4_free_inode:319: comm fsstress: bit already cleared for inode 1592
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
kernel: EXT4-fs error (device sda2) in __ext4_new_inode:962: IO failure
