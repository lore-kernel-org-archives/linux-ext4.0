From: Devrin Talen <dct23@cornell.edu>
Subject: Re: ext4 filesystem corruption across partitions
Date: Mon, 5 May 2014 22:01:30 -0400
Message-ID: <20140505220130.1a256f9d@luigi>
References: <1397747123.6833.24.camel@luigi>
	<20140417161249.GH18591@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mxout-08.mxes.net ([216.86.168.183]:37090 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933564AbaEFCBj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 May 2014 22:01:39 -0400
In-Reply-To: <20140417161249.GH18591@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 17 Apr 2014 12:12:49 -0400
"Theodore Ts'o" <tytso@mit.edu> wrote:

> On Thu, Apr 17, 2014 at 11:05:23AM -0400, Devrin Talen wrote:
> > Hi all,
> > 
> > I'm debugging an issue on my platform.  In short, I can corrupt an
> > ext4 filesystem on one partition by writing a file on a different
> > one.  I'm suspecting something is off either with my partition
> > table or filesystem parameters, but I'm such an ext4 beginner that
> > I thought I'd start here to get some help in where to look.
> 
> The partition table looks fine.  (What I did was to take the lba_start
> and partition_size fields from your table, imported them into a
> spreadsheet, and then verified that "lba_start + partition_size/512"
> for each partition was the same as the lba_start of the next
> partition.  Obviously, there is no partition table overlap.)

Ted, thanks for the response.  I wanted to reply sooner but I had to
make sure I had a good way to reproduce the filesystem corruption
before getting back.

As far as the partition table, that's what I thought too but it helps to
have a second pair of eyes on it.  Thanks!

> The kernel is supposed to make sure that writes in one partition can't
> affect another parition, so either you have a kernel bug in the block
> device layer or driver, or you have a hardware problem.

That could be.  We're fairly certain it's not electrical, just because
of how simple the hookups are to our CPU, but it wouldn't be surprising
if there's some setting on the eMMC part that we're missing.  Anyway,
here's how we've been able to get this to reproduce fairly reliably:

1. Run `ls -R *` in a loop from the root directory.  The root is
mounted from partition 11 (system) on the eMMC and the ls will read
the /cache (partition 12) and /data (partition 13) filesystems as well.

2. Write data to partition 12 via ADB (using `adb push ... /cache/`)

Doing these two things, we'll get ext4 errors reported on partition
13.  I'll get the exact error messages when I'm back at my desk
tomorrow.

Fortunately, we managed to capture the failure while printing out the
trace of eMMC commands from the block driver.  It's a large file, but
if someone would find that useful I think I can make it available
somehow.

> I hate to ask this, but are you sure you have a quality 4GB sd card?
> There are fraudulent cards out there where a card will be marked as
> having X GB, but it only really has Y GB, or even Y MB worth of flash.
> The people making these fraudulent cards rely on the fact that very
> often people don't actually fill up their flash cards, so as long as
> they don't write to more than Y GB worth of disk sectors, they won't
> notice anything wrong.  But if you do write to more sectors than there
> is flash, then the N+Ith unique disk sector write ends up going to the
> Ith disk sector that had been written.

That's a good point, but we're actually using a Micron eMMC part
soldered to out board, so it better be as big as they advertise it :).

Again, thanks for the help so far and hope that we can track this down.

-- 
Devrin Talen <dct23@cornell.edu>
