From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH v2 00/28] ext4: Add metadata checksumming
Date: Sat, 08 Oct 2011 00:53:43 -0700
Message-ID: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48836 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab1JHHz7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 03:55:59 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 8 Oct 2011 03:55:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This patchset adds crc32c checksums to most of the ext4 metadata objects.  A
full design document is on the ext4 wiki[1] but I will summarize that document here.

As much as we wish our storage hardware was totally reliable, it is still
quite possible for data to be corrupted on disk, corrupted during transfer over
a wire, or written to the wrong places.  To protect against this sort of
non-hostile corruption, it is desirable to store checksums of metadata objects
on the filesystem to prevent broken metadata from shredding the filesystem.

The crc32c polynomial was chosen for its improved error detection capabilities
over crc32 and crc16, and because of its hardware acceleration on current and
upcoming Intel and Sparc chips.

Each type of metadata object has been retrofitted to store a checksum as follows:

- The superblock stores a crc32c of itself.
- Each inode stores crc32c(fs_uuid + inode_num + inode_gen + inode +
  slack_space_after_inode)
- Block and inode bitmaps each get their own crc32c(fs_uuid + group_num +
  bitmap), stored in the block group descriptor.
- Each extent tree block stores a crc32c(fs_uuid + inode_num + inode_gen +
  extent_entries) in unused space at the end of the block.
- Each directory leaf block has an unused-looking directory entry big enough to
  store a crc32c(fs_uuid + inode_num + inode_gen + block) at the end of the
  block.
- Each directory htree block is shortened to contain a crc32c(fs_uuid +
  inode_num + inode_gen + block) at the end of the block.
- Extended attribute blocks store crc32c(fs_uuid + id + ea_block) in the
  header, where id is, depending on the refcount, either the inode_num and
  inode_gen; or the block number.
- MMP blocks store crc32c(fs_uuid + mmpblock) at the end of the MMP block.
- Block groups can now use crc32c instead of crc16.
- The journal now has a v2 checksum feature flag.
- crc32c(j_uuid + block) checksums have been inserted into descriptor blocks,
  commit blocks, revoke blocks, and the journal superblock.
- Each block tag in a descriptor block has a checksum of the related data block.

The first five patches in the kernel patchset fix existing bugs in ext4 that
cause incorrect checkums to be written.  I think Ted already took them, but
they don't appear in 3.1.0-rc9.  The subsequent patches add the necessary code
to support checksumming in ext4 and jbd2.

I also have a set patches that provide a faster crc32c implementation based on
Bob Pearson's earlier crc32 patchset.  This has been sent under separate cover
to the crypto list and to lkml/linux-ext4.

The patchset for e2fsprogs will be sent under separate cover only to linux-ext4
as it is quite lengthy (~48 patches).

As far as performance impact goes, I see nearly no change with a standard mail
server ffsb simulation.  On a test that involves only file creation and
deletion and extent tree modifications, I see a drop of about 50 percent with
the current kernel crc32c implementation; this improves to a drop of about 20
percent with the enclosed crc32c implementation.  However, given that metadata
is usually a small fraction of total IO, it doesn't seem like the cost of
enabling this feature is unreasonable.

There are of course unresolved issues:

- I haven't fixed it up to checksum the exclude bitmap yet.  I'll probably
  submit that as an add-on to the snapshot patchset.

- Using the journal commit hooks to delay crc32c calculation until dirty
  buffers are actually being written to disk.

- Interaction with online resize code.  Yongqiang seems to be in the process of
  rewriting this, so I haven't looked at it very closely yet.

Please have a look at the design document and patches, and please feel free to
suggest any changes.

v2: Checksum the MMP block, store the checksum type in the superblock, include
the inode generation in file checksums, and finally solve the problem of limited
space in block groups by splitting the checksum into two halves.

This patchset has been tested on 3.1.0-rc9 on x64, i386, ppc64, and ppc32.  The
patches seems to work fine on all four platforms.

--D

[1] https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums

