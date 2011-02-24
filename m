From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] ext4:Fix a bug in ext4_ext_fiemap_cb().
Date: Thu, 24 Feb 2011 08:33:19 +0800
Message-ID: <AANLkTi=E_yGKHS8J3=hW2jxv+8wmTDJSPPysGihV84AR@mail.gmail.com>
References: <1298476779-27883-1-git-send-email-xiaoqiangnk@gmail.com>
	<4D6538C6.4090004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37234 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab1BXAdW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Feb 2011 19:33:22 -0500
Received: by eyx24 with SMTP id 24so2946eyx.19
        for <linux-ext4@vger.kernel.org>; Wed, 23 Feb 2011 16:33:20 -0800 (PST)
In-Reply-To: <4D6538C6.4090004@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 24, 2011 at 12:41 AM, Eric Sandeen <sandeen@redhat.com> wro=
te:
> On 2/23/11 9:59 AM, Yongqiang Yang wrote:
>> 1] Delayed extents after a hole are neglected.
>>
>> =A0 =A0By using find_get_pages() instead of find_get_page() to
>> =A0 =A0lookup pagecache, delayed extents can be found, because
>> =A0 =A0find_get_pages() with nr_pages=3D1 will return the next page
>> =A0 =A0in pagecache.
>>
>> 2] Extents after a delayed extent or a hole are neglected as well.
>>
>> =A0 =A0Fix it by accurating the request range by the result of
>> =A0 =A0ext4_ext_next_allocated_block().
>>
>> Reported by Chris Mason <chris.mason@oracle.com>:
>> We've had reports on btrfs that cp is giving us files full of zeros
>> instead of actually copying them. =A0It was tracked down to a bug wi=
th
>> the btrfs fiemap implementation where it was returning holes for
>> delalloc ranges.
>>
>> Newer versions of cp are trusting fiemap to tell it where the holes
>> are, which does seem like a pretty neat trick.
>>
>> I decided to give xfs and ext4 a shot with a few tests cases too, xf=
s
>> passed with all the ones btrfs was getting wrong, and ext4 got the b=
asic
>> delalloc case right.
>> $ mkfs.ext4 /dev/xxx
>> $ mount /dev/xxx /mnt
>> $ dd if=3D/dev/zero of=3D/mnt/foo bs=3D1M count=3D1
>> $ fiemap-test foo
>> ext: =A0 0 logical: [ =A0 =A0 =A0 0.. =A0 =A0 255] phys: =A0 =A0 =A0=
 =A00.. =A0 =A0 255
>> flags: 0x007 tot: 256
>>
>> Horray! =A0But once we throw a hole in, things go bad:
>> $ mkfs.ext4 /dev/xxx
>> $ mount /dev/xxx /mnt
>> $ dd if=3D/dev/zero of=3D/mnt/foo bs=3D1M count=3D1 seek=3D1
>> $ fiemap-test foo
>> < no output >
>>
>> We've got a delalloc extent after the hole and ext4 fiemap didn't fi=
nd
>> it. =A0If I run sync to kick the delalloc out:
>> $sync
>> $ fiemap-test foo
>> ext: =A0 0 logical: [ =A0 =A0 256.. =A0 =A0 511] phys: =A0 =A034048.=
=2E =A0 34303
>> flags: 0x001 tot: 256
>>
>> fiemap-test is sitting in my /usr/local/bin, and I have no idea how =
it
>> got there. =A0It's full of pretty comments so I know it isn't mine, =
but
>> you can grab it here:
>>
>> http://oss.oracle.com/~mason/fiemap-test.c
>>
>> xfsqa has a fiemap program too.
>>
>> After Fix, test results are as follows:
>> ext: =A0 0 logical: [ =A0 =A0 256.. =A0 =A0 511] phys: =A0 =A0 =A0 =A0=
0.. =A0 =A0 255
>> flags: 0x007 tot: 256
>> ext: =A0 0 logical: [ =A0 =A0 256.. =A0 =A0 511] phys: =A0 =A033280.=
=2E =A0 33535
>> flags: 0x001 tot: 256
>>
>> Signe-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> ---
>> =A0fs/ext4/extents.c | =A0 26 +++++++++++++++++++++++---
>> =A0mm/filemap.c =A0 =A0 =A0| =A0 =A01 +
>> =A02 files changed, 24 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index ccce8a7..ad455a0 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -3788,17 +3788,27 @@ static int ext4_ext_fiemap_cb(struct inode *=
inode, struct ext4_ext_path *path,
>> =A0 =A0 =A0 __u64 =A0 physical;
>> =A0 =A0 =A0 __u64 =A0 length;
>> =A0 =A0 =A0 __u32 =A0 flags =3D 0;
>> + =A0 =A0 ext4_lblk_t end;
>> =A0 =A0 =A0 int =A0 =A0 error;
>>
>> =A0 =A0 =A0 logical =3D =A0(__u64)newex->ec_block << blksize_bits;
>>
>> - =A0 =A0 if (newex->ec_start =3D=3D 0) {
>> + =A0 =A0 if (!newex->ec_start) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* There is no extent contains @newex->e=
c_block block.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* It implies that @newex->ec_block bloc=
k lies 1)a hole
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* or 2)delayed-allocated blocks that ha=
s not been
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* allocated, so pagecache is needed to =
lookup.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* And if it is case 2, @newex->ec_len n=
eeds to be corrected.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pgoff_t offset;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct page *page;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct buffer_head *bh =3D NULL;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset =3D logical >> PAGE_SHIFT;
>> - =A0 =A0 =A0 =A0 =A0 =A0 page =3D find_get_page(inode->i_mapping, o=
ffset);
>> + =A0 =A0 =A0 =A0 =A0 =A0 (void)find_get_pages(inode->i_mapping, off=
set, 1, &page);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!page || !page_has_buffers(page))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return EXT_CONTINUE;
>>
>> @@ -3807,8 +3817,13 @@ static int ext4_ext_fiemap_cb(struct inode *i=
node, struct ext4_ext_path *path,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!bh)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return EXT_CONTINUE;
>>
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* Assume block-size equals page-size. */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (buffer_delay(bh)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D FIEMAP_EXTENT=
_DELALLOC;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (page->index > offset) =
{
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 logical =3D=
 =A0((__u64)page->index << PAGE_SHIFT);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 newex->ec_=
block =3D logical >> blksize_bits;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(page)=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(page)=
;
>> @@ -3830,7 +3845,8 @@ static int ext4_ext_fiemap_cb(struct inode *in=
ode, struct ext4_ext_path *path,
>> =A0 =A0 =A0 =A0*
>> =A0 =A0 =A0 =A0* XXX this might miss a single-block extent at EXT_MA=
X_BLOCK
>> =A0 =A0 =A0 =A0*/
>> - =A0 =A0 if (ext4_ext_next_allocated_block(path) =3D=3D EXT_MAX_BLO=
CK ||
>> + =A0 =A0 end =3D ext4_ext_next_allocated_block(path);
>
> I think this will fall down if you have:
>
> [ HOLE ][ DELALLOC ][ HOLE ][ ALLOCATED ] won't it?
>
> i.e. your "end" will be the first block of "allocated" right?
Yes, but it neglect nothing.  If we want to deal his model, we need to
lookup dirty pages in specified range.

>
> -Eric
>
>> + =A0 =A0 if (end =3D=3D EXT_MAX_BLOCK ||
>> =A0 =A0 =A0 =A0 =A0 newex->ec_block + newex->ec_len - 1 =3D=3D EXT_M=
AX_BLOCK) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 loff_t size =3D i_size_read(inode);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 loff_t bs =3D EXT4_BLOCK_SIZE(inode->i_s=
b);
>> @@ -3839,8 +3855,12 @@ static int ext4_ext_fiemap_cb(struct inode *i=
node, struct ext4_ext_path *path,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((flags & FIEMAP_EXTENT_DELALLOC) &&
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 logical+length > size)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 length =3D (size - logic=
al + bs - 1) & ~(bs-1);
>> + =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 newex->ec_len =3D end - newex->ec_block;
>> + =A0 =A0 =A0 =A0 =A0 =A0 length =3D (__u64)newex->ec_len << blksize=
_bits;
>> =A0 =A0 =A0 }
>>
>> +
>> =A0 =A0 =A0 error =3D fiemap_fill_next_extent(fieinfo, logical, phys=
ical,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 length, flags);
>> =A0 =A0 =A0 if (error < 0)
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index 83a45d3..1c01ffc 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -803,6 +803,7 @@ repeat:
>> =A0 =A0 =A0 rcu_read_unlock();
>> =A0 =A0 =A0 return ret;
>> =A0}
>> +EXPORT_SYMBOL(find_get_pages);
>>
>> =A0/**
>> =A0 * find_get_pages_contig - gang contiguous pagecache lookup
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
