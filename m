Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8D7261B92;
	Wed, 29 Apr 2026 15:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474905; cv=none; b=e4Rd1PUVPBL8GyQ/1aJUbAdxX+EONagtKvJCdxRqTt2w8E1+2MI1BPl5gxI38uW2i5vc8j1zLhzNlyNUscAjxbvBNNKvbb/r+RRQwXCTXAKc4Vq2yBcOKPNKpVfZQnXH+rORaVDsVMvmse+jrhNBF4xYoH8MzNo2ydBs7jnob0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474905; c=relaxed/simple;
	bh=+u3n1PQiT3tPfWI57V0WB+Vas0Xvxqfauog4x9kJGTU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GbgbaJp1VMIyG2HYx89Tb4I36o6ZJ0zqoMc2CfvjQ/PsFtddxvD8ntNDy/m3Hw2ArTJOtYt2vasEbKU+XtRIDB6rWOD+b1ry3aLzUA8Xqwvo1BSS7JxHmXfTJi6a2AfyPw9jLIAZdcTsu+qFWtVfYZWxtdeCmL/o6C1sD3ehwxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U2IfRr/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U2IfRr/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B6BC19425;
	Wed, 29 Apr 2026 15:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474905;
	bh=+u3n1PQiT3tPfWI57V0WB+Vas0Xvxqfauog4x9kJGTU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U2IfRr/dplB4IIkRNgKMndNzqutAWaKujXcD8JqAjTGZe8rSPP9kta8ZQaaVsiOUs
	 WEUuzMmXab9SZ220eeIwIdFhcxhycPcb5jytXeTm3MGu4Y96R0Wi7vZ5DXSXJypkfw
	 5EWhnF5s1npV9PmhH9VemPTzoqOpUysZAr0GgUfR+qpqiyoErQ4R+PC173Wmp5Dxxl
	 E2mg5dKYuL0KBkZRbmPlDMfRc+FiApxOdTdzgkk5GvVf69UaZN/nE187h32nj4ACaO
	 Rq1NJZjcMK6Ev+WsCLzEmvBa9v0XeozS+1+rDlLFjJM8gXt/MGiMf4+LYOFSTC4Npw
	 VqPLqVNK7+Ayg==
Date: Wed, 29 Apr 2026 08:01:44 -0700
Subject: [PATCH 2/4] fuse2fs: constrain iomap mapping cache size
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747215735.4110581.16684664454284252297.stgit@frogsfrogsfrogs>
In-Reply-To: <177747215686.4110581.16852917113451473539.stgit@frogsfrogsfrogs>
References: <177747215686.4110581.16852917113451473539.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Update the iomap config functions to handle the new iomap mapping cache
size restriction knob.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |    6 ++++--
 misc/fuse2fs.c    |    5 +++--
 2 files changed, 7 insertions(+), 4 deletions(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 56a79dd48c9f43..d07c576d31862a 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -7481,9 +7481,11 @@ static void op_iomap_config(fuse_req_t req,
 
 	FUSE4FS_CHECK_CONTEXT(req);
 
-	dbg_printf(ff, "%s: flags=0x%llx maxbytes=0x%llx\n", __func__,
+	dbg_printf(ff, "%s: flags=0x%llx maxbytes=0x%llx cache_maxbytes=0x%x\n",
+		   __func__,
 		   (unsigned long long)p->flags,
-		   (unsigned long long)p->maxbytes);
+		   (unsigned long long)p->maxbytes,
+		   p->cache_maxbytes);
 	fs = fuse4fs_start(ff);
 
 	cfg.flags |= FUSE_IOMAP_CONFIG_UUID;
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index e485c38bda41e8..232181bc170183 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -6753,9 +6753,10 @@ static int op_iomap_config(const struct fuse_iomap_config_params *p,
 
 	FUSE2FS_CHECK_CONTEXT(ff);
 
-	dbg_printf(ff, "%s: flags=0x%llx maxbytes=0x%llx\n", __func__,
+	dbg_printf(ff, "%s: flags=0x%llx maxbytes=0x%llx cache_maxbytes=%u\n", __func__,
 		   (unsigned long long)p->flags,
-		   (unsigned long long)p->maxbytes);
+		   (unsigned long long)p->maxbytes,
+		   p->cache_maxbytes);
 	fs = fuse2fs_start(ff);
 
 	cfg->flags |= FUSE_IOMAP_CONFIG_UUID;

