From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH][0/28] Lustre e2fsprogs patch series
Date: Mon, 11 Feb 2008 15:52:28 +0530
Message-ID: <20080211102228.GA12966@skywalker>
References: <20080202075943.GB23836@webber.adilger.int> <20080211041912.GC26205@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:56820 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbYBKKWo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Feb 2008 05:22:44 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m1BAMMWd015187
	for <linux-ext4@vger.kernel.org>; Mon, 11 Feb 2008 21:22:22 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1BAMgvL3756098
	for <linux-ext4@vger.kernel.org>; Mon, 11 Feb 2008 21:22:42 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1BAMg9Q004053
	for <linux-ext4@vger.kernel.org>; Mon, 11 Feb 2008 21:22:42 +1100
Content-Disposition: inline
In-Reply-To: <20080211041912.GC26205@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 10, 2008 at 11:19:12PM -0500, Theodore Tso wrote:
> On Sat, Feb 02, 2008 at 12:59:43AM -0700, Andreas Dilger wrote:
> > The following series of emails will contain the large part of the
> > e2fsprogs patch series that is used for Lustre.  It will not contain
> > the regression tests for EXTENTS nor the DIR_NLINK features, as those
> > are very large and were previously submitted.
> > 
> > A full tarball that includes the patches, series, and regression tests
> > will be uploaded to ftp://ftp.lustre.org/pub/lustre/other/e2fsprogs/
> 
> Hey Andreas,
> 
> I've applied these patches to the tip of "maint", and exported it as
> "e2fsprogs-interim" on the e2fsprogs git repository.  There quite a
> few patch conflicts, mostly due to some changes that had happened on
> the tip of maint, but also apparently because your patchset was
> missing the flex bg changes.  I haven't applied them yet, but I'll
> probably tack them at the end.
> 
> If you could sanity check to make sure they are sane, I would
> appreciate it.
> 

Needed this diff to get it build

                from ../../../lib/ext2fs/crc16.h:18,
                 from ../../../lib/ext2fs/crc16.c:9:
/usr/include/sys/types.h:46: error: conflicting types for 'loff_t'
/usr/include/linux/types.h:30: error: previous declaration of 'loff_t' was here
/usr/include/sys/types.h:62: error: conflicting types for 'dev_t'
/usr/include/linux/types.h:13: error: previous declaration of 'dev_t' was here
In file included from /usr/include/sys/types.h:133,
                 from /usr/include/stdlib.h:438,
                 from ../../../lib/ext2fs/crc16.h:18,
                 from ../../../lib/ext2fs/crc16.c:9


diff --git a/lib/ext2fs/crc16.c b/lib/ext2fs/crc16.c
index 5d87e10..246813f 100644
--- a/lib/ext2fs/crc16.c
+++ b/lib/ext2fs/crc16.c
@@ -5,7 +5,6 @@
  * Version 2. See the file COPYING for more details.
  */
 
-#include <linux/types.h>
 #include "crc16.h"
 
 /** CRC table for the CRC-16. The poly is 0x8005 (x^16 + x^15 + x^2 + 1) */
