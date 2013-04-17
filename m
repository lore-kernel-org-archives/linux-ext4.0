From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fsck memory usage
Date: Wed, 17 Apr 2013 19:07:45 -0400
Message-ID: <20130417230745.GC5401@thunk.org>
References: <CAEUQceh3Wm6LZpGQnXNjh0c9WbO8S70D5-KYjY8anup80WbLHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Subranshu Patel <spatel.ml@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42397 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936107Ab3DRATF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Apr 2013 20:19:05 -0400
Content-Disposition: inline
In-Reply-To: <CAEUQceh3Wm6LZpGQnXNjh0c9WbO8S70D5-KYjY8anup80WbLHQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 17, 2013 at 08:40:08PM +0530, Subranshu Patel wrote:
> I performed some recovery (fsck) tests with large EXT4 filesystem. The
> filesystem size was 500GB (3 million files, 5000 directories).
> Perfomed force recovery on the clean filesystem and measured the
> memory usage, which was around 2 GB.
> 

What version of e2fsprogs are you using?  There has been a number of
changes made to improve both CPU and memory utilization in more recent
versions of e2fsprogs.

What would be useful would be for you to run the command:

	/usr/bin/time e2fsck -nvftt /dev/XXX

Here's a run that I've done on a 1TB disk that was about 70% filled
with 8M files.  It doesn't have as many directories (1000) and far
fewer files (3000) but you'll see it uses much less memory:

e2fsck 1.42.6+git2 (29-Nov-2012)
Pass 1: Checking inodes, blocks, and sizes
Pass 1: Memory used: 400k/7888k (299k/102k), time:  9.64/ 1.04/ 0.02
Pass 1: I/O read: 4MB, write: 0MB, rate: 0.41MB/s
Pass 2: Checking directory structure
Pass 2: Memory used: 400k/15536k (276k/125k), time:  3.72/ 0.02/ 0.05
Pass 2: I/O read: 5MB, write: 0MB, rate: 1.34MB/s
Pass 3: Checking directory connectivity
Peak memory: Memory used: 400k/15536k (276k/125k), time: 13.59/ 1.28/ 0.07
Pass 3A: Memory used: 400k/15536k (297k/104k), time:  0.00/ 0.00/ 0.00
Pass 3A: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 3: Memory used: 400k/15536k (263k/138k), time:  0.00/ 0.00/ 0.00
Pass 3: I/O read: 1MB, write: 0MB, rate: 1162.79MB/s
Pass 4: Checking reference counts
Pass 4: Memory used: 400k/240k (228k/173k), time:  1.90/ 1.88/ 0.00
Pass 4: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 5: Checking group summary information
Pass 5: Memory used: 400k/240k (206k/195k), time:  6.25/ 1.46/ 0.38
Pass 5: I/O read: 31MB, write: 0MB, rate: 4.96MB/s
/dev/hdw3: 4272/48891680 files (0.6% non-contiguous), 170570829/244190000 blocks
Memory used: 400k/240k (206k/195k), time: 21.93/ 4.78/ 0.46
I/O read: 39MB, write: 0MB, rate: 1.78MB/s
4.78user 0.55system 0:22.08elapsed 24%CPU (0avgtext+0avgdata 68608maxresident)k
0inputs+0outputs (5major+2323minor)pagefaults 0swaps

It would be useful to see what your run reports, and to see what
version of e2fsprogs you are using.

> Then I performed metadata corruption - 10% of the files, 10% of the
> directories and some superblock attributes using debugfs. Then I
> executed fsck to find a memory usage of around 8GB, a much larger
> value.

It's going to depend on what sort of metadata corruption was suffered.
If you need to do pass 1b/c/d fix ups, it will need more memory.
That's pretty much unavoidable, but it's also not the common case.  In
most use cases, if those cases require using swap, that's generally OK
if it's the rare case, and not the common case.  That's why it's not
something I've really been worried about.

> 2. This question is not related to this EXT4 mailing list. But in real
> scenario how this kind of situation (large memory usage) is handled in
> large scale filesystem deployment when actual filesystem corruption
> occurs (may be due to some fault in hardware/controller)

What's your use case where you are memory constrained?  Is it a
bookshelf NAS configuration?  Are you hooking up large number of disks
to a memory-constrained server and then trying to run fsck in parallel
across a large number of 3TB or 4TB disks?  Depending on what you are
trying to do, there may be different solutions.

In general ext4 has always assumed at least a "reasonable" amount of
memory for a large amount of storage, but it's understood that
reasonable has changed over the years.  So there have been some
improvements that we've made more recently, but it may or may not bee
good enough for your use case.  Can you give us more details about
what your requirements are?

Regards,

						- Ted
