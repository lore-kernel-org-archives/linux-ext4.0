Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 175F65437F7;
	Wed,  9 Sep 2026 11:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.164.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788953910; cv=none; b=iDCSLzed5u00T2ScJXpP5xKXVmanL9tpA9ZyAwWgqh3cq/OFwB2s2jucnmadv1a7+B74H8L/d/Pex3Y7jD2MaocOgQaLt6UoxG+iLV6rRPniNpbFAwPSfJt8LMBK5isG6o3Beu03Ijz/IDrRBao34Mvt3Zmdzvr/TASDBYZpjrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788953910; c=relaxed/simple;
	bh=U+9X/a/Q3cvpmAgFmGTelD3t+Kqk1ZK5Jvg5E874iX4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cXDomnv9yGMu7Y7KFe55CXK6WSu0/fyvqNYKoHq2Zew88V/KUVhCcDk8qtxWnBXeGn+ndQFVblviT/yV4HwxEVKvwe8vY5rOWOYHmjiWgSd2nkgSZh57tovPKRIV9ropjal5IQ1Fvsq6spGr7mpnYk4/a6OTXO176Pg3rt6Ah9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=162.243.164.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.98.66.117])
	by mtasvr (Coremail) with SMTP id _____wDn7zcYRaFqQxMDAQ--.34631S3;
	Wed, 09 Sep 2026 19:38:01 +0800 (CST)
Received: from localhost.localdomain (unknown [10.98.66.117])
	by mail-app2 (Coremail) with SMTP id zC_KCgDnedAWRaFqjdhmBA--.25001S2;
	Wed, 09 Sep 2026 19:37:58 +0800 (CST)
From: Fan Wu <fanwu01@zju.edu.cn>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fan Wu <fanwu01@zju.edu.cn>,
	stable@vger.kernel.org,
	Song Li <songl@zju.edu.cn>
Subject: [PATCH v3] ext4: fix discard work use-after-free on failed mount
Date: Wed,  9 Sep 2026 11:37:03 +0000
Message-Id: <20260909113703.698544-1-fanwu01@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zC_KCgDnedAWRaFqjdhmBA--.25001S2
X-CM-SenderInfo: qrstjiaswqq6lmxovvfxof0/
X-CM-DELIVERINFO: =?B?vx2W+wXKKxbFmtjJiESix3B1w3vZ3A9ovKVTomAyoQazvoRs/NHSP8GI2EvgeEEW7R
	sfncGSG+szpQCInt5Y8rbJUI1k4dmeOS3OpjqUz8I0yaYTVcD3I9J1X63PfSqexTU06tE1
	bOoQkt5yl/qIxVUiZo2p9E6mavGmQbzmcFsnzP86
X-Coremail-Antispam: 1Uk129KBj93XoWxXF1fCr1fXr17WFyfXryUXFc_yoWrAF4fpr
	sxAF17KryDXry0kw47ua1xXFy8Ka1ruay7Wryxur4Uu39IqryfAFZrtF1Y9F4jkrWkCa1a
	vF1DK347WFW5A3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPYb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc804V
	CY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AK
	xVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48Icx
	kI7VAKI48JM4x0Y48IcxkI7VAKI48G6xCjnVAKz4kxM4IIrI8v6xkF7I0E8cxan2IY04v7
	MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
	0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0E
	wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JV
	WxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAI
	cVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07jeAp5UUUUU=

ext4_put_super() shuts the journal down before it releases the mballoc
structures, but the failure unwind of __ext4_fill_super() runs the two
steps in the opposite order: failed_mount6 calls ext4_mb_release(),
which flushes sbi->s_discard_work, and the journal is destroyed only
later, just above failed_mount3a.

With -o discard, that journal destroy re-arms the work after the flush:
ext4_journal_destroy() calls ext4_force_commit(), and the commit
callback, registered once mballoc is initialized, queues s_discard_work
whenever the discard option is set, even with an empty freed-data list.
A running transaction can be live at that point: replaying the orphan
list is the easiest way to get one, and the quota paths on
failed_mount8/failed_mount9 can leave one too. The final force commit
is not necessarily a no-op.

Nothing drains s_discard_work after that point: failed_mount3 flushes
only s_sb_upd_work and the s_err_report timer, and ext4_fill_super()
then frees sbi with a plain kfree() through ext4_free_sbi(). If the
system_dfl_wq worker is delayed across the rest of the unwind,
ext4_discard_work() then accesses the freed sbi, first through
sbi->s_sb and then while taking sbi->s_md_lock.

This is the pattern fixed for the s_err_report timer in commit
0ce160c5bdb6 ("ext4: fix timer use-after-free on failed mount"):
async state armed after the unwind's last drain point.

Force the commit at failed_mount6, before ext4_mb_release(), so that
the discard work its commit callback queues is normally already
pending when the flush_work() in ext4_mb_release() runs.
disable_work_sync() there then makes this airtight: it also drains an
instance the flush missed, and no later commit, including the force
commit inside the journal destroy further down the unwind, can
requeue the work. The journal destroy stays at its existing position.

This issue was found by an in-house static analysis tool.

Fixes: 55cdd0af2bc5 ("ext4: get discard out of jbd2 commit kthread contex")
Cc: stable@vger.kernel.org # v6.10+
Reviewed-by: Jan Kara <jack@suse.cz>
Assisted-by: Codex:gpt-5.6
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
---
v3: address review nits from Jan Kara: simplify the failed_mount6
    comment and drop the redundant sbi->s_journal check in
    ext4_force_commit()'s callers. Reviewed-by was obtained on v2.
v2: keep the journal shutdown at its existing point instead of
    destroying the journal at failed_mount6, per review from Jan Kara:
    force the outstanding transaction there so the re-arm happens
    before the ext4_mb_release() flush, and disable_work_sync() the
    discard work after the flush.
    https://lore.kernel.org/linux-ext4/20260909054124.657782-1-fanwu01@zju.edu.cn/
v1: https://lore.kernel.org/linux-ext4/20260820052102.4616-1-fanwu01@zju.edu.cn/
---
 fs/ext4/mballoc.c | 2 ++
 fs/ext4/super.c   | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ed1bd00e11cd..874b71931ab6 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3897,6 +3897,8 @@ void ext4_mb_release(struct super_block *sb)
 	 * wait the discard work to drain all of ext4_free_data
 	 */
 	flush_work(&sbi->s_discard_work);
+	/* Prevent the later journal teardown from requeueing discard work. */
+	disable_work_sync(&sbi->s_discard_work);
 	WARN_ON_ONCE(!list_empty(&sbi->s_discard_list));
 
 	group_info = rcu_access_pointer(sbi->s_group_info);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4b6112e5d6c5..37dc6b5f20c6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5761,6 +5761,12 @@ failed_mount8: __maybe_unused
 failed_mount7:
 	ext4_unregister_li_request(sb);
 failed_mount6:
+	/*
+	 * We can have a running transaction from orphan replay or quota
+	 * setup. Commit it so that discard work after commit runs before
+	 * we shutdown mballoc.
+	 */
+	ext4_force_commit(sb);
 	ext4_mb_release(sb);
 	ext4_flex_groups_free(sbi);
 failed_mount5:

