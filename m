From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH v5] ext4:Make FIEMAP and delayed allocation play well together.
Date: Sun, 27 Feb 2011 16:19:13 +0800
Message-ID: <AANLkTikNpm0vrH_zMpWzEkrXxkHt+5Wy62=quWUtGe5U@mail.gmail.com>
References: <1298794585-13926-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu, sandeen@redhat.com, adilger@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40116 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab1B0ITP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Feb 2011 03:19:15 -0500
Received: by iwn34 with SMTP id 34so2256159iwn.19
        for <linux-ext4@vger.kernel.org>; Sun, 27 Feb 2011 00:19:14 -0800 (PST)
In-Reply-To: <1298794585-13926-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Sorry, I forgot adding emails of Eric and Andreas. It's my fault. Sorry=
 again.

This patch passes xfstest 225 with Eric's patches.

http://oss.sgi.com/pipermail/xfs/2011-February/049525.html
http://oss.sgi.com/pipermail/xfs/2011-February/049527.html

On Sun, Feb 27, 2011 at 4:16 PM, Yongqiang Yang <xiaoqiangnk@gmail.com>=
 wrote:
> 1. lookup dirty pages with specified range in pagecache.
> =A0 If no page is got, then there is no delayed-extent and
> =A0 return with EXT_CONTINUE.
> 2. find the 1st mapped buffer,
> 3. check if the mapped buffer is both in the request range
> =A0 and a delayed buffer. If not, there is no delayed-extent,
> =A0 then return.
> 4. a delayed-extent is found, the extent will be collected.
>
> Reported by Chris Mason <chris.mason@oracle.com>:
> We've had reports on btrfs that cp is giving us files full of zeros
> instead of actually copying them. =A0It was tracked down to a bug wit=
h
> the btrfs fiemap implementation where it was returning holes for
> delalloc ranges.
>
> Newer versions of cp are trusting fiemap to tell it where the holes
> are, which does seem like a pretty neat trick.
>
> I decided to give xfs and ext4 a shot with a few tests cases too, xfs
> passed with all the ones btrfs was getting wrong, and ext4 got the ba=
sic
> delalloc case right.
> $ mkfs.ext4 /dev/xxx
> $ mount /dev/xxx /mnt
> $ dd if=3D/dev/zero of=3D/mnt/foo bs=3D1M count=3D1
> $ fiemap-test foo
> ext: =A0 0 logical: [ =A0 =A0 =A0 0.. =A0 =A0 255] phys: =A0 =A0 =A0 =
=A00.. =A0 =A0 255
> flags: 0x007 tot: 256
>
> Horray! =A0But once we throw a hole in, things go bad:
> $ mkfs.ext4 /dev/xxx
> $ mount /dev/xxx /mnt
> $ dd if=3D/dev/zero of=3D/mnt/foo bs=3D1M count=3D1 seek=3D1
> $ fiemap-test foo
> < no output >
>
> We've got a delalloc extent after the hole and ext4 fiemap didn't fin=
d
> it. =A0If I run sync to kick the delalloc out:
> $sync
> $ fiemap-test foo
> ext: =A0 0 logical: [ =A0 =A0 256.. =A0 =A0 511] phys: =A0 =A034048..=
 =A0 34303
> flags: 0x001 tot: 256
>
> fiemap-test is sitting in my /usr/local/bin, and I have no idea how i=
t
> got there. =A0It's full of pretty comments so I know it isn't mine, b=
ut
> you can grab it here:
>
> http://oss.oracle.com/~mason/fiemap-test.c
>
> xfsqa has a fiemap program too.
>
> After Fix, test results are as follows:
> ext: =A0 0 logical: [ =A0 =A0 256.. =A0 =A0 511] phys: =A0 =A0 =A0 =A0=
0.. =A0 =A0 255
> flags: 0x007 tot: 256
> ext: =A0 0 logical: [ =A0 =A0 256.. =A0 =A0 511] phys: =A0 =A033280..=
 =A0 33535
> flags: 0x001 tot: 256
>
> $ mkfs.ext4 /dev/xxx
> $ mount /dev/xxx /mnt
> $ dd if=3D/dev/zero of=3D/mnt/foo bs=3D1M count=3D1 seek=3D1
> $ sync
> $ dd if=3D/dev/zero of=3D/mnt/foo bs=3D1M count=3D1 seek=3D3
> $ dd if=3D/dev/zero of=3D/mnt/foo bs=3D1M count=3D1 seek=3D5
> $ fiemap-test foo
> ext: =A0 0 logical: [ =A0 =A0 256.. =A0 =A0 511] phys: =A0 =A033280..=
 =A0 33535
> flags: 0x000 tot: 256
> ext: =A0 1 logical: [ =A0 =A0 768.. =A0 =A01023] phys: =A0 =A0 =A0 =A0=
0.. =A0 =A0 255
> flags: 0x006 tot: 256
> ext: =A0 2 logical: [ =A0 =A01280.. =A0 =A01535] phys: =A0 =A0 =A0 =A0=
0.. =A0 =A0 255
> flags: 0x007 tot: 256
>
> Tested-by: Eric Sandeen
> Reviewed-by: Andreas Dilger
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> =A0fs/ext4/extents.c | =A0187 +++++++++++++++++++++++++++++++++++++++=
+++-----------
> =A01 files changed, 148 insertions(+), 39 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ccce8a7..00ed687 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3775,6 +3775,7 @@ int ext4_convert_unwritten_extents(struct inode=
 *inode, loff_t offset,
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0return ret > 0 ? ret2 : ret;
> =A0}
> +
> =A0/*
> =A0* Callback function called for each extent to gather FIEMAP inform=
ation.
> =A0*/
> @@ -3782,38 +3783,162 @@ static int ext4_ext_fiemap_cb(struct inode *=
inode, struct ext4_ext_path *path,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ext4_ext_cache *ne=
wex, struct ext4_extent *ex,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 void *data)
> =A0{
> - =A0 =A0 =A0 struct fiemap_extent_info *fieinfo =3D data;
> - =A0 =A0 =A0 unsigned char blksize_bits =3D inode->i_sb->s_blocksize=
_bits;
> =A0 =A0 =A0 =A0__u64 =A0 logical;
> =A0 =A0 =A0 =A0__u64 =A0 physical;
> =A0 =A0 =A0 =A0__u64 =A0 length;
> + =A0 =A0 =A0 loff_t =A0size;
> =A0 =A0 =A0 =A0__u32 =A0 flags =3D 0;
> - =A0 =A0 =A0 int =A0 =A0 error;
> + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 ret =3D 0;
> + =A0 =A0 =A0 struct fiemap_extent_info *fieinfo =3D data;
> + =A0 =A0 =A0 unsigned char blksize_bits;
>
> - =A0 =A0 =A0 logical =3D =A0(__u64)newex->ec_block << blksize_bits;
> + =A0 =A0 =A0 blksize_bits =3D inode->i_sb->s_blocksize_bits;
> + =A0 =A0 =A0 logical =3D (__u64)newex->ec_block << blksize_bits;
>
> =A0 =A0 =A0 =A0if (newex->ec_start =3D=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pgoff_t offset;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct page *page;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* No extent in extent-tree contains =
block @newex->ec_start,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* then the block may stay in 1)a hol=
e or 2)delayed-extent.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Holes or delayed-extents are proce=
ssed as follows.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* 1. lookup dirty pages with specifi=
ed range in pagecache.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* =A0 =A0If no page is got, then the=
re is no delayed-extent and
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* =A0 =A0return with EXT_CONTINUE.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* 2. find the 1st mapped buffer,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* 3. check if the mapped buffer is b=
oth in the request range
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* =A0 =A0and a delayed buffer. If no=
t, there is no delayed-extent,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* =A0 =A0then return.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* 4. a delayed-extent is found, the =
extent will be collected.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_lblk_t =A0 =A0 end =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pgoff_t =A0 =A0 =A0 =A0 last_offset;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pgoff_t =A0 =A0 =A0 =A0 offset;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pgoff_t =A0 =A0 =A0 =A0 index;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct page =A0 =A0 **pages =3D NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct buffer_head *bh =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct buffer_head *head =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int nr_pages =3D PAGE_SIZE / s=
izeof(struct page *);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pages =3D kmalloc(PAGE_SIZE, GFP_KERNEL=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pages =3D=3D NULL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0offset =3D logical >> PAGE_SHIFT;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 page =3D find_get_page(inode->i_mapping=
, offset);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!page || !page_has_buffers(page))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return EXT_CONTINUE;
> +repeat:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 last_offset =3D offset;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 head =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D find_get_pages_tag(inode->i_map=
ping, &offset,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 PAGECACHE_TAG_DIRTY, nr_pages, pages);
> +
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
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
EXT_CONTINUE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D page_buffers(page);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Try to find the 1st =
mapped buffer. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 end =3D ((__u64)pages[0=
]->index << PAGE_SHIFT) >>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blk=
size_bits;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!page_has_buffers(p=
ages[0]))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 head =3D page_buffers(p=
ages[0]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!head)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!bh)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return EXT_CONTINUE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D head;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 do {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (buf=
fer_mapped(bh)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 /* get the 1st mapped buffer. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 if (end > newex->ec_block +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 newex->ec_len)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 /* The buffer is out of
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0* the request range.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 goto found_mapped_buffer;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D =
bh->b_this_page;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 end++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } while (bh !=3D head);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (buffer_delay(bh)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D FIEMAP_EXTEN=
T_DELALLOC;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(page=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* No mapped buffer fou=
nd. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(page=
);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return EXT_CONTINUE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*Find contiguous delay=
ed buffers. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret > 0 && pages[0]=
->index =3D=3D last_offset)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 head =3D=
 page_buffers(pages[0]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D head;
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
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (index =3D 1; index=
 < ret; index++) {
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
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pag=
es[index]->index !=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 pages[0]->index + index) {
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
 =A0 =A0 =A0 =A0 =A0 =A0 (ext4_lblk_t)EXT_INIT_MAX_LEN);
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
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (index =3D 0; index < ret; index++)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(page=
s[index]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(pages);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0physical =3D (__u64)newex->ec_start << blksize_bits;
> @@ -3822,32 +3947,16 @@ static int ext4_ext_fiemap_cb(struct inode *i=
node, struct ext4_ext_path *path,
> =A0 =A0 =A0 =A0if (ex && ext4_ext_is_uninitialized(ex))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flags |=3D FIEMAP_EXTENT_UNWRITTEN;
>
> - =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0* If this extent reaches EXT_MAX_BLOCK, it must be l=
ast.
> - =A0 =A0 =A0 =A0*
> - =A0 =A0 =A0 =A0* Or if ext4_ext_next_allocated_block is EXT_MAX_BLO=
CK,
> - =A0 =A0 =A0 =A0* this also indicates no more allocated blocks.
> - =A0 =A0 =A0 =A0*
> - =A0 =A0 =A0 =A0* XXX this might miss a single-block extent at EXT_M=
AX_BLOCK
> - =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 if (ext4_ext_next_allocated_block(path) =3D=3D EXT_MAX_=
BLOCK ||
> - =A0 =A0 =A0 =A0 =A0 newex->ec_block + newex->ec_len - 1 =3D=3D EXT_=
MAX_BLOCK) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 loff_t size =3D i_size_read(inode);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 loff_t bs =3D EXT4_BLOCK_SIZE(inode->i_=
sb);
> -
> + =A0 =A0 =A0 size =3D i_size_read(inode);
> + =A0 =A0 =A0 if (logical + length >=3D size)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flags |=3D FIEMAP_EXTENT_LAST;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((flags & FIEMAP_EXTENT_DELALLOC) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 logical+length > size)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 length =3D (size - logi=
cal + bs - 1) & ~(bs-1);
> - =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 error =3D fiemap_fill_next_extent(fieinfo, logical, phy=
sical,
> + =A0 =A0 =A0 ret =3D fiemap_fill_next_extent(fieinfo, logical, physi=
cal,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0length, flags);
> - =A0 =A0 =A0 if (error < 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return error;
> - =A0 =A0 =A0 if (error =3D=3D 1)
> + =A0 =A0 =A0 if (ret < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 if (ret =3D=3D 1)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return EXT_BREAK;
> -
> =A0 =A0 =A0 =A0return EXT_CONTINUE;
> =A0}
>
> --
> 1.7.4
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
