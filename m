From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH v3] ext4:Let ext4_ext_fiemap_cb() handle blocks before
 request range correctly.
Date: Sun, 22 May 2011 19:59:40 +0800
Message-ID: <BANLkTikwCDBWU0+7fgtY4OXsZKe9yaiMwA@mail.gmail.com>
References: <1305545234-11751-1-git-send-email-xiaoqiangnk@gmail.com>
	<BANLkTinfHXUx0Ro6J7T7hr5Q=8SNtghViw@mail.gmail.com>
	<BANLkTikeXcqDGQhx9v6RrRUjOucV4wnzCA@mail.gmail.com>
	<BANLkTimkxGE9DacKCFqPKp_20=7iQvjOpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com, tytso@mit.edu
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42951 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab1EVL7m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 22 May 2011 07:59:42 -0400
Received: by vws1 with SMTP id 1so3543303vws.19
        for <linux-ext4@vger.kernel.org>; Sun, 22 May 2011 04:59:41 -0700 (PDT)
In-Reply-To: <BANLkTimkxGE9DacKCFqPKp_20=7iQvjOpQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 22, 2011 at 4:35 PM, Amir Goldstein <amir73il@gmail.com> wr=
ote:
> On Mon, May 16, 2011 at 4:15 PM, Yongqiang Yang <xiaoqiangnk@gmail.co=
m> wrote:
>> On Mon, May 16, 2011 at 7:53 PM, Amir Goldstein <amir73il@gmail.com>=
 wrote:
>>> On Mon, May 16, 2011 at 2:27 PM, Yongqiang Yang <xiaoqiangnk@gmail.=
com> wrote:
>>>> To get delayed-extent information, ext4_ext_fiemap_cb() looks up
>>>> pagecache, it thus collects information starting from a page's
>>>> head block.
>>>>
>>>> If blocksize < pagesize, the beginning blocks of a page may lies
>>>> before the request range. So ext4_ext_fiemap_cb() should proceed
>>>> ignoring them, because they has been handled before. If no mapped
>>>> buffer in the range is found in the 1st page, we need to look up
>>>> the 2nd page, otherwise delayed-extents after a hole will be ignor=
ed.
>>>
>>> Does this patch fix the endless loop I encountered?
>> Yes, it fixes another bug.
>>> If so, you may want to add to commit message:
>>> - Reported-by: Amir..
>>> - that the patch fixes a hang bug
>>> - how was it reproduced
>>> - which commit introduced the bug
>> Sorry, I forgot to add these. =A0 I rewrote the xfstests 225 and fou=
nd
>> another bug which the old 225 could not find.
>> I think I should resend this patch.
>
> Hi Yongqiang,
>
> Did you resend this patch? I see that Ted hasn't picked it up yet.
> Apparently, he is expecting to get a new version from you with proper
> commit log (I think he mentioned that on last week's confcall).
Sorry,  I had a travel in last three days without a computer.   I will
send it out tomorrow.

>
> Amir.
>
>>
>>>
>>>>
>>>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>>>> ---
>>>> =A0fs/ext4/extents.c | =A0 51 ++++++++++++++++++++++++++++++++++++=
---------------
>>>> =A01 files changed, 36 insertions(+), 15 deletions(-)
>>>>
>>>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>>>> index e363f21..474eaad 100644
>>>> --- a/fs/ext4/extents.c
>>>> +++ b/fs/ext4/extents.c
>>>> @@ -3680,6 +3680,7 @@ static int ext4_ext_fiemap_cb(struct inode *=
inode, struct ext4_ext_path *path,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pgoff_t =A0 =A0 =A0 =A0 last_offset=
;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pgoff_t =A0 =A0 =A0 =A0 offset;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pgoff_t =A0 =A0 =A0 =A0 index;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pgoff_t =A0 =A0 =A0 =A0 start_index =
=3D 0;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct page =A0 =A0 **pages =3D NUL=
L;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct buffer_head *bh =3D NULL;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct buffer_head *head =3D NULL;
>>>> @@ -3706,39 +3707,57 @@ out:
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfr=
ee(pages);
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret=
urn EXT_CONTINUE;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 index =3D 0;
>>>>
>>>> +next_page:
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Try to find the =
1st mapped buffer. */
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 end =3D ((__u64)page=
s[0]->index << PAGE_SHIFT) >>
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 end =3D ((__u64)page=
s[index]->index << PAGE_SHIFT) >>
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
blksize_bits;
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!page_has_buffer=
s(pages[0]))
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!page_has_buffer=
s(pages[index]))
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0got=
o out;
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 head =3D page_buffer=
s(pages[0]);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 head =3D page_buffer=
s(pages[index]);
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!head)
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0got=
o out;
>>>> -
>>>> +
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 index++;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bh =3D head;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0do {
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (=
buffer_mapped(bh)) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (=
end >=3D newex->ec_block +
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 newex->ec_len)
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 /* The buffer is out of
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0* the request range.
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0*/
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 goto out;
>>>> +
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (=
buffer_mapped(bh) &&
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 end >=3D newex->ec_block) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 start_index =3D index - 1;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0/* get the 1st mapped buffer. */
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 if (end > newex->ec_block +
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 newex->ec_len)
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 /* The buffer is out of
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* the request range.
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0goto found_mapped_buffer;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>>>> +
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bh =
=3D bh->b_this_page;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0end=
++;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} while (bh !=3D he=
ad);
>>>>
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* No mapped buffer =
found. */
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* No mapped buffer =
in the range found in this page,
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* We need to look=
 up next page.
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (index >=3D ret) =
{
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* T=
here is no page left, but we need to limit
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*=
 newex->ec_len.
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*=
/
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 newe=
x->ec_len =3D end - newex->ec_block;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto=
 out;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto next_page;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*Find contiguous d=
elayed buffers. */
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret > 0 && page=
s[0]->index =3D=3D last_offset)
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0hea=
d =3D page_buffers(pages[0]);
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bh =3D head;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 index =3D 1;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 start_index =3D 0;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>>>>
>>>> =A0found_mapped_buffer:
>>>> @@ -3761,7 +3780,7 @@ found_mapped_buffer:
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0end=
++;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} while (bh !=3D he=
ad);
>>>>
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (index =3D 1; in=
dex < ret; index++) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (; index < ret; =
index++) {
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if =
(!page_has_buffers(pages[index])) {
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0bh =3D NULL;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0break;
>>>> @@ -3771,8 +3790,10 @@ found_mapped_buffer:
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0bh =3D NULL;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0break;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>>>> +
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if =
(pages[index]->index !=3D
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 pages[0]->index + index) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 pages[start_index]->index + index
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 - start_index) {
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0/* Blocks are not contiguous. */
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0bh =3D NULL;
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0break;
>>>> --
>>>> 1.7.5.1
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ex=
t4" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>>>>
>>>
>>
>>
>>
>> --
>> Best Wishes
>> Yongqiang Yang
>>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
