From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [RFC] ext4 metadata checksumming design
Date: Tue, 16 Aug 2011 20:25:19 -0700
Message-ID: <20110817032519.GN20655@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Joel Becker <jlbec@evilplan.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Coly Li <colyli@gmail.com>, Andi Kleen <andi@firstfloor.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

I've created a page on the ext4 wiki outlining the patchset that I'm working on
to add metadata checksumming to ext4.  The page can be found at this address:
https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums

For the most part, the metadata objects in ext4 actually have enough space to
squeeze in a 32-bit checksum; it was trivially easy to find a spot in the
superblock, the extent tree, extended attribute blocks, and the inode.  Those
pieces are already done and in my tree, but the patchset as a whole is being
held up by the second class of metadata objects.

That second class of objects are the ones that required a bit of work:

- Directory blocks have an "unused" 12-byte directory entry at the very end of
  the block; 8 bytes of header are followed by a 32-bit checksum.  This can be
  taken care of as part of directory rebuilding in e2fsck/rehash.c.

- HTree blocks had to have the dx_entry limit reduced by 1 to accomodate a
  checksum.  This is also taken care of during e2fsck directory rebuild.

- Extended attribute blocks that are stored in the inode table -- the h_magic
  field is written by the kernel, but neither the kernel nor e2fsprogs ever
  actually read this field.  The field could be reused to checksum the extra
  space since (as far as I can tell) EAs are the only user of that empty space.

Other miscellany:

- e2fsprogs had to be converted to always work with ext2_inode_large.

- Various bugs in the htree code....

I hope to have a first draft of the kernel/e2fsprogs patches out on the mailing
list in a week or two, or at least before LPC next month.  Still on my todo
list is superblocks, EAs, changing the jbd2 checksum, and rigorous testing on
powerpc.

Please have a look at the design document and please feel free to suggest any
changes.

--D
