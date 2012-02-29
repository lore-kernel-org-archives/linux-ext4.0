From: Jacek Luczak <difrost.kernel@gmail.com>
Subject: getdents - ext4 vs btrfs performance
Date: Wed, 29 Feb 2012 14:31:03 +0100
Message-ID: <CADDYkjRnRKPMW53F=oELhwkSt5EQB9v0JkC=inNvZQPKu94Xtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, Al Viro <viro@zeniv.linux.org.uk>,
	"Ted Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40481 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987Ab2B2NbF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Feb 2012 08:31:05 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

Long story short: We've found that operations on a directory structure
holding many dirs takes ages on ext4.

The Question: Why there's that huge difference in ext4 and btrfs? See
below test results for real values.

Background: I had to backup a Jenkins directory holding workspace for
few projects which were co from svn (implies lot of extra .svn dirs).
The copy takes lot of time (at least more than I've expected) and
process was mostly in D (disk sleep). I've dig more and done some
extra test to see if this is not a regression on block/fs site. To
isolate the issue I've also performed same tests on btrfs.

Test environment configuration:
1) HW: HP ProLiant BL460 G6, 48 GB of memory, 2x 6 core Intel X5670 HT
enabled, Smart Array P410i, RAID 1 on top of 2x 10K RPM SAS HDDs.
2) Kernels: All tests were done on following kernels:
 - 2.6.39.4-3 -- the build ID (3) is used here for internal tacking of
config changes mostly. In -3 we've introduced ,,fix readahead pipeline
break caused by block plug'' patch. Otherwise it's pure 2.6.39.4.
 - 3.2.7 -- latest kernel at the time of testing (3.2.8 has been
release recently).
3) A subject of tests, directory holding:
 - 54GB of data (measured on ext4)
 - 1978149 files
 - 844008 directories
4) Mount options:
 - ext4 -- errors=remount-ro,noatime,data=writeback
 - btrfs -- noatime,nodatacow and for later investigation on
copression effect: noatime,nodatacow,compress=lzo

In all tests I've been measuring time of execution. Following tests
were performed:
- find . -type d
- find . -type f
- cp -a
- rm -rf

Ext4 results:
| Type     | 2.6.39.4-3   | 3.2.7
| Dir cnt  | 17m 40sec  | 11m 20sec
| File cnt |  17m 36sec | 11m 22sec
| Copy    | 1h 28m        | 1h 27m
| Remove| 3m 43sec
