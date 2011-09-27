From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] Add SEEK_DATA/SEEK_HOLE support
Date: Tue, 27 Sep 2011 09:32:37 +0800
Message-ID: <CAGBYx2b41YqFifdxSBYckxPVnsgA-_ZO0ZTUnmAgVhbH2s5Y6w@mail.gmail.com>
References: <4E808343.8080205@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: jeff.liu@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:42130 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab1I0Bch convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Sep 2011 21:32:37 -0400
Received: by pzk1 with SMTP id 1so16154985pzk.1
        for <linux-ext4@vger.kernel.org>; Mon, 26 Sep 2011 18:32:37 -0700 (PDT)
In-Reply-To: <4E808343.8080205@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 26, 2011 at 9:50 PM, Jeff Liu <jeff.liu@oracle.com> wrote:
> Dear developer,
>
> Has anyone started working on SEEK_DATA/SEEK_HOLE yet?
> If not, I'd like to submit a patch for it, or please just ignore my n=
oise. :-P.
>
> The mainly idea of how to retrieve the delayed extent info are copied=
 from ext4_ext_fiemap_cb().
> And also, IMHO, for block based file, return -ENOTSUPP is ok?
>
> I have done the following tests, all works for me.
> 1. file start with hole.
> 2. file end with hole.
> 3. file with about 10001 extents on my test env which was created thr=
ough:
> python -c "f=3Dopen('./sptest', 'w'); [(f.seek(x) or f.write(str(x)))=
 for x in range(1, 1000000000, 99999)]; f.close()
>
> Any constructive criticism/comments are welcome, thank you!
>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>
> ---
> =A0fs/ext4/ext4.h =A0 =A0 =A0 =A0 | =A0 =A04 +
> =A0fs/ext4/ext4_extents.h | =A0 =A08 ++
> =A0fs/ext4/extents.c =A0 =A0 =A0| =A0234 ++++++++++++++++++++++++++++=
++++++++++++++++++++
> =A0fs/ext4/file.c =A0 =A0 =A0 =A0 | =A0 14 ++--
> =A04 files changed, 253 insertions(+), 7 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index e717dfd..05b9a3a 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2222,6 +2222,10 @@ extern int ext4_move_extents(struct file *o_fi=
lp, struct file *d_filp,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 start_o=
rig, __u64 start_donor,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u64 len, __=
u64 *moved_len);
>
> +/* extent.c */
> +extern int ext4_find_desired_extent(struct inode *inode, loff_t *off=
set,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 int origin);
> +
> =A0/* page-io.c */
> =A0extern int __init ext4_init_pageio(void);
> =A0extern void ext4_exit_pageio(void);
> diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
> index 095c36f..ca7a339 100644
> --- a/fs/ext4/ext4_extents.h
> +++ b/fs/ext4/ext4_extents.h
> @@ -116,6 +116,14 @@ struct ext4_ext_path {
> =A0};
>
> =A0/*
> + * Structure for retrieving extent offset for SEEK_DATA/SEEK_HOLE.
> + */
> +struct ext4_extent_seek_info {
> + =A0 =A0 =A0 unsigned int origin; =A0 =A0/* SEEK_DATA or SEEK_HOLE *=
/
> + =A0 =A0 =A0 loff_t offset; =A0 =A0 =A0 =A0 =A0/* input/output offse=
t */
> +};
> +
> +/*
> =A0* structure for external API
> =A0*/
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 57cf568..a339e00 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3901,6 +3901,240 @@ int ext4_convert_unwritten_extents(struct ino=
de *inode, loff_t offset,
> =A0}
>
> =A0/*
> + * Callback function called for each extent to gather SEEK_DATA/SEEK=
_HOLE
> + * information.
> + */
> +static int ext4_ext_seek_cb(struct inode *inode, ext4_lblk_t next,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ext4_ext=
_cache *newex,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ext4_ext=
ent *ex,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 void *data)
Hi,

We'd better implement SEEK_DATA and SEEK_HOLE based on FIEMAP,  thus,
code will be much maintainable.   You can have a look at btrfs's
implementation.

There is another important problem here.  This function operates on
pages heavily to collect delayed extents,  as Jan Kara pointed out we
should lock a page before we use the page.  Now the problem comes,
the function is called with i_mutex_lock held, so we can not lock
page, otherwise, deadlock is easy to happen.   To address the problem,
we have two solutions: 1. doing as filemap, releasing i_mutex_block
before calling this function, 2. collecting delayed extent info in an
in-memory extent tree, I am working on it.  The question regarding the
2nd solution is if it is worth adding an in-memory extent tree.
bigalloc has similar problem with delayed extent.

You can have a look at fiemap using delayed extent tree via
http://patchwork.ozlabs.org/patch/112233/.   It is very simple.

Thx!
Yongqiang.

> +{
> + =A0 =A0 =A0 __u64 =A0 logical;
> + =A0 =A0 =A0 __u32 =A0 flags =3D 0;
> + =A0 =A0 =A0 int =A0 =A0 ret =3D 0;
> + =A0 =A0 =A0 unsigned char blksize_bits;
> + =A0 =A0 =A0 struct ext4_extent_seek_info *ext_seek_info =3D data;
> +
> + =A0 =A0 =A0 blksize_bits =3D inode->i_sb->s_blocksize_bits;
> + =A0 =A0 =A0 logical =3D (__u64)newex->ec_block << blksize_bits;
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* No extent in extent-tree contains block @newex->ec=
_start,
> + =A0 =A0 =A0 =A0* then the block may stay in 1)a hole or 2)delayed-e=
xtent.
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* Holes or delayed-extents are processed as follows.
> + =A0 =A0 =A0 =A0* 1. lookup dirty pages with specified range in page=
cache.
> + =A0 =A0 =A0 =A0* =A0 =A0If no page is got, then there is no delayed=
-extent and
> + =A0 =A0 =A0 =A0* =A0 =A0return with EXT_CONTINUE if SEEK_DATA; retu=
rn EXT_BREAK
> + =A0 =A0 =A0 =A0* =A0 =A0with extent offset if SEEK_HOLE.
> + =A0 =A0 =A0 =A0* 2. find the 1st mapped buffer,
> + =A0 =A0 =A0 =A0* 3. check if the mapped buffer is both in the reque=
st range
> + =A0 =A0 =A0 =A0* =A0 =A0and a delayed buffer. If not, there is no d=
elayed-extent,
> + =A0 =A0 =A0 =A0* =A0 =A0then return with EXT_CONTINUE if SEEK_DATA,=
 or return
> + =A0 =A0 =A0 =A0* =A0 =A0EXT_BREAK if SEEK_HOLE and extent offset.
> + =A0 =A0 =A0 =A0* 4. a delayed-extent is found, return the extent of=
fset if
> + =A0 =A0 =A0 =A0* =A0 =A0SEEK_DATA and EXT_BREAK.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (newex->ec_start =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_lblk_t =A0 =A0 end =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pgoff_t =A0 =A0 =A0 =A0 last_offset;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pgoff_t =A0 =A0 =A0 =A0 offset;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pgoff_t =A0 =A0 =A0 =A0 index;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pgoff_t =A0 =A0 =A0 =A0 start_index =3D=
 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct page =A0 =A0 **pages =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct buffer_head *bh =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct buffer_head *head =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int nr_pages =3D PAGE_SIZE / s=
izeof(struct page *);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pages =3D kmalloc(PAGE_SIZE, GFP_KERNEL=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pages =3D=3D NULL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset =3D logical >> PAGE_SHIFT;
> +repeat:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 last_offset =3D offset;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 head =3D NULL;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D find_get_pages_tag(inode->i_map=
ping, &offset,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0PAGECACHE_TAG_DIRTY, nr_pages, pages);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Not a delay allocated extent. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!(flags & FIEMAP_EXTENT_DELALLOC)) =
{
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* First time, try to f=
ind a mapped buffer. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret =3D=3D 0) {
> +out:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (in=
dex =3D 0; index < ret; index++)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 page_cache_release(pages[index]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* just=
 a hole. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(p=
ages);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* If S=
EEK_HOLE, return the logical offset. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ext=
_seek_info->origin =3D=3D SEEK_HOLE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ext_seek_info->offset =3D logical;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 return EXT_BREAK;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
EXT_CONTINUE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 index =3D 0;
> +next_page:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Try to find the 1st =
mapped buffer. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 end =3D ((__u64)pages[i=
ndex]->index << PAGE_SHIFT) >>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk=
size_bits;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!page_has_buffers(p=
ages[index]))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 head =3D page_buffers(p=
ages[index]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!head)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 index++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D head;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 do {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* The =
buffer is out of the request range. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (end=
 >=3D newex->ec_block + newex->ec_len)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 goto out;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (buf=
fer_mapped(bh) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 end >=3D newex->ec_block) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 start_index =3D index - 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 /* get the 1st mapped buffer. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 goto found_mapped_buffer;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D =
bh->b_this_page;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 end++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } while (bh !=3D head);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* No mapped buffer in =
the range found in this page,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* We need to look up=
 next page.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (index >=3D ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Ther=
e is no page left, but we need to limit
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* ne=
wex->ec_len.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 newex->=
ec_len =3D end - newex->ec_block;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto next_page;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*Find contiguous delay=
ed buffers. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret > 0 && pages[0]=
->index =3D=3D last_offset)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 head =3D=
 page_buffers(pages[0]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D head;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 index =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 start_index =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> +found_mapped_buffer:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (bh !=3D NULL && buffer_delay(bh)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* 1st or contiguous de=
layed buffer found. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!(flags & FIEMAP_EX=
TENT_DELALLOC)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* 1s=
t delayed buffer found, record
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* th=
e start of extent.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=
=3D FIEMAP_EXTENT_DELALLOC;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 newex->=
ec_block =3D end;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 logical=
 =3D (__u64)end << blksize_bits;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Find contiguous dela=
yed buffers. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 do {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!bu=
ffer_delay(bh))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 goto found_delayed_extent;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D =
bh->b_this_page;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 end++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } while (bh !=3D head);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (; index < ret; ind=
ex++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!pa=
ge_has_buffers(pages[index])) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 bh =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 head =3D=
 page_buffers(pages[index]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!he=
ad) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 bh =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pag=
es[index]->index !=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 pages[start_index]->index + index
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 - start_index) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 /* Blocks are not contiguous. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 bh =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D =
head;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 do {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 if (!buffer_delay(bh))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 /* Delayed-extent ends. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 goto found_delayed_extent;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 bh =3D bh->b_this_page;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 end++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } while=
 (bh !=3D head);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (!(flags & FIEMAP_EXTENT_DELA=
LLOC))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* a hole found. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> +
> +found_delayed_extent:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 newex->ec_len =3D min(end - newex->ec_b=
lock,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 (ext4_lblk_t)EXT_INIT_MAX_LEN);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret =3D=3D nr_pages && bh !=3D NULL=
 &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 newex->ec_len < EXT_INI=
T_MAX_LEN &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 buffer_delay(bh)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Have not collected a=
n extent and continue. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (index =3D 0; index=
 < ret; index++)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_ca=
che_release(pages[index]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto repeat;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (index =3D 0; index < ret; index++)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(page=
s[index]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(pages);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (ret < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> +
> + =A0 =A0 =A0 if (ext_seek_info->origin =3D=3D SEEK_DATA) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext_seek_info->offset =3D logical;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return EXT_BREAK;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return EXT_CONTINUE;
> +}
> +
> +int ext4_find_desired_extent(struct inode *inode, loff_t *offset, in=
t origin)
> +{
> + =A0 =A0 =A0 ext4_lblk_t start_blk;
> + =A0 =A0 =A0 ext4_lblk_t end_blk;
> + =A0 =A0 =A0 ext4_lblk_t len_blks;
> + =A0 =A0 =A0 struct ext4_extent_seek_info ext_seek_info;
> + =A0 =A0 =A0 unsigned int blkbits =3D inode->i_sb->s_blocksize_bits;
> + =A0 =A0 =A0 int error =3D 0;
> +
> + =A0 =A0 =A0 /* Only support seeking extents based file. */
> + =A0 =A0 =A0 if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOTSUPP;
> +
> + =A0 =A0 =A0 start_blk =3D *offset >> blkbits;
> + =A0 =A0 =A0 if (start_blk >=3D EXT_MAX_BLOCKS)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENXIO;
> +
> + =A0 =A0 =A0 end_blk =3D i_size_read(inode) >> blkbits;
> + =A0 =A0 =A0 len_blks =3D ((ext4_lblk_t)end_blk) - start_blk + 1;
> +
> + =A0 =A0 =A0 ext_seek_info.origin =3D origin;
> + =A0 =A0 =A0 error =3D ext4_ext_walk_space(inode, start_blk, len_blk=
s,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 ext4_ext_seek_cb, &ext_seek_info);
> + =A0 =A0 =A0 if (!error)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *offset =3D ext_seek_info.offset;
> +
> + =A0 =A0 =A0 return error;
> +}
> +
> +/*
> =A0* Callback function called for each extent to gather FIEMAP inform=
ation.
> =A0*/
> =A0static int ext4_ext_fiemap_cb(struct inode *inode, ext4_lblk_t nex=
t,
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index e4095e9..48579d5 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -219,6 +219,7 @@ loff_t ext4_llseek(struct file *file, loff_t offs=
et, int origin)
> =A0{
> =A0 =A0 =A0 =A0struct inode *inode =3D file->f_mapping->host;
> =A0 =A0 =A0 =A0loff_t maxbytes;
> + =A0 =A0 =A0 int ret;
>
> =A0 =A0 =A0 =A0if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))=
)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0maxbytes =3D EXT4_SB(inode->i_sb)->s_b=
itmap_maxbytes;
> @@ -241,21 +242,20 @@ loff_t ext4_llseek(struct file *file, loff_t of=
fset, int origin)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * In the generic case the entire file=
 is data, so as long as
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * offset isn't at the end of the file=
 then the offset is data.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (offset >=3D inode->i_size) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&inode->i_=
mutex);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENXIO;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> =A0 =A0 =A0 =A0case SEEK_HOLE:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * There is a virtual hole at the end =
of the file, so as long as
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * offset isn't i_size or larger, retu=
rn i_size.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (offset >=3D inode->i_size) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (offset >=3D i_size_read(inode)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&inode->i=
_mutex);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENXIO;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset =3D inode->i_size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_find_desired_extent(inode,=
 &offset, origin);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&inode->i_=
mutex);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0}
>
> --
> 1.7.4.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
