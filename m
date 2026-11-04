Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.221
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793779983;
	b=DbdF+ugc0xeRGkyWw/l5lCE24/1+DKYd/78I3FLstHUcPPVCSjbKTcVk99N/nc8GFKbv
	 PQRvlcgg2nBuSZ8k4ko67VROEeLylB6XH0hGijq1IoMFleoSVUxLitnVbVVYRCO+lRBEb
	 ghMidFR+I3GPNL+fj2mCMXtNU7lEqoFmW9kf8OkpQXIfyhj/3TWwaYcyP5sa1503EUAsI
	 7DOcOhYrNelFF71ucj5IsrvazU6YlhjSXBHm8oVVn0F+f98jxWuYZMgZjWsyFqfqAsTsv
	 y6079Nq7IC511/84hJsIU3dQbRlO1oiesNJ+zzqyotK5D9gbm7ZPTiclorWqeHgqEpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793779983;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=S/YVX51d+YFgjFTpFmGYpWUbOdKLDllTGQah6OFPrpo=;
	b=LhS14Qdx6XOTF2M+/zFgtmPwzGhzGmM2wahfOltLkrcb9QJi0yzGiQcv+wROQyRzW/fI
	 4NteQTkoSIxaWOOTq2dMh+WdNKUeHXMSYDx+OvtG8R732BjsRsp6t+8hKmGZC7nCJxJ3V
	 ngL4MGWM6BHs0eAGbMW7O3zThzP22Y6G0pzjcDGQsI38D/6WXWG6cKxliXh/F7Ni9uGXS
	 QGhO/caUipPnYsi7m7/7MPXeo0Eb+Zhh+QcE473DajZtLZerIa9uH561caseJeeZs1YGx
	 6BsMqhhUwTxRp8P5edwTzVjQeiwM1WyfX8Aq9QXU47HJjXdwICEic5WkIBBN0jXrX1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=TPenK9bW;
	arc=none smtp.remote-ip=203.205.221.221
Received: from out203-205-221-221.mail.qq.com (out203-205-221-221.mail.qq.com [203.205.221.221])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B385B606A331;
	Wed,  4 Nov 2026 08:13:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B385B606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=TPenK9bW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1793779973; bh=S/YVX51d+YFgjFTpFmGYpWUbOdKLDllTGQah6OFPrpo=;
	h=From:To:Cc:Subject:Date;
	b=TPenK9bWMOIf1KC+d1po0I/fMTgIqocugscB0JUDPGac3meIFfHvDhpRmjj0ctMT1
	 c7OfLGA/jqK3xVYCfVErnBm5XVtRA/Ae7CevWOGRuPbNdDVPpGDxCjK0TDahdLL1+S
	 26t59iVCAtmnS2NUVih7v+a0Ki8DdpHmBRXbgZz8=
Received: from shuai-VMware-Virtual-Platform.. ([218.28.192.28])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 3272383A; Wed, 04 Nov 2026 16:12:39 +0800
X-QQ-mid: xmsmtpt1793779959td668sw7l
Message-ID: <tencent_76448BFB81B402CBBF3C529331EEA998FA06@qq.com>
X-QQ-XMAILINFO: MipYEBg1qKqIq0wuplufvRhP1JDQPijVv6mHXd6vajxUJE4MclRdcZAjoHIlmZ
	 r7FboEiFeIF4qH194IizylKO12853sP3U866z3B5XcGZ4NAaROmKeaHk8uKuuDk2HK89Uw8aW/g2
	 LnPvzklKMwDCBlHZt3vLHdmfDNh/vitIArdln0+LyoE25x+Ymwws5gTf0j8EtJ4y64Q8Oc/eySN1
	 DXos9IDRPE4KXuNgmfaCAacoU0ZAJ+pIVMYRfSW48c0Hy1qI20mskmRlfR5I0m8v4fR4bEJgLBDN
	 QQqNnzsF3Wr/k4/yJOpNZTHQvP4AVIn+mORDbOw7/vQy7DBuNtyyND2KfVn/44fjh1PXUHuxGnZG
	 NdVWsY66u5t0gIIawW1VFXA+UM9RHHZzdXtyIliYog4DE1X7G4PlBnRnwr6Hnk6/YoZOdiX9oy9N
	 Ryr4s417UnwEESy2mU78W1TtcJZd6/bdgCBTwzOm5BUijY4alBhocRe5Bg9yo5XPnThPHubxtv1v
	 mR4RPyafhDsaAlEvg0IIywrWNQsMaBRArKu1f36Oduzcg6r13z4jUhqvV0LYv225yc8j0wPPW574
	 RfUrjvvaHR8woESNrjH2ao9NUcp04k1F2wN66p0hHGocwmu9c2ZYmDs2Nbia6oxaB3oZ29SCVOUb
	 UyzrrwFswEvUXi9nSkwFHAj6iMjrfZQSZy5yovViTXQDnRUmJJAe7jKz/24MaUESEXGeJhgsYFDW
	 pquE0xXP1yuY2BbPhRFu0Xa9bsc7Hw8vDt04jGdEjlX0v8pOPak/OEjUP+PaYJqBxUIv0Wi4NDmb
	 pqUYoSoBtM4jY67GmMCMXDSnLxmD6Po/TQ1P1MFAJTNURhB2FkR5G8sMlW/Jpbluc+BBojwQgfYU
	 jVFY7Y2VzcLK5im0KRURCj2MTACpdY/m7zz9dKfI34rLbcUFqORmbNu7R+i5oGruoWpbmFTWy5p0
	 OxS9+BDbrdAEqJ4WcQoKmLtYx4tC5xjvuEefu/+o+Ge6f9WEQS74kSq5Y8utl0trPiS6cbNyQv1f
	 DaR8kOp5CG3+Z7gxAq1pAc+S70e9qnnvnhb7rq6OPuZ3oJK7pDsTVbGeAP8ABsAl/Em/OPzzGp3b
	 TsySaK
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: Shuai Liu <847807867@qq.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-kernel@vger.kernel.org,
	syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com,
	Shuai Liu <847807867@qq.com>,
	stable@vger.kernel.org
Subject: [PATCH] ext4: fix slab-use-after-free in do_split()
Date: Wed,  4 Nov 2026 16:12:37 +0800
X-OQ-MSGID: <20261104081237.704486-1-847807867@qq.com>
X-Mailer: git-send-email 2.43.0
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

do_split() allocates a new directory block with ext4_append() to hold
the second half of the entries of the leaf block being split, then
dx_move_dirents() copies entries from the old block (*bh) into the new
one (bh2).  Nothing verifies that the newly allocated block differs
from the block being split.

On a filesystem whose block bitmap is inconsistent with the directory
tree, a block already referenced as a directory leaf can still be
marked free, so ext4_append() can return that same block.  With
concurrent operations on such a filesystem (as exercised by the
syzbot reproducer), the block can even be freed between allocations,
resulting in bh2 aliasing *bh.  dx_move_dirents() then copies the
block onto itself, corrupting directory entries mid-copy: a rec_len
field can be overwritten with name bytes, so the subsequent wipe of
the stale entry memset()s a bogus length, causing the slab-use-
after-free reported by syzbot.

Fix this by checking for bh2 == *bh right after ext4_append() and
bailing out with -EFSCORRUPTED before any directory block contents
are modified, reporting the corruption via ext4_error_inode_block().

Reported-by: syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=09bec78ee77613a3efdd
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Shuai Liu <847807867@qq.com>
---
 fs/ext4/namei.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 354fc2d22df1..4ef7983d46c6 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1928,6 +1928,13 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 		*bh = NULL;
 		return ERR_CAST(bh2);
 	}
+	if (bh2 == *bh) {
+		ext4_error_inode_block(dir, newblock, -EFSCORRUPTED,
+				       "cannot split aliased directory block");
+		brelse(bh2);
+		*bh = NULL;
+		return ERR_PTR(-EFSCORRUPTED);
+	}
 
 	BUFFER_TRACE(*bh, "get_write_access");
 	err = ext4_journal_get_write_access(handle, dir->i_sb, *bh,
-- 
2.43.0

