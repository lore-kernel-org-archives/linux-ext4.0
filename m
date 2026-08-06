Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C0548CD77
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 17:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035613; cv=none; b=qTmnKQ4XBVH0Kt39kOt8nC7ddYmFOyTrgUUlT3ICQL4uC5KdRFjiJCRJsglhMoMQ3yjaa+k5ArSXxh+yP9vIxjUruCcMZcvdfc38Ornn1bKsUZZa0n5RNI18nbvUzFDsJaaWlpDqCUmcRX4OWx7DSVLu6ay4/JBcxt9/dPs1WzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035613; c=relaxed/simple;
	bh=PQ2ah5ZVupMR/HGE9t8COOvVi4Hx2BdC9HNHr4xKmRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEsREVWXImmmCLs3sG51Xv8U8hDpIaCMxOtyes9CCNwtHWj9R0uxm/6ob8OTkJmZucIWa1ZXnZGJMovWZe9NXXSL6mDbMmkANyoE1PHT33EL+gvGMHMnZI+YrsDKlLeWVgiwZ851h9oL9GdCXhMJvMcqkOKSNh239jV4jJGyytU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ClOez0iu; arc=none smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ClOez0iu"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5c276bfce7eso1727095e0c.2
        for <linux-ext4@vger.kernel.org>; Thu, 06 Aug 2026 10:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035610; x=1786640410; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aY+Eq3Vzt7bW6hh+0BwKtYH0EUlmb7bdAzVAsm/0VMk=;
        b=ClOez0iufuTQUr/mpy5VSpP51GEZvuHiLydAzYKpFIdMA+iPX31rVu9GYF+buyykIi
         JFHFR7GHCzFLfdsLVRmoC2gBVt0NOoNW6ovPydzBENEZ7AkWIJQGj+uwqUPYtFiKV4la
         eA6qrp+UaI6f90h6IOpmiXXTYa/O3CiAbawG/gIObQrwdRdcWY3AvhUrLoxQk4Y6tykz
         uAPwpNZHJxyvlaBYLQHyH/G0/D5EtNkCij63xSUDkSU8mekZ5ago6oTVIBOq9ROuJ/7t
         9oQwW0/j4FetFM/7oQNdQPCWxWq+/LRtlyNvUwtpmlJzA4hH/SMrHje8/YAWVw6+Pf6c
         zKFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035610; x=1786640410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aY+Eq3Vzt7bW6hh+0BwKtYH0EUlmb7bdAzVAsm/0VMk=;
        b=Trvs8azk0zyqr2+C1FknfY0+za9NgSnrTlANBTRTlzFXO9Bo1ZEqsW/a7gF6EfB6bl
         qT8n+D9rCXC1mI7C43AEPK3Cje/Nezq3jNu/xNFknZf+1u8CpxXr+ormp3zcY5M0+JGA
         K7L3TwbZa4l/IR/mbROSAbURZq5p4gpZl6M3nUPD2GzghylnzZX/0j9a1cmx1GoeFjZX
         22DN8VmVEOsvgyZxo99U6mUkWNI4uMVJlv7Su72bk+dKNDQzqRVSvXzE04IVEkQxJJvp
         xx1flCUxhjpPnnGg4DOhGV9J+z0K5RoiMy6uvaM8Jdt+43hw3AETZjhbTfH6avUgZoG1
         IXGg==
X-Forwarded-Encrypted: i=1; AHgh+RqGEmvanqLirzy1iq+dWSuYlrrTH7rh2gBHrwMkYSoI7nqa8I6dl+7m+8rTTFq/OB3yuntTYS9Qzil/@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8tYVhjBSM1kdEvxAzS/xEfnBt6BnbjJ/4iVyMRXM/o6sDw1Hs
	Jghz/9AaX1HTg2r4sy48JZGBKyTUc4t+E9KVIdtzRSjE5lRcegMVLzAZ
X-Gm-Gg: AR+sD11a2jYX6Mzeq8nQ4e1UTE6Blu3QxVNXTQxtZNt4DnVTuBiZzHkc1o0JZANAetC
	n5Rr6eX52XtE338Qqn35Y5Y/pYgUJ6FcGwQDs4idLeIxQzRzAZvstxDLF5IDngWUG3IR4EcufUn
	6LcEvWhT39K30NTkq7Gas/3nUhJzC+eYEtXnOyTmEUHoxBYCoCcqVylyn/OTxso57iWdF4fTqQj
	mXvj5FjAEQ9tM/4dOLOcr0DjlJBn/l0tsYxLJJBcSVLKNbRWHNYtau4XIoawIpJ/VNWzdMFTmo7
	Ct7ZqcBQUYpE/tfCRet+QwjwHs5O8O8COZK4XSyARd6ospePiAAArVZuultpbctpVBtctqpgV8o
	6ZMzh/frJtwBRyeAA2kyqih4TxV/97GO9BjFoQ7gA/aptH5Z/DlmYUVHp+Tbi0pf/E8j/xWxDm+
	Fvc1YBWw/Kv/sQrXHeKhVKKyA0gnQFpHEuLzjADeUmAwB/Aw3sqCS5wTn82T5K/G9bpqp8YOVMc
	MKAtgo=
X-Received: by 2002:a05:6122:d06:b0:5bb:d233:70bd with SMTP id 71dfb90a1353d-5c3d9068e60mr2530050e0c.2.1786035610452;
        Thu, 06 Aug 2026 10:00:10 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.10.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 10:00:09 -0700 (PDT)
From: Chao Shi <coshi036@gmail.com>
To: Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Bob Copeland <me@bobcopeland.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>,
	Weidong Zhu <weizhu@fiu.edu>
Subject: [PATCH v2 20/21] buffer: stop touching BH_Uptodate on write completion
Date: Thu,  6 Aug 2026 12:58:43 -0400
Message-ID: <61d7d5737f5773f53ee543f375fcde81aa8d28c2.1785951556.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785951556.git.coshi036@gmail.com>
References: <cover.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A buffer whose write failed still holds exactly the data the filesystem
asked to be written.  It is the disk that is out of date, not the buffer.
Clearing BH_Uptodate says the opposite, and callers act on it:

 - mark_buffer_dirty() has a WARN_ON_ONCE(!buffer_uptodate(bh)).  A
   filesystem that dirties the buffer again after a failed write - which is
   the normal way to retry - trips it.  That is the warning this series
   started from.

 - a buffer that is not up to date gets re-read from disk, which replaces
   the data the filesystem was trying to write with the stale on-disk copy,
   silently.

 - the window between the write completing and the buffer being marked not
   up to date is visible to anyone holding the folio lock, so the state is
   not even self consistent while it lasts.

BH_Write_EIO already records the failure, and by now every place in the
tree that needs to know about it tests that flag instead: the two core
helpers in this file, adfs, exfat, ext2, ext4, fat, gfs2, jbd2, ocfs2 and
omfs, converted one filesystem at a time in the preceding patches.  The
private completion handlers in jbd2 and ext4 fast commit were converted
along with their waiters.  Nothing is left that reads BH_Uptodate to find
out whether a write failed.

Setting BH_Uptodate on success goes too.  A buffer has to be up to date
before it can be written - you cannot write out data you do not have - so
the only thing that assignment could do is paper over a caller that got
that wrong.  Write completion now leaves BH_Uptodate alone in both
directions.

What this changes for readers.  A buffer whose write failed stays up to
date, so the read paths stop replacing it with the on-disk copy:
__bread_gfp() no longer sends it to __bread_slow(), and
bh_uptodate_or_lock() reports it as usable.  That is the intent.  ocfs2
changes the most, because ocfs2_read_blocks() decides whether to go to disk
on its own cluster uptodate cache and only tests BH_Uptodate after the
wait, so a block whose write failed makes that read return -EIO today and
from here it succeeds and hands back the in-memory data.  A caller that
needs to know the write failed asks BH_Write_EIO.

Found by FuzzNvme.

Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/buffer.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index aebf74abbc49..425fbfe72ad1 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -202,12 +202,9 @@ void bh_end_write(struct bio *bio)
 	struct buffer_head *bh;
 	bool success = bio_endio_bh(bio, &bh);
 
-	if (success) {
-		set_buffer_uptodate(bh);
-	} else {
+	if (!success) {
 		buffer_io_error(bh, ", lost sync page write");
 		mark_buffer_write_io_error(bh);
-		clear_buffer_uptodate(bh);
 	}
 	unlock_buffer(bh);
 }
@@ -436,12 +433,9 @@ void bh_end_async_write(struct bio *bio)
 	BUG_ON(!buffer_async_write(bh));
 
 	folio = bh->b_folio;
-	if (success) {
-		set_buffer_uptodate(bh);
-	} else {
+	if (!success) {
 		buffer_io_error(bh, ", lost async page write");
 		mark_buffer_write_io_error(bh);
-		clear_buffer_uptodate(bh);
 	}
 
 	first = folio_buffers(folio);
-- 
2.43.0

