From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Tue, 16 Aug 2011 14:32:12 -0700
Message-ID: <CAFgt=MCQttE5Vv_4W=hFWU_L_FvELnY6bnFQ3uSOu07VkDm6rA@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Michael Tokarev <mjt@tls.msk.ru>,
	linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:36910 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1HPVcS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Aug 2011 17:32:18 -0400
Received: from wpaz9.hot.corp.google.com (wpaz9.hot.corp.google.com [172.24.198.73])
	by smtp-out.google.com with ESMTP id p7GLWEEH005005
	for <linux-ext4@vger.kernel.org>; Tue, 16 Aug 2011 14:32:14 -0700
Received: from yib19 (yib19.prod.google.com [10.243.65.83])
	by wpaz9.hot.corp.google.com with ESMTP id p7GLUQMf009665
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 16 Aug 2011 14:32:13 -0700
Received: by yib19 with SMTP id 19so416340yib.27
        for <linux-ext4@vger.kernel.org>; Tue, 16 Aug 2011 14:32:13 -0700 (PDT)
In-Reply-To: <4E4A86D0.2070300@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 16, 2011 at 8:03 AM, Tao Ma <tm@tao.ma> wrote:
> On 08/16/2011 09:53 PM, Jan Kara wrote:
>> On Mon 15-08-11 16:53:34, Jiaying Zhang wrote:
>>> On Mon, Aug 15, 2011 at 1:56 AM, Michael Tokarev <mjt@tls.msk.ru> w=
rote:
>>>> 15.08.2011 12:00, Michael Tokarev wrote:
>>>> [....]
>>>>
>>>> So, it looks like this (starting with cold cache):
>>>>
>>>> 1. rename the redologs and copy them over - this will
>>>> =A0 make a hot copy of redologs
>>>> 2. startup oracle - it will complain that the redologs aren't
>>>> =A0 redologs, the header is corrupt
>>>> 3. shut down oracle, start it up again - it will succeed.
>>>>
>>>> If between 1 and 2 you'll issue sync(1) everything will work.
>>>> When shutting down, oracle calls fsync(), so that's like
>>>> sync(1) again.
>>>>
>>>> If there will be some time between 1. and 2., everything
>>>> will work too.
>>>>
>>>> Without dioread_nolock I can't trigger the problem no matter
>>>> how I tried.
>>>>
>>>>
>>>> A smaller test case. =A0I used redo1.odf file (one of the
>>>> redologs) as a test file, any will work.
>>>>
>>>> =A0$ cp -p redo1.odf temp
>>>> =A0$ dd if=3Dtemp of=3Dfoo iflag=3Ddirect count=3D20
>>> Isn't this the expected behavior here? When doing
>>> 'cp -p redo1.odf temp', data is copied to temp through
>>> buffer write, but there is no guarantee when data will be
>>> actually written to disk. Then with 'dd if=3Dtemp of=3Dfoo
>>> iflag=3Ddirect count=3D20', data is read directly from disk.
>>> Very likely, the written data hasn't been flushed to disk
>>> yet so ext4 returns zero in this case.
>> =A0 No it's not. Buffered and direct IO is supposed to work correctl=
y
>> (although not fast) together. In this particular case we take care t=
o flush
>> dirty data from page cache before performing direct IO read... But
>> something is broken in this path obviously.
I see. Thanks a lot for the explanation.

I wonder whether the following patch will solve the problem:

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 6c27111..ca90d73 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -800,12 +800,17 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *=
iocb,
        }

 retry:
-       if (rw =3D=3D READ && ext4_should_dioread_nolock(inode))
+       if (rw =3D=3D READ && ext4_should_dioread_nolock(inode)) {
+               if (unlikely(!list_empty(&ei->i_completed_io_list))) {
+                       mutex_lock(&inode->i_mutex);
+                       ext4_flush_completed_IO(inode);
+                       mutex_unlock(&inode->i_mutex);
+               }
                ret =3D __blockdev_direct_IO(rw, iocb, inode,
                                 inode->i_sb->s_bdev, iov,
                                 offset, nr_segs,
                                 ext4_get_block, NULL, NULL, 0);
-       else {
+       } else {
                ret =3D blockdev_direct_IO(rw, iocb, inode,
                                 inode->i_sb->s_bdev, iov,
                                 offset, nr_segs,

I tested the patch a little bit and it seems to resolve the race
on dioread_nolock in my case. Michael, I would very appreciate
if you can try this patch with your test case and see whether it works.

>>
>> I don't have time to dig into this in detail now but what seems to b=
e the
>> problem is that with dioread_nolock option, we don't acquire i_mutex=
 for
>> direct IO reads anymore. Thus these reads can compete with
>> ext4_end_io_nolock() called from ext4_end_io_work() (this is called =
under
>> i_mutex so without dioread_nolock the race cannot happen).
>>
>> Hmm, the new writepages code seems to be broken in combination with =
direct
>> IO. Direct IO code expects that when filemap_write_and_wait() finish=
es,
>> data is on disk but with new bio submission code this is not true be=
cause
>> we clear PageWriteback bit (which is what filemap_fdatawait() waits =
for) in
>> ext4_end_io_buffer_write() but do extent conversion only after that =
in
>> convert workqueue. So the race seems to be there all the time, just =
without
>> dioread_nolock it's much smaller.
I think ext4_end_io_buffer_write() is only called with dioread_nolock e=
nabled.
So I think we should be ok with the default mount options.

Jiaying

> You are absolutely right. The really problem is that ext4_direct_IO
> begins to work *after* we clear the page writeback flag and *before* =
we
> convert unwritten extent to a valid state. Some of my trace does show
> that. I am working on it now.
>>
>> Fixing this is going to be non-trivial - I'm not sure we can really =
move
>> clearing of PageWriteback bit to conversion workqueue. I thienk we a=
lready
>> tried that once but it caused deadlocks for some reason...
> I just did as what you described and yes I met with another problem a=
nd
> try to resolve it now. Once it is OK, I will send out the patch.
>
> Thanks
> Tao
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
