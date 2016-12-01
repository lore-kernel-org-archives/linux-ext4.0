From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 0/6] UBIFS NFS export support
Date: Thu,  1 Dec 2016 23:02:15 +0100
Message-ID: <1480629741-18375-1-git-send-email-richard@nod.at>
Cc: david@sigma-star.at, tytso@mit.edu, dedekind1@gmail.com,
        adrian.hunter@intel.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
        akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Adding fscrypto support to UBIFS forced us to implement 64bit
cookies. Using this building block we can finally implement
export operations and allow UBIFS being exported via NFS.
This series adds the last missing bits.

It can be obtained from:
git://git.infradead.org/users/rw/linux.git ubifs_export_v1

Richard Weinberger (6):
  ext4: Move is_32bit_api() to generic code
  ubifs: Provide a custom llseek for directories
  ubifs: Use 64bit readdir cookies
  ubifs: Maintain a parent pointer
  ubifs: Implement export_operations
  ubifs: Wire up NFS support

 fs/ext4/dir.c          |  9 ------
 fs/ubifs/dir.c         | 88 ++++++++++++++++++++++++++++++++++++++------------
 fs/ubifs/journal.c     |  5 ++-
 fs/ubifs/key.h         | 59 +++++++++++++++++++++++++++++++++
 fs/ubifs/sb.c          |  2 ++
 fs/ubifs/super.c       | 35 ++++++++++++++++++++
 fs/ubifs/ubifs-media.h | 18 +++++++++--
 fs/ubifs/ubifs.h       |  6 ++++
 include/linux/compat.h |  2 ++
 9 files changed, 190 insertions(+), 34 deletions(-)

-- 
2.7.3
