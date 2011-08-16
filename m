From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Tue, 16 Aug 2011 16:07:38 -0700
Message-ID: <CAFgt=MBMyf=n2GM6iNPdOoBiC2o0PqLSi7yrssHn562K96wn_g@mail.gmail.com>
References: <4E456436.8070107@msgid.tls.msk.ru>
	<1313251371-3672-1-git-send-email-tm@tao.ma>
	<4E4836A8.3080709@msgid.tls.msk.ru>
	<4E48390E.9050102@msgid.tls.msk.ru>
	<4E488625.609@tao.ma>
	<4E48D231.5060807@msgid.tls.msk.ru>
	<4E48DF31.4050603@msgid.tls.msk.ru>
	<CAFgt=MAfbU_muEzmxx-8CK8w7=nGR5dUZSgBQ1dN6XkyrTbO9g@mail.gmail.com>
	<20110816135325.GD23416@quack.suse.cz>
	<4E4A86D0.2070300@tao.ma>
	<CAFgt=MCQttE5Vv_4W=hFWU_L_FvELnY6bnFQ3uSOu07VkDm6rA@mail.gmail.com>
	<4E4AEF13.7070504@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tao Ma <tm@tao.ma>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Michael Tokarev <mjt@tls.msk.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:3145 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab1HPXHm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Aug 2011 19:07:42 -0400
Received: from hpaq1.eem.corp.google.com (hpaq1.eem.corp.google.com [172.25.149.1])
	by smtp-out.google.com with ESMTP id p7GN7eSE011377
	for <linux-ext4@vger.kernel.org>; Tue, 16 Aug 2011 16:07:40 -0700
Received: from gyg8 (gyg8.prod.google.com [10.243.50.136])
	by hpaq1.eem.corp.google.com with ESMTP id p7GN7cbV022741
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 16 Aug 2011 16:07:39 -0700
Received: by gyg8 with SMTP id 8so369666gyg.26
        for <linux-ext4@vger.kernel.org>; Tue, 16 Aug 2011 16:07:38 -0700 (PDT)
In-Reply-To: <4E4AEF13.7070504@msgid.tls.msk.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 16, 2011 at 3:28 PM, Michael Tokarev <mjt@tls.msk.ru> wrote=
:
> 17.08.2011 01:32, Jiaying Zhang wrote:
>> On Tue, Aug 16, 2011 at 8:03 AM, Tao Ma <tm@tao.ma> wrote:
>>> On 08/16/2011 09:53 PM, Jan Kara wrote:
>>>> On Mon 15-08-11 16:53:34, Jiaying Zhang wrote:
>>>>> On Mon, Aug 15, 2011 at 1:56 AM, Michael Tokarev <mjt@tls.msk.ru>=
 wrote:
>>>>>> 15.08.2011 12:00, Michael Tokarev wrote:
>>>>>> [....]
>>>>>>
>>>>>> So, it looks like this (starting with cold cache):
>>>>>>
>>>>>> 1. rename the redologs and copy them over - this will
>>>>>> =A0 make a hot copy of redologs
>>>>>> 2. startup oracle - it will complain that the redologs aren't
>>>>>> =A0 redologs, the header is corrupt
>>>>>> 3. shut down oracle, start it up again - it will succeed.
>>>>>>
>>>>>> If between 1 and 2 you'll issue sync(1) everything will work.
>>>>>> When shutting down, oracle calls fsync(), so that's like
>>>>>> sync(1) again.
>>>>>>
>>>>>> If there will be some time between 1. and 2., everything
>>>>>> will work too.
>>>>>>
>>>>>> Without dioread_nolock I can't trigger the problem no matter
>>>>>> how I tried.
>>>>>>
>>>>>>
>>>>>> A smaller test case. =A0I used redo1.odf file (one of the
>>>>>> redologs) as a test file, any will work.
>>>>>>
>>>>>> =A0$ cp -p redo1.odf temp
>>>>>> =A0$ dd if=3Dtemp of=3Dfoo iflag=3Ddirect count=3D20
>>>>> Isn't this the expected behavior here? When doing
>>>>> 'cp -p redo1.odf temp', data is copied to temp through
>>>>> buffer write, but there is no guarantee when data will be
>>>>> actually written to disk. Then with 'dd if=3Dtemp of=3Dfoo
>>>>> iflag=3Ddirect count=3D20', data is read directly from disk.
>>>>> Very likely, the written data hasn't been flushed to disk
>>>>> yet so ext4 returns zero in this case.
>>>> =A0 No it's not. Buffered and direct IO is supposed to work correc=
tly
>>>> (although not fast) together. In this particular case we take care=
 to flush
>>>> dirty data from page cache before performing direct IO read... But
>>>> something is broken in this path obviously.
>> I see. Thanks a lot for the explanation.
>>
>> I wonder whether the following patch will solve the problem:
>>
>> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
>> index 6c27111..ca90d73 100644
>> --- a/fs/ext4/indirect.c
>> +++ b/fs/ext4/indirect.c
>
> It is in inode.c in 3.0, not in indirect.c (there's no such file ther=
e).
> But it applies (after de-MIMEfying it) - well, almost with no mods...=
 ;)
>
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
> So I tried it just now. =A0I tried hard, several times. =A0No joy: I =
don't
> see the "corruption" anymore, neither with the simple dd case nor wit=
h
> oracle version. =A0I added a printk into the new if-unlikely path, an=
d
> it triggers several times, - almost always when I run my "oracle
> test-case" - starting the database after newly-copying the redologs.
>
> So it appears you've hit the right place there. =A0At least for this
> test case ;) =A0Not sure if that's exactly right way to go - maybe
> it's possible to have some optimisation in there, in case completed
> list is not empty but not overlaps with our I/O list, but that's
> probably overkill, dunno.
>
>>>> Hmm, the new writepages code seems to be broken in combination wit=
h direct
>>>> IO. Direct IO code expects that when filemap_write_and_wait() fini=
shes,
>>>> data is on disk but with new bio submission code this is not true =
because
>>>> we clear PageWriteback bit (which is what filemap_fdatawait() wait=
s for) in
>>>> ext4_end_io_buffer_write() but do extent conversion only after tha=
t in
>>>> convert workqueue. So the race seems to be there all the time, jus=
t without
>>>> dioread_nolock it's much smaller.
>
>> I think ext4_end_io_buffer_write() is only called with dioread_noloc=
k enabled.
>> So I think we should be ok with the default mount options.
>
> Am I right that the intention was to enable dioread_nolock by default
> eventually, or even to keep its behavour only, without mount options?
Good question. At the time when we checked in the code, we wanted to be
careful that it didn't introduce data corruptions that would affect nor=
mal
workloads. Apparently, the downside is that this code path doesn't get
a good test coverage. Maybe it is time to reconsider enabling this feat=
ure
by default. I guess we still want to guard it with a mount option given=
 that
it doesn't work with certain options, like "data=3Djournaled" mode and =
small
block size.

Jiaying
>
> And thank you -- all -- for your work and support!
>
> /mjt
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
