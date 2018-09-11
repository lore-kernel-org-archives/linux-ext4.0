From: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: [PATCH 1/2] ext4, dax: update dax check to skip journal inode
Date: Tue, 11 Sep 2018 09:42:45 -0600
Message-ID: <20180911154246.6844-2-toshi.kani@hpe.com>
References: <20180911154246.6844-1-toshi.kani@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: tytso-3s7WtUTddSA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jack-AlSwsSmVLrQ@public.gmane.org,
	dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180911154246.6844-1-toshi.kani-ZPxbGqLxI0U@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

Ext4 mount path calls ext4_iget() to obtain the journal inode.  This
inode does not support DAX, and 'ext4_da_aops' needs to be set.  It
currently works for the DAX mount case because ext4_iget() always set
'ext4_da_aops' to any regular files.

  ext4_fill_super
    ext4_load_journal
      ext4_get_journal_inode
        ext4_iget

In preparation to fix ext4_iget() to set 'ext4_dax_aops' for DAX files,
update ext4_should_use_dax() to return false for the journal inode.

Fixes: 5f0663bb4a64f588f0a2dd6d1be68d40f9af0086
Signed-off-by: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
---
 fs/ext4/ext4_jbd2.h |    8 ++++++++
 fs/ext4/inode.c     |    2 ++
 2 files changed, 10 insertions(+)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 15b6dd733780..9847dc980a0d 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -437,6 +437,14 @@ static inline int ext4_should_writeback_data(struct inode *inode)
 	return ext4_inode_journal_mode(inode) & EXT4_INODE_WRITEBACK_DATA_MODE;
 }
 
+static inline int ext4_is_journal_inode(struct inode *inode)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	unsigned int journal_inum = le32_to_cpu(sbi->s_es->s_journal_inum);
+
+	return journal_inum && (journal_inum == inode->i_ino);
+}
+
 /*
  * This function controls whether or not we should try to go down the
  * dioread_nolock code paths, which makes it safe to avoid taking
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d0dd585add6a..775cd9b4af55 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4686,6 +4686,8 @@ static bool ext4_should_use_dax(struct inode *inode)
 		return false;
 	if (ext4_should_journal_data(inode))
 		return false;
+	if (ext4_is_journal_inode(inode))
+		return false;
 	if (ext4_has_inline_data(inode))
 		return false;
 	if (ext4_encrypted_inode(inode))
