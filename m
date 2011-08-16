From: Tao Ma <tm@tao.ma>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Tue, 16 Aug 2011 23:03:44 +0800
Message-ID: <4E4A86D0.2070300@tao.ma>
References: <4E456436.8070107@msgid.tls.msk.ru> <1313251371-3672-1-git-send-email-tm@tao.ma> <4E4836A8.3080709@msgid.tls.msk.ru> <4E48390E.9050102@msgid.tls.msk.ru> <4E488625.609@tao.ma> <4E48D231.5060807@msgid.tls.msk.ru> <4E48DF31.4050603@msgid.tls.msk.ru> <CAFgt=MAfbU_muEzmxx-8CK8w7=nGR5dUZSgBQ1dN6XkyrTbO9g@mail.gmail.com> <20110816135325.GD23416@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jiaying Zhang <jiayingz@google.com>,
	Michael Tokarev <mjt@tls.msk.ru>, linux-ext4@vger.kernel.org,
	sandeen@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:35930 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752607Ab1HPPD7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Aug 2011 11:03:59 -0400
In-Reply-To: <20110816135325.GD23416@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/16/2011 09:53 PM, Jan Kara wrote:
> On Mon 15-08-11 16:53:34, Jiaying Zhang wrote:
>> On Mon, Aug 15, 2011 at 1:56 AM, Michael Tokarev <mjt@tls.msk.ru> wrote:
>>> 15.08.2011 12:00, Michael Tokarev wrote:
>>> [....]
>>>
>>> So, it looks like this (starting with cold cache):
>>>
>>> 1. rename the redologs and copy them over - this will
>>>   make a hot copy of redologs
>>> 2. startup oracle - it will complain that the redologs aren't
>>>   redologs, the header is corrupt
>>> 3. shut down oracle, start it up again - it will succeed.
>>>
>>> If between 1 and 2 you'll issue sync(1) everything will work.
>>> When shutting down, oracle calls fsync(), so that's like
>>> sync(1) again.
>>>
>>> If there will be some time between 1. and 2., everything
>>> will work too.
>>>
>>> Without dioread_nolock I can't trigger the problem no matter
>>> how I tried.
>>>
>>>
>>> A smaller test case.  I used redo1.odf file (one of the
>>> redologs) as a test file, any will work.
>>>
>>>  $ cp -p redo1.odf temp
>>>  $ dd if=temp of=foo iflag=direct count=20
>> Isn't this the expected behavior here? When doing
>> 'cp -p redo1.odf temp', data is copied to temp through
>> buffer write, but there is no guarantee when data will be
>> actually written to disk. Then with 'dd if=temp of=foo
>> iflag=direct count=20', data is read directly from disk.
>> Very likely, the written data hasn't been flushed to disk
>> yet so ext4 returns zero in this case.
>   No it's not. Buffered and direct IO is supposed to work correctly
> (although not fast) together. In this particular case we take care to flush
> dirty data from page cache before performing direct IO read... But
> something is broken in this path obviously.
> 
> I don't have time to dig into this in detail now but what seems to be the
> problem is that with dioread_nolock option, we don't acquire i_mutex for
> direct IO reads anymore. Thus these reads can compete with
> ext4_end_io_nolock() called from ext4_end_io_work() (this is called under
> i_mutex so without dioread_nolock the race cannot happen).
> 
> Hmm, the new writepages code seems to be broken in combination with direct
> IO. Direct IO code expects that when filemap_write_and_wait() finishes,
> data is on disk but with new bio submission code this is not true because
> we clear PageWriteback bit (which is what filemap_fdatawait() waits for) in
> ext4_end_io_buffer_write() but do extent conversion only after that in
> convert workqueue. So the race seems to be there all the time, just without
> dioread_nolock it's much smaller.
You are absolutely right. The really problem is that ext4_direct_IO
begins to work *after* we clear the page writeback flag and *before* we
convert unwritten extent to a valid state. Some of my trace does show
that. I am working on it now.
> 
> Fixing this is going to be non-trivial - I'm not sure we can really move
> clearing of PageWriteback bit to conversion workqueue. I thienk we already
> tried that once but it caused deadlocks for some reason...
I just did as what you described and yes I met with another problem and
try to resolve it now. Once it is OK, I will send out the patch.

Thanks
Tao
