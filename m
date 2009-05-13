From: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Thu, 14 May 2009 09:26:18 +0930
Message-ID: <20090513235618.GC4914@kulgan>
References: <20090513062634.GE4972@kulgan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bowden.ucwb.org.au ([203.122.237.119]:42412 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbZEMX4S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 May 2009 19:56:18 -0400
Received: from kulgan.wumi.org.au (unknown [192.168.0.62])
	by mail.ucwb.org.au (Postfix) with ESMTP id D2EAE4BCF8
	for <linux-ext4@vger.kernel.org>; Thu, 14 May 2009 09:26:18 +0930 (CST)
Content-Disposition: inline
In-Reply-To: <20090513062634.GE4972@kulgan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 13, 2009 at 03:56:34PM +0930, Kevin Shanahan wrote:
> And following the same formula as last time(s):
> 
> hermes:~# debugfs /dev/dm-0
> debugfs:  stat "local/apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLPROF.IF"
> invalid inode->i_extra_isize (8224)
> Inode: 2542   Type: bad type    Mode:  0043   Flags: 0x5849462f
> Generation: 538970637    Version: 0x66663030:535f4445
> User: 538980401   Group: 538993001   Size: 996566576
> File ACL: 538976288    Directory ACL: 0
> Links: 8812   Blockcount: 35322822674750
> Fragment:  Address: 538976288    Number: 0    Size: 0
>  ctime: 0x41462d54:65636166 -- Tue Sep 14 08:59:24 2004
>  atime: 0x4e4f4620:63206c61 -- Sat Aug 20 14:59:04 2011
>  mtime: 0x594c494d:6972413d -- Fri Jun 23 08:18:45 2017
> crtime: 0x726f6c6f:3138233d -- Sun Nov  3 13:24:39 2030
> dtime: 0x7241203a -- Sun Sep 29 09:35:14 2030
> Size of extra inode fields: 8224
> BLOCKS:
> 
> debugfs:  imap "local/apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLPROF.IF"
> Inode 2542 is part of block group 0
>         located at block 447, offset 0x0d00
> 
> hermes:~# dd if=/dev/dm-0 of=block-447.dump bs=4k skip=447 count=1
> 1+0 records in
> 1+0 records out
> 4096 bytes (4.1 kB) copied, 0.0121164 s, 338 kB/s
> 
> Now, this is (possibly) interesting - that block contains a bunch of
> file data. Looks like a html email (I can tell it's email because of
> the FIXED_ prefix added to the tags by the mail sanitizer).
> 
> If I can locate the source of that data, perhaps it will point to
> where the corruption is coming from? Any tips on scanning for the
> data? I'll start with simple find and grep and see how far I get.

I didn't find this in any file in the current directory structure. I
guess it could be old data that hadn't been zeroed out.

However, the only binary data I can see seems to be at offset 0x0155
(341), nowhere near offset 0x0d00 (unless I misunderstand the imap
output above. Does that little blob of binary data make any sense as
an inode?

Cheers,
Kevin.
