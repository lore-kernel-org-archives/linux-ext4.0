From: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Subject: RE: data=journal regressions in 3.16-rc1
Date: Mon, 23 Jun 2014 21:11:49 +0000
Message-ID: <100D68C7BA14664A8938383216E40DE0407A5AB2@FMSMSX114.amr.corp.intel.com>
References: <20140623202404.GA16979@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "tytso@mit.edu" <tytso@mit.edu>
To: Eric Whitney <enwlinux@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49227 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbaFWVMf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jun 2014 17:12:35 -0400
In-Reply-To: <20140623202404.GA16979@wallace>
Content-Language: en-CA
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Which test in 075.0.fsxlog indicates failure?
________________________________________
From: Eric Whitney [enwlinux@gmail.com]
Sent: June 23, 2014 1:24 PM
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu; Wilcox, Matthew R
Subject: data=journal regressions in 3.16-rc1

My regression test results for 3.16-rc1 on x86_64 show three new xfstests
failures since 3.15 final when running on an ext4 filesystem mounted with the
data=journal and block_validity mount options (xfstests-bld's data_journal
scenario). These are generic/075, /112, and /231.  All three tests fail
consistently.

These failures bisect to this kernel patch:
7fc34a62ca  mm/msync.c: sync only the requested range in msync()

These failures also appear when running on 3.16-rc2, and disappear if the
aforementioned patch is reverted.  I've not seen the failures in any of the
other test scenarios I've run on 3.16-rc1 (4k, ext3, nojournal, etc.).

No error messages appear in the kernel log, and not a lot useful is reported
when a test fails.  Just for reference, here's the result of a generic/075
failure:

generic/075 62s ...     [15:33:07] [15:33:09] [failed, exit status 1] - output mismatch (see /root/xfstests/results//generic/075.out.bad)
    --- tests/generic/075.out   2014-06-16 13:14:27.233891460 -0400
    +++ /root/xfstests/results//generic/075.out.bad     2014-06-23 15:33:09.654212783 -0400
    @@ -4,15 +4,5 @@
     -----------------------------------------------
     fsx.0 : -d -N numops -S 0
     -----------------------------------------------
    -
    ------------------------------------------------
    -fsx.1 : -d -N numops -S 0 -x
    ------------------------------------------------
    ...
    (Run 'diff -u tests/generic/075.out /root/xfstests/results//generic/075.out.bad'  to see the entire diff)
Ran: generic/075
Failures: generic/075
Failed 1 of 1 tests


And the contents of xfstests/results/generic/075.out.bad:


QA output created by 075
brevity is wit...

-----------------------------------------------
fsx.0 : -d -N numops -S 0
-----------------------------------------------
    fsx (-d -N 1000 -S 0) failed, 0 - compare /root/xfstests/results//generic/075.0.{good,bad,fsxlog}
od: /root/xfstests/results//generic/075.0.fsxgood: No such file or directory


Additional test configuration info:

e2fsprogs master branch:  bb9cca2ca9
xfstests master branch:  45d1fac130

Perhaps data=journal has an unexpected dependency on the old msync behavior,
given the patch comment?

Thanks,
Eric
