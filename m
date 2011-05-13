From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH v2] ext4:Let ext4_ext_fiemap_cb() handle blocks before
 request range correctly.
Date: Fri, 13 May 2011 11:40:02 +0800
Message-ID: <BANLkTi=BJ+OQx4Eb3VLUzGWSGLf12j-9wA@mail.gmail.com>
References: <1305036366-1228-1-git-send-email-xiaoqiangnk@gmail.com>
	<alpine.LFD.2.00.1105101620590.18016@dhcp-27-109.brq.redhat.com>
	<BANLkTi=G+cwRLLPTqP0F7OKN-1d8yNZqLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@sandeen.net>, josef@redhat.com,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44104 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab1EMDkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 May 2011 23:40:04 -0400
Received: by vws1 with SMTP id 1so1574979vws.19
        for <linux-ext4@vger.kernel.org>; Thu, 12 May 2011 20:40:03 -0700 (PDT)
In-Reply-To: <BANLkTi=G+cwRLLPTqP0F7OKN-1d8yNZqLA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 10, 2011 at 11:08 PM, Yongqiang Yang <xiaoqiangnk@gmail.com=
> wrote:
> On Tue, May 10, 2011 at 10:35 PM, Lukas Czerner <lczerner@redhat.com>=
 wrote:
>> On Tue, 10 May 2011, Yongqiang Yang wrote:
>>
>>> v1->v2:
>>> =A0 Add more specific description.
>>>
>>> To get delayed-extent information, ext4_ext_fiemap_cb() lookups pag=
ecache,
>>> it thus collects information starting from a page's head block.
>>> If blockszie < pagesize, the beginning blocks of a page may lie bef=
ore the
>>> range. =A0ext4_ext_fiemap_cb() should proceed ignoring them, becaus=
e they
>>> has been handled before.
>>
>> Thanks for the description, but I have one question below.
>>
>>>
>>> Reported-by: Amir Goldstein <amir73il@users.sf.net>
>>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>>> ---
>>> =A0fs/ext4/extents.c | =A0 =A07 ++++++-
>>> =A01 files changed, 6 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>>> index e363f21..ec37109 100644
>>> --- a/fs/ext4/extents.c
>>> +++ b/fs/ext4/extents.c
>>> @@ -3718,9 +3718,14 @@ out:
>>>
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh =3D head;
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 do {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (end <=
 newex->ec_block)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 /* The buffer is not in
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0* the request range.
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0*/
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 continue;
>> So if the condition is true, then we might leave the loop, because (=
bh =3D=3D
>> head) in the first iteration, is that desired behavior? Also if we h=
it
>> this condition in other than first iteration we will spin forever. I=
 do
>> not think this is right. How did you tested this case ?
> You are right. =A0Maybe the patch sent out is not same as the patch w=
ith
> which I tested. =A0What a stupid error!
> I am not sure what happened now. =A0I will check the patch with which=
 I
> tested tomorrow.
>
> My working tree passed xfstests 225 in both 1k blocksize and 4k
> blocksize cases.
I checked the code I tested with.  Indeed I tested with this ugly
patch and xfstests 225 passed.  I tested again and results were same '
PASSED'.

I had a look into xfstests 225 and found that there are problems in
xfstests 225 so it can not find the bug induced by this ugly patch.
It seems that current xfstests 225 has a lot of problems.

I am fixing xfstests 225 to enable it find this bug.

Yongqiang.

>
> Sorry!
>
> Yongqiang.
>>
>> Thanks!
>> -Lukas
>>
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (buf=
fer_mapped(bh)) {
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 /* get the 1st mapped buffer. */
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 if (end > newex->ec_block +
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 if (end >=3D newex->ec_block +
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 newex->ec_len)
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 /* The buffer is out of
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0* the request range.
>>>
>>
>
>
>
> --
> Best Wishes
> Yongqiang Yang
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
