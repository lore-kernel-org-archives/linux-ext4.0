From: Nikola Pajkovsky <nikola.pajkovsky@gooddata.com>
Subject: Re: xfstests generic/130 hang with non-4k block size ext4 on 4.7-rc1 kernel
Date: Thu, 02 Jun 2016 14:30:08 +0200
Message-ID: <87zir36aen.fsf@gooddata.com>
References: <20160531140922.GM5140@eguan.usersys.redhat.com>
	<20160531154017.GC5357@thunk.org>
	<20160601063822.GH10350@eguan.usersys.redhat.com>
	<20160601165800.GI10350@eguan.usersys.redhat.com>
	<20160602085840.GH19636@quack2.suse.cz>
	<20160602121750.GC32574@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Eryu Guan <guaneryu@gmail.com>, Theodore Ts'o <tytso@mit.edu>,
	Eryu Guan <eguan@redhat.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36912 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbcFBMaM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Jun 2016 08:30:12 -0400
Received: by mail-wm0-f43.google.com with SMTP id z87so67650691wmh.0
        for <linux-ext4@vger.kernel.org>; Thu, 02 Jun 2016 05:30:11 -0700 (PDT)
In-Reply-To: <20160602121750.GC32574@quack2.suse.cz> (Jan Kara's message of
	"Thu, 2 Jun 2016 14:17:50 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

> On Thu 02-06-16 10:58:40, Jan Kara wrote:
>> On Thu 02-06-16 00:58:00, Eryu Guan wrote:
>> > On Wed, Jun 01, 2016 at 02:38:22PM +0800, Eryu Guan wrote:
>> > > On Tue, May 31, 2016 at 11:40:17AM -0400, Theodore Ts'o wrote:
>> > > > On Tue, May 31, 2016 at 10:09:22PM +0800, Eryu Guan wrote:
>> > > > > 
>> > > > > I noticed that generic/130 hangs starting from 4.7-rc1 kernel, on non-4k
>> > > > > block size ext4 (x86_64 host). And I bisected to commit 06bd3c36a733
>> > > > > ("ext4: fix data exposure after a crash").
>> > > > > 
>> > > > > It's the sub-test "Small Vector Sync" in generic/130 hangs the kernel,
>> > > > > and I can reproduce it on different hosts, both bare metal and kvm
>> > > > > guest.
>> > > > 
>> > > > Hmm, it's not reproducing for me, either using your simplified repro
>> > > > or generic/130.  Is there something specific with your kernel config,
>> > > > which is needed for the reproduction, perhaps?
>> > > 
>> > > That's weird, it's easily reproduced for me on different hosts/guests.
>> > > The kernel config I'm using is based on the config from RHEL7.2 kernel,
>> > > leaving all new config options to their default choices. i.e
>> > > 
>> > > cp /boot/<config-rhel7.2> ./.config && yes "" | make oldconfig && make
>> > > 
>> > > I attached my kernel config file.
>> > > 
>> > > And my test vm has 8G memory & 4 vcpus, with RHEL7.2 installed running
>> > > upstream kernel, host is RHEL6.7. xfsprogs version 3.2.2 (shipped with
>> > > RHEL7.2) and version 4.5.0 (compiled from upstream) made no difference.
>> > > 
>> > > I think I can try configs from other venders such as SuSE, Ubuntu. If
>> > > you can share your config file I'll test it as well.
>> > 
>> > I've tried kernel config from Ubuntu 16.04, and I can reproduce the hang
>> > as well. If I add "-o data=journal" or "-o data=writeback" mount option,
>> > I don't see the hang. So seems it only happens in data=ordered mode,
>> > which matches the code change in commit 06bd3c36a733, I think.
>> 
>> Yeah, so this is what I kind of expected. From the backtraces you have
>> provided it is clear that:
>> 
>> 1) There is process (xfs_io) doing O_SYNC write. That is blocked waiting
>> for transaction commit when it entered fsync path.
>> 
>> 2) jbd2 thread is blocked waiting for PG_Writeback to be cleared - this
>> happens only in data=ordered mode.
>> 
>> But what is not clear to me is: Why PG_Writeback doesn't get cleared for
>> the page? It should get cleared once the IO that was submitted completes...
>> Also how my change can trigger the problem - we have waited for
>> PG_Writeback in data=ordered mode even before. What my patch did is that we
>> are now avoiding filemap_fdatawrite() call before the filemap_fdatawait()
>> call. So I suspect this is a race that has always been there and the new
>> faster code path is just tickling it in your setup.
>> 
>> I'll try to reproduce this problem in my setup (but my kvm instance fails
>> to boot with 4.7-rc1 so I'm debugging that currently) and if I succeed,
>> I'll debug this more. If I'm unable to reproduce this, I'll need you to
>> debug why the IO for that page does not complete. Probably attaching to the
>> hung kvm guest with gdb and looking through it is the simplest in that
>> case. Thanks for your report!
>
> So I was trying but I could not reproduce the hang either. Can you find out
> which page is jbd2 thread waiting for and dump page->index, page->flags and
> also bh->b_state, bh->b_blocknr of all 4 buffer heads attached to it via
> page->private? Maybe that will shed some light...

It's dump question, but how can I find out which page is jbd2 thread
waiting for and dump page->index, page->flags and also bh->b_state,
bh->b_blocknr of all 4 buffer heads attached to it via page->private?

-- 
Nikola
