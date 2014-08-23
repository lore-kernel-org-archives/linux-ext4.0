From: Eric Whitney <enwlinux@gmail.com>
Subject: collapse range test failures on 3.17-rc1 bigalloc
Date: Fri, 22 Aug 2014 21:28:26 -0400
Message-ID: <20140823012826.GA19205@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:47003 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaHWB2q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Aug 2014 21:28:46 -0400
Received: by mail-qa0-f54.google.com with SMTP id k15so10155495qaq.41
        for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2014 18:28:46 -0700 (PDT)
Received: from wallace (c-50-187-53-200.hsd1.nh.comcast.net. [50.187.53.200])
        by mx.google.com with ESMTPSA id w105sm37523629qge.6.2014.08.22.18.28.44
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Fri, 22 Aug 2014 18:28:45 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

My 3.17-rc1 regression results show new failures for 10 xfstests when run on a
bigalloc file system using the test infrastructure from xfstests-bld.  (Ted
reported similar failures on a pre-3.17-rc1 kernel recently.)

The failures include generic/012, generic/016, generic/017, generic/021,
generic/022, generic/075, generic/091, generic/112, generic/127, and
generic/263.  They occur on an x86_64 virtual machine as well as on a
Pandaboard (ARM).  All involve EINVAL returns from fallocate() with
COLLAPSE_RANGE.

They are related to this patch which enabled collapse range for bigalloc:
ee98fa3a8b  ext4: fix COLLAPSE RANGE test for bigalloc file systems

(Reverting it in 3.17-rc1 restores the test behavior observed in my 3.16 
baseline.  The first five tests reported above were not run in that baseline
because collapse range was disabled for bigalloc in 3.16 and this prevented
them from running (_require_xfs_io_command "fcollapse").  The latter five
yielded EOPNOTSUPP returns and thus test failures, again because collapse
range was disabled in the 3.16 kernel.)

The root cause is that each of the failed tests in 3.17-rc1 generates collapse
range offset and/or length values that are guaranteed to fail the new test in
ee98fa3a8b intended to assure that offsets are aligned on cluster boundaries
and that lengths are multiples of clusters.  In fact, none of the tests
generates values that are legal in xfstest-bld's bigalloc test scenario
(cluster size is 64 KB), so there does not currently appear to be any useful
xfstest test coverage for the collapse range feature on 4 KB block bigalloc
file systems.

There is at least some useful coverage in the bigalloc_1k scenario (cluster
size is 16 KB), where the list of failures related to collapse range does not
include generic/012, generic/016, generic/021, and generic/022.  That's
because those tests happen to generate collapse range requests whose offset
and length values align on 16 KB boundaries or which are multiples of 16 KB in
length.

However, generic/017 does not generate legal offset and/or length values for
the bigalloc_1k scenario, and neither do generic/075, generic/091, generic/112,
generic/127, or generic/263.

There's obviously nothing wrong with verifying that illegal values are
handled correctly, but that's not the case here.

Perhaps it's a little early to enable collapse range for bigalloc on ext4
unless the tests can be improved to provide better coverage.

FWIW, this is by far the worst of the regressions I'm seeing in 3.17-rc1 -
there are just a few items besides this, and overall it's looking pretty good.

Test system configuration:
e2fsprogs - master branch, 489ff4a2c7
xfsprogs - master branch, ba24eb7c82
xfstests - master branch, f7d0a30629
xfstests-bld - master branch, 3c375bae76

Thanks,
Eric




