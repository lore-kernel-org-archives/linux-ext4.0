From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] iomap: Add inline data support to
	iomap_readpage_actor
Date: Sun, 1 Jul 2018 08:21:42 +0200
Message-ID: <20180701062141.GA27281@lst.de>
References: <20180615130209.1970-2-hch@lst.de>
	<20180629144444.28826-1-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
To: Andreas Gruenbacher <agruenba@redhat.com>
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180629144444.28826-1-agruenba@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

Looks sensible, although I think it could use some more sanity checking
and a changelog.  Does the version below work for you?

---
>From e4603b7acde9b77e7a4aad6038c7ac42ca35772d Mon Sep 17 00:00:00 2001
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 29 Jun 2018 16:44:44 +0200
Subject: iomap: Add inline data support to iomap_readpage_actor

Just copy the inline data into the page using the existing helper.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/iomap.c b/fs/iomap.c
index 4d8ff0f5ecc9..966ffad9706a 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -155,6 +155,13 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	bool is_contig = false;
 	sector_t sector;
 
+	if (iomap->type == IOMAP_INLINE) {
+		WARN_ON_ONCE(poff);
+		WARN_ON_ONCE(plen != PAGE_SIZE);
+		iomap_read_inline_data(inode, page, iomap);
+		return PAGE_SIZE;
+	}
+
 	/* we don't support blocksize < PAGE_SIZE quite yet. */
 	WARN_ON_ONCE(pos != page_offset(page));
 	WARN_ON_ONCE(plen != PAGE_SIZE);
-- 
2.18.0
