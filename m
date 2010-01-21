From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH V2] Add flag to files with blocks intentionally past EOF
Date: Thu, 21 Jan 2010 12:32:04 -0800
Message-ID: <5df78e1d1001211232n1aab06dav3cbb54461d29bafa@mail.gmail.com>
References: <4B5627EF.3080804@redhat.com> <4B58963E.4080007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:59288 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab0AUUcI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jan 2010 15:32:08 -0500
Received: from spaceape23.eur.corp.google.com (spaceape23.eur.corp.google.com [172.28.16.75])
	by smtp-out.google.com with ESMTP id o0LKW6th022919
	for <linux-ext4@vger.kernel.org>; Thu, 21 Jan 2010 20:32:07 GMT
Received: from pwj10 (pwj10.prod.google.com [10.241.219.74])
	by spaceape23.eur.corp.google.com with ESMTP id o0LKW48D010118
	for <linux-ext4@vger.kernel.org>; Thu, 21 Jan 2010 12:32:05 -0800
Received: by pwj10 with SMTP id 10so287589pwj.6
        for <linux-ext4@vger.kernel.org>; Thu, 21 Jan 2010 12:32:04 -0800 (PST)
In-Reply-To: <4B58963E.4080007@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric,

Thank you very much for bringing the patch up-to-date and improving it!
I have been thinking to re-sync it and send it again but was pulled awa=
y
but other things.

The patch looks good. I think it is ok to drop the ioctl support at thi=
s
time. We can add it later if there are users need that feature.

Jiaying

On Thu, Jan 21, 2010 at 10:00 AM, Eric Sandeen <sandeen@redhat.com> wro=
te:
>
> From: Jiaying Zhang <jiayingz@google.com>
>
> fallocate() may potentially instantiate blocks past EOF, depending
> on the flags used when it is called.
>
> e2fsck currently has a test for blocks past i_size, and it
> sometimes trips up - noticeably on xfstests 013 which runs fsstress.
>
> This patch from Jiayang does fix it up - it (along with
> e2fsprogs updates and other patches recently from Aneesh) has
> survived many fsstress runs in a row.
>
>
> (Eric Sandeen: removed ioctl interface and minor cleanups)
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 874d169..1f6b936 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -284,6 +284,7 @@ struct flex_groups {
> =A0#define EXT4_TOPDIR_FL =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x00020000 =
/* Top of directory hierarchies*/
> =A0#define EXT4_HUGE_FILE_FL =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x00040000 /=
* Set to each huge file */
> =A0#define EXT4_EXTENTS_FL =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A00x00080000 /* Inode uses extents */
> +#define EXT4_EOFBLOCKS_FL =A0 =A0 =A0 =A0 =A0 =A0 =A00x00400000 /* B=
locks allocated beyond EOF */
> =A0#define EXT4_RESERVED_FL =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x80000000 /*=
 reserved for ext4 lib */
>
> =A0#define EXT4_FL_USER_VISIBLE =A0 =A0 =A0 =A0 =A0 0x000BDFFF /* Use=
r visible flags */
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 765a482..95e94ae 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3185,7 +3185,7 @@ int ext4_ext_get_blocks(handle_t *handle, struc=
t inode *inode,
> =A0{
> =A0 =A0 =A0 =A0struct ext4_ext_path *path =3D NULL;
> =A0 =A0 =A0 =A0struct ext4_extent_header *eh;
> - =A0 =A0 =A0 struct ext4_extent newex, *ex;
> + =A0 =A0 =A0 struct ext4_extent newex, *ex, *last_ex;
> =A0 =A0 =A0 =A0ext4_fsblk_t newblock;
> =A0 =A0 =A0 =A0int err =3D 0, depth, ret, cache_type;
> =A0 =A0 =A0 =A0unsigned int allocated =3D 0;
> @@ -3366,6 +3366,19 @@ int ext4_ext_get_blocks(handle_t *handle, stru=
ct inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0EXT4_STATE_DIO_UNWRITTEN;;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
> +
> + =A0 =A0 =A0 if (unlikely(EXT4_I(inode)->i_flags & EXT4_EOFBLOCKS_FL=
)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (eh->eh_entries) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 last_ex =3D EXT_LAST_EX=
TENT(eh);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (iblock + ar.len > l=
e32_to_cpu(last_ex->ee_block)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 + ext4_ext_get_actual_len(last_ex))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_I(=
inode)->i_flags &=3D ~EXT4_EOFBLOCKS_FL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(eh->eh_entries =
=3D=3D 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_error(inode->i_sb,=
 __func__,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "inode#=
%lu, eh->eh_entries =3D 0!", inode->i_ino);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0err =3D ext4_ext_insert_extent(handle, inode, path, &n=
ewex, flags);
> =A0 =A0 =A0 =A0if (err) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* free data blocks we just allocated =
*/
> @@ -3499,6 +3512,13 @@ static void ext4_falloc_update_inode(struct in=
ode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0i_size_write(inode, ne=
w_size);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (new_size > EXT4_I(inode)->i_disksi=
ze)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_update_i_disksize=
(inode, new_size);
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Mark that we allocate beyond EOF s=
o the subsequent truncate
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* can proceed even if the new size i=
s the same as i_size.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (new_size > i_size_read(inode))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_I(inode)->i_flags =
|=3D EXT4_EOFBLOCKS_FL;
> =A0 =A0 =A0 =A0}
>
> =A0}
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index cbf56da..f5802e9 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4429,6 +4429,8 @@ void ext4_truncate(struct inode *inode)
> =A0 =A0 =A0 =A0if (!ext4_can_truncate(inode))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
>
> + =A0 =A0 =A0 EXT4_I(inode)->i_flags &=3D ~EXT4_EOFBLOCKS_FL;
> +
> =A0 =A0 =A0 =A0if (inode->i_size =3D=3D 0 && !test_opt(inode->i_sb, N=
O_AUTO_DA_ALLOC))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ei->i_state |=3D EXT4_STATE_DA_ALLOC_C=
LOSE;
>
> @@ -5284,7 +5286,9 @@ int ext4_setattr(struct dentry *dentry, struct =
iattr *attr)
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (S_ISREG(inode->i_mode) &&
> - =A0 =A0 =A0 =A0 =A0 attr->ia_valid & ATTR_SIZE && attr->ia_size < i=
node->i_size) {
> + =A0 =A0 =A0 =A0 =A0 attr->ia_valid & ATTR_SIZE &&
> + =A0 =A0 =A0 =A0 =A0 (attr->ia_size < inode->i_size ||
> + =A0 =A0 =A0 =A0 =A0 =A0(EXT4_I(inode)->i_flags & EXT4_EOFBLOCKS_FL)=
)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0handle_t *handle;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0handle =3D ext4_journal_start(inode, 3=
);
> @@ -5315,6 +5319,9 @@ int ext4_setattr(struct dentry *dentry, struct =
iattr *attr)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto e=
rr_out;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* ext4_truncate will clear the flag */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((EXT4_I(inode)->i_flags & EXT4_EOFB=
LOCKS_FL))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_truncate(inode);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0rc =3D inode_setattr(inode, attr);
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
