From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Need of revoke mechanism in JBD
Date: Fri, 29 Apr 2011 22:45:23 +0300
Message-ID: <BANLkTin35yOg+ndy3i4vTT7RHxtFso+HCA@mail.gmail.com>
References: <4DB68257.4070407@gmail.com>
	<BANLkTikuNB8m3-X8BXVcL2OCqQiZwRCbQA@mail.gmail.com>
	<BANLkTikV4nU4Zc4OxNa6q8wDtM7cLUF_ig@mail.gmail.com>
	<20110426122558.GF9486@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ding Dinghua <dingdinghua85@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Niraj Kulkarni <kulkarniniraj14@gmail.com>,
	linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35044 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760869Ab1D2TpZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Apr 2011 15:45:25 -0400
Received: by ewy4 with SMTP id 4so1245284ewy.19
        for <linux-ext4@vger.kernel.org>; Fri, 29 Apr 2011 12:45:24 -0700 (PDT)
In-Reply-To: <20110426122558.GF9486@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 26, 2011 at 3:25 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Tue, Apr 26, 2011 at 05:23:21PM +0800, Ding Dinghua wrote:
>> I think it's not only a performance issue but more important, a
>> correctness issue.
>> Revoke table is used for preventing the wrong replay of journal whic=
h
>> cause data corruption:
>> If block A has been journalled its modification, committed to journa=
l
>> and hasn't been checkpointed,
>> and in later transactions block A is freed and reused for data in
>> no-journalled-data mode, then If
>> we don't have revoke table which recording the releasing event, repl=
ay
>> of journal will overwrite the new data,
>> which causing data corruption.
>
> Yes, this is correct. =A0It should be covered fairly well in Stephen
> Tweedie's, "Journaling the ext2fs file system" paper, which you can
> find at:
>
> https://ext4.wiki.kernel.org/index.php/Publications

Actually, the original paper has no mention of revoke records.
I went out to look for useful documentation on journal forget/revoke
and came back empty handed as well.

>
> if you'd like more details.
>
> Hope this helps!
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
