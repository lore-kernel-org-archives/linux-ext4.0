From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 13/16] ext4: Calculate and verify checksums of extended
	attribute blocks
Date: Fri, 2 Sep 2011 11:43:32 -0700
Message-ID: <20110902184332.GG12086@tux1.beaverton.ibm.com>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com> <20110901003200.31048.70117.stgit@elm3c44.beaverton.ibm.com> <F4A42DCE-F91C-419B-9153-65A7EA91D241@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:34466 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab1IBSnz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Sep 2011 14:43:55 -0400
Content-Disposition: inline
In-Reply-To: <F4A42DCE-F91C-419B-9153-65A7EA91D241@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 01, 2011 at 01:42:26AM -0600, Andreas Dilger wrote:
> On 2011-08-31, at 6:32 PM, Darrick J. Wong wrote:
> > Calculate and verify the checksums of extended attribute blocks.  This only
> > applies to separate EA blocks that are pointed to by inode->i_file_acl (i.e.
> > external EA blocks); the checksum lives in the EA header.
> > 
> > diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
> > index 25b7387..b2b20af 100644
> > --- a/fs/ext4/xattr.h
> > +++ b/fs/ext4/xattr.h
> > @@ -27,7 +27,8 @@ struct ext4_xattr_header {
> > 	__le32	h_refcount;	/* reference count */
> > 	__le32	h_blocks;	/* number of disk blocks used */
> > 	__le32	h_hash;		/* hash value of all attributes */
> > -	__u32	h_reserved[4];	/* zero right now */
> > +	__le32	h_checksum;	/* crc32c(uuid+inum+xattrblock) */
> 
> This comment is incorrect - the inum cannot be part of the checksum if
> the block is shared.  That said, I wouldn't object if the checksum DID
> include the inum if the block was not shared (h_refcount == 1).  Since
> the h_refcount needs to be modified and the checksum recomputed if other
> inodes share this block, this doesn't impose any extra overhead.

Oops, I guess I was typing too fast.  "inum" should be "ea_block_num".  Though
I suspect that in the common case files don't share EA blocks, so we could do
inum when refcount==1.

--D
> 
> Cheers, Andreas
> 
