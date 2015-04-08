From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] ext4 crypto: testing the wrong variable
Date: Wed, 8 Apr 2015 11:53:38 +0300
Message-ID: <20150408085338.GA8837@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Michael Halcrow <mhalcrow@google.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The intention was to check "IS_ERR(*buf)" instead of "IS_ERR(buf)".
It's never an ERR_PTR() in the current code so this is a harmless
mistake.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I have a static checker warning for when people check IS_ERR() and it's
not an error pointer.  Adding these extra checks introduces deliberate
warnings and makes my work harder which means that bugs are missed.

Also there is no good reason to pass an ERR_PTR to
ext4_fname_crypto_free_buffer() but eventually someone will take
advantage of this feature to write ugly code.  Ugly code is going to be
buggy.

At least do a "if (WARN_ON(IS_ERR(*buf))) return;".  I could filter out
impossible conditions which are inside a WARN_ON() and it will mean
people don't actually pass error pointers here.

diff --git a/fs/ext4/crypto_fname.c b/fs/ext4/crypto_fname.c
index 5fda403..f076b52 100644
--- a/fs/ext4/crypto_fname.c
+++ b/fs/ext4/crypto_fname.c
@@ -558,7 +558,7 @@ int ext4_fname_crypto_alloc_buffer(struct ext4_fname_crypto_ctx *ctx,
  */
 void ext4_fname_crypto_free_buffer(void **buf)
 {
-	if (*buf == NULL || IS_ERR(buf))
+	if (*buf == NULL || IS_ERR(*buf))
 		return;
 	kfree(*buf);
 	*buf = NULL;
