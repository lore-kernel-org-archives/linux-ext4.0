From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Fri, 03 Apr 2009 17:01:04 -0400
Message-ID: <1238792464.24082.32.camel@think.oraclecorp.com>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu>
	 <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain>
	 <20090403184729.GC5178@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:61949 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZDCVCA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Apr 2009 17:02:00 -0400
In-Reply-To: <20090403184729.GC5178@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2009-04-03 at 20:47 +0200, Jens Axboe wrote:
> On Fri, Apr 03 2009, Linus Torvalds wrote:
> > 
> > 
> > On Fri, 3 Apr 2009, Theodore Ts'o wrote:
> > > 
> > > Please pull from:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git ext3-latency-fixes
> > 
> > Thanks, pulled. I'll be interested to see how it feels. Will report back 
> > after I've rebuild and gone through a few more emails.
> 
> I have one question, didn't see this series before... Ted, what kind of
> tests did you run with this and on what? Currently one has to be careful
> with WRITE_SYNC, as it also implies an immediate unplug of the device.
> So not only does it flag the priority as sync, it'll also kick things
> off immediately. We had a nasty regression in performance in a few
> revisions of the kernel due to this, sqlite performance was basically 4
> times as bad as before we did WRITE_SYNC in sync_dirty_buffer(). So I'd
> be curious what kind of testing was done with the patch series before
> submitting it.
> 

I had run a few tests against this...the assumption was that since ext3
doesn't have writepages I should be able to easily show using WRITE_SYNC
made for fewer merges and lower performance.  But, the write cache on my
array happily ate the smaller requests and came out just as fast.

So, your sqlite example made me think of something different:

mkfs.ext3 /dev/sdb
mount /dev/sdb /mnt
cd /mnt
tar xf /local/linux-2.6.tar
sync
sync
sync
echo 3 > /proc/sys/vm/drop_caches

# step one, start an O_SYNC writer to trigger lots of WRITE_SYNC
# this 32GB file is big enough that my drive can't finish it before the
# tar is done.
dd if=/dev/zero of=/mnt/foo bs=1M count=32000 oflag=sync &

# step two, time how long it takes to read the linux-2.6 dir
# from above
time tar cf /dev/zero /mnt/linux-2.6 &
wait %2
kill %1

/local/linux-2.6.tar is a full kernel tree after compiling with
debuginfo turned on and including the mercurial history files.  It has
2.2GB of files.  The goal here is to time how long it takes to read the
big directory tree in the face of a writer doing constant WRITE_SYNC
writes.  Time to read the directory tree:

With Ted's ext3 patches: 8m2s
Plain 2.6.29:            4m9s

-chris


