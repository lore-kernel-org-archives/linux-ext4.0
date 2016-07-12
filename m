From: Dave Chinner <david@fromorbit.com>
Subject: Re: ext4 error when testing virtio-scsi & vhost-scsi
Date: Wed, 13 Jul 2016 09:03:56 +1000
Message-ID: <20160712230356.GJ1922@dastard>
References: <CAMj5BkiVGQ4dAUY+wi-+O4qRdVS6YPiUP2BpsiE5y0r+2AhLgw@mail.gmail.com>
 <CAMj5BkiKC2m3PLHvoDWwyj9BQZ-Bg5mD0f1J0kZcpwroH+rR1g@mail.gmail.com>
 <CAMj5BkgSXjD+_GB_VPgizowyyJ1uYxLiKd7ehQmEdVvnuY55cA@mail.gmail.com>
 <20160712164324.GC11020@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zhangfei Gao <zhangfei.gao@gmail.com>, kvm@vger.kernel.org,
	qemu-devel@nongnu.org, target-devel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160712164324.GC11020@thunk.org>
Sender: target-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 12, 2016 at 12:43:24PM -0400, Theodore Ts'o wrote:
> On Tue, Jul 12, 2016 at 03:14:38PM +0800, Zhangfei Gao wrote:
> > Some update:
> > 
> > If test with ext2, no problem in iblock.
> > If test with ext4, ext4_mb_generate_buddy reported error in the
> > removing files after reboot.
> > 
> > 
> > root@(none)$ rm test
> > [   21.006549] EXT4-fs error (device sda): ext4_mb_generate_buddy:758: group 18
> > , block bitmap and bg descriptor inconsistent: 26464 vs 25600 free clusters
> > [   21.008249] JBD2: Spotted dirty metadata buffer (dev = sda, blocknr = 0). Th
> > ere's a risk of filesystem corruption in case of system crash.
> > 
> > Any special notes of using ext4 in qemu?
> 
> Ext4 has more runtime consistency checking than ext2.  So just because
> ext4 complains doesn't mean that there isn't a problem with the file
> system; it just means that ext4 is more likely to notice before you
> lose user data.
> 
> So if you test with ext2, try running e2fsck afterwards, to make sure
> the file system is consistent.
> 
> Given that I'm reguarly testing ext4 using kvm, and I haven't seen
> anything like this in a very long time, I suspect the problemb is with
> your SCSI code, and not with ext4.

It's the same error I reported yesterday for ext3 on 4.7-rc6 when
rebooting a VM after it hung.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
