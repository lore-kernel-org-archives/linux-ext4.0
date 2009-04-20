From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: PATCH: Making mb_history length a dynamic tunable
Date: Mon, 20 Apr 2009 11:53:12 -0700
Message-ID: <6601abe90904201153q5e66cb30na22a49767245e53f@mail.gmail.com>
References: <6601abe90904071020gdce65d2madc6df30c182c5cd@mail.gmail.com>
	 <20090420032252.GA3209@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:9408 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZDTSxS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Apr 2009 14:53:18 -0400
Received: from wpaz37.hot.corp.google.com (wpaz37.hot.corp.google.com [172.24.198.101])
	by smtp-out.google.com with ESMTP id n3KIrErb013257
	for <linux-ext4@vger.kernel.org>; Mon, 20 Apr 2009 19:53:14 +0100
Received: from qw-out-1920.google.com (qwj9.prod.google.com [10.241.195.73])
	by wpaz37.hot.corp.google.com with ESMTP id n3KIrCkC030430
	for <linux-ext4@vger.kernel.org>; Mon, 20 Apr 2009 11:53:13 -0700
Received: by qw-out-1920.google.com with SMTP id 9so707369qwj.40
        for <linux-ext4@vger.kernel.org>; Mon, 20 Apr 2009 11:53:12 -0700 (PDT)
In-Reply-To: <20090420032252.GA3209@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas:

> On Apr 07, 2009  10:20 -0700, Curt Wohlgemuth wrote:
> > Since we frequently run in memory-constrained systems with many partitions,
> > the ~68K for each partition for the mb_history buffer can be excessive.  The
> > following creates a new proc file under /proc/fs/ext4/ to control the number
> > of entries at mount time.
>
> Sorry for the delay, it's been a hectic 2 weeks.  I'm totally OK with this
> patch.

Thanks for the detailed reply.

> > If the notion of a history length tunable is okay, but the location should
> > be under /sys/fs/ext4/ instead of /proc/fs/ext4/, I can change this.  The
> > leftover files under /proc/fs/ext4/<partition>/ are a bit confusing to me.
>
> Complex /proc files like this cannot be moved into /sys because it
> does not support the seqfile interface for having output span more
> than one page.

Got it.

> >  static void ext4_mb_generate_from_freelist(struct super_block *sb,
> > void *bitmap,
> > @@ -2417,31 +2421,36 @@ static struct file_operations ext4_mb_se
> >  static void ext4_mb_history_release(struct super_block *sb)
> >  {
> >  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> > +	int delete_mbhist = sbi->s_mb_history_max != 0;
> >
> >  	if (sbi->s_proc != NULL) {
> >  		remove_proc_entry("mb_groups", sbi->s_proc);
> > -		remove_proc_entry("mb_history", sbi->s_proc);
> > +		if (delete_mbhist)
> > +			remove_proc_entry("mb_history", sbi->s_proc);
> >  	}
> > -	kfree(sbi->s_mb_history);
> > +	if (delete_mbhist)
> > +		kfree(sbi->s_mb_history);
>
> If sbi->s_mb_history == NULL (as opposed to garbage) it is OK to
> just call kfree() without the extra check.

Done.

> Since the s_mb_history buffers are allocated at mount time only,
> and later writing to mb_hist_size does not affect their size,
> it means that mb_hist_size must be set before the filesystems are
> mounted.  However, that makes it impossible to tune the root
> filesystem history size, and at best it is difficult to tune the
> other filesystems because the value has to be set by an init
> script after root mounts but before other filesystems mount.
>
> Another possible option is to have a module parameter that can be
> set when the ext4 module is inserted, so that it is sure to be
> available for all filesystems, but this won't help if ext4 is
> built into the kernel.

Which is certainly our case.

> The final (though more complex) option is to add a per-fs
> tunable that allows changing the history size at runtime for
> each filesystem.

Right, I thought about this.  But avoiding the race when the tunable is
being changed at the same time that history is being updated just didn't
seem worth it to me.

I see the mb_history mostly as a debug issue; having to umount/remount a FS
to change history doesn't seem too onerous -- with the exception, of course,
of the root FS.  Do you think this is too big a burden, and I should look at
handling it while a FS is mounted?

> > @@ -2894,6 +2903,49 @@ static void release_blocks_on_commit(jou
> >  	mb_debug("freed %u blocks in %u structures\n", count, count2);
> >  }
> >
> > +static ssize_t read_mb_hist_size(struct file *file, char __user *buf,
> > +				size_t count, loff_t *ppos)
> > +static ssize_t write_mb_hist_size(struct file *file, const char __user *buf,
> > +				   size_t count, loff_t *ppos)
>
> Please add an ext4_ prefix to these function names.

Done.

> > +{
> > +	/* This allows for 99999 entries, at 68 bytes each */
> > +#define MAX_BUFSIZE 6
> > +	char kbuf[MAX_BUFSIZE + 1];
> > +	int value;
> > +
> > +	if (count) {
> > +		if (count > MAX_BUFSIZE)
> > +			return -EINVAL;
> > +		if (copy_from_user(&kbuf, buf, count))
> > +			return -EFAULT;
> > +		kbuf[min(count, sizeof(kbuf))-1] = '\0';
>
> This is could probably be avoided.  Simply initializing "kbuf" at
> declaration time will ensure that there is a trailing NUL because
> at most MAX_BUFSIZE bytes are copied into it.
>
> 	char kbuf[MAX_BUFSIZE + 1] = "";

Ah, right, thanks; done.

Second patch follows.

       Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---

--- ext4/fs/ext4/mballoc.c.orig	2009-04-07 09:13:12.000000000 -0700
+++ ext4/fs/ext4/mballoc.c	2009-04-20 11:22:25.000000000 -0700
@@ -334,6 +334,10 @@
 static struct kmem_cache *ext4_pspace_cachep;
 static struct kmem_cache *ext4_ac_cachep;
 static struct kmem_cache *ext4_free_ext_cachep;
+
+#define DEFAULT_HIST_SIZE 1000
+static int ext4_mbhist_size = DEFAULT_HIST_SIZE;
+
 static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 					ext4_group_t group);
 static void ext4_mb_generate_from_freelist(struct super_block *sb,
void *bitmap,
@@ -2417,10 +2421,12 @@
 static void ext4_mb_history_release(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	int delete_mbhist = sbi->s_mb_history_max != 0;

 	if (sbi->s_proc != NULL) {
 		remove_proc_entry("mb_groups", sbi->s_proc);
-		remove_proc_entry("mb_history", sbi->s_proc);
+		if (delete_mbhist)
+			remove_proc_entry("mb_history", sbi->s_proc);
 	}
 	kfree(sbi->s_mb_history);
 }
@@ -2429,19 +2435,21 @@
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int i;
+	int create_mbhist = ext4_mbhist_size != 0;

 	if (sbi->s_proc != NULL) {
-		proc_create_data("mb_history", S_IRUGO, sbi->s_proc,
-				 &ext4_mb_seq_history_fops, sb);
+		if (create_mbhist)
+			proc_create_data("mb_history", S_IRUGO, sbi->s_proc,
+					 &ext4_mb_seq_history_fops, sb);
 		proc_create_data("mb_groups", S_IRUGO, sbi->s_proc,
 				 &ext4_mb_seq_groups_fops, sb);
 	}

-	sbi->s_mb_history_max = 1000;
+	sbi->s_mb_history_max = ext4_mbhist_size;
 	sbi->s_mb_history_cur = 0;
 	spin_lock_init(&sbi->s_mb_history_lock);
 	i = sbi->s_mb_history_max * sizeof(struct ext4_mb_history);
-	sbi->s_mb_history = kzalloc(i, GFP_KERNEL);
+	sbi->s_mb_history = create_mbhist ? kzalloc(i, GFP_KERNEL) : NULL;
 	/* if we can't allocate history, then we simple won't use it */
 }

@@ -2894,6 +2902,48 @@
 	mb_debug("freed %u blocks in %u structures\n", count, count2);
 }

+static ssize_t ext4_read_mb_hist_size(struct file *file, char __user *buf,
+					size_t count, loff_t *ppos)
+{
+	char buffer[20];
+	size_t len;
+
+	len = snprintf(buffer, sizeof(buffer), "%i\n", ext4_mbhist_size);
+
+	return simple_read_from_buffer(buf, count, ppos, buffer, len);
+}
+
+static ssize_t ext4_write_mb_hist_size(struct file *file,
+					const char __user *buf,
+					size_t count, loff_t *ppos)
+{
+	/* This allows for 99999 entries, at 68 bytes each */
+#define MAX_BUFSIZE 6
+	char kbuf[MAX_BUFSIZE + 1] = "";
+	int value;
+
+	if (count) {
+		if (count > MAX_BUFSIZE)
+			return -EINVAL;
+		if (copy_from_user(&kbuf, buf, count))
+			return -EFAULT;
+
+		value = simple_strtol(kbuf, NULL, 0);
+
+		if (value < 0)
+			return -EINVAL;
+
+		ext4_mbhist_size = value;
+	}
+	return count;
+#undef MAX_BUFSIZE
+}
+
+static struct file_operations ext4_mb_size_fops = {
+	.read		= ext4_read_mb_hist_size,
+	.write		= ext4_write_mb_hist_size,
+};
+
 int __init init_ext4_mballoc(void)
 {
 	ext4_pspace_cachep =
@@ -2912,6 +2962,9 @@
 		return -ENOMEM;
 	}

+	proc_create("mb_hist_size", S_IRUGO | S_IWUGO, ext4_proc_root,
+			 &ext4_mb_size_fops);
+
 	ext4_free_ext_cachep =
 		kmem_cache_create("ext4_free_block_extents",
 				     sizeof(struct ext4_free_data),
