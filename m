Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022853DAAD5;
	Fri,  9 Oct 2026 21:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791582730; cv=none; b=HXw+EPiUcRzHBFLrjuil57bPbyEAXWag85YODqLRwoH5qRryqa8S+9Ox1BSyDuHLXN4c1UUb9BxPTCiiuPHEHT8eranBorrZGWqgXxv1XUqjKSbylreWZ8z8UtPL8/odmspRcZNXHualOFY3Clrh7UVYqC8iQ1+RHzBUA+lg4pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791582730; c=relaxed/simple;
	bh=6ycPluNe0bTUc/HK3YEQoODY7x78K9cOX57gHVQBOzA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fr5hvQOoXL+ahMjbft0aF47a6ttrufLzb/+v+ysfbC/VIwQ6y/vGqD1qqZHpdaSj3bl/X/PXMgndgxfv5HOJgrwah2I246/lDcWfT9l5hpX0/nvgV2bj8K59qNZYk7c/3IdVqMAQ+X7SFSmqpRUIQCNct8Y8OcfG+mLu8piiWLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XkutbXvi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XkutbXvi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883201F000FF;
	Fri,  9 Oct 2026 21:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791582729;
	bh=gjcqyGUwrNifIXoFBbzpJFXLtibXv9GMS1bitr5l05A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XkutbXviK2EaSQVrZebs5rGViNZG5aCOKwsWdNE5CPP53Tp9Q7ZwijAm27NiFUFvw
	 jyjZf8Pgarz335dqFLbRNgQ10GsoMfaSd2qBQDXHm+8O4Ky7FGrZbpT3aZ6ArUn0SG
	 jv6T7BJuekF4fJl/miqCGZgGL8h73UrLA0s6KHJqs+vWJSZtmsmB4f9s/hboPGeo4o
	 OVEXZL2EPTfUvZlqTfUgE/Bd6XgXCWRssmM5W7GBrWErQUDC9mmJEVbQ7f7aFthqtR
	 Vugo7HfU70ZS5prwJDutCtih0BkhMZ9IzdD3CKNK+0/wnpJVk5/RqNDueDmLKzeN0J
	 ITl1a7urOytog==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 09 Oct 2026 23:51:53 +0200
Subject: [PATCH 3/8] 9p: free the session after a grace period
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-work-fixes-rcu-v1-3-7446d2d335e6@kernel.org>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
In-Reply-To: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, 
 v9fs@lists.linux.dev, linux-trace-kernel@vger.kernel.org, 
 ntfs3@lists.linux.dev, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2478; i=brauner@kernel.org;
 h=from:subject:message-id; bh=6ycPluNe0bTUc/HK3YEQoODY7x78K9cOX57gHVQBOzA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSdTPzDlLS8ae2ZE6ZRC7ylnzx4Fls0M8B/3t4lO5T37
 FbbZHjVqKOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAik5sYGV6/O99pmD3nZuZR
 MePssy7XUixO3Y3puce48OhiRyvGJwaMDDtjn8/XFy4NyU0+dCIvTPdVOxNHzlu3Xyd/mLsf2Z/
 cxAMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

v9fs_vfs_get_link_dotl() reads ->cache from the v9fs_session_info in
sb->s_fs_info to decide whether the symlink target sits in the page
cache. It does that before it looks at the dentry, so it also does it in
rcu pathwalk mode. Without loose or metadata caching the dentries have
no ->d_revalidate() that would make the walk leave rcu mode before it
gets there.

v9fs_kill_super() frees the session and clears sb->s_fs_info without
waiting for a grace period. Right now a pathwalk can't still be in
v9fs_vfs_get_link_dotl() at that point, but only by accident. umount(2)
waits for a grace period in namespace_unlock() before it drops the
mount. And a mount whose last reference goes away elsewhere, like the
chdir out of a lazily unmounted directory, still gets a grace period
from bdi_unregister(). v9fs_fill_super() sets up a private bdi, so
generic_shutdown_super() unregisters it from kill_anon_super() and
bdi_remove_from_list() waits in synchronize_rcu_expedited() before
v9fs_kill_super() frees the session. That grace period protects the rcu
readers of bdi_list in the writeback code. It has nothing to do with
pathwalk.

Don't rely on it. Keep sb->s_fs_info and free the session after a grace
period.

Fixes: 712da38d134b ("9p: Enable symlink caching in page cache")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/9p/v9fs.h      | 1 +
 fs/9p/vfs_super.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index a462bcbfc7da..2ac863dc8446 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -137,6 +137,7 @@ struct v9fs_session_info {
 	struct list_head slist; /* list of sessions registered with v9fs */
 	struct rw_semaphore rename_sem;
 	long session_lock_timeout; /* retry interval for blocking locks */
+	struct rcu_head rcu;	/* v9fs_vfs_get_link_dotl() reads ->cache in rcu pathwalk */
 };
 
 #define NDENTRY_TIMEOUT_NEVER (-1U)
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 94d6b02c221b..79526044685c 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -173,8 +173,8 @@ static void v9fs_kill_super(struct super_block *s)
 
 	v9fs_session_cancel(v9ses);
 	v9fs_session_close(v9ses);
-	kfree(v9ses);
-	s->s_fs_info = NULL;
+	/* v9fs_vfs_get_link_dotl() may still read ->cache in rcu pathwalk */
+	kfree_rcu(v9ses, rcu);
 	p9_debug(P9_DEBUG_VFS, "exiting kill_super\n");
 }
 

-- 
2.53.0

