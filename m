From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH v1 00/16] ext4: Add metadata checksumming
Date: Wed, 31 Aug 2011 17:30:31 -0700
Message-ID: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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
- Each inode stores crc32c(fs_uuid + inode_num + inode + slack_space_after_inode)
- Block and inode bitmaps each get their own crc32c(fs_uuid + group_num +
  bitmap), stored in the block group descriptor.
- Each extent tree block stores a crc32c(fs_uuid + inode_num + extent_entries)
  in unused space at the end of the block.
- Each directory leaf block has an unused-looking directory entry big enough to
  store a crc32c(fs_uuid + inode_num + block) at the end of the block.
- Each directory htree block is shortened to contain a crc32c(fs_uuid +
  inode_num + block) at the end of the block.
- Extended attribute blocks store crc32c(fs_uuid + block_no + ea_block) in the
  header.
- Journal commit blocks can be converted to use crc32c to checksum all blocks
  in the transaction, if journal_checksum is given.

The first four patches in the kernel patchset fix existing bugs in ext4 that
cause incorrect checkums to be written.  I think Ted already took them, but
with recent instability I'm resending them to be cautious.  The subsequent 12
patches add the necessary code to support checksumming in ext4 and jbd2.

I also have a set of three patches that provide a faster crc32c implementation
based on Bob Pearson's earlier crc32 patchset.  This will be sent under
separate cover to the crypto list and to lkml/linux-ext4.

The patchset for e2fsprogs will be sent under separate cover only to linux-ext4
as it is quite lengthy (~36 patches).

As far as performance impact goes, I see nearly no change with a standard mail
server ffsb simulation.  On a test that involves only file creation and
deletion and extent tree modifications, I see a drop of about 50 percent with
the current kernel crc32c implementation; this improves to a drop of about 20
percent with the enclosed crc32c implementation.  However, given that metadata
is usually a small fraction of total IO, it doesn't seem like the cost of
enabling this feature is unreasonable.

There are of course unresolved issues:

- What to do when the block group descriptor isn't big enough to hold 2 crc32s
  (which is the case with 32-bit ext4 filesystems, sadly).  I'm not quite
  convinced that truncating a 32-bit checksum to 16-bits is a safe idea.  Right
  now, one has to enable the 64bit feature to enable any bitmap checksums.
  I'm not sure how effective crc16 is at checksumming 32768-bit bitmaps.

- Using the journal commit hooks to delay crc32c calculation until dirty
  buffers are actually being written to disk.

- Can we get away with using a (hw accelerated) LE crc32c for jbd2, which
  stores its data in BE order?

- Interaction with online resize code.  Yongqiang seems to be in the process of
  rewriting this, so I haven't looked at it very closely yet.

- If block group descriptors can now exceed 32 bytes (when 64bit filesystem
  support is enabled), should we use crc32c instead of crc16?  From what I've
  read of the literature, crc16 is not very effective on datasets exceeding 256
  bytes.

Please have a look at the design document and patches, and please feel free to
suggest any changes.  I will be at LPC next week if anyone wishes to discuss,
debate, or protest.

--D

[1] https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums
