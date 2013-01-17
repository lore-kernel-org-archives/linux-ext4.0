From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2.4 0/3] mm/fs: Remove unnecessary waiting for stable
 pages
Date: Wed, 16 Jan 2013 18:49:02 -0800
Message-ID: <20130117024902.GJ6426@blackbox.djwong.org>
References: <20130115054235.1563.12967.stgit@blackbox.djwong.org>
 <20130115144608.722180b7.akpm@linux-foundation.org>
 <20130116002246.GI6426@blackbox.djwong.org>
 <20130115163359.16d64ab4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	tytso@mit.edu, viro@zeniv.linux.org.uk, rminnich@sandia.gov,
	martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	gnehzuil.liu@gmail.com, linux-kernel@vger.kernel.org,
	hch@infradead.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	linux-ext4@vger.kernel.org, hirofumi@mail.parknet.co.jp
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29044 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab3AQCvT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jan 2013 21:51:19 -0500
Content-Disposition: inline
In-Reply-To: <20130115163359.16d64ab4.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 15, 2013 at 04:33:59PM -0800, Andrew Morton wrote:
> On Tue, 15 Jan 2013 16:22:46 -0800
> "Darrick J. Wong" <darrick.wong@oracle.com> wrote:
> 
> > > > This patchset has been tested on 3.8.0-rc3 on x64 with ext3, ext4, and xfs.
> > > > What does everyone think about queueing this for 3.9?
> > > 
> > > This patchset lacks any performance testing results.
> > 
> > On my setup (various consumer SSDs and spinny disks, none of which support
> > T10DIF) I see that the maximum write latency with these patches applied is
> > about half of what it is without the patches.  But don't take my word for it;
> > Andy Lutomirski[1] says that his soft-rt latency-sensitive programs no longer
> > freak out when he applies the patch set.  Afaik, Google and Taobao run custom
> > kernels with all this turned off, so they should see similar latency
> > improvements too.
> > 
> > Obviously, I see no difference on the DIF disk.
> 
> We're talking 2001 here ;) Try leaping into your retro time machine and
> run dbench on ext2 on a spinny disk and I expect you'll see significant
> performance changes.
> 
> The problem back in 2001 was that we held lock_page() across the
> duration of page writeback, so if another thread came in and tried to
> dirty the page, it would block on lock_page() until IO completion.  I
> can't remember whether writeback would also block read().  Maybe it did,
> in which case the effects of this patchset won't be as dramatic as were
> the effects of splitting PG_lock into PG_lock and PG_writeback.

Now that you've stirred my memory, I /do/ dimly recall that Linux waited for
writeback back in the old days.  At least we'll be back to that.  As a side
note, the average latency of a write to a non-DIF disk dropped down to nearly
nothing.

> > > For clarity's sake, please provide a description of which filesystems
> > > (and under which circumstances) will block behind writeback when
> > > userspace is attempting to dirty a page.  Both before and, particularly,
> > > after this patchset.  IOW, did everything get fixed?
> > 
> > Heh, this is complicated.
> > 
> > Before this patchset, all filesystems would block, regardless of whether or not
> > it was necessary.  ext3 would wait, but still generate occasional checksum
> > errors.  The network filesystems were left to do their own thing, so they'd
> > wait too.
> > 
> > After this patchset, all the disk filesystems except ext3 and btrfs will wait
> > only if the hardware requires it.  ext3 (if necessary) snapshots pages instead
> > of blocking, and btrfs provides its own bdi so the mm will never wait.  Network
> > filesystems haven't been touched, so either they provide their own wait code,
> > or they don't block at all.  The blocking behavior is back to what it was
> > before 3.0 if you don't have a disk requiring stable page writes.
> > 
> > (I will reconfirm this statement before sending out the next iteration.)
> > 
> > I will of course add all of this to the cover message.
> 
> OK, thanks, that sounds reasonable.
> 
> Do we generate nice kernel messages (at mount or device-probe time)
> which will permit people to work out which strategy their device/fs is
> using?

No.  /sys/devices/virtual/bdi/*/stable_pages_required will tell you
stable pages are on or not, but so far only ext3 uses snapshots and the rest
just wait.  Do you think a printk would be useful?

--D
