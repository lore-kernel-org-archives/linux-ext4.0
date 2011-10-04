From: yargil@free.fr
Subject: Re: [PATCH] ext4: don't work without procfs
Date: Tue, 04 Oct 2011 13:03:39 +0200
Message-ID: <1317726219.4e8ae80b24893@imp.free.fr>
References: <1317674761-17837-1-git-send-email-yargil@free.fr> <alpine.LFD.2.00.1110041100260.7833@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:57184 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab1JDLKC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Oct 2011 07:10:02 -0400
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 2CF51CA92F7
	for <linux-ext4@vger.kernel.org>; Tue,  4 Oct 2011 13:04:18 +0200 (CEST)
In-Reply-To: <alpine.LFD.2.00.1110041100260.7833@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Selon Lukas Czerner <lczerner@redhat.com>:

> On Mon, 3 Oct 2011, Yargil wrote:
>
> > Regression from commit dd68314ccf3fb918c1fb6471817edbc60ece4b52
>
> Hi,
>
> the commit you've mentioned does not have anything to do with procfs.
> Maybe you meant commit
>
> c9de560ded61faa5b754137b7753da252391c55a
> 	ext4: Add multi block allocator for ext4
>
> which adds multi block allocator for ext4 (mballoc.c) and has been added
> in Jan 29 2008.
>
> > ---
> >  fs/ext4/super.c |    8 ++++++++
> >  1 files changed, 8 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 44d0c8d..8e7298d 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -53,7 +53,9 @@
> >  #define CREATE_TRACE_POINTS
> >  #include <trace/events/ext4.h>
> >
> > +#ifdef CONFIG_PROC_FS
> >  static struct proc_dir_entry *ext4_proc_root;
> > +#endif
>
> This is not needed I think, since proc_dir_entry is defined in
> linux/proc_fs.h even if CONFIG_PROC_FS is not defined.
>
> >  static struct kset *ext4_kset;
> >  static struct ext4_lazy_init *ext4_li_info;
> >  static struct mutex ext4_li_mtx;
> > @@ -812,9 +814,11 @@ static void ext4_put_super(struct super_block *sb)
> >  		es->s_state = cpu_to_le16(sbi->s_mount_state);
> >  		ext4_commit_super(sb, 1);
> >  	}
> > +#ifdef CONFIG_PROC_FS
> >  	if (sbi->s_proc) {
> >  		remove_proc_entry(sb->s_id, ext4_proc_root);
>
> This function exists even if CONFIG_PROC_FS is not defined.
>
> #define remove_proc_entry(name, parent) do {} while (0)
>
>
> >  	}
> > +#endif
> >  	kobject_del(&sbi->s_kobj);
> >
> >  	for (i = 0; i < sbi->s_gdb_count; i++)
> > @@ -4984,9 +4988,11 @@ static int __init ext4_init_fs(void)
> >  	ext4_kset = kset_create_and_add("ext4", NULL, fs_kobj);
> >  	if (!ext4_kset)
> >  		goto out6;
> > +#ifdef CONFIG_PROC_FS
> >  	ext4_proc_root = proc_mkdir("fs/ext4", NULL);
>
> The same here
>
> static inline struct proc_dir_entry *proc_mkdir(const char *name,
> 	struct proc_dir_entry *parent) {return NULL;}
>
>
> >  	if (!ext4_proc_root)
> >  		goto out5;
> However this is wrong, because in case that procfs is not compiled in
> ext4_proc_root will be NULL, but there is no reason to error out in this
> case.
>
> The question is whether we should error out in case that it fails even
> if we have procfs compiled in. I am slightly in favour of just printing
> a warning in !CONFIG_PROC_FS case.
>
> Also this is probably why you blame commit
> dd68314ccf3fb918c1fb6471817edbc60ece4b52 for the regression, since this
> check was added with this commit. But I think that there is no reasong
> to #ifdef everything procfs related.

I did that to avoid warning. But if printing warning is not a problem then the
only part of code to be #ifdef is the test of the return value of proc_mkdir in
the ext4_init_fs function.

>
>
> > +#endif
> >
> >  	err = ext4_init_feat_adverts();
> >  	if (err)
> > @@ -5022,8 +5028,10 @@ out2:
> >  out3:
> >  	ext4_exit_feat_adverts();
> >  out4:
> > +#ifdef CONFIG_PROC_FS
> >  	remove_proc_entry("fs/ext4", NULL);
>
> same here.
>
> >  out5:
> > +#endif
> >  	kset_unregister(ext4_kset);
> >  out6:
> >  	ext4_exit_system_zone();
> >
>
> -Lukas
>


