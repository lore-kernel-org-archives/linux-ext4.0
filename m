From: "Theodore Ts'o" <tytso@mit.edu>
Subject: e2fsprogs v1.40.2 released
Date: Sat, 14 Jul 2007 09:32:25 -0400
Message-ID: <E1I9hjV-0001ph-Nd@candygram.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55235 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756843AbXGNNc2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Jul 2007 09:32:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


E2fsprogs 1.40.2 has been released.  It can be downloaded from one of
the following sites:

http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.40.2.tar.gz

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/e2fsprogs-1.40.2.tar.gz

Release notes follow...

E2fsprogs 1.40.2 (July 12, 2007)
================================

A recent change to e2fsck_add_dir_info() to use tdb files to check
filesystems with a very large number of filesystems had a typo which
caused us to resize the wrong data structure.  This would cause a
array overrun leading to malloc pointer corruptions and segfaults.
Since we normally can very accurately predict how big the the dirinfo
array needs to be, this bug only got triggered on very badly corrupted
filesystems.

Fix a bug in e2fsck which caused it to incorrectly salvange
directories when the last entry's rec_len is bogusly too big.  This
resulted in a nonsense filesystem corruption to be reported, and
required a second run of e2fsck to fully fix up the directory.

Update tune2fs man page to include more discussion of reserved blocks
(Addresses Launchpad bug #47817)

Update Turkish, Polish, Dutch, and Vietnamese PO files from the
Translation Project
