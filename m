From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 5/6] ocfs2: Wait for page writeback to provide stable pages
Date: Mon, 14 Jan 2013 21:43:13 -0800
Message-ID: <20130115054313.1563.70148.stgit@blackbox.djwong.org>
References: <20130115054235.1563.12967.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: martin.petersen@oracle.com, neilb@suse.de,
	Mark Fasheh <mfasheh@suse.com>, david@fromorbit.com,
	gnehzuil.liu@gmail.com, linux-kernel@vger.kernel.org,
	hch@infradead.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, ocfs2-devel@oss.oracle.com,
	bharrosh@panasas.com, jlayton@samba.org,
	linux-ext4@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	Joel Becker <jlbec@evilplan.org>
To: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz,
	darrick.wong@oracle.com, ericvh@gmail.com, tytso@mit.edu,
	viro@zeniv.linux.org.uk, rminnich@sandia.gov
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130115054235.1563.12967.stgit@blackbox.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When stable pages are required, we have to wait if the page is just
going to disk and we want to modify it. Add proper callback to
ocfs2_grab_pages_for_write().

CC: ocfs2-devel@oss.oracle.com
CC: Joel Becker <jlbec@evilplan.org>
CC: Mark Fasheh <mfasheh@suse.com>
From: Jan Kara <jack@suse.cz>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/aops.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 6577432..9796330 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1194,6 +1194,7 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
 				goto out;
 			}
 		}
+		wait_for_stable_page(wc->w_pages[i]);
 
 		if (index == target_index)
 			wc->w_target_page = wc->w_pages[i];
