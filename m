From: Eryu Guan <eguan@redhat.com>
Subject: [v4.14-rc1 regression] ext4 failed fstests generic/233 quota test
Date: Sun, 8 Oct 2017 13:42:36 +0800
Message-ID: <20171008054236.GA10593@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Eric Whitney <enwlinux@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38560 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750892AbdJHFmj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 8 Oct 2017 01:42:39 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

After generic/232 failure has been reported and resolved[1], I still
could see fstests generic/233 failure on ext4 with v4.14-rc3 kernel.
This is not 100% reproduced (block usage needs to exceed soft limit) but
reliably.

 seed = S
 Comparing user usage
-Comparing group usage
+4c4
+< #1001     +-   32064   32000   32000            998  1000  1000       
+---
+> #1001     +-   32064   32000   32000  7days     998  1000  1000

Grace time was not printed by repquota right after the fsstress run when
we exceeded the block soft limit, and only printed after a quotacheck
was run.  With v4.13 kernel, block grace time could be printed
immediately after the fsstress run.

git bisect pointed the first bad to commit 7b9ca4c61bc2 ("quota: Reduce
contention on dq_data_lock"). And I've confirmed the bisection result by
converting the commit in question and running generic/233 for 20
iterations without a failure.

Thanks,
Eryu

[1] https://www.spinics.net/lists/linux-ext4/msg58372.html
