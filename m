From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 03/11] ext4: Let S_DAX set only if DAX is really supported
Date: Tue,  1 Nov 2016 22:06:13 +0100
Message-ID: <1478034381-19037-4-git-send-email-jack@suse.cz>
References: <1478034381-19037-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
 Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Ted Tso <tytso-3s7WtUTddSA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
To: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1478034381-19037-1-git-send-email-jack-AlSwsSmVLrQ@public.gmane.org>
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

Currently we have S_DAX set inode->i_flags for a regular file whenever
ext4 is mounted with dax mount option. However in some cases we cannot
really do DAX - e.g. when inode is marked to use data journalling, when
inode data is being encrypted, or when inode is stored inline. Make sure
S_DAX flag is appropriately set/cleared in these cases.

Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/ext4/inline.c | 10 ++++++++++
 fs/ext4/inode.c  |  9 ++++++++-
 fs/ext4/super.c  |  5 +++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index f74d5ee2cdec..c29678965c3c 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -299,6 +299,11 @@ static int ext4_create_inline_data(handle_t *handle,
 	EXT4_I(inode)->i_inline_size = len + EXT4_MIN_INLINE_DATA_SIZE;
 	ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);
 	ext4_set_inode_flag(inode, EXT4_INODE_INLINE_DATA);
+	/*
+	 * Propagate changes to inode->i_flags as well - e.g. S_DAX may
+	 * get cleared
+	 */
+	ext4_set_inode_flags(inode);
 	get_bh(is.iloc.bh);
 	error = ext4_mark_iloc_dirty(handle, inode, &is.iloc);
 
@@ -442,6 +447,11 @@ static int ext4_destroy_inline_data_nolock(handle_t *handle,
 		}
 	}
 	ext4_clear_inode_flag(inode, EXT4_INODE_INLINE_DATA);
+	/*
+	 * Propagate changes to inode->i_flags as well - e.g. S_DAX may
+	 * get set.
+	 */
+	ext4_set_inode_flags(inode);
 
 	get_bh(is.iloc.bh);
 	error = ext4_mark_iloc_dirty(handle, inode, &is.iloc);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9eb1f89201ed..4cbd1b24c237 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4350,7 +4350,9 @@ void ext4_set_inode_flags(struct inode *inode)
 		new_fl |= S_NOATIME;
 	if (flags & EXT4_DIRSYNC_FL)
 		new_fl |= S_DIRSYNC;
-	if (test_opt(inode->i_sb, DAX) && S_ISREG(inode->i_mode))
+	if (test_opt(inode->i_sb, DAX) && S_ISREG(inode->i_mode) &&
+	    !ext4_should_journal_data(inode) && !ext4_has_inline_data(inode) &&
+	    !ext4_encrypted_inode(inode))
 		new_fl |= S_DAX;
 	inode_set_flags(inode, new_fl,
 			S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|S_DAX);
@@ -5618,6 +5620,11 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 		ext4_clear_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
 	}
 	ext4_set_aops(inode);
+	/*
+	 * Update inode->i_flags after EXT4_INODE_JOURNAL_DATA was updated.
+	 * E.g. S_DAX may get cleared / set.
+	 */
+	ext4_set_inode_flags(inode);
 
 	jbd2_journal_unlock_updates(journal);
 	percpu_up_write(&sbi->s_journal_flag_rwsem);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6db81fbcbaa6..c83d6f1cfab8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1125,6 +1125,10 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 			ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
 			ext4_clear_inode_state(inode,
 					EXT4_STATE_MAY_INLINE_DATA);
+			/*
+			 * Update inode->i_flags - e.g. S_DAX may get disabled
+			 */
+			ext4_set_inode_flags(inode);
 		}
 		return res;
 	}
@@ -1139,6 +1143,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 			len, 0);
 	if (!res) {
 		ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
+		/* Update inode->i_flags - e.g. S_DAX may get disabled */
 		res = ext4_mark_inode_dirty(handle, inode);
 		if (res)
 			EXT4_ERROR_INODE(inode, "Failed to mark inode dirty");
-- 
2.6.6
