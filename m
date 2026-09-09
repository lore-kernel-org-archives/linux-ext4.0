Received: from zg8tmtyylji0my4xnjeumjiw.icoremail.net (zg8tmtyylji0my4xnjeumjiw.icoremail.net [162.243.161.220])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83DE52DB78C;
	Wed,  9 Sep 2026 05:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.161.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788932554; cv=none; b=Lxkb3M1bL7HyG5vHjr78N7mGcv7w4vx5qu7AqGXgA3jfOwNGnCe00gZtAw171voyibJ4jDIU0qm2XSeBdg8fVBwehGSRKRIELBjwHpe5mkMo5hsWw0xVoKy5Zz3vFnXRuLTTXeJs8BzfiJOr9hMUYY6R7kUrUJD/KbdJ4fPj9sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788932554; c=relaxed/simple;
	bh=irgw5692G3THZMp8Ohgma24p5AdL59yjnKDh1VN+LU4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=A6XJbKITLECMvLZcztvBsHfNszoIHClHjG1ZcntuQxxIXhrRUjTuKM9bcOPPQVdgHSF8vuEPewalJxIECMU1bkzmjtdkw3A0lLlvLAV432IyqE3gFg7kI+j8nbuWjWStCmkF1VKhWZF8U7FDrwH3Ilhy3lBwlJQQ1jR606pckfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=162.243.161.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.98.66.117])
	by mtasvr (Coremail) with SMTP id _____wAXAT+98aBqcPgBAQ--.7086S3;
	Wed, 09 Sep 2026 13:42:21 +0800 (CST)
Received: from localhost.localdomain (unknown [10.98.66.117])
	by mail-app4 (Coremail) with SMTP id zi_KCgAnezO88aBqWyaoAw--.14S2;
	Wed, 09 Sep 2026 13:42:20 +0800 (CST)
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
Subject: [PATCH v2] ext4: fix discard work use-after-free on failed mount
Date: Wed,  9 Sep 2026 05:41:24 +0000
Message-Id: <20260909054124.657782-1-fanwu01@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zi_KCgAnezO88aBqWyaoAw--.14S2
X-CM-SenderInfo: qrstjiaswqq6lmxovvfxof0/
X-CM-DELIVERINFO: =?B?k/HslgXKKxbFmtjJiESix3B1w3vZ3A9ovKVTomAyoQazvoRs/NHSP8GI2EvgeEEW7R
	sfnXz+g1OQfMo27QHy5TwQyZyEmTEYPW8rwO+uoQfYOdLQf3NR5W4PiQdyNICW5RYHww39
	IjhLnkNV1x8vEIdir8k=
X-Coremail-Antispam: 1Uk129KBj93XoWxXF1fCr1fXr17WFyfXryUXFc_yoWrCr18pr
	43Ar1UKrWDWry0kw47uw4xXFy0gw4ruF47Gryxur1DZ398X34SyFZrt3Wa9F4UKrZ5G3WS
	vF1jg34DWFWrA3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Cr1j6rxdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6x
	kI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v2
	6r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2
	Ij64vIr41lF7xvr2IYc2Ij64vIr40E4x8a64kEw24lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l
	42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
	WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAK
	I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F
	4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY
	6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU7rcfUUUUU

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
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
---
v2: per review from Jan Kara, keep the journal shutdown at its existing
    point instead of destroying the journal at failed_mount6: force the
    outstanding transaction there so the re-arm happens before the
    ext4_mb_release() flush, and disable_work_sync() the discard work
    after the flush. jbd2 publishes j_commit_sequence before running
    the commit callback, so the callback can still queue the work
    after ext4_force_commit() and the flush have both returned;
    disable_work_sync() drains that instance as well and keeps the
    later journal destroy from requeueing the work.
v1: https://lore.kernel.org/linux-ext4/20260820052102.4616-1-fanwu01@zju.edu.cn/
---
 fs/ext4/mballoc.c | 2 ++
 fs/ext4/super.c   | 9 +++++++++
 2 files changed, 11 insertions(+)

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
index 4b6112e5d6c5..62d1930e9783 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5761,6 +5761,15 @@ failed_mount8: __maybe_unused
 failed_mount7:
 	ext4_unregister_li_request(sb);
 failed_mount6:
+	/*
+	 * Flush any running transaction: its commit callback may queue
+	 * s_discard_work, which the flush_work() in ext4_mb_release()
+	 * below drains; disable_work_sync() there also drains an
+	 * instance queued after that, and keeps the journal destroy
+	 * further down the unwind from requeueing the work.
+	 */
+	if (sbi->s_journal)
+		ext4_force_commit(sb);
 	ext4_mb_release(sb);
 	ext4_flex_groups_free(sbi);
 failed_mount5:

