Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45571D6DA9;
	Wed, 22 Apr 2026 23:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776900372; cv=none; b=FgNx9YElbHuHQ7fM6A6fW6LbOF1R5NHjKHj4Pe+mC6XbZbepr7CxiE+ThUzRVy4MPVZ4jK3rdDztSSXrOJETBCua1GnIbuzKVnltNs1njdA6AGdAUwl/8ebb0Xh25YLYBaItW1I94RtY02fwemwune3Nb7sQ+zmgBPiSiEYmsxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776900372; c=relaxed/simple;
	bh=e0F23TlsTVNqph/gwND+L2yl6H6ZyCUo1QHw+FOvZYs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PZ7/vCyTE2nuQ3DA09J/hFObZpdPicH3HYvUr77+vjBkhMNlghvTjwhhiySnnWlH/xlIxjMU7g/lqap2FgiiXBcpjTwnQO8rTarFPlhruv2nAAql+BrYL7PCl4tPttxAjg41xzoNCoj7jPImw//6+q/xyOY0WV5+fVrqxpIZa70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mWplpYHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mWplpYHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42216C2BCAF;
	Wed, 22 Apr 2026 23:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776900372;
	bh=e0F23TlsTVNqph/gwND+L2yl6H6ZyCUo1QHw+FOvZYs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mWplpYHSWnJZK18UDSOT/dKt0RlKyCcB2+RcLTT56XcoB1UZpeZ3Llf3d+2OPWID2
	 0llej7nqQ0zNsLXWpb/jQG3jxTXMgqqRB/bWixtZmbXYJX3MhPKEp1EgdY9Ilt3HAg
	 dqH15iFkkE3wLn7nrdn6DCo0GYbolKTAiD+UNrQduRndNBzsj5f7k/gInZ2z/LeQyE
	 8xK0TRZaYTRy53NdHR4jpwZInnwksCikd23cu/CGT8PTPIJaNfGuW5NcHBSi8xCVHc
	 kR0D3QoqrEIMufdUVc/Krw7vIRf4WT08PRtiycq2PUtE48NM4wdg9FXwQnKqVlHz6l
	 2NeH2GTmLMdAA==
Date: Wed, 22 Apr 2026 16:26:11 -0700
Subject: [PATCH 10/10] debian: update packaging for fuse4fs service
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-ext4@vger.kernel.org, neal@gompa.dev, joannelkoong@gmail.com,
 miklos@szeredi.hu, bernd@bsbernd.com
Message-ID: <177689989717.3821326.3934400216489321372.stgit@frogsfrogsfrogs>
In-Reply-To: <177689989498.3821326.15497525132012299039.stgit@frogsfrogsfrogs>
References: <177689989498.3821326.15497525132012299039.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Update the Debian packaging code so that we can create fuse4fs service
containers.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 debian/e2fsprogs.install |    7 ++++++-
 debian/fuse4fs.install   |    3 +++
 debian/rules             |    3 +++
 3 files changed, 12 insertions(+), 1 deletion(-)
 mode change 100644 => 100755 debian/fuse4fs.install


diff --git a/debian/e2fsprogs.install b/debian/e2fsprogs.install
index 17a80e3922dcee..808474bcab1717 100755
--- a/debian/e2fsprogs.install
+++ b/debian/e2fsprogs.install
@@ -50,4 +50,9 @@ usr/share/man/man8/resize2fs.8
 usr/share/man/man8/tune2fs.8
 etc
 [linux-any] ${deb_udevudevdir}/rules.d
-[linux-any] ${deb_systemdsystemunitdir}
+[linux-any] ${deb_systemdsystemunitdir}/e2scrub@.service
+[linux-any] ${deb_systemdsystemunitdir}/e2scrub@.service
+[linux-any] ${deb_systemdsystemunitdir}/e2scrub_all.service
+[linux-any] ${deb_systemdsystemunitdir}/e2scrub_all.timer
+[linux-any] ${deb_systemdsystemunitdir}/e2scrub_fail@.service
+[linux-any] ${deb_systemdsystemunitdir}/e2scrub_reap.service
diff --git a/debian/fuse4fs.install b/debian/fuse4fs.install
old mode 100644
new mode 100755
index 17bdc90e33cb67..56048136c2b28b
--- a/debian/fuse4fs.install
+++ b/debian/fuse4fs.install
@@ -1,2 +1,5 @@
+#!/usr/bin/dh-exec
 usr/bin/fuse4fs
 usr/share/man/man1/fuse4fs.1
+[linux-any] ${deb_systemdsystemunitdir}/fuse4fs.socket
+[linux-any] ${deb_systemdsystemunitdir}/fuse4fs@.service
diff --git a/debian/rules b/debian/rules
index b680eb33ceac9e..d629e9d6915cfe 100755
--- a/debian/rules
+++ b/debian/rules
@@ -173,6 +173,9 @@ override_dh_installinfo:
 ifneq ($(DEB_HOST_ARCH_OS), hurd)
 override_dh_installsystemd:
 	dh_installsystemd -p e2fsprogs --no-restart-after-upgrade --no-stop-on-upgrade e2scrub_all.timer e2scrub_reap.service
+ifeq ($(SKIP_FUSE4FS),)
+	dh_installsystemd -p fuse4fs fuse4fs.socket
+endif
 endif
 
 override_dh_makeshlibs:

