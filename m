From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: add checksum calculation when clearing UNINIT flag
Date: Mon, 10 Nov 2008 18:23:49 -0700
Message-ID: <20081111012349.GS32755@webber.adilger.int>
References: <1226053376.3542.8.camel@frecb007923.frec.bull.fr>
 <20081107135222.GB9543@mit.edu> <20081107142718.GL25194@skywalker>
 <20081107143806.GD9543@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	=?utf-8?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63402 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097AbYKKBYE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Nov 2008 20:24:04 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAB1Nqjc003287
	for <linux-ext4@vger.kernel.org>; Mon, 10 Nov 2008 17:24:02 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KA500D01AGPGQ00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 10 Nov 2008 17:23:52 -0800 (PST)
In-reply-to: <20081107143806.GD9543@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 07, 2008  09:38 -0500, Theodore Ts'o wrote:
> On Fri, Nov 07, 2008 at 07:57:18PM +0530, Aneesh Kumar K.V wrote:
> > Because when we clear the uninitt_bg flag the kernel expect the block 
> > bitmap to be correctly indicate blocks containing block
> > bitmap and inode bitmap as used. If mke2fs didn't do that we would
> > need to do the same when we remove the uninit_bg flag.
> 
> We have separate flags inidicating whether the block allocation bitmap
> and inode allocation bitmaps are initialized or not,
> EXT4_BG_BLOCK_UNINIT, and EXT4_BG_INODE_UNINIT, respectively.  So what
> I am proposing is to not initialize the block bitmap in
> ext4_new_inode(), and not to clear the EXT4_BG_BLOCK_UNINIT flag, either.

That would be dangerous, because the block group _would_ be in use due
to the fact that one of the inode table blocks is in use.  That isn't
to say we couldn't adopt sematics as you suggest (e.g. that INODE_UNINIT
not being set implies that the inode table blocks are in use regardless
of whether or not BLOCK_UNINIT is set, but it needs careful consideration.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

