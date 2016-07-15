From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: kernel BUG at fs/ext4/inode.c:3709! (Re: open bugs found by fuzzing)
Date: Fri, 15 Jul 2016 15:39:19 +0200
Message-ID: <5788E787.106@oracle.com>
References: <5787FFBA.70406@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ildar Muslukhov <ildarm@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-ext4@vger.kernel.org, Michael Halcrow <mhalcrow@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37441 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbcGONj1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Jul 2016 09:39:27 -0400
In-Reply-To: <5787FFBA.70406@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/14/2016 11:10 PM, Vegard Nossum wrote:
> 3. kernel BUG at fs/ext4/inode.c:3709!
> http://139.162.151.198/f/ext4/5bdefda69f39b2f2c56d9b67d5b7d9e2cc8dfd5f

I don't see any evidence of memory corruption here, so this one seems
pretty straightforward: we have an encrypted orphan inode and when we
try to truncate it during the orphan list cleanup it results in a BUG
because we haven't loaded the encryption key for it.

The inode in question has ->i_ino == 16 so I don't think this has
anything to do with special inodes.

Something quick and dirty like this does solve the BUG_ON() for me, but
it looks a lot like papering over an underlying bug:

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5a6277d..794b33a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3735,9 +3735,11 @@ static int __ext4_block_zero_page_range(handle_t 
*handle,
  		if (S_ISREG(inode->i_mode) &&
  		    ext4_encrypted_inode(inode)) {
  			/* We expect the key to be set. */
-			BUG_ON(!fscrypt_has_encryption_key(inode));
-			BUG_ON(blocksize != PAGE_SIZE);
-			WARN_ON_ONCE(fscrypt_decrypt_page(page));
+		        if (list_empty(&EXT4_I(inode)->i_orphan)) {
+				BUG_ON(!fscrypt_has_encryption_key(inode));
+				BUG_ON(blocksize != PAGE_SIZE);
+				WARN_ON_ONCE(fscrypt_decrypt_page(page));
+			}
  		}
  	}
  	if (ext4_should_journal_data(inode)) {

I'm a bit puzzled that we're actually creating a mapping and trying to
decrypt here in the first place, since if this is an orphan inode that
is being recovered at mount time it means that we know _for sure_ that
there is no existing memory mappings and we're truncating it to 0.

Anyway, adding some Ccs.


Vegard
