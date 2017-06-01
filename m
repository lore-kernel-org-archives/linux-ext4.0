From: Jan Kara <jack@suse.cz>
Subject: [PATCH 04/35] dax: Fix inefficiency in dax_writeback_mapping_range()
Date: Thu,  1 Jun 2017 11:32:14 +0200
Message-ID: <20170601093245.29238-5-jack@suse.cz>
References: <20170601093245.29238-1-jack@suse.cz>
Cc: Hugh Dickins <hughd@google.com>,
	David Howells <dhowells@redhat.com>,
	linux-afs@lists.infradead.org,
	Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
	linux-nilfs@vger.kernel.org,
	Bob Peterson <rpeterso@redhat.com>,
	cluster-devel@redhat.com,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	tytso@mit.edu,
	linux-ext4@vger.kernel.org,
	Ilya Dryomov <idryomov@gmail.com>,
	"Yan, Zheng" <zyan@redhat.com>,
	ceph-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	David Sterba <dsterba@suse.com>,
	"Darrick J . Wong" <darrick.wong@oracle.com>,
	linux-xfs@vger.kernel.org,
	Nadia Yvette Chambers <nyc@holomorphy.com>,
	Jan Kara <jack@suse.cz>,
	stable@vger.kernel.org
To: <linux-mm@kvack.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170601093245.29238-1-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

dax_writeback_mapping_range() fails to update iteration index when
searching radix tree for entries needing cache flushing. Thus each
pagevec worth of entries is searched starting from the start which is
inefficient and prone to livelocks. Update index properly.

CC: stable@vger.kernel.org
Fixes: 9973c98ecfda3a1dfcab981665b5f1e39bcde64a
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dax.c b/fs/dax.c
index c22eaf162f95..c204445a69b0 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -859,6 +859,7 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 			if (ret < 0)
 				goto out;
 		}
+		start_index = indices[pvec.nr - 1] + 1;
 	}
 out:
 	put_dax(dax_dev);
-- 
2.12.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
