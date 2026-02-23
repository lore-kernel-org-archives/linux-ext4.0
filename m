Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A16337F72C;
	Mon, 23 Feb 2026 23:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771889544; cv=none; b=uYRCAOPgjPBLqz6Nm+42uPJPl66WOjN3Iz8LmiURtgsOX0oFKDfMowaK6Omb+aOFfGIp2ao/qrv1ZmMiMllzfrjgTOcWE7UdG6/eiD8UpsWyexj6scbu9FtmTUoBlX5dzfdSWVnIgbPC6zEYcnF2xtoIrqmypDP5wY+bcRgI5UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771889544; c=relaxed/simple;
	bh=FH6ODyJsYUv8YKrVXc31OxDGkjUJjRlW6xBoMclfkSI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h4ps3UR2gxTbL6bbE/m3w3fbH9jmaqN/AK/fNlsOUn2cOSXrORK7PhqwU4QQlQPETNPiy9O+PeH7AsOx6ntQTBqEk6923CVtOJpZdkHcXjZpjS+i2zRdxzX2uvSYFABRZWxkLiPzgLxsGp7NXYdRhJKtgSlcJrozdHyZuKFlCtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ym9J92lp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ym9J92lp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09420C116C6;
	Mon, 23 Feb 2026 23:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771889544;
	bh=FH6ODyJsYUv8YKrVXc31OxDGkjUJjRlW6xBoMclfkSI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ym9J92lpnPMaJ9ex1ZTUIJ3FHO20tR/emgJS/XlYMVzI+GVRk9UtiYgdmZ4SIhhGD
	 Nd1ljVDlHnxSBQdgGLHPBoaY+i/tnYlQ0eSmhxETI2ij7TDutQCFHPmWgKbiAKCydx
	 hW4tNhNHRHqtA31JInoKOlpBfozBjOkzYucxDzVWCm/bGko+G4cTZYsjxvtdEzBY0G
	 3H/RfdnMOU7uFo2uqjdYcLJcHYzPeAa3armmPV6SIxCKEDjygBLq+YEamxydqsEyH0
	 MCIWvlOd8NhisKWCuOa9EEBVIeEgG1lhn7qQUmKGfT8R6Fu69YEGln2nrcLUb7dyqK
	 bfADbO6IEylFw==
Date: Mon, 23 Feb 2026 15:32:23 -0800
Subject: [PATCH 1/2] libfuse: add strictatime/lazytime mount options
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, bschubert@ddn.com
Cc: bernd@bsbernd.com, miklos@szeredi.hu, neal@gompa.dev,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 bpf@vger.kernel.org, joannelkoong@gmail.com
Message-ID: <177188740792.3941738.13720566344426625617.stgit@frogsfrogsfrogs>
In-Reply-To: <177188740769.3941738.15253689862800289077.stgit@frogsfrogsfrogs>
References: <177188740769.3941738.15253689862800289077.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

fuse+iomap leaves the kernel completely in charge of handling
timestamps.  Add the lazytime and strictatime mount options so that
fuse+iomap filesystems can take advantage of those options.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 lib/mount.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)


diff --git a/lib/mount.c b/lib/mount.c
index c82fd4c293ce66..1b20c4eab92d46 100644
--- a/lib/mount.c
+++ b/lib/mount.c
@@ -117,9 +117,16 @@ static const struct fuse_opt fuse_mount_opts[] = {
 	FUSE_OPT_KEY("dirsync",			KEY_KERN_FLAG),
 	FUSE_OPT_KEY("noatime",			KEY_KERN_FLAG),
 	FUSE_OPT_KEY("nodiratime",		KEY_KERN_FLAG),
-	FUSE_OPT_KEY("nostrictatime",		KEY_KERN_FLAG),
 	FUSE_OPT_KEY("symfollow",		KEY_KERN_FLAG),
 	FUSE_OPT_KEY("nosymfollow",		KEY_KERN_FLAG),
+#ifdef MS_LAZYTIME
+	FUSE_OPT_KEY("lazytime",		KEY_KERN_FLAG),
+	FUSE_OPT_KEY("nolazytime",		KEY_KERN_FLAG),
+#endif
+#ifdef MS_STRICTATIME
+	FUSE_OPT_KEY("strictatime",		KEY_KERN_FLAG),
+	FUSE_OPT_KEY("nostrictatime",		KEY_KERN_FLAG),
+#endif
 	FUSE_OPT_END
 };
 
@@ -189,11 +196,18 @@ static const struct mount_flags mount_flags[] = {
 	{"noatime", MS_NOATIME,	    1},
 	{"nodiratime",	    MS_NODIRATIME,	1},
 	{"norelatime",	    MS_RELATIME,	0},
-	{"nostrictatime",   MS_STRICTATIME,	0},
 	{"symfollow",	    MS_NOSYMFOLLOW,	0},
 	{"nosymfollow",	    MS_NOSYMFOLLOW,	1},
 #ifndef __NetBSD__
 	{"dirsync", MS_DIRSYNC,	    1},
+#endif
+#ifdef MS_LAZYTIME
+	{"lazytime",	    MS_LAZYTIME,	1},
+	{"nolazytime",	    MS_LAZYTIME,	0},
+#endif
+#ifdef MS_STRICTATIME
+	{"strictatime",	    MS_STRICTATIME,	1},
+	{"nostrictatime",   MS_STRICTATIME,	0},
 #endif
 	{NULL,	    0,		    0}
 };

