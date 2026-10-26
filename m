Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793015967;
	b=gjbNw83fVcHqTIZkI6bPOuzG8zjpaiVpWwDJgChsKz2VOnnWneyObIOGPvhBhwgQnNQ5
	 FxKwXnKoQrLvc+DLLPNIjhNDksg197wxG9rq0On5KZpvwZxJCVBGined7Zim03/ZXmYxe
	 wi7GMFdLq/6Sdr0WtUKxmhiEkBKqCncvFBlQPiUj0kOffLusO9vxkqwZDEA9QUGpMTxjM
	 IVQ/Zq8xyw1kvy4noRW4VFYcnI8Z/KpHNKfL67eVySXvlsgowlsYdIVjZ8j5mVUS0IO7w
	 wMx5zWso01Lcguze87KggbNUNkeeeW26h9sG51afU7XLIJ2fbue8e1QQdZEXec8J1lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793015967;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=TRHdDmKmNUVrbT0gsKCdKpas6+uFfIkuvlQoHBJJ63Y=;
	b=vW7Mv43YVLdpakBrk9BIvcdi+SRJr5+KommMnlK4lbNr02cX7SqzUxpse0HPzsb61tjE
	 zllAWWRij25CFZuZTj96JLQq+HBYftc4UptRsKA1L0YgCUYWwdekiWeXpkdE2p4XnCsHJ
	 j3KGVJ8JWA8Gz+JMnpn6P6OA1FTQhSjdYkMbtQE0PZu7vJ4pfjHdIIrZ9CT9vemzuiar1
	 4q/hulYU24Y+FtkWOisjqxw3nJoH61FGekwx7MMPVu8Mlc+2wsw1angD+SQ4vsfoKU5pN
	 gIEojDuzgCroXegbM0OgFxhKssI9WpH1RF4tjorkbxZ9noGMcx4y/PYZMCqagj1bmPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.112
Received: from dggmsgout12.his.huawei.com (dggmsgout12.his.huawei.com [124.71.93.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54615606A324;
	Mon, 26 Oct 2026 11:59:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54615606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggmsgout12.his.huawei.com (SkyGuard) with ESMTP id 4jCsbt1KmZz1ybq;
	Mon, 26 Oct 2026 19:59:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0FBC54056B;
	Mon, 26 Oct 2026 19:59:16 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAnZvWLQN9q6RyfBw--.40032S6;
	Mon, 26 Oct 2026 19:59:15 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	chengzhihao1@huawei.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH 2/4] ext4: fix extent status cache clearing when truncating inline data
Date: Mon, 26 Oct 2026 19:51:29 +0800
Message-ID: <20261026115131.1735014-3-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261026115131.1735014-1-yi.zhang@huaweicloud.com>
References: <20261026115131.1735014-1-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAnZvWLQN9q6RyfBw--.40032S6
X-Coremail-Antispam: 1UD129KBjvJXoWxXF4UKF17GFyfKw18Xry7KFg_yoW5Ww4Upa
	9xCw4UGr1kW348WFZ7u3WjqF1Yga1fGr47uryagrnrWFy3CFyIgFs0krWjva4xKrWvvayj
	vFWYqr1DCa15JrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVj
	vjDU0xZFpf9x0JUQXo7UUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

ext4_inline_data_truncate() clears the whole extent status tree of the
inode when it truncates the inline data, with

	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);

It does that when the inode still carries inline data while the
EXT4_STATE_MAY_INLINE_DATA state bit is already cleared. This is the
case once an inline-to-extent conversion has been initiated, which is
triggered by a delalloc buffered write larger than the inline space in
ext4_da_convert_inline_data_to_extent().

The clear is meant to drop stale extent status entries of such an inode
to prevent stale extents and stale reserved space after the conversion,
but the range is too wide.  It also drops the entries of the blocks
below the new end of file, that is the blocks that stay in the file.

When writeback of these blocks starts later, the lookup of such a block
misses the extent status tree, falls back to the extent tree and caches
a hole entry for it.  Those blocks then have dirty, mapped and delayed
buffers together with a hole extent status entry.  This is an
unexpected inconsistency.

This problem has been hidden so far because we allocate blocks and new
extents for them during writeback.  But once [1] is merged during the
iomap conversion, the writeback behavior will be normalized, and it will
no longer allocate blocks for holes, thus exposing this problem.

Therefore, restrict the range to the blocks that are actually truncated
away, and pass EXT_MAX_BLOCKS minus lblk as the length.

[1] https://lore.kernel.org/linux-ext4/20261009103033.2920530-9-yi.zhang@huaweicloud.com/

Reported-by: syzbot ci <syzbot+ci46f64f7b6a2a188e@syzkaller.appspotmail.com>
Closes: https://lore.kernel.org/linux-ext4/6ac92a4c.70ed5d86.2ac85.0072.GAE@google.com/
Fixes: 0add491df4e5 ("ext4: remove extent cache entries when truncating inline data")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inline.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index ceee69a66482b..b630e56815bb5 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1905,8 +1905,12 @@ int ext4_inline_data_truncate(struct inode *inode, int *has_inline)
 		 * the extent status cache must be cleared to avoid leaving
 		 * behind stale delayed allocated extent entries
 		 */
-		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
-			ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
+		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
+			ext4_lblk_t lblk = EXT4_B_TO_LBLK(inode, i_size);
+
+			ext4_es_remove_extent(inode, lblk,
+					      EXT_MAX_BLOCKS - lblk);
+		}
 
 		/* Clear the content in the xattr space. */
 		if (inline_size > EXT4_MIN_INLINE_DATA_SIZE) {
-- 
2.52.0

