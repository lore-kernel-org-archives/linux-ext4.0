From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [ext3] Changes to block device after an ext3 mount point has been remounted readonly
Date: Wed, 24 Feb 2010 20:26:13 +0300
Message-ID: <87eikao896.fsf@openvz.org>
References: <baaef4711002180845n29561ccif451fae62e49e520@mail.gmail.com>
	<9F53CAF8-B6B4-40EB-89FA-CD6779D17DBE@sun.com>
	<baaef4711002182338g17e42a7dpa47242dd334a27c2@mail.gmail.com>
	<20100222223252.GA13882@atrey.karlin.mff.cuni.cz>
	<20100222230552.GB13882@atrey.karlin.mff.cuni.cz>
	<16F918FB-F45D-478E-9358-550BB39E277E@sun.com>
	<baaef4711002230042p3d6fa7fam5a80174269773d48@mail.gmail.com>
	<20100223135531.GA7699@atrey.karlin.mff.cuni.cz>
	<877hq2tyg8.fsf@openvz.org> <4B855A97.4010702@redhat.com>
	<20100224170506.GN3687@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Camille Moncelier <pix@devlife.org>,
	"linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:32925 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab0BXR0T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Feb 2010 12:26:19 -0500
In-Reply-To: <20100224170506.GN3687@quack.suse.cz> (Jan Kara's message of
	"Wed, 24 Feb 2010 18:05:06 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

> On Wed 24-02-10 10:57:59, Eric Sandeen wrote:
>> Dmitry Monakhov wrote:
>> > Jan Kara <jack@suse.cz> writes:
>> >>> The fact is that I've been able to reproduce the problem on LVM block
>> >>> devices, and sd* block devices so it's definitely not a loop device
>> >>> specific problem.
>> >>>
>> >>> By the way, I tried several other things other than "echo s
>> >>>> /proc/sysrq_trigger" I tried multiple sync followed with a one minute
>> >>> "sleep",
>> >>>
>> >>> "echo 3 >/proc/sys/vm/drop_caches" seems to lower the chances of "hash
>> >>> changes" but doesn't stops them.
>> >>   Strange. When I use sync(1) in your script and use /dev/sda5 instead of a
>> >> /dev/loop0, I cannot reproduce the problem (was running the script for
>> >> something like an hour).
>> > Theoretically some pages may exist after rw=>ro remount
>> > because of generic race between write/sync, And they will be written
>> > in by writepage if page already has buffers. This not happen in ext4
>> > because. Each time it try to perform writepages it try to start_journal
>> > and this result in EROFS.
>> > The race bug will be closed some day but new one may appear again.
>> > 
>> > Let's be honest and change ext3 writepage like follows:
>> > - check ROFS flag inside write page
>> > - dump writepage's errors.
>> > 
>> > 
>> 
>> sounds like the wrong approach to me, we really need to fix the root
>> cause and make remount,ro finish the job, I think.
Off course, but still. This is just a sanity check. Similar check
in ext4 help me to find the generic issue. Off course it have to
be guarded by unlikely() statement
>> 
>> Throwing away writes which an application already thinks are completed
>> just because remount,ro didn't keep up sounds like a bad idea.  I think
>> I would much rather have the write complete shortly after the readonly
>> transition, if I had to choose...
>   Well, my opinion is that VFS should take care about the rw->ro transition
> so that it isn't racy...
No, My patch just try to nail the RO semantics in to writepage.
Since other places are already guarded by start_journal, writepage is
the only one which may has weakness.
About ENOSPC/EDQUOT spam. It may be not bad to print a error message
for crazy person who use mmap for space file.
>
>> I haven't looked at these paths at all but just hand-wavily,
>> remount,ro should follow pretty much the same path as freeze,
>> I think.  And if freeze isn't getting everything on-disk we have
>> an even bigger problem.
>   With freeze you can still keep dirty data in cache until the filesystem
> unfreezes so it's a different situation from rw->ro transition.
In fact freeze is also not absolutely io proof :)
When i've worked on COW device i use freeze-fs for consistent
image creation, And sometimes after filesystem was friezed
i still get bios. We do not investigate this too deeply
and just queue bios in to pending queue.

>
> 								Honza
