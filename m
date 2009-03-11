From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: Possible ext4 corruption - ACL related?
Date: Wed, 11 Mar 2009 17:07:28 +0530
Message-ID: <ea11fea30903110437h28c115bfld1022d8422ec2c3a@mail.gmail.com>
References: <1236642197.30280.18.camel@kulgan.wumi.org.au>
	 <49B5D71D.1030802@redhat.com>
	 <1236655451.30280.29.camel@kulgan.wumi.org.au>
	 <49B5EDFE.8060405@redhat.com>
	 <1236661371.30280.33.camel@kulgan.wumi.org.au>
	 <20090310070915.GN3199@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>, mkatiyar@gmail.com
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:41270 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbZCKLhb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Mar 2009 07:37:31 -0400
Received: by rv-out-0506.google.com with SMTP id g9so2972820rvb.5
        for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2009 04:37:29 -0700 (PDT)
In-Reply-To: <20090310070915.GN3199@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 10, 2009 at 12:39 PM, Andreas Dilger <adilger@sun.com> wrot=
e:
> On Mar 10, 2009 =A015:32 +1030, Kevin Shanahan wrote:
>> On Mon, 2009-03-09 at 23:35 -0500, Eric Sandeen wrote:
>> > Kevin Shanahan wrote:
>> > > On Mon, 2009-03-09 at 21:57 -0500, Eric Sandeen wrote:
>> > >> Kevin Shanahan wrote:
>> > >>> kernel: init_special_inode: bogus i_mode (53253)
>
> If anyone has a chance, fixing this error message to be not-useless w=
ould
> be good... =A0Including the device name and the inode number would he=
lp
> track down the source of the problem.

Hi Andreas,

Below is the patch along with other trivial cleanups in fs/inode.c

=46ix init_special_inode to print device name and inode number.
Convert simple_strtoul to strict_strtoul.
Remove checkpatch.pl warnings:
Before :-
total: 24 errors, 26 warnings, 1547 lines checked
After :-
total: 0 errors, 0 warnings, 1539 lines checked


Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/inode.c |   91 +++++++++++++++++++++++++++-------------------------=
-------
 1 files changed, 42 insertions(+), 49 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 913ab2d..ef4a9b1 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -98,7 +98,7 @@ static DEFINE_MUTEX(iprune_mutex);
  */
 struct inodes_stat_t inodes_stat;

-static struct kmem_cache * inode_cachep __read_mostly;
+static struct kmem_cache *inode_cachep __read_mostly;

 static void wake_up_inode(struct inode *inode)
 {
@@ -123,7 +123,7 @@ struct inode *inode_init_always(struct super_block
*sb, struct inode *inode)
 	static struct inode_operations empty_iops;
 	static const struct file_operations empty_fops;

-	struct address_space * const mapping =3D &inode->i_data;
+	struct address_space *const mapping =3D &inode->i_data;

 	inode->i_sb =3D sb;
 	inode->i_blkbits =3D sb->s_blocksize_bits;
@@ -206,7 +206,7 @@ static struct inode *alloc_inode(struct super_block=
 *sb)
 	return NULL;
 }

-void destroy_inode(struct inode *inode)
+void destroy_inode(struct inode *inode)
 {
 	BUG_ON(inode_has_buffers(inode));
 	security_inode_free(inode);
@@ -242,12 +242,11 @@ void inode_init_once(struct inode *inode)
 	mutex_init(&inode->inotify_mutex);
 #endif
 }
-
 EXPORT_SYMBOL(inode_init_once);

 static void init_once(void *foo)
 {
-	struct inode * inode =3D (struct inode *) foo;
+	struct inode *inode =3D (struct inode *) foo;

 	inode_init_once(inode);
 }
@@ -255,7 +254,7 @@ static void init_once(void *foo)
 /*
  * inode_lock must be held
  */
-void __iget(struct inode * inode)
+void __iget(struct inode *inode)
 {
 	if (atomic_read(&inode->i_count)) {
 		atomic_inc(&inode->i_count);
@@ -279,7 +278,7 @@ void clear_inode(struct inode *inode)
 {
 	might_sleep();
 	invalidate_inode_buffers(inode);
-
+
 	BUG_ON(inode->i_data.nrpages);
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
@@ -293,7 +292,6 @@ void clear_inode(struct inode *inode)
 		cd_forget(inode);
 	inode->i_state =3D I_CLEAR;
 }
-
 EXPORT_SYMBOL(clear_inode);

 /*
@@ -341,8 +339,8 @@ static int invalidate_list(struct list_head *head,
struct list_head *dispose)

 	next =3D head->next;
 	for (;;) {
-		struct list_head * tmp =3D next;
-		struct inode * inode;
+		struct list_head *tmp =3D next;
+		struct inode *inode;

 		/*
 		 * We can reschedule here without worrying about the list's
@@ -378,7 +376,7 @@ static int invalidate_list(struct list_head *head,
struct list_head *dispose)
  *	fails because there are busy inodes then a non zero value is return=
ed.
  *	If the discard is successful all the inodes have been discarded.
  */
-int invalidate_inodes(struct super_block * sb)
+int invalidate_inodes(struct super_block *sb)
 {
 	int busy;
 	LIST_HEAD(throw_away);
@@ -394,7 +392,6 @@ int invalidate_inodes(struct super_block * sb)

 	return busy;
 }
-
 EXPORT_SYMBOL(invalidate_inodes);

 static int can_unuse(struct inode *inode)
@@ -490,7 +487,7 @@ static int shrink_icache_memory(int nr, gfp_t gfp_m=
ask)
 		 * Nasty deadlock avoidance.  We may hold various FS locks,
 		 * and we don't want to recurse into the FS that called us
 		 * in clear_inode() and friends..
-	 	 */
+		 */
 		if (!(gfp_mask & __GFP_FS))
 			return -1;
 		prune_icache(nr);
@@ -510,10 +507,11 @@ static void __wait_on_freeing_inode(struct inode =
*inode);
  * by hand after calling find_inode now! This simplifies iunique and w=
on't
  * add any additional branch in the common code.
  */
-static struct inode * find_inode(struct super_block * sb, struct
hlist_head *head, int (*test)(struct inode *, void *), void *data)
+static struct inode *find_inode(struct super_block *sb, struct
hlist_head *head,
+				int (*test)(struct inode *, void *), void *data)
 {
 	struct hlist_node *node;
-	struct inode * inode =3D NULL;
+	struct inode *inode =3D NULL;

 repeat:
 	hlist_for_each_entry(inode, node, head, i_hash) {
@@ -534,10 +532,11 @@ repeat:
  * find_inode_fast is the fast path version of find_inode, see the com=
ment at
  * iget_locked for details.
  */
-static struct inode * find_inode_fast(struct super_block * sb, struct
hlist_head *head, unsigned long ino)
+static struct inode *find_inode_fast(struct super_block *sb,
+				struct hlist_head *head, unsigned long ino)
 {
 	struct hlist_node *node;
-	struct inode * inode =3D NULL;
+	struct inode *inode =3D NULL;

 repeat:
 	hlist_for_each_entry(inode, node, head, i_hash) {
@@ -617,10 +616,10 @@ struct inode *new_inode(struct super_block *sb)
 	 * here to attempt to avoid that.
 	 */
 	static unsigned int last_ino;
-	struct inode * inode;
+	struct inode *inode;

 	spin_lock_prefetch(&inode_lock);
-=09
+
 	inode =3D alloc_inode(sb);
 	if (inode) {
 		spin_lock(&inode_lock);
@@ -631,7 +630,6 @@ struct inode *new_inode(struct super_block *sb)
 	}
 	return inode;
 }
-
 EXPORT_SYMBOL(new_inode);

 void unlock_new_inode(struct inode *inode)
@@ -659,7 +657,6 @@ void unlock_new_inode(struct inode *inode)
 	inode->i_state &=3D ~(I_LOCK|I_NEW);
 	wake_up_inode(inode);
 }
-
 EXPORT_SYMBOL(unlock_new_inode);

 /*
@@ -668,13 +665,16 @@ EXPORT_SYMBOL(unlock_new_inode);
  * We no longer cache the sb_flags in i_flags - see fs.h
  *	-- rmk@arm.uk.linux.org
  */
-static struct inode * get_new_inode(struct super_block *sb, struct
hlist_head *head, int (*test)(struct inode *, void *), int
(*set)(struct inode *, void *), void *data)
+static struct inode *get_new_inode(struct super_block *sb,
+				struct hlist_head *head,
+				int (*test)(struct inode *, void *),
+				int (*set)(struct inode *, void *), void *data)
 {
-	struct inode * inode;
+	struct inode *inode;

 	inode =3D alloc_inode(sb);
 	if (inode) {
-		struct inode * old;
+		struct inode *old;

 		spin_lock(&inode_lock);
 		/* We released the lock, so.. */
@@ -716,13 +716,14 @@ set_failed:
  * get_new_inode_fast is the fast path version of get_new_inode, see t=
he
  * comment at iget_locked for details.
  */
-static struct inode * get_new_inode_fast(struct super_block *sb,
struct hlist_head *head, unsigned long ino)
+static struct inode *get_new_inode_fast(struct super_block *sb,
+				struct hlist_head *head, unsigned long ino)
 {
-	struct inode * inode;
+	struct inode *inode;

 	inode =3D alloc_inode(sb);
 	if (inode) {
-		struct inode * old;
+		struct inode *old;

 		spin_lock(&inode_lock);
 		/* We released the lock, so.. */
@@ -808,7 +809,6 @@ struct inode *igrab(struct inode *inode)
 	spin_unlock(&inode_lock);
 	return inode;
 }
-
 EXPORT_SYMBOL(igrab);

 /**
@@ -909,7 +909,6 @@ struct inode *ilookup5_nowait(struct super_block
*sb, unsigned long hashval,

 	return ifind(sb, head, test, data, 0);
 }
-
 EXPORT_SYMBOL(ilookup5_nowait);

 /**
@@ -938,7 +937,6 @@ struct inode *ilookup5(struct super_block *sb,
unsigned long hashval,

 	return ifind(sb, head, test, data, 1);
 }
-
 EXPORT_SYMBOL(ilookup5);

 /**
@@ -961,7 +959,6 @@ struct inode *ilookup(struct super_block *sb,
unsigned long ino)

 	return ifind_fast(sb, head, ino);
 }
-
 EXPORT_SYMBOL(ilookup);

 /**
@@ -1000,7 +997,6 @@ struct inode *iget5_locked(struct super_block
*sb, unsigned long hashval,
 	 */
 	return get_new_inode(sb, head, test, set, data);
 }
-
 EXPORT_SYMBOL(iget5_locked);

 /**
@@ -1032,7 +1028,6 @@ struct inode *iget_locked(struct super_block
*sb, unsigned long ino)
 	 */
 	return get_new_inode_fast(sb, head, ino);
 }
-
 EXPORT_SYMBOL(iget_locked);

 int insert_inode_locked(struct inode *inode)
@@ -1061,7 +1056,6 @@ int insert_inode_locked(struct inode *inode)
 		iput(old);
 	}
 }
-
 EXPORT_SYMBOL(insert_inode_locked);

 int insert_inode_locked4(struct inode *inode, unsigned long hashval,
@@ -1091,7 +1085,6 @@ int insert_inode_locked4(struct inode *inode,
unsigned long hashval,
 		iput(old);
 	}
 }
-
 EXPORT_SYMBOL(insert_inode_locked4);

 /**
@@ -1109,7 +1102,6 @@ void __insert_inode_hash(struct inode *inode,
unsigned long hashval)
 	hlist_add_head(&inode->i_hash, head);
 	spin_unlock(&inode_lock);
 }
-
 EXPORT_SYMBOL(__insert_inode_hash);

 /**
@@ -1124,7 +1116,6 @@ void remove_inode_hash(struct inode *inode)
 	hlist_del_init(&inode->i_hash);
 	spin_unlock(&inode_lock);
 }
-
 EXPORT_SYMBOL(remove_inode_hash);

 /*
@@ -1171,7 +1162,6 @@ void generic_delete_inode(struct inode *inode)
 	BUG_ON(inode->i_state !=3D I_CLEAR);
 	destroy_inode(inode);
 }
-
 EXPORT_SYMBOL(generic_delete_inode);

 static void generic_forget_inode(struct inode *inode)
@@ -1218,12 +1208,11 @@ void generic_drop_inode(struct inode *inode)
 	else
 		generic_forget_inode(inode);
 }
-
 EXPORT_SYMBOL_GPL(generic_drop_inode);

 /*
  * Called when we're dropping the last reference
- * to an inode.
+ * to an inode.
  *
  * Call the FS "drop()" function, defaulting to
  * the legacy UNIX filesystem behaviour..
@@ -1243,7 +1232,7 @@ static inline void iput_final(struct inode *inode=
)
 }

 /**
- *	iput	- put an inode
+ *	iput	- put an inode
  *	@inode: inode to put
  *
  *	Puts an inode, dropping its usage count. If the inode use count hit=
s
@@ -1260,7 +1249,6 @@ void iput(struct inode *inode)
 			iput_final(inode);
 	}
 }
-
 EXPORT_SYMBOL(iput);

 /**
@@ -1271,10 +1259,10 @@ EXPORT_SYMBOL(iput);
  *	Returns the block number on the device holding the inode that
  *	is the disk block number for the block of the file requested.
  *	That is, asked for block 4 of inode 1 the function will return the
- *	disk block relative to the disk start that holds that block of the
+ *	disk block relative to the disk start that holds that block of the
  *	file.
  */
-sector_t bmap(struct inode * inode, sector_t block)
+sector_t bmap(struct inode *inode, sector_t block)
 {
 	sector_t res =3D 0;
 	if (inode->i_mapping->a_ops->bmap)
@@ -1377,7 +1365,6 @@ void file_update_time(struct file *file)
 		mark_inode_dirty_sync(inode);
 	mnt_drop_write(file->f_path.mnt);
 }
-
 EXPORT_SYMBOL(file_update_time);

 int inode_needs_sync(struct inode *inode)
@@ -1388,7 +1375,6 @@ int inode_needs_sync(struct inode *inode)
 		return 1;
 	return 0;
 }
-
 EXPORT_SYMBOL(inode_needs_sync);

 int inode_wait(void *word)
@@ -1461,9 +1447,15 @@ EXPORT_SYMBOL(inode_double_unlock);
 static __initdata unsigned long ihash_entries;
 static int __init set_ihash_entries(char *str)
 {
+	int ret;
+
 	if (!str)
 		return 0;
-	ihash_entries =3D simple_strtoul(str, &str, 0);
+
+	ret =3D strict_strtoul(str, 0, &ihash_entries);
+	if (ret < 0 || ihash_entries =3D=3D 0)
+		return 0;
+
 	return 1;
 }
 __setup("ihash_entries=3D", set_ihash_entries);
@@ -1540,7 +1532,8 @@ void init_special_inode(struct inode *inode,
umode_t mode, dev_t rdev)
 	else if (S_ISSOCK(mode))
 		inode->i_fop =3D &bad_sock_fops;
 	else
-		printk(KERN_DEBUG "init_special_inode: bogus i_mode (%o)\n",
-		       mode);
+		printk(KERN_DEBUG "init_special_inode: bogus i_mode (%o) for"
+				  " inode %s:%lu\n", mode, inode->i_sb->s_id,
+				  inode->i_ino);
 }
 EXPORT_SYMBOL(init_special_inode);
--=20
1.5.4.3



Thanks -
Manish

>
>> hermes:~# debugfs /dev/dm-0
>> debugfs 1.41.3 (12-Oct-2008)
>> debugfs: =A0stat "local/apps/Gestalt.Net/SetupCD/program files/Busin=
ess Objects/Common/3.5/bin/Cdo32sv.dll"
>>
>> Gives the following output:
>>
>> =A0 Inode: 867 =A0 Type: bad type =A0 =A0Mode: =A00404 =A0 Flags: 0x=
802a61af
>> =A0 Generation: 2483046020 =A0 =A0Version: 0xb9286359:17a7fdfd
>> =A0 User: 1455931783 =A0 Group: -798021131 =A0 Size: -1808719531
>> =A0 File ACL: 141934744 =A0 =A0Directory ACL: 0
>> =A0 Links: 15681 =A0 Blockcount: 171984001880781
>> =A0 Fragment: =A0Address: 956780679 =A0 =A0Number: 0 =A0 =A0Size: 0
>> =A0 =A0ctime: 0xdca60244:006c5b08 -- Wed Apr 23 01:54:36 2087
>> =A0 =A0atime: 0x5c9e956c:777587a4 -- Sat Mar 30 08:30:12 2019
>> =A0 =A0mtime: 0x2ce44e11:286138f8 -- Sat Nov 13 13:31:37 1993
>> =A0 crtime: 0x737781cb:5661f351 -- Thu May 22 19:54:11 2031
>> =A0 dtime: 0xf19c4882 -- Sat Jun 14 11:57:14 2098
>> =A0 Size of extra inode fields: 3625
>> =A0 BLOCKS:
>>
>> And when I exit the pager and return to the prompt I also see:
>>
>> =A0 invalid inode->i_extra_isize (3625)
>
> All garbage. =A0Running e2fsck should fix this, though it won't expla=
in
> why it got corrupted in the first place..
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
