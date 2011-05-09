From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/1] Null Pointer when make_indexed_dir returns -ENOSPC
Date: Mon, 9 May 2011 16:42:01 +0200
Message-ID: <20110509144201.GP4122@quack.suse.cz>
References: <4DC5DBB3.9030207@linux.vnet.ibm.com>
 <20110509110329.GF4122@quack.suse.cz>
 <BANLkTi=hSeN4mb8x9vu4DfBb-us_ocaqXw@mail.gmail.com>
 <20110509113052.GI4122@quack.suse.cz>
 <20110509135516.GJ4138@thunk.org>
 <20110509140537.GN4122@quack.suse.cz>
 <20110509142237.GA19811@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="17pEHd4RhPHOinZp"
Cc: Jan Kara <jack@suse.cz>, Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49724 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771Ab1EIOmE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 May 2011 10:42:04 -0400
Content-Disposition: inline
In-Reply-To: <20110509142237.GA19811@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon 09-05-11 10:22:37, Ted Tso wrote:
> On Mon, May 09, 2011 at 04:05:37PM +0200, Jan Kara wrote:
> >   Yes. ext4_append() can return ENOSPC and passed bh will get set to NULL
> > without being marked dirty.
> 
> Ah, so the right fix then is to add to make the cleanup code like this:
> 
> 		ext4_mark_inode_dirty(handle, dir);
> 		ext4_handle_dirty_metadata(handle, dir, frame->bh);
> +	        ext4_handle_dirty_metadata(handle, dir, bh2);
> +		if (bh)
> +			ext4_handle_dirty_metadata(handle, dir, bh);
> 		dx_release(frames);
> 		return retval;
> 
> Agreed?
  Not quite. make_indexed_dir() does frame->bh = bh and bh = bh2 before
calling do_split(). So bh2 is not really carrying a valid buffer reference
at this point - even more so because do_split() does brelse() on the passed
bh so it need not be around when are at this point. The code is a real
mess. But for example attached patch will work because both callers of
do_split() do brelse() anyway.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--17pEHd4RhPHOinZp
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Stop-releasing-passed-bh-in-do_split.patch"

>From 59729e0ab18a763ba36616a1025ce606a8721f1c Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 9 May 2011 16:39:34 +0200
Subject: [PATCH] ext4: Stop releasing passed bh in do_split()

make_indexed_dir() needs to do error recovery on the passed bh when do_split()
fails. So do not release it early in do_split().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/namei.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 3c7a06e..1cddab9 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1165,11 +1165,8 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	int	err = 0, i;
 
 	bh2 = ext4_append (handle, dir, &newblock, &err);
-	if (!(bh2)) {
-		brelse(*bh);
-		*bh = NULL;
+	if (!bh2)
 		goto errout;
-	}
 
 	BUFFER_TRACE(*bh, "get_write_access");
 	err = ext4_journal_get_write_access(handle, *bh);
@@ -1235,9 +1232,7 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	return de;
 
 journal_error:
-	brelse(*bh);
 	brelse(bh2);
-	*bh = NULL;
 	ext4_std_error(dir->i_sb, err);
 errout:
 	*error = err;
-- 
1.7.1


--17pEHd4RhPHOinZp--
