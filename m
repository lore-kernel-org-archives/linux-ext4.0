From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [RESEND PATCH 2/2] ext3: flush journal only when journal mode is
 changed from journaled
Date: Tue, 15 Nov 2011 21:57:13 +0800
Message-ID: <CAGBYx2anUeniKWhs4XTnuBZfCoJddZKq-odk-6us8s5vnq67Fg@mail.gmail.com>
References: <1321344289-13125-1-git-send-email-xiaoqiangnk@gmail.com>
	<20111115133305.GE21732@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58134 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab1KON5P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Nov 2011 08:57:15 -0500
Received: by fagn18 with SMTP id n18so387643fag.19
        for <linux-ext4@vger.kernel.org>; Tue, 15 Nov 2011 05:57:14 -0800 (PST)
In-Reply-To: <20111115133305.GE21732@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 15, 2011 at 9:33 PM, Jan Kara <jack@suse.cz> wrote:
> On Tue 15-11-11 16:04:49, Yongqiang Yang wrote:
>> To prevent data from corruption during repaly, we need to flush jour=
nal
>> before changing journal mode from journaled. =A0However flushing jou=
rnal is
>> not needed when changing journal to journaled.
> =A0We flush the journal for other reasons as well - switching inodes
> ->i_aops is rather complex thing so a filesystem should better be in =
a
> quiescent state. You'd definitely at least need to commit the running
> transaction otherwise a hell would break loose if you tried to modify=
 a
> buffer both as ordered data and as metadata in one transaction.
>
> =A0So I strongly prefer to keep the code as is unless you can really
> convincingly *prove* that nothing breaks and show benefit of such cha=
nge.
Well.  The only benefit is that we can switch journal mode of a file
from ordered to journaled without flushing journal, thus, it is much
faster.
Before switching journal mode of a file from ordered to journaled, the
metadata has been in journal while data not.  After switching, both
metadata and data will be go to journal.  I am not sure if there is
any problem:-).

I am not very insistent on the patch.  It seems that the benefit can be=
 ignored.

Yongqiang.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
>>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> ---
>> =A0fs/ext3/inode.c | =A0 =A07 ++++---
>> =A01 files changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
>> index 04da6ac..5577358 100644
>> --- a/fs/ext3/inode.c
>> +++ b/fs/ext3/inode.c
>> @@ -3546,7 +3546,6 @@ int ext3_change_inode_journal_flag(struct inod=
e *inode, int val)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EROFS;
>>
>> =A0 =A0 =A0 journal_lock_updates(journal);
>> - =A0 =A0 journal_flush(journal);
>>
>> =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0* OK, there are no updates running now, and all cache=
d data is
>> @@ -3556,10 +3555,12 @@ int ext3_change_inode_journal_flag(struct in=
ode *inode, int val)
>> =A0 =A0 =A0 =A0* the inode's in-core data-journaling state flag now.
>> =A0 =A0 =A0 =A0*/
>>
>> - =A0 =A0 if (val)
>> + =A0 =A0 if (val) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT3_I(inode)->i_flags |=3D EXT3_JOURNAL=
_DATA_FL;
>> - =A0 =A0 else
>> + =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 journal_flush(journal);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT3_I(inode)->i_flags &=3D ~EXT3_JOURNA=
L_DATA_FL;
>> + =A0 =A0 }
>> =A0 =A0 =A0 ext3_set_aops(inode);
>>
>> =A0 =A0 =A0 journal_unlock_updates(journal);
>> --
>> 1.7.5.1
>>
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
