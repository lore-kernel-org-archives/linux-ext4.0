From: David =?iso-8859-1?q?Mart=EDnez_Moreno?= <ender@tuenti.com>
Subject: ext3 crash with tune2fs and MD RAID10 device.
Date: Tue, 15 Sep 2009 12:01:08 +0200
Message-ID: <200909151201.08482.ender@tuenti.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	David =?iso-8859-1?q?Mart=EDnez_Moreno?= <ender@tuenti.com>
To: linux-ext4@vger.kernel.org, "Theodore Y. Ts'o" <tytso@mit.edu>,
	linux-raid@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from calipso.tuenti.com ([95.131.168.251]:41486 "EHLO
	calipso.tuenti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZIOKcR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Sep 2009 06:32:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

	Good morning.  During a maintainance, I've changed (20 hours ago) the reserved
block count in my servers' data partition to 0.  In some hours, I've got a number
of errors (5) in ext3 in different servers that are not possible by simple luck.
The errors are:

=========================================================
EXT3-fs error (device md3): ext3_new_block: Allocating block in system zone - blocks from 8192000, length 1
Aborting journal on device md3.
Remounting filesystem read-only
EXT3-fs error (device md3): ext3_free_blocks: Freeing blocks in system zones - Block = 8192000, count = 1
EXT3-fs error (device md3) in ext3_free_blocks_sb: Journal has aborted
__journal_remove_journal_head: freeing b_committed_data
__journal_remove_journal_head: freeing b_committed_data
...
=========================================================

or

=========================================================
EXT3-fs error (device md3): ext3_free_blocks_sb: bit already cleared for block 22479363                                     
Aborting journal on device md3.                                                                                             
Remounting filesystem read-only                                                                                             
EXT3-fs error (device md3): ext3_free_blocks_sb: bit already cleared for block 22479364                                     
EXT3-fs error (device md3): ext3_free_blocks_sb: bit already cleared for block 22479365                                     
EXT3-fs error (device md3): ext3_free_blocks_sb: bit already cleared for block 22479367                                     
EXT3-fs error (device md3) in ext3_free_blocks_sb: Journal has aborted                                                      
EXT3-fs error (device md3) in ext3_free_blocks_sb: Journal has aborted                                                      
EXT3-fs error (device md3) in ext3_free_blocks_sb: Journal has aborted                                                      
...
=========================================================

	I have some servers with a single SAS disc and others with a software RAID10
volume over 4 discs.  So far, only the RAID10 volumes are showing errors.
Coincidence?

	This is Debian etch, and 2.6.24.2.  The command line we've run was:

tune2fs -r 0 partition

while MySQL was running.  The e2fsprogs version is 1.39+1.40-WIP-2006.11.14+dfsg-2etch1.

	Do you know of any problem with this setup?  I've reviewed the e2fsprogs
changelog searching for something like this but it seems rather related to
RAID10+ext3 interaction.

	We have lots of servers waiting for crashing, I suspect.  While I was writing
this mail another one crashed.  Probably I can provide superblock copies for
analysis or any other information.

	Best regards,


		Ender.
-- 
I once farted on the set of Blue Lagoon.
		-- Brooke Shields (South Park).
--
Responsable de sistemas
tuenti.com
