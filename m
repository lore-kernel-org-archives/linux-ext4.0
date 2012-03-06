From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH v3 00/54] e2fsprogs: Add metadata checksumming
Date: Tue, 06 Mar 2012 15:57:21 -0800
Message-ID: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
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
Received: from e32.co.us.ibm.com ([32.97.110.150]:52852 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670Ab2CFX5d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Mar 2012 18:57:33 -0500
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 6 Mar 2012 16:57:33 -0700
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 357C91FF0049
	for <linux-ext4@vger.kernel.org>; Tue,  6 Mar 2012 16:57:31 -0700 (MST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q26NvTQQ078144
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 16:57:29 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q26NvPLn009100
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 16:57:29 -0700
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

v2.3: Change fsck handling of checksum errors: First ask to clear the item; if
the user declines, run the regular checks; if no corrective actions result, ask
to reset the checksum.  Also, precompute the UUID checksum seed, refactor the
inode generation patch into respective patches, and clean up structure member
declarations.

v3: Eliminate the bg_use_meta_csum feature flag and make metadata_csum
supersede uninit_bg.  Enable metadata_csum by default on ext4dev filesystems.

This patchset has been tested on 3.3.0-rc6 on x64 and i386.  The patches seems
to work fine on both platforms.  The patchset is based atop the 1.42.1 release.

--D

[1] https://ext4.wiki.kernel.org/articles/e/x/t/Ext4_Disk_Layout_aecb.html

