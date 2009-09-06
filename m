From: Andreas Dilger <adilger@sun.com>
Subject: Please reserve INCOMPAT flags
Date: Sun, 06 Sep 2009 11:25:46 +0200
Message-ID: <20090906092546.GU4197@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:33662 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbZIFJZq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Sep 2009 05:25:46 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n869PmVf011272
	for <linux-ext4@vger.kernel.org>; Sun, 6 Sep 2009 02:25:49 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KPJ00G00M6LGE00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Sun,
 06 Sep 2009 02:25:48 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted,
in addition to the data-in-dirent INCOMPAT flag Rahul sent the patches
for last week, I would like to ensure that we also have the INCOMPAT
flag for large EA-in-inode flag reserved.  This patch is going into
testing at one of our large customers, and I want to make sure that
we don't accidentally get a conflicting INCOMPAT flag assignment.

#define EXT4_FEATURE_INCOMPAT_EA_INODE	0x0400
#define EXT4_FEATURE_INCOMPAT_DIRDATA   0x1000

#define EXT4_EA_INODE_FL	0x00200000 /* Inode used for large EA */

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

