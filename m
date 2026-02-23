Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE3637F727;
	Mon, 23 Feb 2026 23:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771888716; cv=none; b=g0Vj2Y7H5JG6yklkEkl4v+wT3CD+0Kdx37ben9sMPndA3/ELxRhXM6cMXjwqHGkmhvrcq9JQiqBNouOYzyYLcsXrcUUGG23f7HdNgKN8X+zSQzWDfLtLNrNFpTLyZJsDgabgkZM9/zK4sGsZxLlPB5AqIhpgLsg1eCACqcSP4Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771888716; c=relaxed/simple;
	bh=hZZ0Nqf3pc2crIGZaHibR4tu96NpNUTg1wVtR82zV8o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YII16AjHQLv3U9rd/k84q3YBQTUUNMxv3g0PigKwfdpSpz51u0G/y+tK3RCikPO0FD2rupnXNzMNaV2fJV1VnWS0bVJsTrkeB5LnUo4JcSGF+gHHZUkrUtGSfUspxXJoYbPhgZ68s9tb0evoyK+H4S9RgbjR+GYHIxEc9Ws8g2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uRA2kjHk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uRA2kjHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D42C116C6;
	Mon, 23 Feb 2026 23:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771888716;
	bh=hZZ0Nqf3pc2crIGZaHibR4tu96NpNUTg1wVtR82zV8o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uRA2kjHk8AlV+J6L1uXgdGsiVDcO8SLlmegVI8PB9+O0HR8TEcEdr6zCL1DbcPlNL
	 zXK4md+a0ILw/7KHPuo986r0Cv6perSzPRFeaH5SkNodaZl+89UrGhUwsfEFGr8dQV
	 Wx+JcAgZDWgBFvMWvpGwTdd+smlBLOeADgJbfdjV0Dks3EtaJj8X26vAuZp9Clfk79
	 YPqdBcQJnNSjOVyWWztY5rZtOG9/T8a4CG333Zg5ST4WTZ3kLIn9SlgFJqFhdyujqr
	 vmPQub57o8lxznUkdhu9Mha8NwFI3vM6cs9L/e8Dc3P1otk6BmcfVFXWrYMt6wwTBo
	 rSiisI4ZVEPow==
Date: Mon, 23 Feb 2026 15:18:35 -0800
Subject: [PATCH 2/9] fuse: force a ctime update after a fileattr_set call when
 in iomap mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: miklos@szeredi.hu, djwong@kernel.org
Cc: joannelkoong@gmail.com, bpf@vger.kernel.org, bernd@bsbernd.com,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Message-ID: <177188735569.3937167.11649393171015153108.stgit@frogsfrogsfrogs>
In-Reply-To: <177188735474.3937167.17022266174919777880.stgit@frogsfrogsfrogs>
References: <177188735474.3937167.17022266174919777880.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In iomap mode, the kernel is in charge of driving ctime updates to
the fuse server and ignores updates coming from the fuse server.
Therefore, when someone calls fileattr_set to change file attributes, we
must force a ctime update.

Found by generic/277.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/fuse/ioctl.c |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/fs/fuse/ioctl.c b/fs/fuse/ioctl.c
index fdc175e93f7474..07529db21fb781 100644
--- a/fs/fuse/ioctl.c
+++ b/fs/fuse/ioctl.c
@@ -546,8 +546,13 @@ int fuse_fileattr_set(struct mnt_idmap *idmap,
 	struct fuse_file *ff;
 	unsigned int flags = fa->flags;
 	struct fsxattr xfa;
+	struct file_kattr old_ma = { };
+	bool is_wb = (fuse_get_cache_mask(inode) & STATX_CTIME);
 	int err;
 
+	if (is_wb)
+		vfs_fileattr_get(dentry, &old_ma);
+
 	ff = fuse_priv_ioctl_prepare(inode);
 	if (IS_ERR(ff))
 		return PTR_ERR(ff);
@@ -571,6 +576,12 @@ int fuse_fileattr_set(struct mnt_idmap *idmap,
 
 cleanup:
 	fuse_priv_ioctl_cleanup(inode, ff);
+	/*
+	 * If we cache ctime updates and the fileattr changed, then force a
+	 * ctime update.
+	 */
+	if (is_wb && memcmp(&old_ma, fa, sizeof(old_ma)))
+		fuse_update_ctime(inode);
 
 	return err;
 }

