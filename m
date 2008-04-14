From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ext3_valid_block_bitmap: Invalid block bitmap in 2.6.25rc in
	memory
Date: Mon, 14 Apr 2008 07:50:08 -0700
Message-ID: <1208184608.3608.7.camel@localhost.localdomain>
References: <20080412205714.GA6855@basil.nowhere.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49106 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761078AbYDNOuK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Apr 2008 10:50:10 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3EEo9tg009278
	for <linux-ext4@vger.kernel.org>; Mon, 14 Apr 2008 10:50:09 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3EEo9OM249372
	for <linux-ext4@vger.kernel.org>; Mon, 14 Apr 2008 10:50:09 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3EEo9sn019066
	for <linux-ext4@vger.kernel.org>; Mon, 14 Apr 2008 10:50:09 -0400
In-Reply-To: <20080412205714.GA6855@basil.nowhere.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2008-04-12 at 22:57 +0200, Andi Kleen wrote:
> FYI, a system here running various 2.6.25rc kernels (latest upto rc7-git6) 
> with longer uptimes suddenly decided to fsck one of its file systems
> due to an error after reboot.
> 
> The error causing this was:
> 
> kernel: EXT3-fs error (device dm-0): ext3_valid_block_bitmap: Invalid block bitmap - block_group = 285, block = 9338882
> 
> detected by the 2.6.25rc7-git6 kernel.
> 
> I don't see any ill effects from it and fsck didn't find anything wrong
> so it must have been something spurious in memory only (or fsck
> fails to check for this condition, but that is hard to imagine) 
> 

The ext3_valid_block_bitmap() is to check whether the block or inode
bitmap block is marked as "used" in the block group bitmap, to prevent
allocating blocks from these system meta data blocks. The error messages
seems indicating that one of the block group meta data is corrupted, but
I don't why fsck doesn't catch this, Andreas?

Mingming
> The system never showed anything like this on earlier kernel versions.
> 
> -Andi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

