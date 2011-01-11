From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 6/6] Add interface to advertise ext4 features in sysfs
Date: Tue, 11 Jan 2011 13:55:40 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1101111354530.3095@dhcp-lab-213.englab.brq.redhat.com>
References: <1284568568-13637-1-git-send-email-lczerner@redhat.com> <1284568568-13637-7-git-send-email-lczerner@redhat.com> <4D2B9151.7060007@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, rwheeler@redhat.com, adilger@dilger.ca
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540Ab1AKMzq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Jan 2011 07:55:46 -0500
In-Reply-To: <4D2B9151.7060007@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 10 Jan 2011, Eric Sandeen wrote:

> On 09/15/2010 11:36 AM, Lukas Czerner wrote:
> > User-space should have the opportunity to check what features doest ext4
> > support in each particular copy. This adds easy interface by creating new
> > "features" directory in sys/fs/ext4/. In that directory files
> > advertising feature names can be created.
> > 
> > Add lazy_itable_init to the feature list.
> 
> This seems to break unloading/reloading in .37; near as I can
> tell /sys/fs/ext4 never gets unregistered on module unload.

That's not good, I'll look at it.

Thanks!
-Lukas

> 
> -Eric
> 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  fs/ext4/ext4.h  |    5 +++++
> >  fs/ext4/super.c |   50 +++++++++++++++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 54 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index 0df3977..9ecac2e 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -1502,6 +1502,11 @@ struct ext4_li_request {
> >  	unsigned long		lr_next_sched;
> >  };
> >  
> > +struct ext4_features {
> > +	struct kobject f_kobj;
> > +	struct completion f_kobj_unregister;
> > +};
> > +
> >  /*
> >   * Function prototypes
> >   */
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 3e285eb..b817eba 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -57,6 +57,7 @@ struct proc_dir_entry *ext4_proc_root;
> >  static struct kset *ext4_kset;
> >  struct ext4_lazy_init *ext4_li_info;
> >  struct mutex ext4_li_mtx;
> > +struct ext4_features *ext4_feat;
> >  
> >  static int ext4_load_journal(struct super_block *, struct ext4_super_block *,
> >  			     unsigned long journal_devnum);
> > @@ -2349,6 +2350,7 @@ static struct ext4_attr ext4_attr_##_name = {			\
> >  #define EXT4_ATTR(name, mode, show, store) \
> >  static struct ext4_attr ext4_attr_##name = __ATTR(name, mode, show, store)
> >  
> > +#define EXT4_INFO_ATTR(name) EXT4_ATTR(name, 0444, NULL, NULL)
> >  #define EXT4_RO_ATTR(name) EXT4_ATTR(name, 0444, name##_show, NULL)
> >  #define EXT4_RW_ATTR(name) EXT4_ATTR(name, 0644, name##_show, name##_store)
> >  #define EXT4_RW_ATTR_SBI_UI(name, elname)	\
> > @@ -2385,6 +2387,14 @@ static struct attribute *ext4_attrs[] = {
> >  	NULL,
> >  };
> >  
> > +/* Features this copy of ext4 supports */
> > +EXT4_INFO_ATTR(lazy_itable_init);
> > +
> > +static struct attribute *ext4_feat_attrs[] = {
> > +	ATTR_LIST(lazy_itable_init),
> > +	NULL,
> > +};
> > +
> >  static ssize_t ext4_attr_show(struct kobject *kobj,
> >  			      struct attribute *attr, char *buf)
> >  {
> > @@ -2413,7 +2423,6 @@ static void ext4_sb_release(struct kobject *kobj)
> >  	complete(&sbi->s_kobj_unregister);
> >  }
> >  
> > -
> >  static const struct sysfs_ops ext4_attr_ops = {
> >  	.show	= ext4_attr_show,
> >  	.store	= ext4_attr_store,
> > @@ -2425,6 +2434,17 @@ static struct kobj_type ext4_ktype = {
> >  	.release	= ext4_sb_release,
> >  };
> >  
> > +static void ext4_feat_release(struct kobject *kobj)
> > +{
> > +	complete(&ext4_feat->f_kobj_unregister);
> > +}
> > +
> > +static struct kobj_type ext4_feat_ktype = {
> > +	.default_attrs	= ext4_feat_attrs,
> > +	.sysfs_ops	= &ext4_attr_ops,
> > +	.release	= ext4_feat_release,
> > +};
> > +
> >  /*
> >   * Check whether this filesystem can be mounted based on
> >   * the features present and the RDONLY/RDWR mount requested.
> > @@ -4581,6 +4601,30 @@ static struct file_system_type ext4_fs_type = {
> >  	.fs_flags	= FS_REQUIRES_DEV,
> >  };
> >  
> > +int __init ext4_init_feat_adverts(void)
> > +{
> > +	struct ext4_features *ef;
> > +	int ret = -ENOMEM;
> > +
> > +	ef = kzalloc(sizeof(struct ext4_features), GFP_KERNEL);
> > +	if (!ef)
> > +		goto out;
> > +
> > +	ef->f_kobj.kset = ext4_kset;
> > +	init_completion(&ef->f_kobj_unregister);
> > +	ret = kobject_init_and_add(&ef->f_kobj, &ext4_feat_ktype, NULL,
> > +				   "features");
> > +	if (ret) {
> > +		kfree(ef);
> > +		goto out;
> > +	}
> > +
> > +	ext4_feat = ef;
> > +	ret = 0;
> > +out:
> > +	return ret;
> > +}
> > +
> >  static int __init init_ext4_fs(void)
> >  {
> >  	int err;
> > @@ -4593,6 +4637,9 @@ static int __init init_ext4_fs(void)
> >  	if (!ext4_kset)
> >  		goto out4;
> >  	ext4_proc_root = proc_mkdir("fs/ext4", NULL);
> > +
> > +	err = ext4_init_feat_adverts();
> > +
> >  	err = init_ext4_mballoc();
> >  	if (err)
> >  		goto out3;
> > @@ -4621,6 +4668,7 @@ out1:
> >  out2:
> >  	exit_ext4_mballoc();
> >  out3:
> > +	kfree(ext4_feat);
> >  	remove_proc_entry("fs/ext4", NULL);
> >  	kset_unregister(ext4_kset);
> >  out4:
> 
> 

-- 
