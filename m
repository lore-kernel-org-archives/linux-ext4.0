From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] Make block_page_mkwrite() handle frozen fs (V2)
Date: Thu, 19 May 2011 14:30:29 +0200
Message-ID: <20110519123029.GI8417@quack.suse.cz>
References: <1305731882-8334-1-git-send-email-jack@suse.cz>
 <20110518180022.GM18929@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ZGiS0Q5IWpPtfppv"
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
	tytso@mit.edu, Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110518180022.GM18929@tux1.beaverton.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 18-05-11 11:00:22, Darrick J. Wong wrote:
> On Wed, May 18, 2011 at 05:17:59PM +0200, Jan Kara wrote:
> > 
> >   Hi,
> > 
> >   this is a second version of my patches which rewrite ext4_page_mkwrite() to
> > use generic helper. When we are already changing this code, I also added proper
> > handling of frozen filesystem there in patch 2/3. I've incorporated suggestions
> > from Christoph in the patches which resulted in some patch reorg. I'd like to
> > get these patches reviewed and then get them merged possibly via ext4-tree
> > (although the first two patches might go via Al but that would complicate
> > merging of ext4 part where I expect more conflicts with ongoing work).
> 
> Do you want me to generate a patch to add wait_on_page_writeback to the
> appropriate place(s) in your new *_page_mkwrite functions, or do you plan to
> add them yourself?
> 
> (iow: is there an order for pushing these ext4_page_mkwrite changes?)
  Attached is a rebase of your block_page_mkwrite change on top of my
patches. I'm not sure what is the actual status your series - have you
pushed VFS changes to Al?

									Honza

--ZGiS0Q5IWpPtfppv
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-vfs-Wait-in-__block_page_mkwrite-for-IO-to-finish.patch"

>From 408d0a667ebdc7edd24d05c8de4b42cc1629e84f Mon Sep 17 00:00:00 2001
From: Darrick J. Wong <djwong@us.ibm.com>
Date: Thu, 19 May 2011 14:14:11 +0200
Subject: [PATCH] vfs: Wait in __block_page_mkwrite for IO to finish

For filesystems such as nilfs2 and xfs that use block_page_mkwrite, modify that
function to wait for pending writeback before allowing the page to become
writable. This is needed to stabilize pages during writeback for those two
filesystems.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index b0675bf..161685d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2365,6 +2365,8 @@ int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 
 	if (unlikely(ret < 0))
 		goto out_unlock;
+	/* Wait so that we don't change page under IO */
+	wait_on_page_writeback(page);
 	/*
 	 * Freezing in progress? We check after the page is marked dirty and
 	 * with page lock held so if the test here fails, we are sure freezing
-- 
1.7.1


--ZGiS0Q5IWpPtfppv--
