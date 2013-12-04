From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v2 27/28] libext2fs: export inode cahce creation function
Date: Wed, 4 Dec 2013 11:56:20 +0800
Message-ID: <20131204035619.GE20409@gmail.com>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
 <1386072715-9869-28-git-send-email-wenqing.lz@taobao.com>
 <20131203222249.GG9535@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:37262 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab3LDDxX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 22:53:23 -0500
Received: by mail-pb0-f52.google.com with SMTP id uo5so22598193pbc.11
        for <linux-ext4@vger.kernel.org>; Tue, 03 Dec 2013 19:53:22 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131203222249.GG9535@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 03, 2013 at 02:22:49PM -0800, Darrick J. Wong wrote:
> On Tue, Dec 03, 2013 at 08:11:54PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > Currently we have already exported inode cache flush and free functions
> > for users.  This commit exports inode cache creation function.  Later
> > we will use this function to initialize inode cache and do some unit
> > tests for inline data.
> > 
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > ---
> >  lib/ext2fs/ext2fs.h |    1 +
> >  lib/ext2fs/inode.c  |    8 ++++----
> >  2 files changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> > index bf0ef26..a47bb40 100644
> > --- a/lib/ext2fs/ext2fs.h
> > +++ b/lib/ext2fs/ext2fs.h
> > @@ -1369,6 +1369,7 @@ extern errcode_t ext2fs_get_memalign(unsigned long size,
> >  				     unsigned long align, void *ptr);
> >  
> >  /* inode.c */
> > +extern errcode_t ext2fs_create_inode_cache(ext2_filsys fs, int cache_size);
> >  extern void ext2fs_free_inode_cache(struct ext2_inode_cache *icache);
> >  extern errcode_t ext2fs_flush_icache(ext2_filsys fs);
> >  extern errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan,
> > diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
> > index 46c1c58..8cf76b0 100644
> > --- a/lib/ext2fs/inode.c
> > +++ b/lib/ext2fs/inode.c
> > @@ -91,7 +91,7 @@ void ext2fs_free_inode_cache(struct ext2_inode_cache *icache)
> >  	ext2fs_free_mem(&icache);
> >  }
> >  
> > -static errcode_t create_icache(ext2_filsys fs)
> > +errcode_t ext2fs_create_inode_cache(ext2_filsys fs, int cache_size)
> 
> cache_size should unsigned int; there's not much point in letting people pass
> us a negative size.
> 
> Possibly ext2_inode_cache.cache_size should be unsigned too...

Fair enough.  I will fix it soon.

Thanks,
                                                - Zheng

> 
> --D
> 
> >  {
> >  	int		i;
> >  	errcode_t	retval;
> > @@ -109,7 +109,7 @@ static errcode_t create_icache(ext2_filsys fs)
> >  
> >  	fs->icache->buffer_blk = 0;
> >  	fs->icache->cache_last = -1;
> > -	fs->icache->cache_size = 4;
> > +	fs->icache->cache_size = cache_size;
> >  	fs->icache->refcount = 1;
> >  	retval = ext2fs_get_array(fs->icache->cache_size,
> >  				  sizeof(struct ext2_inode_cache_ent),
> > @@ -596,7 +596,7 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
> >  		return EXT2_ET_BAD_INODE_NUM;
> >  	/* Create inode cache if not present */
> >  	if (!fs->icache) {
> > -		retval = create_icache(fs);
> > +		retval = ext2fs_create_inode_cache(fs, 4);
> >  		if (retval)
> >  			return retval;
> >  	}
> > @@ -732,7 +732,7 @@ errcode_t ext2fs_write_inode_full(ext2_filsys fs, ext2_ino_t ino,
> >  			}
> >  		}
> >  	} else {
> > -		retval = create_icache(fs);
> > +		retval = ext2fs_create_inode_cache(fs, 4);
> >  		if (retval)
> >  			goto errout;
> >  	}
> > -- 
> > 1.7.9.7
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
