From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Need of revoke mechanism in JBD
Date: Tue, 26 Apr 2011 11:27:20 -0600
Message-ID: <05811D05-1E14-4EA9-B9A4-BA4DD5B1D986@dilger.ca>
References: <4DB68257.4070407@gmail.com> <BANLkTikuNB8m3-X8BXVcL2OCqQiZwRCbQA@mail.gmail.com> <BANLkTikV4nU4Zc4OxNa6q8wDtM7cLUF_ig@mail.gmail.com> <4DB6A2B0.7050708@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ding Dinghua <dingdinghua85@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	linux-ext4@vger.kernel.org
To: Niraj Kulkarni <kulkarniniraj14@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:47096 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637Ab1DZR1W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Apr 2011 13:27:22 -0400
In-Reply-To: <4DB6A2B0.7050708@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-04-26, at 4:47 AM, Niraj Kulkarni wrote:
> If I am thinking correctly, journal would be checkpointed  on
> filesystem unmount calls.
> This implies the given scenario would be pretty rare.
> 
> ie first filesystem should be mounted in full-journal mode, and
> crashed prior to checkpoint.
> then it should be remounted in no-journalled-data mode without
> recovery and again remounted in full journalled mode with recovery.

It shouldn't be possible to mount the filesystem in no-journal mode
without doing journal recovery.  The filesystem sets an INCOMPAT_RECOVER
flag when the journal has any transactions in it, and the journal should
be replayed before the filesystem is finished mounting.

Looking at ext4_fill_super() the "noload" mount option is used to avoid
loading the journal even if there is a journal (COMPAT_HAS_JOURNAL is set),
but if INCOMPAT_RECOVER is set the filesystem will refuse to mount.


> On Tuesday 26 April 2011 02:53 PM, Ding Dinghua wrote:
>> I think it's not only a performance issue but more important, a
>> correctness issue.
>> Revoke table is used for preventing the wrong replay of journal which
>> cause data corruption:
>> If block A has been journalled its modification, committed to journal
>> and hasn't been checkpointed,
>> and in later transactions block A is freed and reused for data in
>> no-journalled-data mode, then If
>> we don't have revoke table which recording the releasing event, replay
>> of journal will overwrite the new data,
>> which causing data corruption.
>> 
>> 2011/4/26 Yongqiang Yang<xiaoqiangnk@gmail.com>:
>>> AFAIK, it can accelerate the recovering process.  If a block is in the
>>> revoke table of a transaction t1 and t1 is committed, then the there
>>> is no need to recover the block in transactions which is earlier than
>>> t1.
>>> 
>>> On Tue, Apr 26, 2011 at 4:29 PM, Niraj Kulkarni
>>> <kulkarniniraj14@gmail.com>  wrote:
>>>> Hi all,
>>>>      I am new to fs development. I am trying to modify the journal structure
>>>> of JBD. While analyzing the code, I could understand most of the things, but
>>>> I am not able to understand the need of revoke mechanism. Can anybody
>>>> enlighten me on this issue?
>>>> 
>>>> Regards
>>>> Niraj
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> 
>>> 
>>> 
>>> --
>>> Best Wishes
>>> Yongqiang Yang
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> 
>> 
>> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





