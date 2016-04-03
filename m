From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 07/13] fscrypto: simplify building key descriptor
	string
Date: Sun,  3 Apr 2016 00:21:58 -0500
Message-ID: <1459660924-2960-8-git-send-email-ebiggers3@gmail.com>
References: <1459660924-2960-1-git-send-email-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, Eric Biggers <ebiggers3@gmail.com>, mhalcrow@google.com,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, jaegeuk@kernel.org,
	linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1459660924-2960-1-git-send-email-ebiggers3@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
---
 fs/crypto/keyinfo.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index cb06351..5fcee4d 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -164,13 +164,8 @@ retry:
 		memset(raw_key, 0x42, FS_AES_256_XTS_KEY_SIZE);
 		goto got_key;
 	}
-	memcpy(full_key_descriptor, FS_KEY_DESC_PREFIX,
-					FS_KEY_DESC_PREFIX_SIZE);
-	sprintf(full_key_descriptor + FS_KEY_DESC_PREFIX_SIZE,
-					"%*phN", FS_KEY_DESCRIPTOR_SIZE,
-					ctx.master_key_descriptor);
-	full_key_descriptor[FS_KEY_DESC_PREFIX_SIZE +
-					(2 * FS_KEY_DESCRIPTOR_SIZE)] = '\0';
+	sprintf(full_key_descriptor, FS_KEY_DESC_PREFIX "%*phN",
+		FS_KEY_DESCRIPTOR_SIZE, ctx.master_key_descriptor);
 	keyring_key = request_key(&key_type_logon, full_key_descriptor, NULL);
 	if (IS_ERR(keyring_key)) {
 		res = PTR_ERR(keyring_key);
-- 
2.7.4


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
