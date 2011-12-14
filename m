From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH v2.2 00/51] e2fsprogs: Add metadata checksumming
Date: Tue, 13 Dec 2011 17:13:17 -0800
Message-ID: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:41885 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab1LNBNa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Dec 2011 20:13:30 -0500
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 13 Dec 2011 18:13:29 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBE1DQIp155896
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 18:13:26 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBE1DJYP000751
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 18:13:26 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This patchset adds support in e2fsprogs for attaching crc32c checksums to most
of the ext4 metadata objects.  A full design document is on the ext4 wiki[1].
Please see the cover letter for the kernel patches for a more thorough summary
of this work.

Please have a look at the design document and patches, and please feel free to
suggest any changes.

v2: Checksum the MMP block, store the checksum type in the superblock, include
the inode generation in file checksums, and finally solve the problem of limited
space in block groups by splitting the checksum into two halves.

v2.1: Checksum the reserved parts of the htree tail structure.

v2.2: Reincorporate the FS UUID in the bitmap checksum calcuations.  Move all
disk layout changes to the front and the feature flag enablement to the end of
the patch set.  Fail journal recovery if revoke block fails checksum.

This patchset has been tested on 3.2.0-rc5 on x64, i386, ppc64, and ppc32.  The
patches seems to work fine on all four platforms.  The patchset is based atop
the 1.42 release.

--D

[1] https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums

