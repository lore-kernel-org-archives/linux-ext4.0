From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 03/35] ext4: Fix off-by-in in loop termination in ext4_find_unwritten_pgoff()
Date: Thu,  1 Jun 2017 11:32:13 +0200
Message-ID: <20170601093245.29238-4-jack@suse.cz>
References: <20170601093245.29238-1-jack@suse.cz>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>,
        David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
        Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>,
        linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bob Peterson <rpeterso-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org,
        linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ilya Dryomov <idryomov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        "Yan, Zheng" <zyan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>,
        "Darrick J . Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
        linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Nadia Yvette Chambers <nyc-tGiaVUSOoeej7qYf8Sx8sA@public.gmane.org>,
        Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
To: <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170601093245.29238-1-jack-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

There is an off-by-one error in loop termination conditions in
ext4_find_unwritten_pgoff() since 'end' may index a page beyond end of
desired range if 'endoff' is page aligned. It doesn't have any visible
effects but still it is good to fix it.

Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/ext4/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index bbea2dccd584..2b00bf84c05b 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -474,7 +474,7 @@ static int ext4_find_unwritten_pgoff(struct inode *inode,
 	endoff = (loff_t)end_blk << blkbits;
 
 	index = startoff >> PAGE_SHIFT;
-	end = endoff >> PAGE_SHIFT;
+	end = (endoff - 1) >> PAGE_SHIFT;
 
 	pagevec_init(&pvec, 0);
 	do {
-- 
2.12.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
