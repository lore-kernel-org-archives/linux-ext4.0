From: Chao Yu <chao2.yu@samsung.com>
Subject: [PATCH 2/2] ext4 crypto: fix incorrect release for crypto ctx
Date: Fri, 29 May 2015 10:58:09 +0800
Message-ID: <002901d099bb$656709d0$30351d70$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, mhalcrow@google.com, jaegeuk@kernel.org
To: 'Ext4 Developers List' <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:8702 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbbE2C6z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 May 2015 22:58:55 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NP30081XCA5E470@mailout4.samsung.com> for
 linux-ext4@vger.kernel.org; Fri, 29 May 2015 11:58:53 +0900 (KST)
Content-language: zh-cn
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When ext4 encryption feature is enable, and our crypto resource
was allocated, then if we rmmod ext4 module, we will receive a
stack backtrace reported in syslog:

BUG: Bad page state in process rmmod  pfn:8c3e1
page:f0b77c3c count:0 mapcount:129 mapping:cdafb6e4 index:0x20
flags: 0xee4fc324(referenced|lru|owner_priv_1|arch_1|head|tail|swapcache|mappedtodisk|reclaim|swapbacked|uncached)
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
bad because of flags:
flags: 0x10020(lru|swapcache)
Modules linked in: xts gf128mul ext4m(O-) cts fuse bnep rfcomm bluetooth dm_crypt binfmt_misc snd_intel8x0 snd_ac97_codec ac97_bus
snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device psmouse snd joydev serio_raw soundcore
i2c_piix4 hid_generic ppdev mac_hid parport_pc lp parport ext4 jbd2 mbcache usbhid hid e1000 [last unloaded: ext4m]
CPU: 0 PID: 8388 Comm: rmmod Tainted: G    B      O    4.1.0-rc3+ #10
Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
00000000 00000000 c9aebeb4 c15b7518 f0b77c3c c9aebed8 c112e0b7 c1779174
ef6d2d34 0008c3e1 01b13ce1 c17791a4 f0b77c3c ee4fc324 c9aebef8 c112e3c3
00000000 f0b77c3c c9aebf0c f0b77c3c ee4fc324 ef9f0000 c9aebf20 c112fdf8
Call Trace:
[<c15b7518>] dump_stack+0x41/0x52
[<c112e0b7>] bad_page.part.72+0xa7/0x100
[<c112e3c3>] free_pages_prepare+0x213/0x220
[<c112fdf8>] free_hot_cold_page+0x28/0x120
[<c116e367>] ? kfree+0xe7/0x110
[<c1146697>] ? kzfree+0x27/0x30
[<c112ff15>] __free_pages+0x25/0x30
[<c112c4fd>] mempool_free_pages+0xd/0x10
[<c112c5f1>] mempool_free+0x31/0x90
[<f0b611ff>] ext4_exit_crypto+0x6f/0xf0 [ext4m]
[<f0b62d7c>] ext4_exit_fs+0x8/0x28c [ext4m]
[<c10c30e0>] SyS_delete_module+0x130/0x180
[<c11556d6>] ? vm_munmap+0x46/0x60
[<c15bd888>] sysenter_do_call+0x12/0x12

The reason is that:

since commit 66de766a0f11
("ext4 crypto: shrink size of the ext4_crypto_ctx structure") is merged,
some fields in ext4_crypto_ctx structure are merged into a union as they
will never be used simultaneously in write path, read path or on free list.

In ext4_exit_crypto, we traverse each crypto ctx from free list, in this
moment, our free_list field in union is valid, but still we will try to
release memory space which is pointed by other invalid field in union
structure for each ctx.

Then the error occurs, let's fix it with this patch.

The same issue in f2fs was found and fixed in this commit 7b85832d3a64
("f2fs crypto: fix incorrect release for crypto ctx"), this patch does
the porting work.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/ext4/crypto.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index ce3e85f..db8b926 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -153,18 +153,8 @@ void ext4_exit_crypto(void)
 {
 	struct ext4_crypto_ctx *pos, *n;
 
-	list_for_each_entry_safe(pos, n, &ext4_free_crypto_ctxs, free_list) {
-		if (pos->w.bounce_page) {
-			if (pos->flags &
-			    EXT4_BOUNCE_PAGE_REQUIRES_FREE_ENCRYPT_FL) {
-				__free_page(pos->w.bounce_page);
-			} else {
-				mempool_free(pos->w.bounce_page,
-					     ext4_bounce_page_pool);
-			}
-		}
+	list_for_each_entry_safe(pos, n, &ext4_free_crypto_ctxs, free_list)
 		kmem_cache_free(ext4_crypto_ctx_cachep, pos);
-	}
 	INIT_LIST_HEAD(&ext4_free_crypto_ctxs);
 	if (ext4_bounce_page_pool)
 		mempool_destroy(ext4_bounce_page_pool);
-- 
2.3.3


