From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/9 v3] ext4: Punch hole and DAX fixes
Date: Sat, 7 Nov 2015 09:17:27 +1100
Message-ID: <20151106221727.GS10656@dastard>
References: <1446653920-23127-1-git-send-email-jack@suse.com>
 <80B02B5F638F054B8B1358323FECDE0A5EA64CCF@G1W3650.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>, Ted Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>
To: "Boylston, Brian" <brian.boylston@hpe.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:3247 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030298AbbKFWRa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Nov 2015 17:17:30 -0500
Content-Disposition: inline
In-Reply-To: <80B02B5F638F054B8B1358323FECDE0A5EA64CCF@G1W3650.americas.hpqcorp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 06, 2015 at 05:57:04PM +0000, Boylston, Brian wrote:
> Hi,
> 
> I've written a test tool (included below) that exercises page faults on
> hole-y portions of an mmapped file.  The file is created, sized using
> various methods, mmapped, and then two threads race to write a marker to
> different offsets within each mapped page.  Once the threads have
> finished marking each page, the pages are checked for the presence of
> the markers.
> 
> With vanilla 4.2 and 4.3 kernels, this test easily exposes corruption on
> pmem-backed, DAX-mounted xfs and ext4 file systems.

4.2/4.3 kernels do not have a fix for this race problem in them, so
it's no surprise that they fail the test. The fixes for this problem
in XFS are currently in the for-next branch, and will be merged into
4.4 during the merge window.

And FWIW, with XFS on a ramdisk on a 4.3+for-next branch kernel,
this test passes just fine:

$ ./dax-hole-test -f /mnt/scratch/holetest 1000
holetest r0

INFO: zero-filled test...
INFO: sz = 3e800000, npages = 256000
INFO: vastart = 00007fc5a90bd000
INFO: thread 0 is 7fc5a90bc700
INFO: thread 1 is 7fc5a88bb700
INFO: 0 error(s) detected

INFO: posix_fallocate test...
INFO: sz = 3e800000, npages = 256000
INFO: vastart = 00007fc5a90bd000
INFO: thread 0 is 7fc5a88bb700
INFO: thread 1 is 7fc5a90bc700
INFO: 0 error(s) detected

INFO: fallocate test...
INFO: sz = 3e800000, npages = 256000
INFO: vastart = 00007fc5a90bd000
INFO: thread 0 is 7fc5a90bc700
INFO: thread 1 is 7fc5a88bb700
INFO: 0 error(s) detected

INFO: ftruncate test...
INFO: sz = 3e800000, npages = 256000
INFO: vastart = 00007fc5a90bd000
INFO: thread 0 is 7fc5a88bb700
INFO: thread 1 is 7fc5a90bc700
INFO: 0 error(s) detected

That tends to indicate a bug in the ext4 patchset, not that the
method we've taken to solve the problem is fundamentally wrong.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
