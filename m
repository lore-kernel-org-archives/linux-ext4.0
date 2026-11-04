Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.58.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782049;
	b=lNqgwLnCw5ffL1R2h75E0O8ZABhzAgM3nbAiYh4sI04RliQuzRPganERI1lCpPeoe/+n
	 nlKVQgJ4yuKEMWKB/KAX+QkSpDqqkCX8q02lm3S7Rin3GRZuAkqr54Jim8CVNXu9y6K5i
	 rUoqKFXS4Of0U+Qz4+eY2ytpg/DOq7NekKS58/ghF9qZq1HAacgqbmrZQPqVCQENW4pmV
	 R2pq2lhG1L9EsI1C1PS9O+2sAYv7FkeJerXPo1/8P8Ve0efaBQYm0Frtywy+x/Yr/d4T5
	 BD5eN1U+MznLIidhDM+7o3BFizajllf9h8c3aAMfIHJcao9hf26wfZ9l4TdgclSH2+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782049;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SikW6QyWShPPm+9vJqKGpIuLHnANOtAHXWhBfwLtRyU=;
	b=ZT3GL+7PqVkc/0uyCvZ3IY/H2rPBje/4W0FCxAWWLAVKsARfj+PGbJXd35qXInJImEae
	 PpnzW/XIQmxiT5B/ahEPGP97fPY1wuqOJeh1sngxEuXAovMaeA3zVSP2XRqefiTNJCa15
	 1MBGTIw4M36arik8Y0VsPCXJIOQ5jDw5McxeC7onR0upd4+osqp2FpV6INqw+f0Ci6wCb
	 QL/6ycxnbrO0CCfv75sFe4PgzHDlh2ur5NERVIWFIKVhKz+h97d463nO0bSN5DzmVSSt9
	 hsHLjvUjvoPNec/51JzSmWdKJX2/P7tkktVHIy96Z8XoV79ETFdoa5sp6BNPsebDiPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=MXtkShpX;
	arc=none smtp.remote-ip=162.62.58.211
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F97606A326;
	Wed,  4 Nov 2026 08:47:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08F97606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=MXtkShpX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1793782042; bh=SikW6QyWShPPm+9vJqKGpIuLHnANOtAHXWhBfwLtRyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MXtkShpXNPHRNF9GbVB0vGh2mkdgIJkWaGYuyTrjNM5G1f2fA0NcG++7VggvNzuDD
	 24Oocehg2T0UvdTXKJ7iKQpJ/XFj7VS3fY2aPygzwpnYDrYJCh2iWZQnrbRuIgC7DR
	 uUmuWDcar8Nk1HrZsrn64YqLTylXAc4IsJFH4S0c=
Received: from shuai-VMware-Virtual-Platform.. ([218.28.192.28])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id BD38AA11; Wed, 04 Nov 2026 16:47:19 +0800
X-QQ-mid: xmsmtpt1793782039t1bbnb9rz
Message-ID: <tencent_7AA5D3581EE4D99A947097C4F02730DCCF09@qq.com>
X-QQ-XMAILINFO: MhLcXbI0hPoHPaMb0xENbO95KO7fvhYaPi13zOgmgRW4/bAl3c3/yP6732NiKY
	 fodR/3UumoR4uAJ4hURhxvAo0QEkH8ztoePnPhXPHYtC0+6/l1jLMgfL7sRdrGf50VjTZihPphGh
	 gaGTBhg3/sTKj/5stiqUFbQ6AFr3AGTFyLlHZNUdGtxhIp5l6gf40BvfntvhfFwM3OVsaHhYk763
	 Cutmi2ur43rGlUfxF5ajPdea7l5fWXENLYdrbPzBqpn60Ca/uWiUvxpp6b+LOioCJXA8ee7xU5IY
	 NkxtC/c9XXtTUScnIBboZXDEgdAyY1xfsw8DfcRYIG33Ei9QlIndNJakroXYbdMziKEdvg/Za+WY
	 6TAprsoBd7a0Yd5jMxpj68HzqgkHGCEsXoWZV5gf+GA2hwfFFtBGS+tYD4WqqLfIvPEEFr6MG7Pm
	 K5S0AzjO7RElh41vAQQkHp5YFDLp7dG64b6A87RoP/M/E2h6mQRsEBKQidiBUVMxGt3C7jRlXHgR
	 3IxuOrxijxAVc2I6Ql21I3qoSyr57UPUsCVIiak6Xy10W+WNQ0ppTyZoukbhf6rnVS+6OthxQRDj
	 F5QJrjBMh8tGBUV0k0Z9xuMZ9oz/R9IGheDSDu/kT8RmRgAL4xKHH8VigI9rE/j77OHrCbFvBFnN
	 JwDJ3HeO/gEUeY6az1wVfYR+McRqJhvu02KdapE2n6+Vke3Eq6lqsnAWpJrZ2g77gJs8uZ7QCHIT
	 VBZDXIhqKNIk56dbZGmQLYQ+8HOBYAZEaaIZ2iIADcoMP0JlYX1KsZmuOHcW8ROpKU7odRhZzvn0
	 3hf3lInTgCY37bjOwOYW8ZtgugTwkUBn/mS1v8YgctCDYRg1LUhu/HVmLc7/sQ78nLxLcyNBxdIW
	 TNFegfrOtYSetceZtVCXcX+bnEBFkXC0kGivYHRP5E1OHZYxYlchsGv6pkPlWZ1369sB7wjNFKfc
	 ODjJtS86tS5iJJaDztuviNXcMq8lj6P3soQslyMxwMmLFfaMnaoQppib46JMJ93af0UT1NhKGD6f
	 63bVR94rRJyKCu33xvD3CfD+g8kdm01/v6Ugw7ubfHNQJe0oQPq/ljf7R07sfe7vkwo160pqK7UH
	 Tirypes5wypdUs0/PWWtHnyss0d1leITQvoFAGnByV9YrJWQcDbFspTSBp6g==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
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
	sashiko-bot@kernel.org,
	Shuai Liu <847807867@qq.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] ext4: fix slab-use-after-free in do_split()
Date: Wed,  4 Nov 2026 16:47:19 +0800
X-OQ-MSGID: <20261104084719.715372-1-847807867@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-196874@kernel.org>
References: <sashiko-outbox-196874@kernel.org>
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

Changes in v2:
  - Release both buffer_head references when bh2 aliases *bh to avoid
    leaking one reference (Sashiko)
  - Pass the physical block number instead of the logical block number
    to ext4_error_inode_block() (Sashiko)
  - Pass a positive errno to ext4_error_inode_block(), as is the
    convention (Sashiko)

 fs/ext4/namei.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 354fc2d22df1..c664ae84320a 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1928,6 +1928,14 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 		*bh = NULL;
 		return ERR_CAST(bh2);
 	}
+	if (bh2 == *bh) {
+		ext4_error_inode_block(dir, (*bh)->b_blocknr, EFSCORRUPTED,
+				       "cannot split aliased directory block");
+		brelse(bh2);
+		brelse(*bh);
+		*bh = NULL;
+		return ERR_PTR(-EFSCORRUPTED);
+	}
 
 	BUFFER_TRACE(*bh, "get_write_access");
 	err = ext4_journal_get_write_access(handle, dir->i_sb, *bh,
-- 
2.43.0

