From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [[PATCH] fix an endianness bug in ext4_encrypted_zeroout()
Date: Thu, 26 Nov 2015 16:04:34 +0000
Message-ID: <20151126160434.GU22011@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ex->ee_block is not host-endian (note that accesses of other fields
of *ex right next to that line go through the helpers that do proper
conversion from little-endian to host-endian; it might make sense
to add similar for ->ee_block to avoid reintroducing that kind of
bugs...)

Cc: stable@vger.kernel.org # v4.1+
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index af06830..1a08350 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -389,7 +389,7 @@ int ext4_encrypted_zeroout(struct inode *inode, struct ext4_extent *ex)
 	struct ext4_crypto_ctx	*ctx;
 	struct page		*ciphertext_page = NULL;
 	struct bio		*bio;
-	ext4_lblk_t		lblk = ex->ee_block;
+	ext4_lblk_t		lblk = le32_to_cpu(ex->ee_block);
 	ext4_fsblk_t		pblk = ext4_ext_pblock(ex);
 	unsigned int		len = ext4_ext_get_actual_len(ex);
 	int			ret, err = 0;
