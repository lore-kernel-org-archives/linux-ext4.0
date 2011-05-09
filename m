From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 1/1] Null Pointer when make_indexed_dir returns -ENOSPC
Date: Mon, 9 May 2011 19:21:32 +0800
Message-ID: <BANLkTikLz2PQoPjtFsvpEMBZXZ=i7DmPTg@mail.gmail.com>
References: <4DC5DBB3.9030207@linux.vnet.ibm.com>
	<20110509110329.GF4122@quack.suse.cz>
	<BANLkTi=hSeN4mb8x9vu4DfBb-us_ocaqXw@mail.gmail.com>
	<BANLkTinT3KXY9RiX_Rv1GAGHi=m6roC37w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46609 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1EILVd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 07:21:33 -0400
Received: by vxi39 with SMTP id 39so5639526vxi.19
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 04:21:32 -0700 (PDT)
In-Reply-To: <BANLkTinT3KXY9RiX_Rv1GAGHi=m6roC37w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 9, 2011 at 7:20 PM, Yongqiang Yang <xiaoqiangnk@gmail.com> =
wrote:
> On Mon, May 9, 2011 at 7:18 PM, Yongqiang Yang <xiaoqiangnk@gmail.com=
> wrote:
>> On Mon, May 9, 2011 at 7:03 PM, Jan Kara <jack@suse.cz> wrote:
>>> On Sat 07-05-11 16:54:27, Allison Henderson wrote:
>>>> Fix for a null pointer bug found while running punch hole tests
>>>>
>>>> Signed-off-by: Allison Henderson <achender@us.ibm.com>
>>>> ---
>>>> :100644 100644 3c7a06e... 3302a6c... M =A0 =A0 =A0 =A0fs/ext4/name=
i.c
>>>> =A0fs/ext4/namei.c | =A0 =A03 ++-
>>>> =A01 files changed, 2 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
>>>> index 3c7a06e..3302a6c 100644
>>>> --- a/fs/ext4/namei.c
>>>> +++ b/fs/ext4/namei.c
>>>> @@ -1422,7 +1422,8 @@ static int make_indexed_dir(handle_t *handle=
, struct dentry *dentry,
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_mark_inode_dirty(handle, dir);
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_handle_dirty_metadata(handle, dir=
, frame->bh);
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_handle_dirty_metadata(handle, dir, =
bh);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (bh)
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_handle_dirty_metada=
ta(handle, dir, bh);
>>> =A0I'm puzzled - bh here is bh2 from the beginning of the function =
and we
>>> check it for being NULL after we ext4_append() it. So how can this =
happen?
>> do_split() encounters a journal error and set bh to NULL before retu=
rning.
> Sorry, it does not make sense.
Sorry for being dense, it makes sense.
>
>>
>>>
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0Honza
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 dx_release(frames);
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return retval;
>>>> =A0 =A0 =A0 }
>>>> --
>>>> 1.7.1
>>>>
>>> --
>>> Jan Kara <jack@suse.cz>
>>> SUSE Labs, CR
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>>
>>
>> --
>> Best Wishes
>> Yongqiang Yang
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
