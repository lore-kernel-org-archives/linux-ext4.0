From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH FOR DISCUSSION] add delalloc debugging
Date: Wed, 26 Jun 2013 14:31:14 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1306261414000.5729@localhost.localdomain>
References: <20130620164249.GC4982@thunk.org> <20130625035002.GA2896@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab3FZMbT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Jun 2013 08:31:19 -0400
In-Reply-To: <20130625035002.GA2896@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 25 Jun 2013, Zheng Liu wrote:

> Date: Tue, 25 Jun 2013 11:50:03 +0800
> From: Zheng Liu <gnehzuil.liu@gmail.com>
> To: Theodore Ts'o <tytso@mit.edu>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH FOR DISCUSSION] add delalloc debugging
> 
> Hi Ted,
> 
> On Thu, Jun 20, 2013 at 12:42:49PM -0400, Theodore Ts'o wrote:
> > I've been carrying a patch in the unstable portion of the patch series
> > for a while now to debug problems with delayed allocation.  This
> > allows us to observe the state of which inodes have inodes subject for
> > delayed allocation, and how many data/metadata blocks have been
> > reserved.
> > 
> > I've finally cleaned it up enough that it's something where I wouldn't
> > feel terrible dropping it into the mainline kernel.  (It's still a
> > little gross, but it's not truly horrifying any more.)  
> > 
> > What do people think?  Is this something that's worth having in the
> > kernel sources?  Or shall I continue carrying it as an out-of-tree
> > debugging patch?
> 
> I think it is worth having it in the kernel source.  But before we apply
> this patch, it seems that we need to solve some problems.

Yes, I very much like this patch. It's worth having and it can yield
important information.

> 
> 1. Now when we read /proc/fs/ext4/{$DEV}/delalloc_debug, it will print
> the result in console.  IMHO, I don't think it is a good choice.  I
> prefer to print this result in debugfs or in sysfs.

I would prefer to print this info in debug_delalloc_show() so we can
simply read the file instead of read the file + read the log.

> 
> 2. If we want to gain this feature, we will enable EXT4_DEBUG option.
> But in a product system, we never enable it because of performance
> degradation.  So I think that maybe we can compile it without EXT4_DEBUG
> option and dynamically enable/disalbe it.

I think that having this enabled only is EXT4_DEBUG is set is just
fine. However if you want to be able to use it even without EXT4_DEBUG
option we could just set proper permissions on the
/proc/fs/ext4/{$DEV}/delalloc_debug so that only privileged user can
open it.

> 
> 3. Maybe we can provide a interface to let the user indicate which inode
> they want to observe.

you can grep for it, I do not think it's a big deal.

> 
> Finally, the patch itself still has two minor problems.  We forget
> to call remove_proc_entry() in ext4_put_super().  Another problem is
> compile warnings.
> 
> > 
> > (Note: we can use similar technique to gain visibility into the status
> > the extent status LRU list.)
> 
> I am happy to generate a patch for extent status LRU list.
> 
> > 
> >       	          	       	      	  - Ted
> > 
> > From f6417debc1c96a9dfa6b9f19da14eff35bf0f504 Mon Sep 17 00:00:00 2001
> > From: Theodore Ts'o <tytso@mit.edu>
> > Date: Thu, 20 Jun 2013 12:35:39 -0400
> > Subject: [PATCH] ext4: add delalloc debugging
> > 
> > This adds a file in /proc/fs/ext4/<dev> which when opened for reading,
> > will trigger debugging code that dumps a lot of information about
> > inodes subject to delayed allocation to the console.
> > 
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> > ---
> >  fs/ext4/super.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 77 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 85b3dd6..ecb8256 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -1832,6 +1832,74 @@ static const struct file_operations ext4_seq_options_fops = {
> >  	.release = single_release,
> >  };
> >  
> > +#ifdef CONFIG_EXT4_DEBUG
> #ifndef MODULE
> > +static void print_inode_delalloc_info(struct inode *inode)
> > +{
> > +	if (!EXT4_I(inode)->i_reserved_data_blocks ||
> > +	    !EXT4_I(inode)->i_reserved_meta_blocks)
> > +		return;
> > +
> > +	printk(KERN_DEBUG "ino %lu: %u %u\n", inode->i_ino,
> > +	       EXT4_I(inode)->i_reserved_data_blocks,
> > +	       EXT4_I(inode)->i_reserved_meta_blocks);
> > +}
> #endif
> > +
> > +static int debug_delalloc_show(struct seq_file *seq, void *offset)
> > +{
> > +	return 0;
> > +}
> > +
> > +static int options_delalloc_debug_open_fs(struct inode *proc_inode,
> > +					  struct file *file)
> > +{
> > +	struct super_block *sb = PDE_DATA(proc_inode);
> > +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> #ifndef MODULE
> > +	struct inode *inode;
> > +	extern spinlock_t inode_sb_list_lock;
> #endif
> 
> Regards,
>                                                 - Zheng
> 
> > +
> > +	printk(KERN_DEBUG "EXT4-fs debug delalloc of %s\n", sb->s_id);
> > +	printk(KERN_DEBUG "EXT4-fs: dirty clusters %lld free clusters %lld\n",
> > +	       percpu_counter_sum(&sbi->s_dirtyclusters_counter),
> > +	       percpu_counter_sum(&sbi->s_freeclusters_counter));
> > +
> > +#ifndef MODULE
> > +	spin_lock(&inode_sb_list_lock);
> > +	if (!list_empty(&sb->s_bdi->wb.b_dirty)) {
> > +		printk(KERN_DEBUG "s_bdi->wb.b_dirty list:\n");
> > +		list_for_each_entry(inode, &sb->s_bdi->wb.b_dirty,
> > +				    i_wb_list) {
> > +			print_inode_delalloc_info(inode);
> > +		}
> > +	}
> > +	if (!list_empty(&sb->s_bdi->wb.b_io)) {
> > +		printk(KERN_DEBUG "s_bdi->wb.b_io list:\n");
> > +		list_for_each_entry(inode, &sb->s_bdi->wb.b_io,
> > +				    i_wb_list) {
> > +			print_inode_delalloc_info(inode);
> > +		}
> > +	}
> > +	if (!list_empty(&sb->s_bdi->wb.b_more_io)) {
> > +		printk(KERN_DEBUG "s_bdi->wb.b_more_io list:\n");
> > +		list_for_each_entry(inode, &sb->s_bdi->wb.b_more_io,
> > +				    i_wb_list) {
> > +			print_inode_delalloc_info(inode);
> > +		}
> > +	}
> > +	spin_unlock(&inode_sb_list_lock);
> > +	printk(KERN_DEBUG "ext4 debug delalloc done\n");
> > +#endif
> > +	return single_open(file, debug_delalloc_show, sb);
> > +}
> > +
> > +static const struct file_operations ext4_seq_delalloc_debug_fops = {
> > +	.owner = THIS_MODULE,
> > +	.open = options_delalloc_debug_open_fs,
> > +	.read = seq_read,
> > +	.llseek = seq_lseek,
> > +	.release = single_release,
> > +};
> > +#endif
> > +
> >  static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
> >  			    int read_only)
> >  {
> > @@ -3764,9 +3832,14 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
> >  	if (ext4_proc_root)
> >  		sbi->s_proc = proc_mkdir(sb->s_id, ext4_proc_root);
> >  
> > -	if (sbi->s_proc)
> > +	if (sbi->s_proc) {
> >  		proc_create_data("options", S_IRUGO, sbi->s_proc,
> >  				 &ext4_seq_options_fops, sb);
> > +#ifdef CONFIG_EXT4_DEBUG
> > +		proc_create_data("delalloc_debug", S_IRUSR, sbi->s_proc,
> > +				 &ext4_seq_delalloc_debug_fops, sb);
> > +#endif
> > +	}
> >  
> >  	bgl_lock_init(sbi->s_blockgroup_lock);
> >  
> > @@ -4149,6 +4222,9 @@ failed_mount:
> >  		crypto_free_shash(sbi->s_chksum_driver);
> >  	if (sbi->s_proc) {
> >  		remove_proc_entry("options", sbi->s_proc);
> > +#ifdef CONFIG_EXT4_DEBUG
> > +		remove_proc_entry("delalloc_debug", sbi->s_proc);
> > +#endif
> >  		remove_proc_entry(sb->s_id, ext4_proc_root);
> >  	}
> >  #ifdef CONFIG_QUOTA
> > -- 
> > 1.7.12.rc0.22.gcdd159b
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
