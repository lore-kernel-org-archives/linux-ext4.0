From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Tue, 16 Aug 2011 12:38:14 +0400
Message-ID: <4E4A2C76.8060407@msgid.tls.msk.ru>
References: <4E456436.8070107@msgid.tls.msk.ru>	<1313251371-3672-1-git-send-email-tm@tao.ma>	<4E4836A8.3080709@msgid.tls.msk.ru>	<4E48390E.9050102@msgid.tls.msk.ru>	<4E488625.609@tao.ma>	<4E48D231.5060807@msgid.tls.msk.ru>	<4E48DF31.4050603@msgid.tls.msk.ru> <CAFgt=MAfbU_muEzmxx-8CK8w7=nGR5dUZSgBQ1dN6XkyrTbO9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org, sandeen@redhat.com,
	Jan Kara <jack@suse.cz>
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:58060 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab1HPIiQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Aug 2011 04:38:16 -0400
In-Reply-To: <CAFgt=MAfbU_muEzmxx-8CK8w7=nGR5dUZSgBQ1dN6XkyrTbO9g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

16.08.2011 03:53, Jiaying Zhang wrote:
> Hi Michael,
> 
> On Mon, Aug 15, 2011 at 1:56 AM, Michael Tokarev <mjt@tls.msk.ru> wrote:
[]
>> A smaller test case.  I used redo1.odf file (one of the
>> redologs) as a test file, any will work.
>>
>>  $ cp -p redo1.odf temp
>>  $ dd if=temp of=foo iflag=direct count=20

> Isn't this the expected behavior here? When doing
> 'cp -p redo1.odf temp', data is copied to temp through
> buffer write, but there is no guarantee when data will be
> actually written to disk. Then with 'dd if=temp of=foo
> iflag=direct count=20', data is read directly from disk.
> Very likely, the written data hasn't been flushed to disk
> yet so ext4 returns zero in this case.

The problem is 3-faced (at least ;)

First of all, it is _not_ an expected behavour.  When you
think about it, maybe it becomes "more expected", but for
first it looks like something Really Wrong (tm).  It can
be made "more expected" by mentioning in various manpages
and whatnot all the possible consecuences of mixing direct
and buffered I/O.  So far it hasn't been done.  I can
understand (and sort of expect), say, buffered write being
insisible for concurrent direct read, while they're going
at the same time.  But here, the file has been closed and
re-opened between writes and reads.

I agree that it's difficult to keep both pieces - direct
and buffered I/O - in sync, -- there were numerous efforts
to syncronize them, with various success and usually huge
amount of work.  Maybe if it were noted initially that
direct I/O _is_ incompatible with buffered I/O, things
weren't that bad now.

Next, this problem does not happen without the mentioned
dioread_nolock option (which - as far as I can see -
supposed to be the default (or only) way to handle this
in the future).  I can't trigger any of the issues
described in this thread without dioread_nolock.

So that makes this as yet another "corner case" somehow
(like famous non-fs-buffer-aligned direct write past end
of file, or like mmapped I/O mixed with direct I/O and
so on), but since most other such corner cases are fixed
now, this one just needs to be fixed too.

And 3rd, this is a race condition: it does not happen all
the time, or even most of the time, it happens "sometimes",
which makes it more like a bug than not.

Thanks,

/mjt
