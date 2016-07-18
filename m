From: Dave Chinner <david@fromorbit.com>
Subject: Re: ext4 error when testing virtio-scsi & vhost-scsi
Date: Mon, 18 Jul 2016 11:53:41 +1000
Message-ID: <20160718015341.GB1922@dastard>
References: <CAMj5BkiVGQ4dAUY+wi-+O4qRdVS6YPiUP2BpsiE5y0r+2AhLgw@mail.gmail.com>
 <CAMj5BkiKC2m3PLHvoDWwyj9BQZ-Bg5mD0f1J0kZcpwroH+rR1g@mail.gmail.com>
 <CAMj5BkgSXjD+_GB_VPgizowyyJ1uYxLiKd7ehQmEdVvnuY55cA@mail.gmail.com>
 <20160712164324.GC11020@thunk.org>
 <20160712230356.GJ1922@dastard>
 <CAMj5Bkhr3aLTRtb58xsZGwZWchFb95bdZ8NbiLEfG=vmoObxkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, kvm@vger.kernel.org,
	qemu-devel@nongnu.org, target-devel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Zhangfei Gao <zhangfei.gao@gmail.com>
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMj5Bkhr3aLTRtb58xsZGwZWchFb95bdZ8NbiLEfG=vmoObxkQ@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 15, 2016 at 03:55:20PM +0800, Zhangfei Gao wrote:
> Dear Dave
> 
> On Wed, Jul 13, 2016 at 7:03 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Tue, Jul 12, 2016 at 12:43:24PM -0400, Theodore Ts'o wrote:
> >> On Tue, Jul 12, 2016 at 03:14:38PM +0800, Zhangfei Gao wrote:
> >> > Some update:
> >> >
> >> > If test with ext2, no problem in iblock.
> >> > If test with ext4, ext4_mb_generate_buddy reported error in the
> >> > removing files after reboot.
> >> >
> >> >
> >> > root@(none)$ rm test
> >> > [   21.006549] EXT4-fs error (device sda): ext4_mb_generate_buddy:758: group 18
> >> > , block bitmap and bg descriptor inconsistent: 26464 vs 25600 free clusters
> >> > [   21.008249] JBD2: Spotted dirty metadata buffer (dev = sda, blocknr = 0). Th
> >> > ere's a risk of filesystem corruption in case of system crash.
> >> >
> >> > Any special notes of using ext4 in qemu?
> >>
> >> Ext4 has more runtime consistency checking than ext2.  So just because
> >> ext4 complains doesn't mean that there isn't a problem with the file
> >> system; it just means that ext4 is more likely to notice before you
> >> lose user data.
> >>
> >> So if you test with ext2, try running e2fsck afterwards, to make sure
> >> the file system is consistent.
> >>
> >> Given that I'm reguarly testing ext4 using kvm, and I haven't seen
> >> anything like this in a very long time, I suspect the problemb is with
> >> your SCSI code, and not with ext4.
> >
> > It's the same error I reported yesterday for ext3 on 4.7-rc6 when
> > rebooting a VM after it hung.
> 
> 
> Any link of this error?

http://article.gmane.org/gmane.comp.file-systems.ext4/53792

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
