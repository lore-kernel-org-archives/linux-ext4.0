From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: add error processing when calling
	ext4_mb_init_cache in mballoc
Date: Wed, 28 May 2008 14:09:55 -0700
Message-ID: <1212008996.3791.36.camel@localhost.localdomain>
References: <483D2884.30309@cn.fujitsu.com>
	 <20080528095420.GD15851@skywalker>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Shen Feng <shen@cn.fujitsu.com>, alex@clusterfs.com,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38789 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbYE1VJ7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 May 2008 17:09:59 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4SL9xNa015747
	for <linux-ext4@vger.kernel.org>; Wed, 28 May 2008 17:09:59 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4SL9x43137204
	for <linux-ext4@vger.kernel.org>; Wed, 28 May 2008 17:09:59 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4SL9wfJ024616
	for <linux-ext4@vger.kernel.org>; Wed, 28 May 2008 17:09:59 -0400
In-Reply-To: <20080528095420.GD15851@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-05-28 at 15:24 +0530, Aneesh Kumar K.V wrote:
> On Wed, May 28, 2008 at 05:40:20PM +0800, Shen Feng wrote:
> > Add error processing for ext4_mb_load_buddy when it calls
> > ext4_mb_init_cache.
> > 
> > Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
> 
> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
Thanks, I have added these two fixes to ext4 patch queue.
> > ---
> >  fs/ext4/mballoc.c |   27 ++++++++++++++++++++-------
> >  1 files changed, 20 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> > index 35c12db..a30a35d 100644
> > --- a/fs/ext4/mballoc.c
> > +++ b/fs/ext4/mballoc.c
> > @@ -883,6 +883,7 @@ ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
> >  	int pnum;
> >  	int poff;
> >  	struct page *page;
> > +	int ret;
> > 
> >  	mb_debug("load group %lu\n", group);
> > 
> > @@ -914,15 +915,21 @@ ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
> >  		if (page) {
> >  			BUG_ON(page->mapping != inode->i_mapping);
> >  			if (!PageUptodate(page)) {
> > -				ext4_mb_init_cache(page, NULL);
> > +				ret = ext4_mb_init_cache(page, NULL);
> > +				if (ret) {
> > +					unlock_page(page);
> > +					goto err;
> > +				}
> >  				mb_cmp_bitmaps(e4b, page_address(page) +
> >  					       (poff * sb->s_blocksize));
> >  			}
> >  			unlock_page(page);
> >  		}
> >  	}
> > -	if (page == NULL || !PageUptodate(page))
> > +	if (page == NULL || !PageUptodate(page)) {
> > +		ret = -EIO;
> >  		goto err;
> > +	}
> >  	e4b->bd_bitmap_page = page;
> >  	e4b->bd_bitmap = page_address(page) + (poff * sb->s_blocksize);
> >  	mark_page_accessed(page);
> > @@ -938,14 +945,20 @@ ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
> >  		page = find_or_create_page(inode->i_mapping, pnum, GFP_NOFS);
> >  		if (page) {
> >  			BUG_ON(page->mapping != inode->i_mapping);
> > -			if (!PageUptodate(page))
> > -				ext4_mb_init_cache(page, e4b->bd_bitmap);
> > -
> > +			if (!PageUptodate(page)) {
> > +				ret = ext4_mb_init_cache(page, e4b->bd_bitmap);
> > +				if (ret) {
> > +					unlock_page(page);
> > +					goto err;
> > +				}
> > +			}
> >  			unlock_page(page);
> >  		}
> >  	}
> > -	if (page == NULL || !PageUptodate(page))
> > +	if (page == NULL || !PageUptodate(page)) {
> > +		ret = -EIO;
> >  		goto err;
> > +	}
> >  	e4b->bd_buddy_page = page;
> >  	e4b->bd_buddy = page_address(page) + (poff * sb->s_blocksize);
> >  	mark_page_accessed(page);
> > @@ -962,7 +975,7 @@ err:
> >  		page_cache_release(e4b->bd_buddy_page);
> >  	e4b->bd_buddy = NULL;
> >  	e4b->bd_bitmap = NULL;
> > -	return -EIO;
> > +	return ret;
> >  }
> > 
> >  static void ext4_mb_release_desc(struct ext4_buddy *e4b)
> > -- 
> > 1.5.4.5
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

