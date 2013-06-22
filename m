From: "Sidorov, Andrei" <Andrei.Sidorov@arrisi.com>
Subject: RE: ext4 file replace guarantees
Date: Sat, 22 Jun 2013 13:40:26 +0000
Message-ID: <C0F0BC787567C848B2C90989451123DA2363CBBE@ATLEXMBX4.ARRS.ARRISI.com>
References: <1371764058.18527.140661246414097.671B4999@webmail.messagingengine.com>
 <20130621005937.GB10730@thunk.org>
 <1371818596.20553.140661246775057.0F7160F3@webmail.messagingengine.com>
 <20130621131521.GE10730@thunk.org>
 <1371822707.3188.140661246795017.2D10645B@webmail.messagingengine.com>
 <20130621143347.GF10730@thunk.org>
 <1371828285.23425.140661246894093.6DC945E0@webmail.messagingengine.com>
 <20130621203547.GA10582@thunk.org>
 <20130622032944.GX29376@dastard>,<20130622044718.GC4727@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Ryan Lortie <desrt@desrt.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.arrisi.com ([216.234.147.109]:43081 "EHLO mail.arrisi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab3FVPEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Jun 2013 11:04:07 -0400
In-Reply-To: <20130622044718.GC4727@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> From a philosophical point of view, I agree with you.  As I wrote in
> my earlier messages, assuming the applications aren't abusively
> calling g_file_set_contents() several times per second, I don't
> understand why Ryan is trying so hard to optimize it.  The fact that
> he's trying to optimize it at least to me seems to indicate a simple
> admission that there *are* broken applications out there, some of
> which may be calling it with high frequency, perhaps out of the UI
> thread.

Well, one application calling fsync is almost nothing to care about.
On the other hand tens and hundreds of apps doing fsync's is a disaster.

> And having general applications or generic desktop libraries trying to
> depend on specific implementation details of file systems is really
> ugly.  So it's not something I'm all that excited about.

Me too, but people have to do that because fs api is too generic and at the
same time one has to account fs specifics in order to make their app take most
advantage or at least to avoid inefficiencies.
For example I have an app that constantly does appending writes to about 15
files and I must ensure that no more than 5 seconds will be lost in an event
of system crash or power loss. How would you do that in generic way?
Generic and portable way to do it is to start 15 threads and call fsyncs on
those fds at the same time. That works fine with JFS since it doesn't do
flushes and it works fine with ext4 because all those fsync's are likely to
complete within single transaction.
However that doesn't scale well and it forces app to do bursts. Scalable, but
still bursty solution could be io_submit, but afaik no fs currently supports
async fsync.
What if you want to distribute the load? Single dedicated thread calling
fsync's works fine with JFS, but sucks with ext4. Ok, there is a
sync_file_range, let's try it out. Luckily I have control over commit=N option
to underlying ext4 fs which I leave at default 5s. Otherwise I would like to
have an ioctl to ext4 to force commit (I'm not sure if fsync on a single fd
will commit currently running transaction). Sync thread calls sync_file_range
evenly over 5s interval, ext4 does commits every 5s. Nice! But it doesn't work
with JFS. Therefore I have two implementations for different file systems.

> Personally, I think application programmers *shouldn't* need such a
> facility, if their applications are competently designed and
> implemented.  But unfortunately, they outnumber us file system
> developers, and apparently many of them seem to want to do things
> their way, whether we like it or not.

I would argue : )
fsync is not the one to rule them all. It's semantics is clear: write all
those bytes NOW.
The fact fsync can be used as a barrier doesn't mean it's the best way to do
it. There are quite few cases where write-right-now semantics is
absolutely required. More often apps just want atomic file updates and
sort of writeback control which is available only as system-wide knob.

As for atomic updates, I'm thinking of something like io_exec() or
io_submit_atomic() or whatever name is best for it. Probably it shouldn't be
tied to kaio.
This syscall would accept an array of iocb's and guarantee atomicity of the
update. This shouldn't be a big deal for ext4 to support it because it already
supports data journalling, which is however only block/page-wise atomic.
Such a syscall wouldn't be undervalued if majority of file systems support it.

Regards,
Andrey.

