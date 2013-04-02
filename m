From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] fs: take i_mutex in __page_symlink()
Date: Tue, 02 Apr 2013 12:19:42 +0400
Message-ID: <87a9phs5sx.fsf@openvz.org>
References: <20130328140635.GA32635@thunk.org> <1364829822-18989-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: Theodore Ts'o <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1364829822-18989-1-git-send-email-tytso@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--=-=-=

On Mon,  1 Apr 2013 11:23:42 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> In Documentation/filesystems/Locking, it's documented that
> write_begin() is guaranteed to be called with i_mutex locked.  The
> function __page_symlink() was not taking i_mutex before calling
> pagecache_write_begin(), which will eventually result in the file
> system's write_begin()'s function getting called.
> 
> Other callers of pagecache_write_begin such as in fs/splice.c, call
> pagecache_write_begin() with i_mutex locked, so fix __page_symlink()
> to be consistent.
> 
> This was discovered by the addition of a new ext4 debugging assertion
> which checked to make sure i_mutex was locked before calling
> ext4_truncate().
> 
> Reported-by: Zheng Liu <gnehzuil.liu@gmail.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: Al Viro <viro@ZenIV.linux.org.uk>
> ---
> 
> Note: I plan to carry the following patch in the ext4 tree, unless
> someone objects or Al insists on carrying this in the vfs git tree.
> 
>  fs/namei.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 57ae9c8..548e57b 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -4035,8 +4035,10 @@ int __page_symlink(struct inode *inode, const char *symname, int len, int nofs)
>  		flags |= AOP_FLAG_NOFS;
>  
>  retry:
> +	mutex_lock(&inode->i_mutex);
>  	err = pagecache_write_begin(NULL, mapping, 0, len-1,
>  				flags, &page, &fsdata);
> +	mutex_unlock(&inode->i_mutex);
Noo. Please do no do that. i_mutex should being hold from write_begin() to
write_end() because:
1) both functions contains one logical block (critical section)
2) write_end() may update i_size
3) write_end() may call truncate

And since we know that we want to lock i_mutex here only for
convention purposes (no one can access this inode yet) let's do that
correct. Original Zheng's patch was much better.
I have following patch in my queue:

--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline; filename=0001-patch-ext4_symlink.patch.patch

>From c147d9ae5f9511f722a97179cd9f661e7e10417e Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Sun, 31 Mar 2013 17:35:38 +0400
Subject: [PATCH] patch ext4_symlink.patch


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/namei.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 57ae9c8..9dcdb27 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4034,6 +4034,7 @@ int __page_symlink(struct inode *inode, const char *symname, int len, int nofs)
 	if (nofs)
 		flags |= AOP_FLAG_NOFS;
 
+	mutex_lock(&inode->i_mutex);
 retry:
 	err = pagecache_write_begin(NULL, mapping, 0, len-1,
 				flags, &page, &fsdata);
@@ -4052,8 +4053,10 @@ retry:
 		goto retry;
 
 	mark_inode_dirty(inode);
+	mutex_unlock(&inode->i_mutex);
 	return 0;
 fail:
+	mutex_unlock(&inode->i_mutex);
 	return err;
 }
 
-- 
1.7.1


--=-=-=


>  	if (err)
>  		goto fail;
>  
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=--
