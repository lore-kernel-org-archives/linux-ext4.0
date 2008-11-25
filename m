From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC 1/2] ext4 resize: Mark the added group with
	EXT4_BG_INODE_ZEROED flag
Date: Tue, 25 Nov 2008 14:18:44 -0700
Message-ID: <20081125211844.GU3186@webber.adilger.int>
References: <20081121102309.182113793@bull.net>
 <20081121102309.507553245@bull.net> <20081124232548.GG3186@webber.adilger.int>
 <18731.57605.633119.670974@frecb006361.adech.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Solofo.Ramangalahy@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:60437 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbYKYVSs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Nov 2008 16:18:48 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAPLIlpI019976
	for <linux-ext4@vger.kernel.org>; Tue, 25 Nov 2008 13:18:47 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAW00H01QWHRZ00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 25 Nov 2008 13:18:47 -0800 (PST)
In-reply-to: <18731.57605.633119.670974@frecb006361.adech.frec.bull.fr>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 25, 2008  12:27 +0100, Solofo.Ramangalahy@bull.net wrote:
> Andreas Dilger writes:
>  > As discussed on the concall, it probably makes more sense to have the
>  > resize code work by marking the inode tables UNINIT (if GDT_CSUM feature
>  > is enabled)
> 
> If I understand correctly, this is already the case:
> #define EXT4_BG_INODE_UNINIT    0x0001 /* Inode table/bitmap not in use */
> #define EXT4_BG_BLOCK_UNINIT    0x0002 /* Block bitmap not in use */
> #define EXT4_BG_INODE_ZEROED    0x0004 /* On-disk itable initialized to zero */

> As the EXT4_BG_INODE_ZEROED is not present, the inode table is UNINIT.

Ah, I suppose you are correct.

> By the way, is there any reason the #defines are like this, instead of:
> #define EXT4_BG_INODE_UNINIT    0x0001 /* Inode table/bitmap not in use */
> #define EXT4_BG_BLOCK_UNINIT    0x0002 /* Block bitmap not in use */
> #define EXT4_BG_ITABLE_UNINIT   0x0004 /* On-disk itable not initialized */
> ?

No particular reason, that is just how the implementation was done.  In
hindsight that probably would make more sense...

> While working on this, I noted this checkpatch error 
> "ERROR: do not use assignment in if condition"
> (but I am not sure of the exact justification).

I'm not sure what you are asking.  The reason not to use "assignment in if"
is because of possible coding error like:

	if (x = 6) {
		/* do something if x is 6 */
	}

when coder actually meant to write:

	if (x == 6) {
		/* do something if x is 6 */
	}

The first one will now generate a warning in GCC unless written as:

	if ((x = 6)) {
		/* do something if x is 6 */
	}

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

