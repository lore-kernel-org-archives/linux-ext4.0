From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Tue, 16 Aug 2011 17:08:42 -0700
Message-ID: <CAFgt=MD4EmeEXNQGinMJHyZ-DOoWPnBbYdzdcw2YRm+yYjodpw@mail.gmail.com>
References: <1313251371-3672-1-git-send-email-tm@tao.ma>
	<4E4836A8.3080709@msgid.tls.msk.ru>
	<4E48390E.9050102@msgid.tls.msk.ru>
	<4E488625.609@tao.ma>
	<4E48D231.5060807@msgid.tls.msk.ru>
	<4E48DF31.4050603@msgid.tls.msk.ru>
	<CAFgt=MAfbU_muEzmxx-8CK8w7=nGR5dUZSgBQ1dN6XkyrTbO9g@mail.gmail.com>
	<20110816135325.GD23416@quack.suse.cz>
	<4E4A86D0.2070300@tao.ma>
	<CAFgt=MCQttE5Vv_4W=hFWU_L_FvELnY6bnFQ3uSOu07VkDm6rA@mail.gmail.com>
	<20110816235901.GL26978@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tao Ma <tm@tao.ma>, Jan Kara <jack@suse.cz>,
	Michael Tokarev <mjt@tls.msk.ru>, linux-ext4@vger.kernel.org,
	sandeen@redhat.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:23513 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab1HQAIq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Aug 2011 20:08:46 -0400
Received: from wpaz9.hot.corp.google.com (wpaz9.hot.corp.google.com [172.24.198.73])
	by smtp-out.google.com with ESMTP id p7H08i97009319
	for <linux-ext4@vger.kernel.org>; Tue, 16 Aug 2011 17:08:44 -0700
Received: from pzk6 (pzk6.prod.google.com [10.243.19.134])
	by wpaz9.hot.corp.google.com with ESMTP id p7H08CRV004540
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 16 Aug 2011 17:08:43 -0700
Received: by pzk6 with SMTP id 6so94835pzk.22
        for <linux-ext4@vger.kernel.org>; Tue, 16 Aug 2011 17:08:42 -0700 (PDT)
In-Reply-To: <20110816235901.GL26978@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 16, 2011 at 4:59 PM, Dave Chinner <david@fromorbit.com> wro=
te:
> On Tue, Aug 16, 2011 at 02:32:12PM -0700, Jiaying Zhang wrote:
>> On Tue, Aug 16, 2011 at 8:03 AM, Tao Ma <tm@tao.ma> wrote:
>> > On 08/16/2011 09:53 PM, Jan Kara wrote:
>> I wonder whether the following patch will solve the problem:
>>
>> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
>> index 6c27111..ca90d73 100644
>> --- a/fs/ext4/indirect.c
>> +++ b/fs/ext4/indirect.c
>> @@ -800,12 +800,17 @@ ssize_t ext4_ind_direct_IO(int rw, struct kioc=
b *iocb,
>> =A0 =A0 =A0 =A0 }
>>
>> =A0retry:
>> - =A0 =A0 =A0 if (rw =3D=3D READ && ext4_should_dioread_nolock(inode=
))
>> + =A0 =A0 =A0 if (rw =3D=3D READ && ext4_should_dioread_nolock(inode=
)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(!list_empty(&ei->i_comple=
ted_io_list))) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock(&inode->i_m=
utex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_flush_completed_I=
O(inode);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&inode->i=
_mutex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D __blockdev_direct_IO(rw, ioc=
b, inode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0i=
node->i_sb->s_bdev, iov,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0o=
ffset, nr_segs,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0e=
xt4_get_block, NULL, NULL, 0);
>> - =A0 =A0 =A0 else {
>> + =A0 =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D blockdev_direct_IO(rw, iocb,=
 inode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0i=
node->i_sb->s_bdev, iov,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0o=
ffset, nr_segs,
>>
>> I tested the patch a little bit and it seems to resolve the race
>> on dioread_nolock in my case. Michael, I would very appreciate
>> if you can try this patch with your test case and see whether it wor=
ks.
>
> Just my 2c worth here: this is a data corruption bug so the root
> cause neeeds to be fixed. The above patch does not address the root
> cause.
>
>> > You are absolutely right. The really problem is that ext4_direct_I=
O
>> > begins to work *after* we clear the page writeback flag and *befor=
e* we
>> > convert unwritten extent to a valid state. Some of my trace does s=
how
>> > that. I am working on it now.
>
> And that's the root cause - think about what that means for a
> minute. =A0It means that extent conversion can race with anything tha=
t
> requires IO to complete first. e.g. truncate or fsync. =A0It can then
> race with other subsequent operations, which can have even nastier
> effects. IOWs, there is a data-corruption landmine just sitting
> there waiting for the next person to trip over it.
You are right that extent conversion can race with truncate and fsync
as well. That is why we already need to call ext4_flush_completed_IO()
in those places as well. I agree this is a little nasty and there can b=
e
some other corner cases that we haven't covered. The problem is we
can not do extent conversion during the end_io time. I haven't thought =
of
a better approach to deal with these races. I am curious how xfs deals
with this problem.

Jiaying

>
> Fix the root cause, don't put band-aids over the symptoms.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
