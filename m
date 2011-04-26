From: Ding Dinghua <dingdinghua85@gmail.com>
Subject: Re: Need of revoke mechanism in JBD
Date: Tue, 26 Apr 2011 17:23:21 +0800
Message-ID: <BANLkTikV4nU4Zc4OxNa6q8wDtM7cLUF_ig@mail.gmail.com>
References: <4DB68257.4070407@gmail.com>
	<BANLkTikuNB8m3-X8BXVcL2OCqQiZwRCbQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Niraj Kulkarni <kulkarniniraj14@gmail.com>,
	linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59413 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab1DZJXV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Apr 2011 05:23:21 -0400
Received: by pzk9 with SMTP id 9so157679pzk.19
        for <linux-ext4@vger.kernel.org>; Tue, 26 Apr 2011 02:23:21 -0700 (PDT)
In-Reply-To: <BANLkTikuNB8m3-X8BXVcL2OCqQiZwRCbQA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I think it's not only a performance issue but more important, a
correctness issue.
Revoke table is used for preventing the wrong replay of journal which
cause data corruption:
If block A has been journalled its modification, committed to journal
and hasn't been checkpointed,
and in later transactions block A is freed and reused for data in
no-journalled-data mode, then If
we don't have revoke table which recording the releasing event, replay
of journal will overwrite the new data,
which causing data corruption.

2011/4/26 Yongqiang Yang <xiaoqiangnk@gmail.com>:
> AFAIK, it can accelerate the recovering process. =A0If a block is in =
the
> revoke table of a transaction t1 and t1 is committed, then the there
> is no need to recover the block in transactions which is earlier than
> t1.
>
> On Tue, Apr 26, 2011 at 4:29 PM, Niraj Kulkarni
> <kulkarniniraj14@gmail.com> wrote:
>> Hi all,
>> =A0 =A0 =A0I am new to fs development. I am trying to modify the jou=
rnal structure
>> of JBD. While analyzing the code, I could understand most of the thi=
ngs, but
>> I am not able to understand the need of revoke mechanism. Can anybod=
y
>> enlighten me on this issue?
>>
>> Regards
>> Niraj
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Best Wishes
> Yongqiang Yang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Ding Dinghua
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
