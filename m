Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3AB3AE1A9
	for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 06:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774593237; cv=none; b=BnB3VIx9n04H0j+y6A0BMWP3HXngrpEesaWXgg0IjLc4RzJkzgh2LYhylmU5IF/Vf9eHcC5RBIRJvXifgXR2eLFAXeoAdruFhi5qK9rpHgIySH8/aOloIKHVLeF83DpmXpscTUZdxLBb2jwrzLAeCBtVOxfAUO/g1OPramcjfgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774593237; c=relaxed/simple;
	bh=zRrk1AUQ/TfIHHKqN/YVp75/3JieHeJf3At99FHlyYw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lq3v95YeEsa1BIMJfrwZmv7LU3IWIn2j7kRX+FAk1q7Wf5gWi7COjoBfuVJ4lc3grZX3BbvGmx5On8LiR9XEQs7SieNfwqfNPpuaTyLrWHBc8H0d2F8qwj0RlcBNIf/8UOKEN6MaGtx3Xl6c03UK3lcVtgtC1o+O9UzPNMfhq6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=c92hqyGM; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="c92hqyGM"
Received: from trampoline.thunk.org (pool-173-48-121-153.bstnma.fios.verizon.net [173.48.121.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62R6XZ3b025991
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 02:33:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774593216; bh=0OP/VYsVW6QPBdqETjMTwArBOthHJECRnjeZtyC7voo=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=c92hqyGMcEkGV7W8iiRBqU+h+WpUh/OOBkiDPOXNTXuJa+89S/600D6cVmRvQALS5
	 /xYMxyJe/wIHHhS8cpgku+Rj5qfbdpG5k272C2296asCHLco7AIvPF6qPUhniRw8E2
	 Ia9P7Nuznuy86AqzTpPutV/z5LoKoiCLaYxCdUtLeG1d3M1gQAOSNwPi4xMYagw9Aw
	 MWIRlrbWiSE61/0cRuQDTXpcgCsvPRxGHxnSbD3tM8O7w60mE1G3hxQzuboBJUTs2Y
	 fWkzMb84FvigwudjlBe6T4MxBRnc7VPvd3jlZtDeUUTwEti8NsJmb4/ZohQNK4K7d8
	 9CqmYTdSHuhew==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 632F42E00D6; Fri, 27 Mar 2026 02:33:35 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] ext4: always drain queued discard work in ext4_mb_release()
Date: Fri, 27 Mar 2026 02:33:30 -0400
Message-ID: <20260327063330.1312426-1-tytso@mit.edu>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While reviewing recent ext4 patch[1], Sashiko raised the following
concern[2]:

> If the filesystem is initially mounted with the discard option,
> deleting files will populate sbi->s_discard_list and queue
> s_discard_work. If it is then remounted with nodiscard, the
> EXT4_MOUNT_DISCARD flag is cleared, but the pending s_discard_work is
> neither cancelled nor flushed.

[1] https://lore.kernel.org/r/20260319094545.19291-1-qiang.zhang@linux.dev/
[2] https://sashiko.dev/#/patchset/20260319094545.19291-1-qiang.zhang%40linux.dev

The concern was valid, but it had nothing to do with the patch[1].
One of the problems with Sashiko in its current (early) form is that
it will detect pre-existing issues and report it as a problem with the
patch that it is reviewing.

In practice, it would be hard to hit deliberately (unless you are a
malicious syzkaller fuzzer), since it would involve mounting the file
system with -o discard, and then deleting a large number of files,
remounting the file system with -o nodiscard, and then immediately
unmounting the file system before the queued discard work has a change
to drain on its own.

Fix it because it's a real bug, and to avoid Sashiko from raising this
concern when analyzing future patches to mballoc.c.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/mballoc.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index cb2bd87c355c..bb58eafb87bc 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3893,13 +3893,11 @@ void ext4_mb_release(struct super_block *sb)
 	struct kmem_cache *cachep = get_groupinfo_cache(sb->s_blocksize_bits);
 	int count;
 
-	if (test_opt(sb, DISCARD)) {
-		/*
-		 * wait the discard work to drain all of ext4_free_data
-		 */
-		flush_work(&sbi->s_discard_work);
-		WARN_ON_ONCE(!list_empty(&sbi->s_discard_list));
-	}
+	/*
+	 * wait the discard work to drain all of ext4_free_data
+	 */
+	flush_work(&sbi->s_discard_work);
+	WARN_ON_ONCE(!list_empty(&sbi->s_discard_list));
 
 	group_info = rcu_access_pointer(sbi->s_group_info);
 	if (group_info) {
-- 
2.51.0

