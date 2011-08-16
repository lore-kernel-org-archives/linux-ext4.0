From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Wed, 17 Aug 2011 02:28:35 +0400
Message-ID: <4E4AEF13.7070504@msgid.tls.msk.ru>
References: <4E456436.8070107@msgid.tls.msk.ru>	<1313251371-3672-1-git-send-email-tm@tao.ma>	<4E4836A8.3080709@msgid.tls.msk.ru>	<4E48390E.9050102@msgid.tls.msk.ru>	<4E488625.609@tao.ma>	<4E48D231.5060807@msgid.tls.msk.ru>	<4E48DF31.4050603@msgid.tls.msk.ru>	<CAFgt=MAfbU_muEzmxx-8CK8w7=nGR5dUZSgBQ1dN6XkyrTbO9g@mail.gmail.com>	<20110816135325.GD23416@quack.suse.cz>	<4E4A86D0.2070300@tao.ma> <CAFgt=MCQttE5Vv_4W=hFWU_L_FvELnY6bnFQ3uSOu07VkDm6rA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Tao Ma <tm@tao.ma>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:34302 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab1HPW2h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Aug 2011 18:28:37 -0400
In-Reply-To: <CAFgt=MCQttE5Vv_4W=hFWU_L_FvELnY6bnFQ3uSOu07VkDm6rA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

17.08.2011 01:32, Jiaying Zhang wrote:
> On Tue, Aug 16, 2011 at 8:03 AM, Tao Ma <tm@tao.ma> wrote:
>> On 08/16/2011 09:53 PM, Jan Kara wrote:
>>> On Mon 15-08-11 16:53:34, Jiaying Zhang wrote:
>>>> On Mon, Aug 15, 2011 at 1:56 AM, Michael Tokarev <mjt@tls.msk.ru> wrote:
>>>>> 15.08.2011 12:00, Michael Tokarev wrote:
>>>>> [....]
>>>>>
>>>>> So, it looks like this (starting with cold cache):
>>>>>
>>>>> 1. rename the redologs and copy them over - this will
>>>>>   make a hot copy of redologs
>>>>> 2. startup oracle - it will complain that the redologs aren't
>>>>>   redologs, the header is corrupt
>>>>> 3. shut down oracle, start it up again - it will succeed.
>>>>>
>>>>> If between 1 and 2 you'll issue sync(1) everything will work.
>>>>> When shutting down, oracle calls fsync(), so that's like
>>>>> sync(1) again.
>>>>>
>>>>> If there will be some time between 1. and 2., everything
>>>>> will work too.
>>>>>
>>>>> Without dioread_nolock I can't trigger the problem no matter
>>>>> how I tried.
>>>>>
>>>>>
>>>>> A smaller test case.  I used redo1.odf file (one of the
>>>>> redologs) as a test file, any will work.
>>>>>
>>>>>  $ cp -p redo1.odf temp
>>>>>  $ dd if=temp of=foo iflag=direct count=20
>>>> Isn't this the expected behavior here? When doing
>>>> 'cp -p redo1.odf temp', data is copied to temp through
>>>> buffer write, but there is no guarantee when data will be
>>>> actually written to disk. Then with 'dd if=temp of=foo
>>>> iflag=direct count=20', data is read directly from disk.
>>>> Very likely, the written data hasn't been flushed to disk
>>>> yet so ext4 returns zero in this case.
>>>   No it's not. Buffered and direct IO is supposed to work correctly
>>> (although not fast) together. In this particular case we take care to flush
>>> dirty data from page cache before performing direct IO read... But
>>> something is broken in this path obviously.
> I see. Thanks a lot for the explanation.
> 
> I wonder whether the following patch will solve the problem:
> 
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 6c27111..ca90d73 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c

It is in inode.c in 3.0, not in indirect.c (there's no such file there).
But it applies (after de-MIMEfying it) - well, almost with no mods... ;)

> @@ -800,12 +800,17 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
>         }
> 
>  retry:
> -       if (rw == READ && ext4_should_dioread_nolock(inode))
> +       if (rw == READ && ext4_should_dioread_nolock(inode)) {
> +               if (unlikely(!list_empty(&ei->i_completed_io_list))) {
> +                       mutex_lock(&inode->i_mutex);
> +                       ext4_flush_completed_IO(inode);
> +                       mutex_unlock(&inode->i_mutex);
> +               }
>                 ret = __blockdev_direct_IO(rw, iocb, inode,
>                                  inode->i_sb->s_bdev, iov,
>                                  offset, nr_segs,
>                                  ext4_get_block, NULL, NULL, 0);
> -       else {
> +       } else {
>                 ret = blockdev_direct_IO(rw, iocb, inode,
>                                  inode->i_sb->s_bdev, iov,
>                                  offset, nr_segs,
> 
> I tested the patch a little bit and it seems to resolve the race
> on dioread_nolock in my case. Michael, I would very appreciate
> if you can try this patch with your test case and see whether it works.

So I tried it just now.  I tried hard, several times.  No joy: I don't
see the "corruption" anymore, neither with the simple dd case nor with
oracle version.  I added a printk into the new if-unlikely path, and
it triggers several times, - almost always when I run my "oracle
test-case" - starting the database after newly-copying the redologs.

So it appears you've hit the right place there.  At least for this
test case ;)  Not sure if that's exactly right way to go - maybe
it's possible to have some optimisation in there, in case completed
list is not empty but not overlaps with our I/O list, but that's
probably overkill, dunno.

>>> Hmm, the new writepages code seems to be broken in combination with direct
>>> IO. Direct IO code expects that when filemap_write_and_wait() finishes,
>>> data is on disk but with new bio submission code this is not true because
>>> we clear PageWriteback bit (which is what filemap_fdatawait() waits for) in
>>> ext4_end_io_buffer_write() but do extent conversion only after that in
>>> convert workqueue. So the race seems to be there all the time, just without
>>> dioread_nolock it's much smaller.

> I think ext4_end_io_buffer_write() is only called with dioread_nolock enabled.
> So I think we should be ok with the default mount options.

Am I right that the intention was to enable dioread_nolock by default
eventually, or even to keep its behavour only, without mount options?

And thank you -- all -- for your work and support!

/mjt
