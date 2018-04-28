From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: [PATCH] ext4: add crc32c soft dependency
Date: Sat, 28 Apr 2018 22:50:44 +0300
Message-ID: <20180428195044.GA14126@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexey Gladkov <legion@altlinux.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Starting with commit a45403b51582, ext4 unconditionally requires
a crc32c provider, which broke certain mkinitrd setups.

Add a soft dependency on crc32c so that mkinitrd, dracut, and other
initrd image generators could include the required helper module.

The dependency on crc32c is quite hard but there seems to be no
mechanism to specify a dependency on an alias, so let's use this
soft dependency as a workaround.

Suggested-by: Alexey Gladkov <legion@altlinux.org>
Fixes: a45403b51582 ("ext4: always initialize the crc32c checksum driver")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
---
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 185f7e6..eb104e8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5886,5 +5886,6 @@ static void __exit ext4_exit_fs(void)
 MODULE_AUTHOR("Remy Card, Stephen Tweedie, Andrew Morton, Andreas Dilger, Theodore Ts'o and others");
 MODULE_DESCRIPTION("Fourth Extended Filesystem");
 MODULE_LICENSE("GPL");
+MODULE_SOFTDEP("pre: crc32c");
 module_init(ext4_init_fs)
 module_exit(ext4_exit_fs)

-- 
ldv
