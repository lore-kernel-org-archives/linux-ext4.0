From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 1/2] jbd/jbd2: validate sb->s_first in journal_get_superblock()
Date: Tue,  1 Nov 2011 10:05:03 +0800
Message-ID: <1320113103-27406-1-git-send-email-guaneryu@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>, Jan Kara <jack@suse.cz>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54420 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab1KACFp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Oct 2011 22:05:45 -0400
Received: by vws1 with SMTP id 1so5422570vws.19
        for <linux-ext4@vger.kernel.org>; Mon, 31 Oct 2011 19:05:44 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I hit a J_ASSERT(blocknr != 0) failure in cleanup_journal_tail() when
mounting a fsfuzzed ext3 image. It turns out that the corrupted ext3
image has s_first = 0 in journal superblock, and the 0 is passed to
journal->j_head in journal_reset(), then to blocknr in
cleanup_journal_tail(), in the end the J_ASSERT failed.

So validate s_first after reading journal superblock from disk in
journal_get_superblock() to ensure s_first is valid.

The following script could reproduce it:

fstype=ext3
blocksize=1024
img=$fstype.img
offset=0
found=0
magic="c0 3b 39 98"

dd if=/dev/zero of=$img bs=1M count=8
mkfs -t $fstype -b $blocksize -F $img
filesize=`stat -c %s $img`
while [ $offset -lt $filesize ]
do
        if od -j $offset -N 4 -t x1 $img | grep -i "$magic";then
                echo "Found journal: $offset"
                found=1
                break
        fi
        offset=`echo "$offset+$blocksize" | bc`
done

if [ $found -ne 1 ];then
        echo "Magic \"$magic\" not found"
        exit 1
fi

dd if=/dev/zero of=$img seek=$(($offset+23)) conv=notrunc bs=1 count=1

mkdir -p ./mnt
mount -o loop $img ./mnt

Cc: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 fs/jbd/journal.c  |    8 ++++++++
 fs/jbd2/journal.c |    8 ++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 9fe061f..0c401de 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -1135,6 +1135,14 @@ static int journal_get_superblock(journal_t *journal)
 		goto out;
 	}
 
+	if (be32_to_cpu(sb->s_first) == 0 ||
+		be32_to_cpu(sb->s_first) >= journal->j_maxlen) {
+		printk(KERN_WARNING
+			"JBD: Invalid start block of journal: %u\n",
+			be32_to_cpu(sb->s_first));
+		goto out;
+	}
+
 	return 0;
 
 out:
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index f24df13..e2d0e13 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1251,6 +1251,14 @@ static int journal_get_superblock(journal_t *journal)
 		goto out;
 	}
 
+	if (be32_to_cpu(sb->s_first) == 0 ||
+		be32_to_cpu(sb->s_first) >= journal->j_maxlen) {
+		printk(KERN_WARNING
+			"JBD2: Invalid start block of journal: %u\n",
+			be32_to_cpu(sb->s_first));
+		goto out;
+	}
+
 	return 0;
 
 out:
-- 
1.7.7.1

