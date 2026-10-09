Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8886E36F8E9;
	Fri,  9 Oct 2026 21:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791582728; cv=none; b=NpddnlycLHDxFEW39l2rosvazgiQouQhd1WwMGf2H1Pa72PeuFFE7+nONbPHvzkScxss5/QvoKOcv0sKTsV04Oz5G81arNIn9Cff1HjfII/HUtdbprMBEZ80lxTIo+kihb1yIirzSL7K+SW0nG+bT/1QT2ZEKji5tpEmt2fA7U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791582728; c=relaxed/simple;
	bh=lpzqFSMOgh0RdKZDr1ZF44KLdQSV9ZDgNWjIUUMEQq0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Q09LzcB4o9nIPAM/M1JyPRm9KdnLkHoqsgc88D8UDrm0afkDmb8+Px8MwwnClEcLTYrqjjZAvl4tstJGKPWmmLZ901DHyBA+1B/2nWkGQGxQdzaWrIrU3k315GcuNDMQbxRPAv5YBw6t8CIZeRDtfvRsyYehR8cBUzWOV1gPCjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fzbujM4n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fzbujM4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FDF1F00898;
	Fri,  9 Oct 2026 21:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791582727;
	bh=nI37YC4qBuqsocK5dSSB5y0YPtX8sBZOzXLWK/m+fjE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fzbujM4nVnDbI/jzXB8BomlEWhpEdxRU+QPQwiVAO2z8pc4fanVxMQrWSSnVEVc0c
	 Q+tumzjZxOj7KbiL+d8je56GKO+tQB9ZNZ18AiYkjpqifqknZCh5cQOI149to1bBdm
	 /1zn/RzBrABJaMx1DVNhauxkZhridZh8JmI7UV+SVH3iDqeNxGIlZHada/N0rMUZcn
	 J/MxGGNMsPF3rnADxb/HC/eo41/DMShJQaQzokaBSlYH4Cj0wG4tley5n7Ofb+nwIe
	 Y0vgVms2UCRFj00DDKoNa5XP0VyeAHtr/4ofL40NRL9EjO4xrfZi93jWbYroJcuQtC
	 PpLcTx6nopi4Q==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 09 Oct 2026 23:51:52 +0200
Subject: [PATCH 2/8] afs: free the super info after a grace period
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-work-fixes-rcu-v1-2-7446d2d335e6@kernel.org>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
In-Reply-To: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, 
 v9fs@lists.linux.dev, linux-trace-kernel@vger.kernel.org, 
 ntfs3@lists.linux.dev, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2452; i=brauner@kernel.org;
 h=from:subject:message-id; bh=lpzqFSMOgh0RdKZDr1ZF44KLdQSV9ZDgNWjIUUMEQq0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSdTPzjJpBd9Nf4QKzxVYWj0+/c/bLiNLPyLrM/v097l
 RYsClt3p6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAi6z4wMjztOWF30OGydVJ6
 vsv1XqHo9YwOTCsc5xz/+PR0RszPM9cZGfa+/3LKaoZp+dFslv8tMsI8yoqJSvtvKbbzf9/xeF7
 wanYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

afs_atcell_get_link() resolves the @cell and .@cell symlinks of a
dynamic root in rcu pathwalk mode. Before it looks at the dentry it gets
the afs_net through afs_i2net(), which reads ->net_ns from the
afs_super_info in sb->s_fs_info. The @cell dentries are kept around when
unused and the dynamic root has no ->d_revalidate(), so a lookup that
finds @cell in the dcache gets to ->get_link() in rcu mode.

afs_kill_super() frees the afs_super_info with a plain kfree() in
afs_destroy_sbi(). Right now a pathwalk can't still be in
afs_atcell_get_link() at that point, but only by accident. umount(2)
waits for a grace period in namespace_unlock() before it drops the
mount. And a mount whose last reference goes away elsewhere, like the
chdir out of a lazily unmounted directory, still gets a grace period
from bdi_unregister(). afs_fill_super() sets up a private bdi, so
generic_shutdown_super() unregisters it from kill_anon_super() and
bdi_remove_from_list() waits in synchronize_rcu_expedited() before
afs_destroy_sbi() runs. That grace period protects the rcu readers of
bdi_list in the writeback code. It has nothing to do with pathwalk.

Don't rely on it and free the afs_super_info after a grace period.

Fixes: 30bca65bbbae ("afs: Make /afs/@cell and /afs/.@cell symlinks")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/afs/internal.h | 2 ++
 fs/afs/super.c    | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 330654ed16ec..3282d5d6e1c0 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -251,6 +251,8 @@ struct afs_super_info {
 	struct afs_volume	*volume;	/* volume record */
 	enum afs_flock_mode	flock_mode:8;	/* File locking emulation mode */
 	bool			dyn_root;	/* True if dynamic root */
+	/* afs_atcell_get_link() reads ->net_ns in rcu pathwalk */
+	struct rcu_head		rcu;
 };
 
 static inline struct afs_super_info *AFS_FS_S(struct super_block *sb)
diff --git a/fs/afs/super.c b/fs/afs/super.c
index 82bb713825a0..33b195821e36 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -523,7 +523,7 @@ static void afs_destroy_sbi(struct afs_super_info *as)
 		afs_put_volume(as->volume, afs_volume_trace_put_destroy_sbi);
 		afs_unuse_cell(as->cell, afs_cell_trace_unuse_sbi);
 		put_net(as->net_ns);
-		kfree(as);
+		kfree_rcu(as, rcu);
 	}
 }
 

-- 
2.53.0

