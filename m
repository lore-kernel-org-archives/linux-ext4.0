From: Niu Yawei <yawei.niu@gmail.com>
Subject: [PATCH 4/5] quota: missing lock in dqcache_shrink_scan()
Date: Wed, 04 Jun 2014 12:22:13 +0800
Message-ID: <538E9EF5.40806@gmail.com>
References: <537DD5BA.1050105@gmail.com> <538464AD.6050407@gmail.com> <20140527101219.GA28035@infradead.org> <538541FE.3070203@gmail.com> <20140602083436.GC3224@quack.suse.cz> <538D9AB0.9090607@gmail.com> <20140603154301.GE30706@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	yawei.niu@intel.com, andreas.dilger@intel.com, lai.siyao@intel.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140603154301.GE30706@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

dqcache_shrink_scan() should use dq_list_lock to protect the
scan on free_dquots list.

Signed-off-by: Niu Yawei <yawei.niu@intel.com>
---
 fs/quota/dquot.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 51b5763..a94d464 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -702,6 +702,7 @@ dqcache_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 	struct dquot *dquot;
 	unsigned long freed = 0;
 
+	spin_lock(&dq_list_lock);
 	head = free_dquots.prev;
 	while (head != &free_dquots && sc->nr_to_scan) {
 		dquot = list_entry(head, struct dquot, dq_free);
@@ -713,6 +714,7 @@ dqcache_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 		freed++;
 		head = free_dquots.prev;
 	}
+	spin_unlock(&dq_list_lock);
 	return freed;
 }
 
-- 
1.7.1


