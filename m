From: jon ernst <jonernst07@gmail.com>
Subject: Re: [PATCH 1/2] ext4: Fix assertion in ext4_add_complete_io()
Date: Tue, 15 Oct 2013 15:54:18 -0400
Message-ID: <CAGW2f1EaVQMQn37QPmzhMZiWUD=oqLTGoFQe=ZteHUUxpQbNCw@mail.gmail.com>
References: <1381843949-31805-1-git-send-email-jack@suse.cz>
	<alpine.LFD.2.00.1310151919290.1921@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
To: =?ISO-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:45033 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab3JOTyT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Oct 2013 15:54:19 -0400
Received: by mail-oa0-f42.google.com with SMTP id k14so2175087oag.15
        for <linux-ext4@vger.kernel.org>; Tue, 15 Oct 2013 12:54:18 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1310151919290.1921@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 15, 2013 at 1:20 PM, Luk=C3=A1=C5=A1 Czerner <lczerner@redh=
at.com> wrote:
> On Tue, 15 Oct 2013, Jan Kara wrote:
>
>> Date: Tue, 15 Oct 2013 15:32:28 +0200
>> From: Jan Kara <jack@suse.cz>
>> To: Ted Tso <tytso@mit.edu>
>> Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
>> Subject: [PATCH 1/2] ext4: Fix assertion in ext4_add_complete_io()
>>
>> It doesn't make sense to require io_end->handle when we are in nojou=
rnal
>> mode. So update the assertion accordingly to avoid false warnings fr=
om
>> ext4_add_complete_io().
>
> Looks good.
>
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
>
>>
>> Reported-by: Eric Whitney <enwlinux@gmail.com>
>> Signed-off-by: Jan Kara <jack@suse.cz>
>> ---
>>  fs/ext4/page-io.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
>> index d7d0c7b46ed4..d488f80ee32d 100644
>> --- a/fs/ext4/page-io.c
>> +++ b/fs/ext4/page-io.c
>> @@ -197,14 +197,15 @@ static void dump_completed_IO(struct inode *in=
ode, struct list_head *head)
>>  static void ext4_add_complete_io(ext4_io_end_t *io_end)
>>  {
>>       struct ext4_inode_info *ei =3D EXT4_I(io_end->inode);
>> +     struct ext4_sb_info *sbi =3D EXT4_SB(io_end->inode->i_sb);
>>       struct workqueue_struct *wq;
>>       unsigned long flags;
>>
>>       /* Only reserved conversions from writeback should enter here =
*/
>>       WARN_ON(!(io_end->flag & EXT4_IO_END_UNWRITTEN));
>> -     WARN_ON(!io_end->handle);
>> +     WARN_ON(!io_end->handle && sbi->s_journal);

swap 2 conditions would be better in my opinion.   (for no-journal
case, it will be short-circuited. For journal case, no harm, no
difference.)
i know this is too picky. :)

>>       spin_lock_irqsave(&ei->i_completed_io_lock, flags);
>> -     wq =3D EXT4_SB(io_end->inode->i_sb)->rsv_conversion_wq;
>> +     wq =3D sbi->rsv_conversion_wq;
>>       if (list_empty(&ei->i_rsv_conversion_list))
>>               queue_work(wq, &ei->i_rsv_conversion_work);
>>       list_add_tail(&io_end->list, &ei->i_rsv_conversion_list);
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
