From: Jan Kara <jack@suse.cz>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Use generic FS in virtual environments
 challenges and solutions
Date: Wed, 29 Jan 2014 16:37:46 +0100
Message-ID: <20140129153746.GA14526@quack.suse.cz>
References: <87zjmekgdh.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Konstantin Khorenko <khorenko@parallels.com>,
	Pavel Emelianov <xemul@parallels.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53585 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbaA2Phu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Jan 2014 10:37:50 -0500
Content-Disposition: inline
In-Reply-To: <87zjmekgdh.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Wed 29-01-14 18:32:58, Dmitry Monakhov wrote:
> Number of virtual environment/container solutions are grow rapidly, here
> is just small list of well known names (qemu/kvm, VMware, openvz, LXC,
> etc) There are two main challenges any VE solution should overcome: 1)
> Minimize Guest OS modification (ideally run unmodified binaries) 2)
> Resource sharing between several VE contexts (mem,cpu,disk) There are
> plenty of advanced algorithms for CPU and memory sharing between VEs.
> There are no many effective virtualization schemes for disk at the
> moment.
> 
> OpenVZ project has interesting experience in fs/disk virtualization.
> I want to propose three topics about fs/disk virtualization:
> 
> 1) Effective space allocation scheme aka "Thin provision" [1]
>    Generic filesystem tries to spawn all it's data across whole disk.
>    In case of virtual images this result continuous VImage growth
>    during FS activity even if actual FS disk usage is low.
> 
>    We have done some research and modified ext4 block allocator
>    which allow us to reduce VImage swelling effect, I would like to
>    discuss our finding's.
  That is interesting. Generally some of that work might be of general
interest because it might reduce free space fragmentation. OTOH there's a
question whether it doesn't introduce more file fragmentation... I'd also
note that we can naturally communicate to the host that we don't need some
blocks anymore using FSTRIM framework and the host can punch unnecessary
blocks from the image file. So that would be a solution to growing image
files not requiring fs modifiction.

> 2) Space reclamation FS/disk shrinking
>    FS/disk growth is relatively simple operation most disk images and FS allow
>    online grow [2], but shrink is very heavyweight operation. I would like
>    to discuss some tricks how to make offline/online shrink less intrusive.
> 
> 3) Filesystem error detection and correction
>    At this moment most filesystem may detect internal errors and perform
>    basic actions(panic,remount_ro) but this reaction is not suitable
>    for virtual environment because HardwareNode should continue to
>    operate and fix dedicated VE as soon as possible.
>    For this purpose it is reasonable to:
>    A) Implement fs event notification API similar to UEVENTs for devices or
>       quota event API. I would like to discuss this API.
  It was you or someone else who already raised this at linux-fsdevel
mailing list?

>    B) Reduce fsck time. Theodore Tso have announced initiative to implement
>       ffck for ext4 [3]. I want to discuss perspectives of design and
>       implementation online fsck for ext4.
  Well, this comes up every once in a while and the answer is always the
same. Checking might be reasonably doable but comes almost for free when
using LVM snapshots and doing fsck on the snapshot. Fixing read-write
filesystem - good luck.

> Footnotes: 
> [1]  http://en.wikipedia.org/wiki/Thin_provisioning
> 
> [2]  http://openvz.org/Ploop
> 
> [3]  http://marc.info/?l=linux-ext4&m=138661211607779&w=2

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
