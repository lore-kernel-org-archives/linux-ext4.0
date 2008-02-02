From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH][0/28] Lustre e2fsprogs patch series
Date: Sat, 02 Feb 2008 00:59:43 -0700
Message-ID: <20080202075943.GB23836@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58129 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366AbYBBH7r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Feb 2008 02:59:47 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m127xkVS006921
	for <linux-ext4@vger.kernel.org>; Fri, 1 Feb 2008 23:59:47 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JVL00I01PUPGG00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 01 Feb 2008 23:59:46 -0800 (PST)
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following series of emails will contain the large part of the
e2fsprogs patch series that is used for Lustre.  It will not contain
the regression tests for EXTENTS nor the DIR_NLINK features, as those
are very large and were previously submitted.

A full tarball that includes the patches, series, and regression tests
will be uploaded to ftp://ftp.lustre.org/pub/lustre/other/e2fsprogs/

Patch series:

e2fsprogs-specdotin.patch
e2fsprogs-eacheck.patch 
e2fsprogs-extended_ops.patch
e2fsprogs-tests-f_unsorted_EAs.patch
e2fsprogs-tests-f_ea_checks.patch
e2fsprogs-nlinks.patch 
e2fsprogs-extents.patch
e2fsprogs-config-before-cmdline.patch
e2fsprogs-SLES10--m-support.patch
e2fsprogs-uninit.patch
e2fsprogs-nlinks-flag.patch 
e2fsprogs-expand-extra-isize.patch
e2fsprogs-tests-f_expisize.patch
e2fsprogs-tests-f_expisize_ea_del.patch
e2fsprogs-ibadness-counter.patch
e2fsprogs-tests-f_ibadness.patch
e2fsprogs-tests-f_ibadness_bad_extents.patch
e2fsprogs-tests-f_random_corruption.patch
e2fsprogs-stride_option.patch
e2fsprogs-mmp.patch
e2fsprogs-journal_chksum.patch
e2fsprogs-tests-f_jchksum_bblk.patch
e2fsprogs-tests-f_jchksum_blast_trans.patch
e2fsprogs-tests-f_jchksum_remount.patch
e2fsprogs-i_size-corruption.patch
e2fsprogs-fiemap.patch
e2fsprogs-debugfs-supported_features.patch
e2fsprogs-lts-make_rpms.patch

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
