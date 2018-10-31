Return-Path: <SRS0=VEyz=NL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:47192 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725731AbeKAEME (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 1 Nov 2018 00:12:04 -0400
From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 3/7] ext4: lost release of s_journal_flag_rwsem on rollback in
 ext4_fill_super
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org, Daeho Jeong <daeho.jeong@samsung.com>
References: <cover.1541011937.git.vvs@virtuozzo.com>
Message-ID: <2a41b591-ce2e-e4e1-d86a-e0fd18e77ccd@virtuozzo.com>
Date: Wed, 31 Oct 2018 22:12:35 +0300
MIME-Version: 1.0
In-Reply-To: <cover.1541011937.git.vvs@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fixes c8585c6fcaf2 ("ext4: fix races between changing inode journal ...") # 4.7

cc: Daeho Jeong <daeho.jeong@samsung.com>
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ed4d36506ec2..0c9e165b4e3f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4511,6 +4511,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
 	percpu_counter_destroy(&sbi->s_dirtyclusters_counter);
+	percpu_free_rwsem(&sbi->s_journal_flag_rwsem);
 failed_mount5:
 	ext4_ext_release(sb);
 	ext4_release_system_zone(sb);
-- 
2.17.1
