From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: fix ext4_flush_completed_IO wait semantics
Date: Fri, 05 Oct 2012 17:53:36 +0400
Message-ID: <877gr5auu7.fsf@openvz.org>
References: <1349289807-18811-1-git-send-email-dmonakhov@openvz.org> <20121005124027.GA21358@thunk.org> <87a9w1ax91.fsf@openvz.org> <20121005132853.GC21358@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52887 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab2JENxk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Oct 2012 09:53:40 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so1368041lbo.19
        for <linux-ext4@vger.kernel.org>; Fri, 05 Oct 2012 06:53:38 -0700 (PDT)
In-Reply-To: <20121005132853.GC21358@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

On Fri, 5 Oct 2012 09:28:53 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> On Fri, Oct 05, 2012 at 05:01:30PM +0400, Dmitry Monakhov wrote:
> > > This WARN_ON is triggering on the truncate path...
> > Yeap, this is false positive one. We skip i_mutex on ext4_evict_inode
> > This is strange xfsstress 269'th should caught that for me.
> > I'll try to prepare workaround ASAP.
> 
> This is the patch which I'm currently testing.  If it passes I'll fold
> it into your patch.  Anyone see any problems with it?
> 
>    	     	     	       	    	     - Ted
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index f18e786..cd171dd 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -238,8 +238,10 @@ void ext4_evict_inode(struct inode *inode)
>  	 * protection against it
>  	 */
>  	sb_start_intwrite(inode->i_sb);
> +	mutex_lock(&inode->i_mutex);
>  	handle = ext4_journal_start(inode, ext4_blocks_for_truncate(inode)+3);
>  	if (IS_ERR(handle)) {
> +		mutex_unlock(&inode->i_mutex);
I mutex is not needed for journal start.
>  		ext4_std_error(inode->i_sb, PTR_ERR(handle));
>  		/*
>  		 * If we're going to skip the normal cleanup, we still need to
> @@ -256,12 +258,14 @@ void ext4_evict_inode(struct inode *inode)
>  	inode->i_size = 0;
>  	err = ext4_mark_inode_dirty(handle, inode);
>  	if (err) {
> +		mutex_unlock(&inode->i_mutex);
>  		ext4_warning(inode->i_sb,
>  			     "couldn't mark inode dirty (err %d)", err);
>  		goto stop_handle;
>  	}
>  	if (inode->i_blocks)
>  		ext4_truncate(inode);
> +	mutex_unlock(&inode->i_mutex);
Jiaying Zhang removed i_mutex from ext4_evict_inode here 8c0bec2151
because of false positive lockdep complains.
Let's just learn warning about evict_inode 

--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0001-ext4-fix-false-positive-warning-ext4_evict_inode.patch

>From edcd1dd6d8c4c17af09d429cc89e370bdc1e737a Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Fri, 5 Oct 2012 17:40:19 +0400
Subject: [PATCH] ext4: fix false positive warning ext4_evict_inode


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/page-io.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 1f5df21..68e896e 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -229,7 +229,8 @@ static void ext4_end_io_work(struct work_struct *work)
 int ext4_flush_unwritten_io(struct inode *inode)
 {
 	int ret;
-	WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex));
+	WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex) &&
+		     !(inode->i_state & I_FREEING));
 	ret = ext4_do_flush_completed_IO(inode, NULL);
 	ext4_unwritten_wait(inode);
 	return ret;
-- 
1.7.7.6


--=-=-=--
