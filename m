From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH v2.1 00/50] e2fsprogs: Add metadata checksumming
Date: Mon, 28 Nov 2011 16:27:56 -0800
Message-ID: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60779 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab1K2A2D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 19:28:03 -0500
Received: from /spool/local
	by e2.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 28 Nov 2011 19:28:02 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pAT0RxYh313554
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 19:27:59 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pAT0RvEZ018105
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 22:27:58 -0200
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

This patchset has been tested on 3.2.0-rc3 on x64, i386, ppc64, and ppc32.  The
patches seems to work fine on all four platforms.  The patchset is based atop
the 1.42 WIP-1120 release.

--D

[1] https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums

