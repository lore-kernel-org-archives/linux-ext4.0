From: Robin Dong <hao.bigrat@gmail.com>
Subject: Re: [PATCH 2/2] ext4 directory index: read-ahead blocks
Date: Sat, 18 Jun 2011 15:45:08 +0800
Message-ID: <BANLkTi=XSr9HkMOSbfVA2zOdGyd3CA3k2Q@mail.gmail.com>
References: <20110617160055.2062012.47590.stgit@localhost.localdomain>
	<20110617160100.2062012.50927.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Bernd Schubert <bernd.schubert@fastmail.fm>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49681 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab1FRHpJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Jun 2011 03:45:09 -0400
Received: by iwn34 with SMTP id 34so2566421iwn.19
        for <linux-ext4@vger.kernel.org>; Sat, 18 Jun 2011 00:45:08 -0700 (PDT)
In-Reply-To: <20110617160100.2062012.50927.stgit@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/6/18 Bernd Schubert <bernd.schubert@fastmail.fm>:
> While creating files in large directories we noticed an endless numbe=
r
> of 4K reads. And those reads very much reduced file creation numbers
> as shown by bonnie. While we would expect about 2000 creates/s, we
> only got about 25 creates/s. Running the benchmarks for a long time
> improved the numbers, but not above 200 creates/s.
> It turned out those reads came from directory index block reads
> and probably the bh cache never cached all dx blocks. Given by
> the high number of directories we have (8192) and number of files req=
uired
> to trigger the issue (16 million), rather probably bh cached dx block=
s
> got lost in favour of other less important blocks.
> The patch below implements a read-ahead for *all* dx blocks of a dire=
ctory
> if a single dx block is missing in the cache. That also helps the LRU
> to cache important dx blocks.
>
> Unfortunately, it also has a performance trade-off for the first acce=
ss to
> a directory, although the READA flag is set already.
> Therefore at least for now, this option is disabled by default, but m=
ay
> be enabled using 'mount -o dx_read_ahead' or 'mount -odx_read_ahead=3D=
1'
>
> Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
> ---
> =A0Documentation/filesystems/ext4.txt | =A0 =A06 ++++
> =A0fs/ext4/ext4.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A03 =
++
> =A0fs/ext4/inode.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 28 ++=
++++++++++++++++
> =A0fs/ext4/namei.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 56 ++=
+++++++++++++++++++++++++++++++---
> =A0fs/ext4/super.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 17 ++=
+++++++++
> =A05 files changed, 106 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/filesystems/ext4.txt b/Documentation/files=
ystems/ext4.txt
> index 3ae9bc9..fad70ea 100644
> --- a/Documentation/filesystems/ext4.txt
> +++ b/Documentation/filesystems/ext4.txt
> @@ -404,6 +404,12 @@ dioread_nolock =A0 =A0 =A0 =A0 =A0 =A0 locking. =
If the dioread_nolock option is specified
> =A0i_version =A0 =A0 =A0 =A0 =A0 =A0 =A0Enable 64-bit inode version s=
upport. This option is
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0off by default.
>
> +dx_read_ahead =A0 =A0 =A0 =A0 =A0Enables read-ahead of directory ind=
ex blocks.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 This option should be e=
nabled if the filesystem several
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 directories with a high=
 number of files. Disadvantage
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 is that on first access=
 to a directory additional reads
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 come up, which might sl=
ow down other operations.
> +
> =A0Data Mode
> =A0=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =A0There are 3 different data modes:
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 1921392..997323a 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -916,6 +916,8 @@ struct ext4_inode_info {
> =A0#define EXT4_MOUNT_DISCARD =A0 =A0 =A0 =A0 =A0 =A0 0x40000000 /* I=
ssue DISCARD requests */
> =A0#define EXT4_MOUNT_INIT_INODE_TABLE =A0 =A00x80000000 /* Initializ=
e uninitialized itables */
>
> +#define EXT4_MOUNT2_DX_READ_AHEAD =A0 =A0 =A00x00002 /* Read ahead d=
irectory index blocks */
> +
> =A0#define clear_opt(sb, opt) =A0 =A0 =A0 =A0 =A0 =A0 EXT4_SB(sb)->s_=
mount_opt &=3D \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0~EXT4_MOUNT_##opt
> =A0#define set_opt(sb, opt) =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_SB(sb)->=
s_mount_opt |=3D \
> @@ -1802,6 +1804,7 @@ struct buffer_head *ext4_getblk(handle_t *, str=
uct inode *,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0ext4_lblk_t, int, int *);
> =A0struct buffer_head *ext4_bread(handle_t *, struct inode *,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0ext4_lblk_t, int, int *);
> +int ext4_bread_ra(struct inode *inode, ext4_lblk_t block);
> =A0int ext4_get_block(struct inode *inode, sector_t iblock,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct=
 buffer_head *bh_result, int create);
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index a5763e3..938fb6c 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1490,6 +1490,9 @@ struct buffer_head *ext4_getblk(handle_t *handl=
e, struct inode *inode,
> =A0 =A0 =A0 =A0return bh;
> =A0}
>
> +/*
> + =A0* Synchronous read of blocks
> + =A0*/
> =A0struct buffer_head *ext4_bread(handle_t *handle, struct inode *ino=
de,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_lblk=
_t block, int create, int *err)
> =A0{
> @@ -1500,6 +1503,7 @@ struct buffer_head *ext4_bread(handle_t *handle=
, struct inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return bh;
> =A0 =A0 =A0 =A0if (buffer_uptodate(bh))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return bh;
> +
> =A0 =A0 =A0 =A0ll_rw_block(READ_META, 1, &bh);
> =A0 =A0 =A0 =A0wait_on_buffer(bh);
> =A0 =A0 =A0 =A0if (buffer_uptodate(bh))
> @@ -1509,6 +1513,30 @@ struct buffer_head *ext4_bread(handle_t *handl=
e, struct inode *inode,
> =A0 =A0 =A0 =A0return NULL;
> =A0}
>
> +/*
> + * Read-ahead blocks
> + */
> +int ext4_bread_ra(struct inode *inode, ext4_lblk_t block)
> +{
> + =A0 =A0 =A0 struct buffer_head *bh;
> + =A0 =A0 =A0 int err;
> +
> + =A0 =A0 =A0 bh =3D ext4_getblk(NULL, inode, block, 0, &err);
> + =A0 =A0 =A0 if (!bh)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> +
> + =A0 =A0 =A0 if (buffer_uptodate(bh)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 brelse(bh);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 ll_rw_block(READA, 1, &bh);
> +
> + =A0 =A0 =A0 brelse(bh);
> + =A0 =A0 =A0 return 0;
> +}
> +
> +
> =A0static int walk_page_buffers(handle_t *handle,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct buffer=
_head *head,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned from=
,
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 6f32da4..78290f0 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -334,6 +334,35 @@ struct stats dx_show_entries(struct dx_hash_info=
 *hinfo, struct inode *dir,
> =A0#endif /* DX_DEBUG */
>
> =A0/*
> + * Read ahead directory index blocks
> + */
> +static void dx_ra_blocks(struct inode *dir, struct dx_entry * entrie=
s)
> +{
> + =A0 =A0 =A0 int i, err =3D 0;
> + =A0 =A0 =A0 unsigned num_entries =3D dx_get_count(entries);
> +
> + =A0 =A0 =A0 if (num_entries < 2 || num_entries > dx_get_limit(entri=
es)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dxtrace(printk("dx read-ahead: invalid =
number of entries\n"));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 dxtrace(printk("dx read-ahead: %d entries in dir-ino %l=
u \n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_entries, dir->i_ino=
));
> +
> + =A0 =A0 =A0 i =3D 1; /* skip first entry, it was already read in by=
 the caller */
> + =A0 =A0 =A0 do {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct dx_entry *entry;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_lblk_t block;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 entry =3D entries + i;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 block =3D dx_get_block(entry);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_bread_ra(dir, dx_get_block=
(entry));

I think your meaning may be:

block =3D dx_get_block(entry);
err =3D ext4_bread_ra(dir, block);

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 i++;
> + =A0 =A0 =A0 =A0} while (i < num_entries && !err);
> +}
> +
> +/*
> =A0* Probe for a directory leaf block to search.
> =A0*
> =A0* dx_probe can return ERR_BAD_DX_DIR, which means there was a form=
at
> @@ -347,11 +376,12 @@ dx_probe(const struct qstr *d_name, struct inod=
e *dir,
> =A0 =A0 =A0 =A0 struct dx_hash_info *hinfo, struct dx_frame *frame_in=
, int *err)
> =A0{
> =A0 =A0 =A0 =A0unsigned count, indirect;
> - =A0 =A0 =A0 struct dx_entry *at, *entries, *p, *q, *m;
> + =A0 =A0 =A0 struct dx_entry *at, *entries, *ra_entries, *p, *q, *m;
> =A0 =A0 =A0 =A0struct dx_root *root;
> =A0 =A0 =A0 =A0struct buffer_head *bh;
> =A0 =A0 =A0 =A0struct dx_frame *frame =3D frame_in;
> =A0 =A0 =A0 =A0u32 hash;
> + =A0 =A0 =A0 bool did_ra =3D false;
>
> =A0 =A0 =A0 =A0frame->bh =3D NULL;
> =A0 =A0 =A0 =A0if (!(bh =3D ext4_bread (NULL,dir, 0, 0, err)))
> @@ -390,7 +420,7 @@ dx_probe(const struct qstr *d_name, struct inode =
*dir,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto fail;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 entries =3D (struct dx_entry *) (((char *)&root->info) =
+
> + =A0 =A0 =A0 ra_entries =3D entries =3D (struct dx_entry *) (((char =
*)&root->info) +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 root->info.info_length);
>
> =A0 =A0 =A0 =A0if (dx_get_limit(entries) !=3D dx_root_limit(dir,
> @@ -446,9 +476,27 @@ dx_probe(const struct qstr *d_name, struct inode=
 *dir,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0frame->bh =3D bh;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0frame->entries =3D entries;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0frame->at =3D at;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!indirect--) return frame;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!(bh =3D ext4_bread (NULL,dir, dx_g=
et_block(at), 0, err)))
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!did_ra && test_opt2(dir->i_sb, DX_=
READ_AHEAD)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* read-ahead of dx blo=
cks */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct buffer_head *tes=
t_bh;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_lblk_t block =3D d=
x_get_block(at);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 test_bh =3D ext4_getblk=
(NULL, dir, block, 0, err);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (test_bh && !buffer_=
uptodate(test_bh)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dx_ra_b=
locks(dir, ra_entries);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 did_ra =
=3D true;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 brelse(test_bh);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!indirect--)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return frame;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D ext4_bread(NULL, dir, dx_get_blo=
ck(at), 0, err);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!bh)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto fail2;
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0at =3D entries =3D ((struct dx_node *)=
 bh->b_data)->entries;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (dx_get_limit(entries) !=3D dx_node=
_limit (dir)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_warning(dir->i_sb=
,
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index cc5c157..9dd7c05 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1119,6 +1119,9 @@ static int ext4_show_options(struct seq_file *s=
eq, struct vfsmount *vfs)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0seq_printf(seq, ",init_inode_table=3D%=
u",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned) sbi->s=
_li_wait_mult);
>
> + =A0 =A0 =A0 if (test_opt2(sb, DX_READ_AHEAD))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_puts(seq, ",dx_read_ahead");
> +
> =A0 =A0 =A0 =A0ext4_show_quota_options(seq, sb);
>
> =A0 =A0 =A0 =A0return 0;
> @@ -1294,6 +1297,7 @@ enum {
> =A0 =A0 =A0 =A0Opt_dioread_nolock, Opt_dioread_lock,
> =A0 =A0 =A0 =A0Opt_discard, Opt_nodiscard,
> =A0 =A0 =A0 =A0Opt_init_inode_table, Opt_noinit_inode_table,
> + =A0 =A0 =A0 Opt_dx_read_ahead,
> =A0};
>
> =A0static const match_table_t tokens =3D {
> @@ -1369,6 +1373,8 @@ static const match_table_t tokens =3D {
> =A0 =A0 =A0 =A0{Opt_init_inode_table, "init_itable=3D%u"},
> =A0 =A0 =A0 =A0{Opt_init_inode_table, "init_itable"},
> =A0 =A0 =A0 =A0{Opt_noinit_inode_table, "noinit_itable"},
> + =A0 =A0 =A0 {Opt_dx_read_ahead, "dx_read_ahead=3D%u"},
> + =A0 =A0 =A0 {Opt_dx_read_ahead, "dx_read_ahead"},
> =A0 =A0 =A0 =A0{Opt_err, NULL},
> =A0};
>
> @@ -1859,6 +1865,17 @@ set_qf_format:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case Opt_noinit_inode_table:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0clear_opt(sb, INIT_INO=
DE_TABLE);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case Opt_dx_read_ahead:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (args[0].from) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mat=
ch_int(&args[0], &option))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 return 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 option =
=3D 1; =A0 =A0 /* No argument, default to 1 */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (option)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_opt=
2(sb, DX_READ_AHEAD);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_o=
pt2(sb, DX_READ_AHEAD);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0default:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_msg(sb, KERN_ERR,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Unrecogn=
ized mount option \"%s\" "
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
--
Best Regard
Robin Dong
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
