From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH v2 00/47] e2fsprogs: Add metadata checksumming
Date: Sat, 08 Oct 2011 00:33:15 -0700
Message-ID: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40578 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab1JHHgD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 03:36:03 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 8 Oct 2011 03:36:03 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987XKG2211138
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:33:20 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987XHOG003971
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:33:20 -0400
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

This patchset has been tested on 3.1.0-rc9 on x64, i386, ppc64, and ppc32.  The
patches seems to work fine on all four platforms.

--D

[1] https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums

