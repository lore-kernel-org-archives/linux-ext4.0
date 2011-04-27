From: Ding Dinghua <dingdinghua85@gmail.com>
Subject: Re: Need of revoke mechanism in JBD
Date: Wed, 27 Apr 2011 08:52:32 +0800
Message-ID: <BANLkTinLqWgsJjt=AfVnM8_aK9DGMkzcDQ@mail.gmail.com>
References: <4DB68257.4070407@gmail.com>
	<BANLkTikuNB8m3-X8BXVcL2OCqQiZwRCbQA@mail.gmail.com>
	<BANLkTikV4nU4Zc4OxNa6q8wDtM7cLUF_ig@mail.gmail.com>
	<4DB6A2B0.7050708@gmail.com>
	<05811D05-1E14-4EA9-B9A4-BA4DD5B1D986@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Niraj Kulkarni <kulkarniniraj14@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51021 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab1D0Awd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Apr 2011 20:52:33 -0400
Received: by pzk9 with SMTP id 9so696889pzk.19
        for <linux-ext4@vger.kernel.org>; Tue, 26 Apr 2011 17:52:32 -0700 (PDT)
In-Reply-To: <05811D05-1E14-4EA9-B9A4-BA4DD5B1D986@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Oh, here no-journalled-data is misleading, I mean mount in
data=3Dwriteback mode or data=3Dordered mode,
not in data=3Djournal mode.

2011/4/27 Andreas Dilger <adilger@dilger.ca>:
> On 2011-04-26, at 4:47 AM, Niraj Kulkarni wrote:
>> If I am thinking correctly, journal would be checkpointed =A0on
>> filesystem unmount calls.
>> This implies the given scenario would be pretty rare.
>>
>> ie first filesystem should be mounted in full-journal mode, and
>> crashed prior to checkpoint.
>> then it should be remounted in no-journalled-data mode without
>> recovery and again remounted in full journalled mode with recovery.
>
> It shouldn't be possible to mount the filesystem in no-journal mode
> without doing journal recovery. =A0The filesystem sets an INCOMPAT_RE=
COVER
> flag when the journal has any transactions in it, and the journal sho=
uld
> be replayed before the filesystem is finished mounting.
>
> Looking at ext4_fill_super() the "noload" mount option is used to avo=
id
> loading the journal even if there is a journal (COMPAT_HAS_JOURNAL is=
 set),
> but if INCOMPAT_RECOVER is set the filesystem will refuse to mount.
>
>
>> On Tuesday 26 April 2011 02:53 PM, Ding Dinghua wrote:
>>> I think it's not only a performance issue but more important, a
>>> correctness issue.
>>> Revoke table is used for preventing the wrong replay of journal whi=
ch
>>> cause data corruption:
>>> If block A has been journalled its modification, committed to journ=
al
>>> and hasn't been checkpointed,
>>> and in later transactions block A is freed and reused for data in
>>> no-journalled-data mode, then If
>>> we don't have revoke table which recording the releasing event, rep=
lay
>>> of journal will overwrite the new data,
>>> which causing data corruption.
>>>
>>> 2011/4/26 Yongqiang Yang<xiaoqiangnk@gmail.com>:
>>>> AFAIK, it can accelerate the recovering process. =A0If a block is =
in the
>>>> revoke table of a transaction t1 and t1 is committed, then the the=
re
>>>> is no need to recover the block in transactions which is earlier t=
han
>>>> t1.
>>>>
>>>> On Tue, Apr 26, 2011 at 4:29 PM, Niraj Kulkarni
>>>> <kulkarniniraj14@gmail.com> =A0wrote:
>>>>> Hi all,
>>>>> =A0 =A0 =A0I am new to fs development. I am trying to modify the =
journal structure
>>>>> of JBD. While analyzing the code, I could understand most of the =
things, but
>>>>> I am not able to understand the need of revoke mechanism. Can any=
body
>>>>> enlighten me on this issue?
>>>>>
>>>>> Regards
>>>>> Niraj
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-e=
xt4" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>>>>>
>>>>
>>>>
>>>> --
>>>> Best Wishes
>>>> Yongqiang Yang
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ex=
t4" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>>>>
>>>
>>>
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
>



--=20
Ding Dinghua
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
