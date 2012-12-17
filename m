From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/4] 9pfs: Fix filesystem to wait for stable page
 writeback
Date: Mon, 17 Dec 2012 11:11:30 +0100
Message-ID: <20121217101130.GG5133@quack.suse.cz>
References: <20121213080740.23360.16346.stgit@blackbox.djwong.org>
 <20121213080802.23360.4487.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0F1p//8PRICkK4MW"
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	viro@zeniv.linux.org.uk, rminnich@sandia.gov, tytso@mit.edu,
	martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-kernel@vger.kernel.org, hch@infradead.org,
	linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
	bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46570 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab2LQKLq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Dec 2012 05:11:46 -0500
Content-Disposition: inline
In-Reply-To: <20121213080802.23360.4487.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 13-12-12 00:08:02, Darrick J. Wong wrote:
> Fix up the ->page_mkwrite handler to provide stable page writes if necessary.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
  Looks good. Also UBIFS and OCFS2 seem to need similar treatment. Patches
attached...

									Honza
> ---
>  fs/9p/vfs_file.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
> index c2483e9..357260b 100644
> --- a/fs/9p/vfs_file.c
> +++ b/fs/9p/vfs_file.c
> @@ -620,6 +620,7 @@ v9fs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	lock_page(page);
>  	if (page->mapping != inode->i_mapping)
>  		goto out_unlock;
> +	wait_for_stable_page(page);
>  
>  	return VM_FAULT_LOCKED;
>  out_unlock:
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--0F1p//8PRICkK4MW
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ocfs2-Wait-for-page-writeback-to-provide-stable-page.patch"

>From 0e99ae8cf891015105f01065e2977ea6cc737ff8 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 17 Dec 2012 11:03:42 +0100
Subject: [PATCH 1/2] ocfs2: Wait for page writeback to provide stable pages

When stable pages are required, we have to wait if the page is just
going to disk and we want to modify it. Add proper callback to
ocfs2_grab_pages_for_write().

CC: ocfs2-devel@oss.oracle.com
CC: Joel Becker <jlbec@evilplan.org>
CC: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/aops.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

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
-- 
1.7.1


--0F1p//8PRICkK4MW
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0002-ubifs-Wait-for-page-writeback-to-provide-stable-page.patch"

>From 988439f828b24fba8784cbd4d713d87cabd807cf Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 17 Dec 2012 11:08:11 +0100
Subject: [PATCH 2/2] ubifs: Wait for page writeback to provide stable pages

When stable pages are required, we have to wait if the page is just
going to disk and we want to modify it. Add proper callback to
ubifs_vm_page_mkwrite().

CC: Artem Bityutskiy <dedekind1@gmail.com>
CC: Adrian Hunter <adrian.hunter@intel.com>
CC: linux-mtd@lists.infradead.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ubifs/file.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 5bc7781..4f6493c 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1522,6 +1522,7 @@ static int ubifs_vm_page_mkwrite(struct vm_area_struct *vma,
 			ubifs_release_dirty_inode_budget(c, ui);
 	}
 
+	wait_for_stable_page(page);
 	unlock_page(page);
 	return 0;
 
-- 
1.7.1


--0F1p//8PRICkK4MW--
