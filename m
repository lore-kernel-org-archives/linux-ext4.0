From: Leonard Michlmayr <leonard.michlmayr@gmail.com>
Subject: Re: [PATCH 11/28] ext4: correctly calculate number of blocks for
 fiemap
Date: Thu, 04 Mar 2010 22:44:58 +0100
Message-ID: <1267739098.4204.12.camel@michlmayr>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
	 <1267553925-6308-12-git-send-email-tytso@mit.edu>
	 <4B8E1410.1010107@rs.jp.nec.com> <20100303175217.GA3530@thunk.org>
	 <4B8F47C6.9060408@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f218.google.com ([209.85.218.218]:63067 "EHLO
	mail-bw0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab0CDVvq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Mar 2010 16:51:46 -0500
Received: by bwz10 with SMTP id 10so2319931bwz.2
        for <linux-ext4@vger.kernel.org>; Thu, 04 Mar 2010 13:51:45 -0800 (PST)
In-Reply-To: <4B8F47C6.9060408@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Akira Fujita:
> <kernel-space>
> fs/ioctl.c ioctl_fimap():
> 
> filemap_check_ranges():
> 	len(~0ULL)
> 	new_len(4398046511103 = s_maxbytes)  <--- Because 'len > s_maxbytes'
> 
> fs/ext4/extents.c ext4_fiemap():
> 	last_blk = start(0) + len(4398046511103) - 1 >> s_blocksize_bits(11)
> 	         = 4294967295 (0xFFFFFFFF)
> 	len_blks = 4294967295 + 1 (0xFFFFFFFF + 0x00000001)
> 		 = 4294967296 (0x100000000)  <--- _OVERFLOW!!_
> 	
> ext4_ext_walk_space():
> 	num = 0
> 
> This overflow leads to incorrect output like the below,
> even though 2 extents exist.
> 

Thank you for pointing this out. I had not checked s_maxbytes.
Appearently s_maxbytes can be 1<<(32 + s_blocksize_bits) - 1. Therefore
the number of blocks in a file cannot be stored in a 32bit integer.

I have a patch that should fix it for fiemap. I have just compiled it
and I will do some testing and double checking tomorrow. I will send a
separate email with the patch.

regards
Leonard


