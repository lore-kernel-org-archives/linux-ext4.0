From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH v3] ext4:Make FIEMAP and delayed allocation play well together.
Date: Sat, 26 Feb 2011 21:45:22 +0800
Message-ID: <AANLkTimCsePqet8-fsgAm2PK4wJFvHjHrUU-UZg8GM_9@mail.gmail.com>
References: <1298626825-3131-1-git-send-email-xiaoqiangnk@gmail.com>
	<9CFD5FC9-82EC-426F-B0EA-742AFB05711E@dilger.ca>
	<AANLkTimUzNXK3t0cr94oXXmEM0kox6zaZNO4b2dfpVNe@mail.gmail.com>
	<C821E65A-5A3A-4B15-B7A9-715B425F6B46@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38676 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab1BZNpX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Feb 2011 08:45:23 -0500
Received: by iyb26 with SMTP id 26so1649415iyb.19
        for <linux-ext4@vger.kernel.org>; Sat, 26 Feb 2011 05:45:22 -0800 (PST)
In-Reply-To: <C821E65A-5A3A-4B15-B7A9-715B425F6B46@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 26, 2011 at 4:01 AM, Andreas Dilger <adilger@dilger.ca> wro=
te:
> On 2011-02-25, at 6:46 AM, Yongqiang Yang wrote:
>> On Fri, Feb 25, 2011 at 6:13 PM, Andreas Dilger <adilger@dilger.ca> =
wrote:
>>> On 2011-02-25, at 2:40 AM, Yongqiang Yang wrote:
>>>> @@ -3782,38 +3783,124 @@ static int ext4_ext_fiemap_cb(struct inod=
e *inode,
>>>> =A0 =A0 =A0 if (newex->ec_start =3D=3D 0) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 struct page =A0 =A0 *page =3D NULL;
>>>> +repeat:
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 last_offset =3D offset;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 head =3D NULL;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 ret =3D find_get_pages_tag(inode->i_mapp=
ing, &offset,
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 PAGECACHE_TAG_DIRTY, 1, &page);
>>>
>>> Hmm, now I wonder about the expense of mapping many thousands of de=
lalloc
>>> pages, one at a time, in order to map this extent.
>>>
>>> Could you please do a test, with as large a file as possible before=
 it is written to disk (say 4GB =3D=3D 1M pages), to see whether single=
-page find_get_pages_tag() is faster than kmalloc() of a PAGE_SIZE buff=
er and (PAGE_SIZE/sizeof(struct page *)) page pointers?
>>
>> Sorry, my machine's memory is in 2GB size. Should I do a test with a
>> file in 1.5GB size?
>
> Yes, as large a file that is possible to keep in DELALLOC state. =A0I=
 think that will require tuning the VM to avoid writeout for as long as=
 possible, and of course making sure that the fiemap tool is not using =
=46IEMAP_FLAG_SYNC:
>
> /proc/sys/vm/dirty_expire_centisecs:60000 =A0 =A0 =A0 # 10 minutes
> /proc/sys/vm/dirty_writeback_centisecs:60000
> /proc/sys/vm/dirty_ratio:99 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 #=
 99% of RAM dirty before flush
>
> Hopefully this does not lock up your system, so long as the dirty dat=
a is kept below the amount of free RAM.
=46rom my tests, sometime single-page case is faster then kmalloc() cas=
e
and sometime single-page case slower.
I will send a patch with kmalloc().

>
>> I think kmalloc() is faster than single-page.
>
> I hope so as well.
>
>> Thank you.
>>>
>>> This would probably work best if the VM is tuned not to flush out d=
irty pages.
>>>
>>> Otherwise, there are only minor style issues to fix up. =A0Thanks f=
or your work so far.
>>>
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!(flags & FIEMAP_EXTENT_DELALLOC)) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* First time, try to fi=
nd a mapped buffer. */
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret =3D=3D 0) {
>>>> +out:
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret =
> 0)
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 page_cache_release(page);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* just =
a hole. */
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return E=
XT_CONTINUE;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>>>
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 if (!bh)
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return EXT_CONTINUE;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Try to find the 1st m=
apped buffer. */
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 end =3D ((__u64)page->in=
dex << PAGE_SHIFT)
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 >> blksize_bits;
>>>
>>> (style) operators go at the end of the previous line.
>>>
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!page_has_buffers(pa=
ge))
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out=
;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 head =3D page_buffers(pa=
ge);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!head)
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out=
;
>>>>
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 if (buffer_delay(bh)) {
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D FIEMAP_EXTENT=
_DELALLOC;
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(page)=
;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D head;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 do {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (buff=
er_mapped(bh)) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 /* get the 1st mapped buffer. */
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 if (end > newex->ec_block +
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 newex->ec_len)
>>>
>>> (style) continued lines should align by the parenthesis '(' on the =
previous line, not on a full tab.
>>>
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 /* The buffer is out of
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0* the request range.
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 goto out;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 goto found_mapped_buffer;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D b=
h->b_this_page;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 end++;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } while (bh !=3D head);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* No mapped buffer foun=
d. */
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*Find contiguous delaye=
d buffers. */
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret > 0 && page->ind=
ex =3D=3D last_offset)
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 head =3D=
 page_buffers(page);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D head;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>>>> +
>>>> +found_mapped_buffer:
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (bh !=3D NULL && buffer_delay(bh)) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* 1st or contiguous del=
ayed buffer found. */
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!(flags & FIEMAP_EXT=
ENT_DELALLOC)) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* 1st=
 delayed buffer found, record
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* the=
 start of extent.
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D=
 FIEMAP_EXTENT_DELALLOC;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 newex->e=
c_block =3D end;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 logical =
=3D =A0(__u64)end << blksize_bits;
>>>
>>> (style) remove double space before '('
>>>
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Find contiguous delay=
ed buffers. */
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 do {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!buf=
fer_delay(bh))
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 goto found_delayed_extent;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D b=
h->b_this_page;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 end++;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } while (bh !=3D head);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 } else if (!(flags & FIEMAP_EXTENT_DELAL=
LOC))
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* a hole found. */
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>>>> +
>>>> +found_delayed_extent:
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 newex->ec_len =3D min(end - newex->ec_bl=
ock,
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 (ext4_lblk_t)EXT_INIT_MAX_LEN);
>>>
>>> (style) align continued line after '(' on previous line
>>>
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (ret =3D=3D 1 && bh !=3D NULL
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && newex->ec_len < EXT_I=
NIT_MAX_LEN
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && buffer_delay(bh)) {
>>>
>>> (style) operators go at the end of the previous line, like:
>>>
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret =3D=3D 1 && bh !=3D NULL &&
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 newex->ec_len < EXT_INIT_MAX_=
LEN && buffer_delay(bh)) {
>>>
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Have not collected an=
 extent and continue. */
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(pag=
e);
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return EXT_CONTINUE;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto repeat;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 page_cache_release(page);
>>>> =A0 =A0 =A0 }
>>>>
>>>> =A0 =A0 =A0 physical =3D (__u64)newex->ec_start << blksize_bits;
>>>> @@ -3822,32 +3909,16 @@ static int ext4_ext_fiemap_cb(struct inode=
 *inode, struct ext4_ext_path *path,
>>>> =A0 =A0 =A0 if (ex && ext4_ext_is_uninitialized(ex))
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D FIEMAP_EXTENT_UNWRITTEN;
>>>>
>>>> - =A0 =A0 /*
>>>> - =A0 =A0 =A0* If this extent reaches EXT_MAX_BLOCK, it must be la=
st.
>>>> - =A0 =A0 =A0*
>>>> - =A0 =A0 =A0* Or if ext4_ext_next_allocated_block is EXT_MAX_BLOC=
K,
>>>> - =A0 =A0 =A0* this also indicates no more allocated blocks.
>>>> - =A0 =A0 =A0*
>>>> - =A0 =A0 =A0* XXX this might miss a single-block extent at EXT_MA=
X_BLOCK
>>>> - =A0 =A0 =A0*/
>>>> - =A0 =A0 if (ext4_ext_next_allocated_block(path) =3D=3D EXT_MAX_B=
LOCK ||
>>>> - =A0 =A0 =A0 =A0 newex->ec_block + newex->ec_len - 1 =3D=3D EXT_M=
AX_BLOCK) {
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 loff_t size =3D i_size_read(inode);
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 loff_t bs =3D EXT4_BLOCK_SIZE(inode->i_s=
b);
>>>> -
>>>> + =A0 =A0 size =3D i_size_read(inode);
>>>> + =A0 =A0 if (logical + length >=3D size)
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D FIEMAP_EXTENT_LAST;
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 if ((flags & FIEMAP_EXTENT_DELALLOC) &&
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 logical+length > size)
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 length =3D (size - logic=
al + bs - 1) & ~(bs-1);
>>>> - =A0 =A0 }
>>>>
>>>> - =A0 =A0 error =3D fiemap_fill_next_extent(fieinfo, logical, phys=
ical,
>>>> + =A0 =A0 ret =3D fiemap_fill_next_extent(fieinfo, logical, physic=
al,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 length, flags);
>>>> - =A0 =A0 if (error < 0)
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 return error;
>>>> - =A0 =A0 if (error =3D=3D 1)
>>>> + =A0 =A0 if (ret < 0)
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 return ret;
>>>> + =A0 =A0 if (ret =3D=3D 1)
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return EXT_BREAK;
>>>> -
>>>> =A0 =A0 =A0 return EXT_CONTINUE;
>>>> }
>>>>
>>>> --
>>>> 1.7.4
>>>>
>>>
>>>
>>> Cheers, Andreas
>>>
>>>
>>>
>>>
>>>
>>>
>>
>>
>>
>> --
>> Best Wishes
>> Yongqiang Yang
>
>
> Cheers, Andreas
>
>
>
>
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
