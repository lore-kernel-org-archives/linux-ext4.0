From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/7] ext2: Avoid DAX zeroing to corrupt data
Date: Mon, 16 May 2016 17:22:06 +0200
Message-ID: <20160516152206.GC21714@quack2.suse.cz>
References: <1462960733-29634-1-git-send-email-jack@suse.cz>
 <1462960733-29634-4-git-send-email-jack@suse.cz>
 <20160512184522.GA19851@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org,
	Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-fsdevel@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853AbcEPPWN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 May 2016 11:22:13 -0400
Content-Disposition: inline
In-Reply-To: <20160512184522.GA19851@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 12-05-16 12:45:22, Ross Zwisler wrote:
> On Wed, May 11, 2016 at 11:58:49AM +0200, Jan Kara wrote:
> > Currently ext2 zeroes any data blocks allocated for DAX inode however it
> > still returns them as BH_New. Thus DAX code zeroes them again in
> > dax_insert_mapping() which can possibly overwrite the data that has been
> > already stored to those blocks by a racing dax_io(). Avoid marking
> > pre-zeroed buffers as new.
> > 
> > Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext2/inode.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> > index 6bd58e6ff038..1f07b758b968 100644
> > --- a/fs/ext2/inode.c
> > +++ b/fs/ext2/inode.c
> > @@ -745,11 +745,11 @@ static int ext2_get_blocks(struct inode *inode,
> >  			mutex_unlock(&ei->truncate_mutex);
> >  			goto cleanup;
> >  		}
> > -	}
> > +	} else
> > +		set_buffer_new(bh_result);
> >  
> >  	ext2_splice_branch(inode, iblock, partial, indirect_blks, count);
> >  	mutex_unlock(&ei->truncate_mutex);
> > -	set_buffer_new(bh_result);
> >  got_it:
> >  	map_bh(bh_result, inode->i_sb, le32_to_cpu(chain[depth-1].key));
> >  	if (count > blocks_to_boundary)
> > -- 
> > 2.6.6
> 
> Interestingly this change is causing a bunch of xfstests regressions for me
> with ext2 + DAX.  All of these tests pass without this one change.

Good catch. Attached patch fixes this issue for me. Preferably it should be
merged before the above ext2 change.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--EeQfGwPcQSOJBaQU
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext2-Fix-block-zeroing-in-ext2_get_blocks-for-DAX.patch"

>From 287d6b6cb0b6f325696fff93ff0f29ee5fde5736 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 16 May 2016 17:17:04 +0200
Subject: [PATCH] ext2: Fix block zeroing in ext2_get_blocks() for DAX

When zeroing allocated blocks for DAX, we accidentally zeroed only the
first allocated block instead of all of them. So far this problem is
hidden by the fact that page faults always need only a single block and
DAX write code zeroes blocks again. But the zeroing in DAX code is racy
and needs to be removed so fix the zeroing in ext2 to zero all allocated
blocks.

Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 6bd58e6ff038..038d0ed5f565 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -740,7 +740,7 @@ static int ext2_get_blocks(struct inode *inode,
 		err = dax_clear_sectors(inode->i_sb->s_bdev,
 				le32_to_cpu(chain[depth-1].key) <<
 				(inode->i_blkbits - 9),
-				1 << inode->i_blkbits);
+				count << inode->i_blkbits);
 		if (err) {
 			mutex_unlock(&ei->truncate_mutex);
 			goto cleanup;
-- 
2.6.6


--EeQfGwPcQSOJBaQU--
