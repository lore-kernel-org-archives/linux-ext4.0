From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: Re: [Ext2-devel] rfc: [patch 3/6] more e2fsprogs fixes
Date: Mon, 4 Sep 2006 16:59:41 +0200
Message-ID: <20060904145941.GA9427@openx1.frec.bull.fr>
References: <20060825131138.GA20278@openx1.frec.bull.fr> <20060825131840.GC20944@openx1.frec.bull.fr> <20060825235049.GP6634@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:56226 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP
	id S1751450AbWIDPAF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Sep 2006 11:00:05 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id EF8EF19D92D
	for <linux-ext4@vger.kernel.org>; Mon,  4 Sep 2006 17:00:00 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 22262-09 for <linux-ext4@vger.kernel.org>;
 Mon,  4 Sep 2006 16:59:57 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 5E05719D980
	for <linux-ext4@vger.kernel.org>; Mon,  4 Sep 2006 16:59:55 +0200 (CEST)
To: linux-ext4@vger.kernel.org
In-Reply-To: <20060825235049.GP6634@schatzie.adilger.int>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Aug 25, 2006 at 05:50:49PM -0600, Andreas Dilger wrote:
> On Aug 25, 2006  15:18 +0200, Alexandre Ratchov wrote:
> > add bg_{block_bitmap,inode_bitmap,inode_table}_hi fields in
> > struct ext2_group_desc and use absolute block numbers. While
> > this is not necessary, IMHO this is simpler than relative
> > addressing, and this change make e2fsprogs "just" work.
> > 
> >  {
> > +	__u32	bg_block_bitmap;	/* Blocks bitmap block */
> > +	__u32	bg_inode_bitmap;	/* Inodes bitmap block */
> >  	__u32	bg_inode_table;		/* Inodes table block */
> >  	__u16	bg_free_blocks_count;	/* Free blocks count */
> >  	__u16	bg_free_inodes_count;	/* Free inodes count */
> >  	__u16	bg_used_dirs_count;	/* Directories count */
> >  	__u16	bg_flags;
> > +	__u32	bg_block_bitmap_hi;	/* Blocks bitmap block */
> > +	__u32	bg_inode_bitmap_hi;	/* Inodes bitmap block */
> > +	__u32	bg_inode_table_hi;	/* Inodes table block */
> > +	/*__u16	bg_reserved[3];*/
> 
> This consumes all of the blockgroup reserved fields, not leaving any
> for checksumming.  In particular, for the UNINIT group changes this
> needs at least 16 bits for the checksum, and it would be good to have
> a 32-bit checksum for the block and inode bitmaps.
> 
> Instead, why not put a 16-bit "_block_bitmap_hi" field here and then
> the inode bitmap and inode table are relative to that?  Alternately,
> if we want a full 32-bit "hi" value, we can maybe live with smaller
> checksums on the bitmaps...
>  

ok, that works for me. However there is still an issue:

in order tu use 48bit adressing, we have to use larger block groups (because
all group descriptors must fit in one block group).  So we'll need 16bit
"_hi" bits for blocks_count, inodes_count and perhaps used_dirs_count. And
this leaves no room for additional fields.

There's already a patch that makes the descriptor structure size variable
(similarly to the inode size), see marc.theaimsgroup.com/?m=114968738307171
Here is the updated patch set:

linux-2.6.18-rc4:

http://www.bullopensource.org/ext4/20060904/ext4-linux-2.6.18-rc4.tar.gz

e2fsprogs-1.39:

http://www.bullopensource.org/ext4/20060904/ext4-e2fsprogs-1.39.tar.gz

cheers,

-- 
Alexandre
