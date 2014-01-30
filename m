From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Use generic FS in virtual environments challenges and solutions
Date: Thu, 30 Jan 2014 11:51:20 +0400
Message-ID: <87wqhhkivb.fsf@openvz.org>
References: <87zjmekgdh.fsf@openvz.org> <20140129153746.GA14526@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Konstantin Khorenko <khorenko@parallels.com>,
	Pavel Emelianov <xemul@parallels.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140129153746.GA14526@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 29 Jan 2014 16:37:46 +0100, Jan Kara <jack@suse.cz> wrote:
>   Hello,
> 
> On Wed 29-01-14 18:32:58, Dmitry Monakhov wrote:
> > Number of virtual environment/container solutions are grow rapidly, here
> > is just small list of well known names (qemu/kvm, VMware, openvz, LXC,
> > etc) There are two main challenges any VE solution should overcome: 1)
> > Minimize Guest OS modification (ideally run unmodified binaries) 2)
> > Resource sharing between several VE contexts (mem,cpu,disk) There are
> > plenty of advanced algorithms for CPU and memory sharing between VEs.
> > There are no many effective virtualization schemes for disk at the
> > moment.
> > 
> > OpenVZ project has interesting experience in fs/disk virtualization.
> > I want to propose three topics about fs/disk virtualization:
> > 
> > 1) Effective space allocation scheme aka "Thin provision" [1]
> >    Generic filesystem tries to spawn all it's data across whole disk.
> >    In case of virtual images this result continuous VImage growth
> >    during FS activity even if actual FS disk usage is low.
> > 
> >    We have done some research and modified ext4 block allocator
> >    which allow us to reduce VImage swelling effect, I would like to
> >    discuss our finding's.
>   That is interesting. Generally some of that work might be of general
> interest because it might reduce free space fragmentation. OTOH there's a
> question whether it doesn't introduce more file fragmentation... I'd also
That was main question at the beginning. I have tried to implement
virtual alloc scheme according to number of basic principles:
Group availability for allocation are depends on:
 a) current fs data/mdata usage
 b) allocation request size
 c) virtual image internal block size.
 d) virtual image allocation map
> note that we can naturally communicate to the host that we don't need some
> blocks anymore using FSTRIM framework and the host can punch unnecessary
> blocks from the image file. So that would be a solution to growing image
> files not requiring fs modifiction.
Yes, ploop already support that, feature is called pcompact. But we have
discovered that it is not always efficient because small files was
placed to different virtual blocks in virtual image. I.e. each fs-block
consumes one image block. This makes (c) very important aspect because
for most VImage implementations it is relatively big 1-4Mb and
it can not be reduced because of performance reasons.
ext4 with modified allocator have shown some promising numbers for
compilebench workload. 
> 
> > 2) Space reclamation FS/disk shrinking
> >    FS/disk growth is relatively simple operation most disk images and FS allow
> >    online grow [2], but shrink is very heavyweight operation. I would like
> >    to discuss some tricks how to make offline/online shrink less intrusive.
> > 
> > 3) Filesystem error detection and correction
> >    At this moment most filesystem may detect internal errors and perform
> >    basic actions(panic,remount_ro) but this reaction is not suitable
> >    for virtual environment because HardwareNode should continue to
> >    operate and fix dedicated VE as soon as possible.
> >    For this purpose it is reasonable to:
> >    A) Implement fs event notification API similar to UEVENTs for devices or
> >       quota event API. I would like to discuss this API.
>   It was you or someone else who already raised this at linux-fsdevel
> mailing list?
Yes. I hope quick brain storm will helps to make it better.
> 
> >    B) Reduce fsck time. Theodore Tso have announced initiative to implement
> >       ffck for ext4 [3]. I want to discuss perspectives of design and
> >       implementation online fsck for ext4.
>   Well, this comes up every once in a while and the answer is always the
> same. Checking might be reasonably doable but comes almost for free when
> using LVM snapshots and doing fsck on the snapshot. Fixing read-write
> filesystem - good luck.
But. What what about merging data from fixed snapshot back to original image?

---time-axis------------------------------------------------->
FS0----[Error]---[write-new-data]----------------->X????
         |                                         |
FS0-snap \-----[start fsck]-----[errors corrected]-/
Obviously there are no way how we can merge fixed snapshot to modified filesystem
So the only option we have after we have discovered error on FS0-snap is
to umount FS0 and run fsck on it. As result we double disk load, and
still have big downtime, but what if error was relatively simple (wrong
group stats, or wrong i_blocks for inode) it is possible to fix it
online. My proposal is to start a discussion about list issues which can be
fixed online.
> 
> > Footnotes: 
> > [1]  http://en.wikipedia.org/wiki/Thin_provisioning
> > 
> > [2]  http://openvz.org/Ploop
> > 
> > [3]  http://marc.info/?l=linux-ext4&m=138661211607779&w=2
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
