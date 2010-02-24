From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [ext3] Changes to block device after an ext3 mount point has
 been remounted readonly
Date: Wed, 24 Feb 2010 10:57:59 -0600
Message-ID: <4B855A97.4010702@redhat.com>
References: <baaef4711002180845n29561ccif451fae62e49e520@mail.gmail.com>	<9F53CAF8-B6B4-40EB-89FA-CD6779D17DBE@sun.com>	<baaef4711002182338g17e42a7dpa47242dd334a27c2@mail.gmail.com>	<20100222223252.GA13882@atrey.karlin.mff.cuni.cz>	<20100222230552.GB13882@atrey.karlin.mff.cuni.cz>	<16F918FB-F45D-478E-9358-550BB39E277E@sun.com>	<baaef4711002230042p3d6fa7fam5a80174269773d48@mail.gmail.com>	<20100223135531.GA7699@atrey.karlin.mff.cuni.cz> <877hq2tyg8.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Camille Moncelier <pix@devlife.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <877hq2tyg8.fsf@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Dmitry Monakhov wrote:
> Jan Kara <jack@suse.cz> writes:
> 
>>> The fact is that I've been able to reproduce the problem on LVM block
>>> devices, and sd* block devices so it's definitely not a loop device
>>> specific problem.
>>>
>>> By the way, I tried several other things other than "echo s
>>>> /proc/sysrq_trigger" I tried multiple sync followed with a one minute
>>> "sleep",
>>>
>>> "echo 3 >/proc/sys/vm/drop_caches" seems to lower the chances of "hash
>>> changes" but doesn't stops them.
>>   Strange. When I use sync(1) in your script and use /dev/sda5 instead of a
>> /dev/loop0, I cannot reproduce the problem (was running the script for
>> something like an hour).
> Theoretically some pages may exist after rw=>ro remount
> because of generic race between write/sync, And they will be written
> in by writepage if page already has buffers. This not happen in ext4
> because. Each time it try to perform writepages it try to start_journal
> and this result in EROFS.
> The race bug will be closed some day but new one may appear again.
> 
> Let's be honest and change ext3 writepage like follows:
> - check ROFS flag inside write page
> - dump writepage's errors.
> 
> 

sounds like the wrong approach to me, we really need to fix the root
cause and make remount,ro finish the job, I think.

Throwing away writes which an application already thinks are completed
just because remount,ro didn't keep up sounds like a bad idea.  I think
I would much rather have the write complete shortly after the readonly
transition, if I had to choose...

I haven't looked at these paths at all but just hand-wavily,
remount,ro should follow pretty much the same path as freeze,
I think.  And if freeze isn't getting everything on-disk we have
an even bigger problem.

-Eric
