From: Andy Isaacson <adi@hexapodia.org>
Subject: Re: hard lockup, followed by ext4_lookup: deleted inode referenced: 524788
Date: Tue, 29 Sep 2009 09:12:50 -0700
Message-ID: <20090929161250.GX12922@hexapodia.org>
References: <20090928191644.GR12922@hexapodia.org> <20090928202507.GB22733@mit.edu> <20090928212838.GS12922@hexapodia.org> <20090929031308.GB24383@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752289AbZI2QMs@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090929031308.GB24383@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Sep 28, 2009 at 11:13:08PM -0400, Theodore Tso wrote:
> What this indicates to me is that an inode table block was written to
> the wrong location on disk.  In fact, given large numbers of inode
> numbers involved, it looks like large numbers of inode table blocks
> were written to the wrong location on disk.

Aha, sounds like an excellent theory.

> I'm surprised by how many inode tables blocks apparently had gotten
> mis-directed.  Almost certainly there must have been some kind of
> hardware failure that must have triggered this.  I'm not sure what
> caused it, but it does seem like your filesystem has been toasted
> fairly badly.

As I said, the machine hung hard while doing a bunch of writes to a USB
thumbdrive and a kernel compile on sda1.  It could be hardware, but I've
been using this laptop as my primary test box for several months and
it's been fairly reliable (as reliable as git-of-the-day is, pretty
much).

I'll run memtest86 and check SMART.

Note that it is running DMAR (the Intel VT-d iommu implementation), it
could be that a DMA got messed up -- since the logs didn't make it I
don't know if DMAR reported any DMA protection faults at the time of
failure.  The DMAR on this box has had some issues in the past which
seem to be fixed, but ...

> At this point my advice to you would be to try to recover as much data
> from the disk as you can, and to *not* try to run fsck or mount the

Oh, all the data is well backed-up; this is a seriously bleeding-edge
box.

I've taken a complete image of /dev/sda1 and will be reinstalling it.
The image is from after the kernel remounted / RO.

> disk using dd to a backup hard drive first.  If you're really curious
> we could try to look at the dumpe2fs output and see if we can find the
> pattern of what might have caused so many misdirected writes, but
> there's no guarantee that we would be able to find the definitive root
> cause, and from a recovery perspective, it's probably faster and less
> risk to reinstall your system disk from scratch.

I would like to get as close to root cause as possible.  I have a
filesystem image copied away and I'll be attempting to repro the
failure; this is a test system for a large deployment, so I don't want
any issues lurking. :)

Let me know what debug commands you'd like to run.  dumpe2fs output is
at http://web.hexapodia.org/~adi/tmp/dumpe2fs.out

-andy
