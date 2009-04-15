From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Recover damaged ext4 volume
Date: Wed, 15 Apr 2009 10:02:14 -0500
Message-ID: <49E5F6F6.4060903@redhat.com>
References: <87iql6lci5.fsf@kawa.kanru.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Kan-Ru Chen <ckanru@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40873 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbZDOPCT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Apr 2009 11:02:19 -0400
In-Reply-To: <87iql6lci5.fsf@kawa.kanru.info>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Kan-Ru Chen wrote:
> Hi,
> 
> It was a LVM lv formated to ext4 that can't mount anymore after
> resize. Both e2fsck and dumpe2fs can not find valid superblock or backup
> superblock.

Did something overwrite it?  What does file -s /dev/<whatever> or blkid
/dev/<whatever> say, as a first try?

For the record, what kernel were you using?

-Eric

> However, I can still read and recognize some data from the volume using
> hd. Is there any chance that I can get my files back?
> 
> Following is the output of findsuper, lines with wrong mount time are
> stripped:
> 
> byte_offset  byte_start     byte_end  fs_blocks blksz  grp  last_mount_time     sb_uuid label
> 21140751872 21140750848  29059596800    1933312  4096    0  Mon Dec  8 18:27:59 2008 f4890ad8 
> 21188896256 21188895232  29107741184    1933312  4096    0  Mon Dec  8 18:27:59 2008 f4890ad8 
> 32368412672 32368411648  96792921088   15728640  4096    0  Thu Dec 11 22:57:22 2008 bd5e4f31 
> 45592096256 45592095232  45847046656     248976  1024    0  Tue Dec  9 20:16:51 2008 931b7f03 
> 
> 
> - Kan

