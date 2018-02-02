From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v4 3/4] ext4: Add helper functions to access inode numbers
Date: Fri, 2 Feb 2018 16:36:20 -0700
Message-ID: <ACD8E7EF-B01F-4151-BCBF-0B723CCA740F@dilger.ca>
References: <20180202094136.13032-1-artem.blagodarenko@gmail.com>
 <20180202094136.13032-4-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_1676683B-1EF5-414F-AF33-41507DE69601";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:55535 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751699AbeBBXgZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Feb 2018 18:36:25 -0500
Received: by mail-it0-f65.google.com with SMTP id c16so10460634itc.5
        for <linux-ext4@vger.kernel.org>; Fri, 02 Feb 2018 15:36:25 -0800 (PST)
In-Reply-To: <20180202094136.13032-4-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_1676683B-1EF5-414F-AF33-41507DE69601
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Feb 2, 2018, at 2:41 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> 64-bit inodes counter uses extra fields to store hight part.
> Let's incapsulate inode number reading and writing to extend
> counter in next commits.
>=20
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> ---
> fs/ext4/dir.c    |  4 +--
> fs/ext4/ext4.h   | 44 +++++++++++++++++++++++---------
> fs/ext4/ialloc.c | 12 ++++-----
> fs/ext4/namei.c  | 78 =
+++++++++++++++++++++++++++++++++++++++-----------------
> fs/ext4/resize.c |  8 +++---
> fs/ext4/super.c  | 45 ++++++++++++++++----------------
> 6 files changed, 121 insertions(+), 70 deletions(-)
>=20
>=20
> +#define EXT4_SB_VALUES(name) \
> +static inline unsigned long ext4_get_##name(struct super_block *sb) \
> +{ \
> +	struct ext4_super_block *es =3D EXT4_SB(sb)->s_es; \
> +	unsigned long value =3D le32_to_cpu(es->s_##name); \
> +	return value; \
> +} \

(style) my preference is to have the linefeed escape '\' aligned at
the end of the line, so they don't interfere with the code, but I
see that is inconsistently used

> +static inline void ext4_set_##name(struct super_block *sb,\
> +					   unsigned long val)\

(style) align continued line after '(' on previous line

> +{ \
> +	struct ext4_super_block *es =3D EXT4_SB(sb)->s_es; \
> +	es->s_##name =3D cpu_to_le32(val); \
> +}
> +
> +EXT4_SB_VALUES(inodes_count)
> +EXT4_SB_VALUES(free_inodes_count)
> +EXT4_SB_VALUES(last_orphan)
> +EXT4_SB_VALUES(first_error_ino)
> +EXT4_SB_VALUES(last_error_ino)

One minor issue with macros like this is that it is not possible to use
tags or grep to find "ext4_{get,set}_inodes_count()" and other generated
function names.  It is useful to at least have those function names in
the comments here, something like:

/*
ext4_get_inodes_count(), ext4_set_inodes_count();
 */
EXT4_SB_VALUES(inodes_count);

so that there is at least some chance of finding them.  I always have =
the
same problem with the ext4_has_feature_*() macros as well, and I'd =
rather
avoid it here.

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index b6681aebe5cf..21f86c48708b 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1543,6 +1543,23 @@ static struct buffer_head * =
ext4_dx_find_entry(struct inode *dir,
> 	return bh;
> }
>=20
> +static int get_ino(struct inode *dir,
> +			     struct ext4_dir_entry_2 *de, __u32 *ino)

(style) align after '(' on previous line

> +{
> +	struct super_block *sb =3D dir->i_sb;
> +
> +	*ino =3D le32_to_cpu(de->inode);
> +	return 0;
> +}
> +
> +static void set_ino(struct inode *dir,
> +		    struct ext4_dir_entry_2 *de, unsigned long i_ino)
> +{
> +	struct super_block *sb =3D dir->i_sb;
> +
> +	de->inode =3D cpu_to_le32(i_ino);
> +}

"get_ino" and "set_ino" are pretty generic function names.  Also, it is
better to put the common components at the start of the name so they can
sort together.  Better to use "dirent_ino_{get,set}()" or maybe
"ext4_dirent_ino_{get,set}()"?

> @@ -2772,8 +2792,8 @@ bool ext4_empty_dir(struct inode *inode)
>=20
> 	de =3D (struct ext4_dir_entry_2 *) bh->b_data;
> 	de1 =3D ext4_next_entry(de, sb->s_blocksize);
> -	if (le32_to_cpu(de->inode) !=3D inode->i_ino ||
> -			le32_to_cpu(de1->inode) =3D=3D 0 ||
> +	if (get_ino(inode, de, &ino) || ino !=3D inode->i_ino ||
> +			get_ino(inode, de1, &ino2) || ino2 =3D=3D 0 ||
> 			strcmp(".", de->name) || strcmp("..", =
de1->name)) {

(style) this is confusingly indented (the original was as well).  Should
be aligned after the first '(' on the "if" line.

> @@ -2943,14 +2963,14 @@ int ext4_orphan_del(handle_t *handle, struct =
inode *inode)
>=20
> 	ino_next =3D NEXT_ORPHAN(inode);
> 	if (prev =3D=3D &sbi->s_orphan) {
> -		jbd_debug(4, "superblock will point to %u\n", ino_next);
> +		jbd_debug(4, "superblock will point to %lu\n", =
ino_next);

(defect) this whole patch chunk should probably be part of the next =
patch,
since ino_next is not yet changed to __u64, and using cpu_to_le64() to
swab a __u32 value below would lead to data corruption on big-endian =
CPUs.

> 		BUFFER_TRACE(sbi->s_sbh, "get_write_access");
> 		err =3D ext4_journal_get_write_access(handle, =
sbi->s_sbh);
> 		if (err) {
> 			mutex_unlock(&sbi->s_orphan_lock);
> 			goto out_brelse;
> 		}
> -		sbi->s_es->s_last_orphan =3D cpu_to_le32(ino_next);
> +		ext4_set_last_orphan(inode->i_sb, =
cpu_to_le64(ino_next));

Also, since ext4_set_last_orphan() is swabbing "value" internally, this =
is
going to be broken on big-endian machines.

> 		mutex_unlock(&sbi->s_orphan_lock);
> 		err =3D ext4_handle_dirty_super(handle, inode->i_sb);
> 	} else {
> @@ -2989,6 +3009,7 @@ static int ext4_rmdir(struct inode *dir, struct =
dentry *dentry)
> 	struct buffer_head *bh;
> 	struct ext4_dir_entry_2 *de;
> 	handle_t *handle =3D NULL;
> +	__u32 ino;
>=20
> 	if (unlikely(ext4_forced_shutdown(EXT4_SB(dir->i_sb))))
> 		return -EIO;
> @@ -3012,7 +3033,7 @@ static int ext4_rmdir(struct inode *dir, struct =
dentry *dentry)
> 	inode =3D d_inode(dentry);
>=20
> 	retval =3D -EFSCORRUPTED;
> -	if (le32_to_cpu(de->inode) !=3D inode->i_ino)
> +	if (get_ino(dir, de, &ino) || ino !=3D inode->i_ino)
> 		goto end_rmdir;
>=20
> 	retval =3D -ENOTEMPTY;
> @@ -3392,13 +3414,15 @@ struct ext4_renament {
> static int ext4_rename_dir_prepare(handle_t *handle, struct =
ext4_renament *ent)
> {
> 	int retval;
> +	__u32 ino;
>=20
> 	ent->dir_bh =3D ext4_get_first_dir_block(handle, ent->inode,
> 					      &retval, &ent->parent_de,
> 					      &ent->dir_inlined);
> 	if (!ent->dir_bh)
> 		return retval;
> -	if (le32_to_cpu(ent->parent_de->inode) !=3D ent->dir->i_ino)
> +	if (get_ino(ent->dir, ent->parent_de, &ino) ||
> +							ino !=3D =
ent->dir->i_ino)

(style) should align after first '(' on previous line

> @@ -3620,7 +3646,8 @@ static int ext4_rename(struct inode *old_dir, =
struct dentry *old_dentry,
> 	 *  same name. Goodbye sticky bit ;-<
> 	 */
> 	retval =3D -ENOENT;
> -	if (!old.bh || le32_to_cpu(old.de->inode) !=3D old.inode->i_ino)
> +	if (!old.bh || get_ino(old.dir, old.de, &ino) ||
> +						ino !=3D =
old.inode->i_ino)

(style) align after first '(' on previous line

> @@ -3834,7 +3862,8 @@ static int ext4_cross_rename(struct inode =
*old_dir, struct dentry *old_dentry,
> 	 *  same name. Goodbye sticky bit ;-<
> 	 */
> 	retval =3D -ENOENT;
> -	if (!old.bh || le32_to_cpu(old.de->inode) !=3D old.inode->i_ino)
> +	if (!old.bh || get_ino(old.dir, old.de, &ino) ||
> +						ino !=3D =
old.inode->i_ino)

...

> @@ -3846,7 +3875,8 @@ static int ext4_cross_rename(struct inode =
*old_dir, struct dentry *old_dentry,
> 	}
>=20
> 	/* RENAME_EXCHANGE case: old *and* new must both exist */
> -	if (!new.bh || le32_to_cpu(new.de->inode) !=3D new.inode->i_ino)
> +	if (!new.bh || get_ino(new.dir, new.de, &ino) ||
> +						ino !=3D =
new.inode->i_ino)

...

> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 035cd3f4785e..d0d5acd1a70d 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -1337,10 +1337,10 @@ static void ext4_update_super(struct =
super_block *sb,
>=20
> 	ext4_blocks_count_set(es, ext4_blocks_count(es) + blocks_count);
> 	ext4_free_blocks_count_set(es, ext4_free_blocks_count(es) + =
free_blocks);
> -	le32_add_cpu(&es->s_inodes_count, EXT4_INODES_PER_GROUP(sb) *
> -		     flex_gd->count);
> -	le32_add_cpu(&es->s_free_inodes_count, EXT4_INODES_PER_GROUP(sb) =
*
> -		     flex_gd->count);
> +	ext4_set_inodes_count(sb, ext4_get_inodes_count(sb) +
> +			      EXT4_INODES_PER_GROUP(sb) * =
flex_gd->count);
> +	ext4_set_free_inodes_count(sb, ext4_get_free_inodes_count(sb) +
> +				   EXT4_INODES_PER_GROUP(sb) * =
flex_gd->count);

(style) align after '(' on previous line

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index ead9406d9cff..455cad8c29e1 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -470,7 +470,7 @@ void __ext4_error_inode(struct inode *inode, const =
char *function,
> 	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
> 		return;
>=20
> -	es->s_last_error_ino =3D cpu_to_le32(inode->i_ino);
> +	ext4_set_last_error_ino(inode->i_sb, cpu_to_le64(inode->i_ino));

(defect) Should be part of next patch that actually converts to 64-bit =
inodes.
Also, this would be double-swabbing "inode->i_ino", since that is being =
done
in the macro now (which also avoids the need to change this code to =
handle
64-bit inodes in your next patch). Should just be:

	ext4_set_last_error_ino(inode->i_sb, inode->i_ino);

> 	es->s_last_error_block =3D cpu_to_le64(block);
> 	if (ext4_error_ratelimit(inode->i_sb)) {
> 		va_start(args, fmt);
> @@ -506,7 +506,7 @@ void __ext4_error_file(struct file *file, const =
char *function,
> 		return;
>=20
> 	es =3D EXT4_SB(inode->i_sb)->s_es;
> -	es->s_last_error_ino =3D cpu_to_le32(inode->i_ino);
> +	ext4_set_last_error_ino(inode->i_sb, cpu_to_le64(inode->i_ino));

(defect) ...

> @@ -717,7 +717,7 @@ __acquires(bitlock)
> 	if (unlikely(ext4_forced_shutdown(EXT4_SB(sb))))
> 		return;
>=20
> -	es->s_last_error_ino =3D cpu_to_le32(ino);
> +	ext4_set_last_error_ino(sb, cpu_to_le64(ino));

(defect) ...

> @@ -829,8 +829,8 @@ static void dump_orphan_list(struct super_block =
*sb, struct ext4_sb_info *sbi)
> {
> 	struct list_head *l;
>=20
> -	ext4_msg(sb, KERN_ERR, "sb orphan head is %d",
> -		 le32_to_cpu(sbi->s_es->s_last_orphan));
> +	ext4_msg(sb, KERN_ERR, "sb orphan head is %llu",
> +		 le64_to_cpu(ext4_get_last_orphan(sb)));

(defect) ... should just be "ext4_get_last_orphan(sb)" without swab

> @@ -2483,11 +2483,12 @@ static void ext4_orphan_cleanup(struct =
super_block *sb,
> 		 */
> 		if (EXT4_SB(sb)->s_mount_state & EXT4_ERROR_FS) {
> 			jbd_debug(1, "Skipping orphan recovery on fs =
with errors.\n");
> -			es->s_last_orphan =3D 0;
> +			ext4_set_last_orphan(sb, 0);
> 			break;
> 		}
>=20
> -		inode =3D ext4_orphan_get(sb, =
le32_to_cpu(es->s_last_orphan));
> +		inode =3D ext4_orphan_get(sb,
> +					=
le64_to_cpu(ext4_get_last_orphan(sb)));

(defect) ...

> @@ -2811,9 +2812,9 @@ static void print_daily_error_info(unsigned long =
arg)
> 		       (int) sizeof(es->s_first_error_func),
> 		       es->s_first_error_func,
> 		       le32_to_cpu(es->s_first_error_line));
> -		if (es->s_first_error_ino)
> -			printk(KERN_CONT ": inode %u",
> -			       le32_to_cpu(es->s_first_error_ino));
> +		if (ext4_get_first_error_ino(sb))
> +			printk(KERN_CONT ": inode %llu",
> +			       =
le64_to_cpu(ext4_get_first_error_ino(sb)));

(defect) no need for swab

Also, since the inodes are always "unsigned long" you can just change =
the
format to "%lu" and no need to change it in your next patch.

> @@ -2825,9 +2826,9 @@ static void print_daily_error_info(unsigned long =
arg)
> 		       (int) sizeof(es->s_last_error_func),
> 		       es->s_last_error_func,
> 		       le32_to_cpu(es->s_last_error_line));
> -		if (es->s_last_error_ino)
> -			printk(KERN_CONT ": inode %u",
> -			       le32_to_cpu(es->s_last_error_ino));
> +		if (ext4_get_last_error_ino(sb))
> +			printk(KERN_CONT ": inode %llu",
> +			       =
le64_to_cpu(ext4_get_last_error_ino(sb)));

(defect) ...

> @@ -4705,9 +4706,9 @@ static int ext4_commit_super(struct super_block =
*sb, int sync)
> 			EXT4_C2B(EXT4_SB(sb), =
percpu_counter_sum_positive(
> 				&EXT4_SB(sb)->s_freeclusters_counter)));
> 	if =
(percpu_counter_initialized(&EXT4_SB(sb)->s_freeinodes_counter))
> -		es->s_free_inodes_count =3D
> -			cpu_to_le32(percpu_counter_sum_positive(
> -				&EXT4_SB(sb)->s_freeinodes_counter));
> +		ext4_set_free_inodes_count(sb,
> +				cpu_to_le32(percpu_counter_sum_positive(
> +				&EXT4_SB(sb)->s_freeinodes_counter)));

(defect) no need for swab

Cheers, Andreas






--Apple-Mail=_1676683B-1EF5-414F-AF33-41507DE69601
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlp09fUACgkQcqXauRfM
H+AZgw/9GfXgAFIIlEG/jC6OzpnN/y8g1NLopTFHyPxbE+vhVBzZvJG1eS9RRWzs
e996DtIvhfEBetgLDB8iV+XzP09Kwa/8ABLPD0RUbYomowpck+y3hN5DM83WfESl
Tz+RPQtue1UVD0HQyTLZoVxA6ZNRcaj39JDCeRjGmPPINB0t9n+CLo13vVzEaXb+
lDA1anlcf2QPrquB030fIYsno9NP8X1vL5l/4Z64vPy3qp4gARsPBPT3W7DuNsF5
qAiqrrQ/ZLD4EQ56yugC/SbenKghCDWpPIEYcwZRfawWvE8EjOrXxwDnJwDz6bOL
+wEOOTmKwkZ4jKRDk93JGXk6upnWCbmHHtwINgYjrgR6oKhamPBblkXSDkRf4pae
1fdZ+YuJmQJGCB/CCyFWSsIRYomdepG7IwEXmtDpZW3rEGKJSMB+Uq5lhPfri3MJ
4G4WU5LTpTTpQBDQCNpj4S5OaigXmsmmjOv4Iq0UDUEK11HRRdHHDlzLECg6u+U6
VtLvlcZsEGNus8zXSZoXLPtEbKT9ZzVv3oK2Ne/MTQ8GiniTHTt612g0dkKvUNo7
LRUKJQYdYcXdvC6nGmBb59AQx+279AG3iQO0Q2oWJ3udZTX4ZmhyoyWeXLN53mR9
WBplrofNjiIc0ecFnJQrzEs3xfrSxG8skDCf1Gv6k93Mq/tcpd0=
=9b2H
-----END PGP SIGNATURE-----

--Apple-Mail=_1676683B-1EF5-414F-AF33-41507DE69601--
