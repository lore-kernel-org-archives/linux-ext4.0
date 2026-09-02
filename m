Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 831993CD8D3;
	Wed,  2 Sep 2026 07:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788332629; cv=none; b=nq1vhRUVzgvUp4PDm8d9cgM3N+nKujClus2FAG6414st6cCLeJ39+jZ9a/7v/rIP5c1BRhkNe46ztoZY8blZbaI1+4+lswU9k69Zlq1UpZEM5Ar5rTGq37SIKZ82YQ2ohmmK1WtYGNBDfUR9lqP8rsk+V4Vsg5RjOQcvDIvF/dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788332629; c=relaxed/simple;
	bh=zTGBLkowuehwEW9heGqd1s27qOW9PRgP8fSwV+TAl58=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=knAu1P68aokzHn00whP1ujpYeaIfC2ywa0LPpZ7lFlZ0j6rUtej4lIRFtGQm43LY6KBD9A9hw06GK6Kf8IvMeszvbBeeP6W7xe1fT62O9EExmdawsGJa3SrP6ivigVycGkT2oU0yldHSMW1HlvlqQMYstEnd+kpxIEL+dTCjo64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
Received: from zhaoxin.com (unknown [127.0.0.1])
	by mx1.zhaoxin.com (MTA) with ESMTP id 4hZYbw70KLzb0tjd;
	Wed,  2 Sep 2026 15:03:40 +0800 (CST)
Received: from zhaoxin.com (unknown [10.28.208.166])
	by mx1.zhaoxin.com (MTA) with ESMTP id 4hZYbw5GtYzb0tjd;
	Wed,  2 Sep 2026 15:03:40 +0800 (CST)
Received: from zjh-os.zhaoxin.com (zjh-os.zhaoxin.com [10.28.24.13])
	by zhaoxin.com (8.30) with ESMTPa949fd261fc3940cf546e9a677fe50da
	Wed, 02 Sep 2026 15:03:39 +0800
X-Eyou-Smtpauth: jonaszhou-oc@zhaoxin.com
X-Eyou-EnvelopeSender: jonaszhou-oc@zhaoxin.com
X-Eyou-From: JonasZhou-oc <jonaszhou-oc@zhaoxin.com>
From: "=?UTF-8?B?Sm9uYXNaaG91LW9j?=" <jonaszhou-oc@zhaoxin.com>
To: tytso@mit.edu,
	jack@suse.com
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhuizzzzz@gmail.com,
	JonasZhou-oc <jonaszhou-oc@zhaoxin.com>
Subject: [PATCH] jbd2: avoid false sharing with j_state_lock
Date: Wed,  2 Sep 2026 15:03:31 +0800
Message-ID: <20260902070331.820322-1-jonaszhou-oc@zhaoxin.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Eyou-Sender: <jonaszhou-oc@zhaoxin.com>

is_journal_aborted() reads journal->j_flags from ext4 and JBD2 hot
paths. At the same time, transaction start and stop paths repeatedly
acquire and release j_state_lock. read_lock() and read_unlock() update
the lock word, so this traffic invalidates the cache line containing
j_flags.

On the tested x86-64 build, j_flags, j_errno, and j_state_lock occupy
the same 64-byte cache line. j_flags starts at offset 0, j_errno at
offset 8, and j_state_lock at offset 56.

Align j_state_lock to a cacheline boundary on SMP builds. This moves it
to offset 64 and prevents lock traffic from invalidating j_flags and
j_errno. Tests were run on Linux 7.3-rc1.

On a two-socket Intel Xeon Silver 4208 system with SMT disabled, CPUs
fixed at 2 GHz, and 16 stress-ng workers, ten-run average bogo-ops/s for
stress-ng.utime, stress-ng.access, stress-ng.file-ioctl, and
stress-ng.open increased by 9.60%, 5.42%, 2.05%, and 4.65%,
respectively. In separate five-run perf c2c measurements, average
Remote HITM samples for the affected j_flags/j_errno line decreased
from 1996, 2041, 1555, and 383 to zero, respectively.

Signed-off-by: JonasZhou-oc <jonaszhou-oc@zhaoxin.com>
---
 include/linux/jbd2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 1b42fe47c26b..e3886963ba00 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -795,7 +795,7 @@ struct journal_s
 	/**
 	 * @j_state_lock: Protect the various scalars in the journal.
 	 */
-	rwlock_t		j_state_lock;
+	rwlock_t		j_state_lock ____cacheline_aligned_in_smp;
 
 	/**
 	 * @j_barrier_count:

base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.43.0


