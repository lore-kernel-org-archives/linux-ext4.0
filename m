From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 17/74] debugfs: don't leak mmp_s memory
Date: Thu, 12 Dec 2013 14:44:38 -0800
Message-ID: <20131212224438.GF10143@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012014.30655.58647.stgit@birch.djwong.org>
 <7848C189-25A5-43FA-9F55-12299217E3A6@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51650 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab3LLWop (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Dec 2013 17:44:45 -0500
Content-Disposition: inline
In-Reply-To: <7848C189-25A5-43FA-9F55-12299217E3A6@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 12, 2013 at 03:33:12PM -0700, Andreas Dilger wrote:
> On Dec 10, 2013, at 6:20 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > ext2fs_free_mem() takes a pointer to a pointer, similar to
> > ext2fs_get_mem().  Improve the documentation, and fix debugfs.
> > 
> > diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> > index 64e498f..0624350 100644
> > --- a/lib/ext2fs/ext2fs.h
> > +++ b/lib/ext2fs/ext2fs.h
> > @@ -1608,7 +1608,7 @@ _INLINE_ void ext2fs_init_csum_seed(ext2_filsys fs)
> > #ifndef EXT2_CUSTOM_MEMORY_ROUTINES
> > #include <string.h>
> > /*
> > - *  Allocate memory
> > + *  Allocate memory.  The 'ptr' arg must point to a pointer.
> >  */
> > _INLINE_ errcode_t ext2fs_get_mem(unsigned long size, void *ptr)
> > {
> 
> Would that imply the second argument in all of these functions is "void **ptr"?
> Does GCC handle that correctly?  Do other compilers?  Am I just clueless?

In the first function, pp is a pointer to malloc()'d memory, and we copy the
contents of pp into wherever ptr points to.  In the second function, we free p,
set p to NULL, then copy that NULL into wherever ptr points to.  In both cases,
ptr has to point to a pointer.

So, yes, the second argument is a pointer to a pointer.  I'm not sure why the
declarations are so strange here, since it seems to promote confusion and
broken code.

Frankly I was tempted just to fix the declarations, since anybody passing a
pointer (not a pointer-pointer) to these functions has never not been broken
anyway.  However, maybe Ted knows of some reason why things are this way?

(That said, the programming errors mostly seem to be on the free end.)

_INLINE_ errcode_t ext2fs_get_mem(unsigned long size, void *ptr)
{
	void *pp;

	pp = malloc(size);
	if (!pp)
		return EXT2_ET_NO_MEMORY;
	memcpy(ptr, &pp, sizeof (pp));
	return 0;
}

_INLINE_ errcode_t ext2fs_free_mem(void *ptr)
{
	void *p;

	memcpy(&p, ptr, sizeof(p));
	free(p);
	p = 0;
	memcpy(ptr, &p, sizeof(p));
	return 0;
}

--D

> 
> Cheers, Andreas
> 
> > @@ -1655,7 +1655,7 @@ _INLINE_ errcode_t ext2fs_get_arrayzero(unsigned long count,
> > }
> > 
> > /*
> > - * Free memory
> > + * Free memory.  The 'ptr' arg must point to a pointer.
> >  */
> > _INLINE_ errcode_t ext2fs_free_mem(void *ptr)
> > {
> > @@ -1669,7 +1669,7 @@ _INLINE_ errcode_t ext2fs_free_mem(void *ptr)
> > }
> > 
> > /*
> > - *  Resize memory
> > + *  Resize memory.  The 'ptr' arg must point to a pointer.
> >  */
> > _INLINE_ errcode_t ext2fs_resize_mem(unsigned long EXT2FS_ATTR((unused)) old_size,
> > 				     unsigned long size, void *ptr)
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 


