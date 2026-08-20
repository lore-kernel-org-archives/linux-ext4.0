Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.75.44.102])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABE19377AB5;
	Thu, 20 Aug 2026 05:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.75.44.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787203349; cv=none; b=Fyd5sqYgn+vp8AnGc5ukMS5qJS9/O78WYgobm+WjNnEqQokrYf3q7+l0crIh9xmC4dXBTJ1NQ0kZyf7sykx9AyUkt8zqBQbrqj44UQdj0VOOeUhL08dSrn8lcda2bI01k9bLt41nv7yvP6GETbtX7Zpz3pX4ubhe3gsfh0AIheI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787203349; c=relaxed/simple;
	bh=scEtCK5RzqwngIkECjRt+68QwazEZeFXESS7h25f1i0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qdHz7/urqmnc0mMZcQ/v8h2+C1GPMaDGEjbzQ9ZUTs09zKW0iAeQd2EmelV1XgTmsuQ+HdaeLeR3qNZ9N6BvDpuWPathnxlrCRrWUMEBKZj1OfTGFltl+2V/P+zGRlwhIm/KHIc1dSW+/Ah/D66zf08xzqS69liZjP9Af2EDosM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=13.75.44.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.98.66.117])
	by mtasvr (Coremail) with SMTP id _____wBHMS_1joZqhRisAA--.2074S3;
	Thu, 20 Aug 2026 13:21:58 +0800 (CST)
Received: from localhost.localdomain (unknown [10.98.66.117])
	by mail-app3 (Coremail) with SMTP id zS_KCgAXLnD1joZqGbKGBA--.17350S2;
	Thu, 20 Aug 2026 13:21:57 +0800 (CST)
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
	stable@vger.kernel.org
Subject: [PATCH] ext4: fix discard work use-after-free on failed mount
Date: Thu, 20 Aug 2026 05:21:02 +0000
Message-Id: <20260820052102.4616-1-fanwu01@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zS_KCgAXLnD1joZqGbKGBA--.17350S2
X-CM-SenderInfo: qrstjiaswqq6lmxovvfxof0/
X-CM-DELIVERINFO: =?B?w43tCwXKKxbFmtjJiESix3B1w3vZ3A9ovKVTomAyoQazvoRs/NHSP8GI2EvgeEEW7R
	sfnZPoDCNGYdHSfuFmYJL54WNc57bz4AM2PfQ2r8oyBzVoKAhPTJ19GJW4x9ioKtcx3hRC
	6aE3dbRR9nMWLg9i8QWp9E6mavGmQbzmcFsnzP86
X-Coremail-Antispam: 1Uk129KBj93XoWxXF1DCw43Wry5Xry3trWfCrX_yoW5Ar15pr
	sxAw4jkrykZ34vkw43Za1xXFy0ga1F9F4UGryI9rs3Z390qw1IvFsxtFyY9F4qvrW8G3Za
	vF48G34jgFWvyrXCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUP0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc804V
	CY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AK
	xVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48Icx
	kI7VAKI48JM4x0Y48IcxkI7VAKI48G6xCjnVAKz4kxM4IIrI8v6xkF7I0E8cxan2IY04v7
	MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
	0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0E
	wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
	W8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
	cVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU85l1PUUUUU==

ext4_put_super() destroys the journal before it calls
ext4_mb_release(), but the failure unwind of __ext4_fill_super() runs
the two steps in the opposite order: failed_mount6 calls
ext4_mb_release(), and the journal is destroyed only later, just above
failed_mount3a.

ext4_mb_release() flushes sbi->s_discard_work before releasing the
mballoc structures, a drain made unconditional in commit 9ee29d20aab2
("ext4: always drain queued discard work in ext4_mb_release()").  With
-o discard, the journal destroy that runs afterwards re-arms that work
after the flush: ext4_journal_destroy() calls ext4_force_commit(), and
the commit callback, registered once mballoc is initialized, queues
s_discard_work whenever the discard option is set, even with an empty
freed-data list.  A quota-enabled mount reaches this with a live
transaction (ext4_enable_quotas() failing into failed_mount8,
ext4_quotas_off() on the failed_mount9 path), so the final force
commit is not a no-op.

Nothing drains s_discard_work after that point: failed_mount3 flushes
only s_sb_upd_work and the s_err_report timer, and ext4_fill_super()
then frees sbi with a plain kfree() through ext4_free_sbi().  If the
system_dfl_wq worker is delayed across the rest of the unwind,
ext4_discard_work() then accesses the freed sbi, first through
sbi->s_sb and then while taking sbi->s_md_lock.

This is the pattern fixed for the s_err_report timer in commit
0ce160c5bdb6 ("ext4: fix timer use-after-free on failed mount"):
async state armed after the unwind's last drain point.

Destroy the journal at failed_mount6, before ext4_mb_release().  This
restores the ext4_put_super() order, so the final commit re-arms
s_discard_work before the flush_work() in ext4_mb_release() drains
it.  The journal destroy further down the unwind still covers paths
that enter below failed_mount6; on the failed_mount6..failed_mount9
paths it does nothing, because ext4_journal_destroy() clears
sbi->s_journal.

This issue was found by an in-house static analysis tool.

Fixes: 55cdd0af2bc5 ("ext4: get discard out of jbd2 commit kthread contex")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
---
 fs/ext4/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4b6112e5d6c5..58b210637b57 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5761,6 +5761,12 @@ failed_mount8: __maybe_unused
 failed_mount7:
 	ext4_unregister_li_request(sb);
 failed_mount6:
+	/*
+	 * The last commit can re-arm s_discard_work, so destroy the
+	 * journal before ext4_mb_release() flushes it.
+	 */
+	if (sbi->s_journal)
+		ext4_journal_destroy(sbi, sbi->s_journal);
 	ext4_mb_release(sb);
 	ext4_flex_groups_free(sbi);
 failed_mount5:

