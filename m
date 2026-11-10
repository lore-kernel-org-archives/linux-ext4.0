Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794295704;
	b=jfao4CTT78/zTnlmN5heGtM+dVtwgeS8AMjbQ597jcdIJcLq066SbXHj7ovXX05bicnM
	 2jZukTWnXrbQyIo51L9sJFz9Q7/tCHf6tTveLCKuKbFplJDQZHIKgbwo3tTYZ88w/5A0k
	 GeVV/LChXmwOCdrODfd1RZZ/+Ne1U8lJZTbj9WGhybbO9bmeF2rhhoukv2Or/DQ1GCqJ+
	 MDzwGmlqNys0ZwETK8fAkoCz0Ex2LCYLr1cMKQnGDVh2afskD8g1sUoxsnaiMkkcE5bD1
	 in1XHTm36K3RoYBUPMWyRzYAviGWrx90/rqB6ZUtib7hcyETIYUryIY1m+TfGcxaUOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794295704;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Vk30BszvLUvZQJPLVx7j5492Hw84BFg36On09QYj8+0=;
	b=vZT2dTnx23ql/yNaatUARN/P8DIUQf/RrrEZNTPOeCt/tFHS4ycSzMaDnMEBcMKejpca
	 ZS19XYWJjRlCnVwikvK+vSGSvDnF/JUng7r/pu4OngCSmhzMsNUdeK9sZi62UYuDL305B
	 K6tZbCKM+NEuEJ1DDuuQNF/j2O9q0F4LgvstpPpEoo0uTmGbEtN3KLGP2twZfe6OOd7yf
	 BzQA2GcKm8oJHhMRspUKJWnM32/HU5XNvyVyIfVP1k3OqmJ1Ltd5amZFXxHst1ucYIMFj
	 RHuXA5fzg35Rg2Ftwuj/JO/37dXXm+fNSxdPXgCRlPxK+xybBjC6pRfFTJ8k5PodSjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b="Mn5un6P/";
	arc=none smtp.remote-ip=203.205.221.209
Received: from out203-205-221-209.mail.qq.com (out203-205-221-209.mail.qq.com [203.205.221.209])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6F7606A33C;
	Tue, 10 Nov 2026 07:28:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD6F7606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=Mn5un6P/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1794295695; bh=Vk30BszvLUvZQJPLVx7j5492Hw84BFg36On09QYj8+0=;
	h=From:To:Cc:Subject:Date;
	b=Mn5un6P/5HVtiJgXYmFaBNp58tH1AhAg12BEvpWJv9VOZTaeq7NL6+2NPCmlX7Wwj
	 l6BwE/azySih3xRSmMsKPbmMsJ3qKE+5P5EkNQ5Zg+Ei7XvN9Y4jIMEcXhQ0tEiyJv
	 yyKT87FacandmrLXdnsuWVdJFOVE5sKmM/VH9BXM=
Received: from ikun ([221.176.157.250])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 70486608; Tue, 10 Nov 2026 15:28:04 +0800
X-QQ-mid: xmsmtpt1794295684t6um2b4rz
Message-ID: <tencent_9EB8EBE910378E46C80E006C6A7DA918BA08@qq.com>
X-QQ-XMAILINFO: MRMtjO3A6C9X4fnIIPYZ1r3ekLU3NqbruqAiolIMcy7IyE5drRcj6ZxomTOTq1
	 J4l+uUm3ZB4Fll4as9Dj+cOXv50XyLgfq/r1wEtOsx+L5WtS1TEkUkPGW7UYMSB5xmGodr2DYbpG
	 btnDR1ee6dUEKP9W5LPMEGKXoWs+NuJpgLvi6bhM/OnDAjIVWowvtbJtM4FL7ENkXl9UrkbgrlgK
	 o87wlczlLaqsVdtPswlXR4Mx1HdRGnTfNe7N4Iq3uVgLWTPYwgFn0dYAcOKgK8V5Uzl/441SpOWn
	 QClZwrc6dVncUG5U/1lf4w768ngYhKO8Pa1w6bkRHvs/0g6OTEJ9DpMeOhgv/qrJuoZ+L1Tv2f7m
	 /D399dsJEp2SZ2BGgUyxFW4Sd31HonaiHdHzMWE6e/K3Y6Z9m1eDJTkt7v/q8FoA638xkj4/Q6dA
	 ov12ZJKnzkDvoJOgpLPF3OzALewlQ7jRVVFXbc7fAI1oYGgM+HSXypY7mpYKcCETMnLKCm1Fmlbg
	 AnF3iIaPARO2mi9PVkYLZvTIAUNJao7AuW9fk2vEZ8oJ6IwBCeSS1Pi+tFFFgSMLcCEzuin+P1+g
	 jPPy8npgjyj8WVXoniVYqY0CGo6teWxmfI7O9ZGo4FxMWtOwKMkho+pCjC7d97HJMduCoGjBjfwn
	 wVPyRIWuDDWAgKRsufuoES6pB+4J8Sw0Ycys9T1m/aysguYtBSvWPwyJ8A+SQGB4E/fYGrrI101P
	 4Qze55Zw7GlCcpkSfeqjgahzUx62ASmYGXv71NNlcPKY31E+WpZaqPWtBoZU3BJZlvCaldOkz++/
	 W7uTE6ryApF1FYGOEKHgLbBzAPP3rdI+lClgrn37KqNUXcFqPseJvqvzNyn5EX+lds183/IRvfmI
	 joCzAupG54TsMzTDty54prs1tPOzpIAD/E6qXruGzVFXpYmpMnHeMon8PxjvHqSuVDCphEhXbs1y
	 sdkS3gEwrL5k+BzdLwKqzkF+CV06FVugX3TI+DHFcXJ7wBU+nxBwT/jUStnW7zkVq7hYkXdzaW9T
	 7VUFzC2uoQkEA/aEVrVIR6+rWdojxuQJDfMzZMe24GDRaWN8XMeKjctb+Mgogj5/ZfhNpjNKba8d
	 crvK/etK8/u1y485k=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
From: Alan <3164729207@qq.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Alan <3164729207@qq.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] ext4: free the new extent block when getting its buffer fails
Date: Tue, 10 Nov 2026 15:27:23 +0800
X-OQ-MSGID: <20261110072757.86156-1-3164729207@qq.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_ext_grow_indepth() allocates and accounts a metadata block before
calling sb_getblk_gfp(). If the buffer allocation fails, the new block
has not been linked into the extent tree, but the error path returns
without freeing it. This leaks the block and leaves i_blocks larger
than the number of blocks reachable from the inode.

Commit 8a83ac54940d ("ext4: call bdev_getblk() from sb_getblk_gfp()")
removed the implicit __GFP_NOFAIL from this allocation, making this
error path reachable.

Free the new metadata block before returning -ENOMEM. Use
ext4_free_blocks() to undo both the allocation and inode accounting.

Tested on Linux 6.12.1 by injecting a NULL result at the caller's buffer
acquisition boundary. Before the fix, seven failed extent tree growth
operations left seven allocated but unreachable blocks and i_blocks of
40 instead of 32 on a filesystem with 4 KiB blocks. After the fix, the
same failures leave i_blocks at 32, and e2fsck -fn passes after a normal
unmount. Retrying the operation, truncating the file, and growing the
tree without injection also succeed.

Fixes: 8a83ac54940d ("ext4: call bdev_getblk() from sb_getblk_gfp()")
Cc: stable@vger.kernel.org
Signed-off-by: Alan <3164729207@qq.com>
---
 fs/ext4/extents.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ad0d80e33f6090..7358df54bcd4ae 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1333,8 +1333,12 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 		return err;
 
 	bh = sb_getblk_gfp(inode->i_sb, newblock, __GFP_MOVABLE | GFP_NOFS);
-	if (unlikely(!bh))
+	if (unlikely(!bh)) {
+		/* The new block has not been linked into the extent tree yet. */
+		ext4_free_blocks(handle, inode, NULL, newblock, 1,
+				 EXT4_FREE_BLOCKS_METADATA);
 		return -ENOMEM;
+	}
 	lock_buffer(bh);
 
 	err = ext4_journal_get_create_access(handle, inode->i_sb, bh,

base-commit: d135ab453a7400a34930bdda1ef4bdc8acfac80e
-- 
2.53.0

