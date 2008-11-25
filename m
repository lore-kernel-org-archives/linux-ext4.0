From: Solofo.Ramangalahy@bull.net
Subject: Re: [RFC 1/2] ext4 resize: Mark the added group with
	EXT4_BG_INODE_ZEROED flag
Date: Tue, 25 Nov 2008 12:27:01 +0100
Message-ID: <18731.57605.633119.670974@frecb006361.adech.frec.bull.fr>
References: <20081121102309.182113793@bull.net>
	<20081121102309.507553245@bull.net>
	<20081124232548.GG3186@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Solofo.Ramangalahy@bull.net, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:55107 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYKYL1G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Nov 2008 06:27:06 -0500
In-Reply-To: <20081124232548.GG3186@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger writes:
 > > As a side note, online resize and inode zeroing are "dual".
 > > 
 > > In order to obtain a filesystem with faster formating times one can
 > > do:
 > > . either format a smaller fs and then resize it,
 > > . or format the fs with lazy_itable_init
 > 
 > As discussed on the concall, it probably makes more sense to have the
 > resize code work by marking the inode tables UNINIT (if GDT_CSUM feature
 > is enabled)

If I understand correctly, this is already the case:
#define EXT4_BG_INODE_UNINIT    0x0001 /* Inode table/bitmap not in use */
#define EXT4_BG_BLOCK_UNINIT    0x0002 /* Block bitmap not in use */
#define EXT4_BG_INODE_ZEROED    0x0004 /* On-disk itable initialized to zero */

As the EXT4_BG_INODE_ZEROED is not present, the inode table is UNINIT.

By the way, is there any reason the #defines are like this, instead of:
#define EXT4_BG_INODE_UNINIT    0x0001 /* Inode table/bitmap not in use */
#define EXT4_BG_BLOCK_UNINIT    0x0002 /* Block bitmap not in use */
#define EXT4_BG_ITABLE_UNINIT   0x0004 /* On-disk itable not initialized */
?

 > and then start the "itable zeroing" thread, if it isn't
 > already running, to do the zeroing of the itable.

Yes.

Is there other resize changes you could think of?
While working on this, I noted this checkpatch error 
"ERROR: do not use assignment in if condition"
(but I am not sure of the exact justification).

Thanks,
-- 
solofo
