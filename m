From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 15/29] ext4: Deprecate max_writeback_mb_bump sysfs
 attribute
Date: Mon, 6 May 2013 14:55:01 +0200
Message-ID: <20130506125501.GC9147@quack.suse.cz>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-16-git-send-email-jack@suse.cz>
 <20130505124719.GA13178@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756625Ab3EFWKr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 May 2013 18:10:47 -0400
Content-Disposition: inline
In-Reply-To: <20130505124719.GA13178@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 05-05-13 20:47:19, Zheng Liu wrote:
> On Mon, Apr 08, 2013 at 11:32:20PM +0200, Jan Kara wrote:
> > This attribute is now unused so deprecate it. We still show the old
> > default value to keep some compatibility but we don't allow writing to
> > that attribute anymore.
> 
> I think we can remove it completely.  IMHO, if an application tries to
> set this value, it will get an error because now it can't set it.
  We tend to be more careful when removing userspace interfaces. So I kept
the sysfs file there and just made it do nothing. We can remove it after a
couple of kernel releases... I certainly wouldn't mind if the file was
removed right away but I'll leave that decision upto Ted.

								Honza

> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext4/ext4.h  |    1 -
> >  fs/ext4/super.c |   30 ++++++++++++++++++++++++------
> >  2 files changed, 24 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index edf9b9e..3575fdb 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -1234,7 +1234,6 @@ struct ext4_sb_info {
> >  	unsigned int s_mb_stats;
> >  	unsigned int s_mb_order2_reqs;
> >  	unsigned int s_mb_group_prealloc;
> > -	unsigned int s_max_writeback_mb_bump;
> >  	unsigned int s_max_dir_size_kb;
> >  	/* where last allocation was done - for stream allocation */
> >  	unsigned long s_mb_last_group;
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 34e8552..09ff724 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -2374,7 +2374,10 @@ struct ext4_attr {
> >  	ssize_t (*show)(struct ext4_attr *, struct ext4_sb_info *, char *);
> >  	ssize_t (*store)(struct ext4_attr *, struct ext4_sb_info *,
> >  			 const char *, size_t);
> > -	int offset;
> > +	union {
> > +		int offset;
> > +		int deprecated_val;
> > +	} u;
> >  };
> >  
> >  static int parse_strtoul(const char *buf,
> > @@ -2443,7 +2446,7 @@ static ssize_t inode_readahead_blks_store(struct ext4_attr *a,
> >  static ssize_t sbi_ui_show(struct ext4_attr *a,
> >  			   struct ext4_sb_info *sbi, char *buf)
> >  {
> > -	unsigned int *ui = (unsigned int *) (((char *) sbi) + a->offset);
> > +	unsigned int *ui = (unsigned int *) (((char *) sbi) + a->u.offset);
> >  
> >  	return snprintf(buf, PAGE_SIZE, "%u\n", *ui);
> >  }
> > @@ -2452,7 +2455,7 @@ static ssize_t sbi_ui_store(struct ext4_attr *a,
> >  			    struct ext4_sb_info *sbi,
> >  			    const char *buf, size_t count)
> >  {
> > -	unsigned int *ui = (unsigned int *) (((char *) sbi) + a->offset);
> > +	unsigned int *ui = (unsigned int *) (((char *) sbi) + a->u.offset);
> >  	unsigned long t;
> >  
> >  	if (parse_strtoul(buf, 0xffffffff, &t))
> > @@ -2478,12 +2481,20 @@ static ssize_t trigger_test_error(struct ext4_attr *a,
> >  	return count;
> >  }
> >  
> > +static ssize_t sbi_deprecated_show(struct ext4_attr *a,
> > +				   struct ext4_sb_info *sbi, char *buf)
> > +{
> > +	return snprintf(buf, PAGE_SIZE, "%d\n", a->u.deprecated_val);
> > +}
> > +
> >  #define EXT4_ATTR_OFFSET(_name,_mode,_show,_store,_elname) \
> >  static struct ext4_attr ext4_attr_##_name = {			\
> >  	.attr = {.name = __stringify(_name), .mode = _mode },	\
> >  	.show	= _show,					\
> >  	.store	= _store,					\
> > -	.offset = offsetof(struct ext4_sb_info, _elname),	\
> > +	.u = {							\
> > +		.offset = offsetof(struct ext4_sb_info, _elname),\
> > +	},							\
> >  }
> >  #define EXT4_ATTR(name, mode, show, store) \
> >  static struct ext4_attr ext4_attr_##name = __ATTR(name, mode, show, store)
> > @@ -2494,6 +2505,14 @@ static struct ext4_attr ext4_attr_##name = __ATTR(name, mode, show, store)
> >  #define EXT4_RW_ATTR_SBI_UI(name, elname)	\
> >  	EXT4_ATTR_OFFSET(name, 0644, sbi_ui_show, sbi_ui_store, elname)
> >  #define ATTR_LIST(name) &ext4_attr_##name.attr
> > +#define EXT4_DEPRECATED_ATTR(_name, _val)	\
> > +static struct ext4_attr ext4_attr_##_name = {			\
> > +	.attr = {.name = __stringify(_name), .mode = 0444 },	\
> > +	.show	= sbi_deprecated_show,				\
> > +	.u = {							\
> > +		.deprecated_val = _val,				\
> > +	},							\
> > +}
> >  
> >  EXT4_RO_ATTR(delayed_allocation_blocks);
> >  EXT4_RO_ATTR(session_write_kbytes);
> > @@ -2507,7 +2526,7 @@ EXT4_RW_ATTR_SBI_UI(mb_min_to_scan, s_mb_min_to_scan);
> >  EXT4_RW_ATTR_SBI_UI(mb_order2_req, s_mb_order2_reqs);
> >  EXT4_RW_ATTR_SBI_UI(mb_stream_req, s_mb_stream_request);
> >  EXT4_RW_ATTR_SBI_UI(mb_group_prealloc, s_mb_group_prealloc);
> > -EXT4_RW_ATTR_SBI_UI(max_writeback_mb_bump, s_max_writeback_mb_bump);
> > +EXT4_DEPRECATED_ATTR(max_writeback_mb_bump, 128);
> >  EXT4_RW_ATTR_SBI_UI(extent_max_zeroout_kb, s_extent_max_zeroout_kb);
> >  EXT4_ATTR(trigger_fs_error, 0200, NULL, trigger_test_error);
> >  
> > @@ -3718,7 +3737,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
> >  	}
> >  
> >  	sbi->s_stripe = ext4_get_stripe_size(sbi);
> > -	sbi->s_max_writeback_mb_bump = 128;
> >  	sbi->s_extent_max_zeroout_kb = 32;
> >  
> >  	/* Register extent status tree shrinker */
> > -- 
> > 1.7.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
