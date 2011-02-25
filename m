From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH v1] ext4:Make FIEMAP and delayed allocation play well together.
Date: Fri, 25 Feb 2011 16:05:23 +0800
Message-ID: <AANLkTi=07iQPnKifdD+wdfHySQ6rzgi9EHP0ezBWHN9d@mail.gmail.com>
References: <1298564112-11078-1-git-send-email-xiaoqiangnk@gmail.com>
	<7CF68C64-B56F-4C1C-881B-BB92AD745C3E@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:32817 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab1BYIFY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Feb 2011 03:05:24 -0500
Received: by eyx24 with SMTP id 24so507278eyx.19
        for <linux-ext4@vger.kernel.org>; Fri, 25 Feb 2011 00:05:23 -0800 (PST)
In-Reply-To: <7CF68C64-B56F-4C1C-881B-BB92AD745C3E@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 25, 2011 at 5:14 AM, Andreas Dilger <adilger@dilger.ca> wro=
te:
> On 2011-02-24, at 9:15 AM, Yongqiang Yang wrote:
>> static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_p=
ath *path,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct ext4_ext_cache *ne=
wex, struct ext4_extent *ex,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0void *data)
>> {
>> + =A0 =A0 struct page *pages[NR_PAGES_PER_TIME];
>
> I agree with Eric that this cannot live on the stack (or alternately =
that we need better stack handling in the kernel :-). =A0Fortunately, t=
he kmalloc() of this data only needs to happen in rare cases, so it sho=
uldn't impact performance very much. =A0It might be possible to cache t=
his buffer in newex, to limit the allocation to once per file, instead =
of once per hole, but I'm not sure it is worthwhile.
>
> The benefit of kmalloc() is that it could be a full page or two, and =
allow far fewer calls into pagevec_lookup_tag(), which I suspect is mor=
e of a performance win than the cost of calling kmalloc().
>
>> + =A0 =A0 __u64 =A0logical;
>> + =A0 =A0 __u64 =A0physical;
>> + =A0 =A0 __u64 =A0length;
>> +
>> + =A0 =A0 loff_t =A0size =3D i_size_read(inode);
>> + =A0 =A0 pgoff_t index =3D 0;
>> + =A0 =A0 ext4_lblk_t end =3D 0;
>> +
>> + =A0 =A0 __u32 =A0flags =3D 0;
>> + =A0 =A0 int =A0 =A0 =A0 =A0ret =3D 0;
>
> (style) please align variable declarations in some consistent manner
>
>> =A0 =A0 =A0 struct fiemap_extent_info *fieinfo =3D data;
>> +
>> =A0 =A0 =A0 unsigned char blksize_bits =3D inode->i_sb->s_blocksize_=
bits;
>
> Many of these are specific to the "if (newex->ec_start =3D=3D 0)" con=
text, so should be allocated there to make this more clear.
>
> (style) there shouldn't be blank lines between the variable declarati=
ons. =A0There are also many other CodingStyle violations that should be=
 cleaned up.
>
>> =A0 =A0 =A0 if (newex->ec_start =3D=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* No extent in extent-tree contains blo=
ck @newex->ec_start,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* then the block may stay in 1)a hole o=
r 2)delayed-extent.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* Holes or delayed-extents are processe=
d as follows.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* 1. lookup dirty pages with specified =
range in pagecache.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* =A0 =A0If no page is got, then there =
is no delayed-extent and
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* =A0 =A0return with EXT_CONTINUE.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* 2. find the 1st mapped buffer,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* 3. check if the mapped buffer is both=
 in the request range
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* =A0 =A0and a delayed buffer. If not, =
there is no delayed-extent,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* =A0 =A0then return.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* 4. a delayed-extent is found, the ext=
ent will be collected.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>
> Good comment.
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 pgoff_t last_offset;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pgoff_t offset;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct buffer_head *bh =3D NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct buffer_head *head =3D NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 unsigned int nr_pages =3D NR_PAGES_PER_TIM=
E;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset =3D logical >> PAGE_SHIFT;
>>
>> +repeat:
>> + =A0 =A0 =A0 =A0 =A0 =A0 index =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 last_offset =3D offset;
>> + =A0 =A0 =A0 =A0 =A0 =A0 head =3D NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 ret =3D find_get_pages_tag(inode->i_mappin=
g, &offset,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 PAGECACHE_TAG_DIRTY, nr_pages, pages);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!(flags & FIEMAP_EXTENT_DELALLOC)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* First time, try to find=
 a mapped buffer. */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret =3D=3D 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* just a =
hole. */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return EXT=
_CONTINUE;
>
> This could contain the "out:" label, and the page_cache_release() loo=
p would be skipped because ret =3D=3D 0. =A0That would avoid the need t=
o use the pages[] and index values outside of the scope of the "if (ec_=
start =3D=3D 0)" clause, like:
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0out:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* jus=
t a hole. */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (i=
ndex =3D 0; index < ret; index++)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0page_cache_release(pages[index]);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return=
 EXT_CONTINUE;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Try to find the 1st map=
ped buffer. */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 end =3D ((__u64)pages[0]->=
index << PAGE_SHIFT) >> blksize_bits;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (index =3D 0; index < =
ret; index ++) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!page_=
has_buffers(pages[index]))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 goto out;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 head =3D p=
age_buffers(pages[index]);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!head)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 goto out;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D hea=
d;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 do {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 if (buffer_mapped(bh)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 /* get the 1st mapped buffer. */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 if (end > newex->ec_block + newex->ec_len)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* The buffer is out of the reques=
t range. */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 goto found_mapped_buffer;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 bh =3D bh->b_this_page;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 end ++;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } while (b=
h !=3D head);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (index =3D=3D ret)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* No mapp=
ed buffer found? */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG();
>
> Hmm, this should be BUG_ON(index =3D=3D ret), but even so I'm not so =
fond of BUG() as a form of error handling. =A0I'd rather just return at=
 this point without an extent.
>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*Find contiguous delayed =
buffers. */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret > 0 && pages[0]->i=
ndex =3D=3D last_offset)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 head =3D p=
age_buffers(pages[0]);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D head;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> +found_mapped_buffer:
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (bh && buffer_delay(bh)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* 1st or contiguous delay=
ed buffer found. */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!(flags & FIEMAP_EXTEN=
T_DELALLOC)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* 1st del=
ayed buffer found, record the start of extent. */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D=
 FIEMAP_EXTENT_DELALLOC;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 newex->ec_=
block =3D end;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 logical =3D=
 =A0(__u64)end << blksize_bits;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Find contiguous delayed=
 buffers. */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 do {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!buffe=
r_delay(bh))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 goto found_delayed_extent;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D bh-=
>b_this_page;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 end ++;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } while (bh !=3D head);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (index ++; index < ret=
; index ++) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!page_=
has_buffers(pages[index])) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 bh =3D NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 break;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 head =3D p=
age_buffers(pages[index]);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!head)=
 {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 bh =3D NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 break;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pages[=
index]->index !=3D pages[0]->index + index) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 /* Blocks are not contiguous. */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 bh =3D NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 break;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D hea=
d;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 do {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 if (!buffer_delay(bh))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 /* Delayed-extent ends. */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 goto found_delayed_extent;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 bh =3D bh->b_this_page;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 end ++;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } while (b=
h !=3D head);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else if (!(flags & FIEMAP_EXTENT_DELALLO=
C))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* a hole found. */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> +
>> +found_delayed_extent:
>> + =A0 =A0 =A0 =A0 =A0 =A0 newex->ec_len =3D min(end - newex->ec_bloc=
k,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 (ext4_lblk_t)EXT_INIT_MAX_LEN);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (ret =3D=3D nr_pages && newex->ec_len <=
 EXT_INIT_MAX_LEN
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && bh && buffer_delay(bh))=
 {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Have not collected an e=
xtent and continue. */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (index =3D0; index < r=
et; index ++)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache=
_release(pages[index]);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto repeat;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 for (index =3D0; index < ret; index ++)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(pages[i=
ndex]);
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 physical =3D (__u64)newex->ec_start << blksize_bits;
>> @@ -3822,32 +3935,24 @@ static int ext4_ext_fiemap_cb(struct inode *=
inode, struct ext4_ext_path *path,
>> =A0 =A0 =A0 if (ex && ext4_ext_is_uninitialized(ex))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D FIEMAP_EXTENT_UNWRITTEN;
>>
>>
>> + =A0 =A0 if (logical + length >=3D size) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 loff_t bs =3D EXT4_BLOCK_SIZE(inode->i_s=
b);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D FIEMAP_EXTENT_L=
AST;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (flags & FIEMAP_EXTENT_DELALLOC)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 length =3D (size - logic=
al + bs - 1) & ~(bs-1);
>
> This should probably set "physical =3D 0" just so that we don't retur=
n random garbage in that field.
physical has equaled 0 here because newex->ec_start equals 0 for delaye=
d-extent.

>
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 error =3D fiemap_fill_next_extent(fieinfo, logical, physic=
al,
>> + =A0 =A0 ret =3D fiemap_fill_next_extent(fieinfo, logical, physical=
,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 length, flags);
>> - =A0 =A0 if (error < 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 return error;
>> - =A0 =A0 if (error =3D=3D 1)
>> + =A0 =A0 if (ret < 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return ret;
>> + =A0 =A0 if (ret =3D=3D 1)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return EXT_BREAK;
>>
>> +out:
>> + =A0 =A0 for (index =3D0; index < ret; index ++)
>> + =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(pages[index]);
>> +
>> =A0 =A0 =A0 return EXT_CONTINUE;
>> }
>>
>> --
>> 1.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
> Cheers, Andreas
>
>
>
>
>
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
