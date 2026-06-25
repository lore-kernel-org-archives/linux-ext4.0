Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5E6315793
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416361; cv=none; b=bY5DJA+MBr6AhD5uCpYjIuuGt5A7OMrGVX0wE26BWPAHC7Um0hea/P8DcjiDbjNwr2MUM9rLOIG/Sw/eQH5WbwKjwZ65oQVy7voAQG7kVzzSx4+vr2Rqz3/m5UwROopBabU2OXWk56hxXaVUHrMr0P+7zRjQmN23ZctQITahgfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416361; c=relaxed/simple;
	bh=e0F23TlsTVNqph/gwND+L2yl6H6ZyCUo1QHw+FOvZYs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S346+K+1W288nQ6BMbHBjOUqf4Ez5bIfeMv+1MH6K0UuI322apz1mUdaHHK2VKl33VyLJGaEijLEdw/4CTTM4zZHk4FD4YxxWnNYY3dG5ZkJVvqqDZyCkDhFoIzcykMWk7Lwp4mFEqVUvixLXzSouwrxqgOGUs6XLQuc3oQfoPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tr+qgCkG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tr+qgCkG"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 789921F00A3A;
	Thu, 25 Jun 2026 19:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416360;
	bh=FFkFh4IZtn5RynzIGWvEFWO0XhG+86uwqpLKSaoWHpU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Tr+qgCkG3yx9QZUIaeQ11GNcEq/8PWgQ+VoB9+lVWG8HQgayY6GJxcyFxufhP44UV
	 9AEL0aIRyRr0hXZJQS31GGLYvWRrlF0UtzuaxK2aTYDXc9pH91ih4at5B3oaFjH2oO
	 owTHzAWcmq/4CNIZng6ANjrWDJ0RECKbhdiEHlISXliPGM6vPD/bnU5dQldUXVERly
	 SN4IE6gqeM/gCLtZ7UF4Z/30tvkhpxAcKf7p8GojVqB+0r2cpCgX4YEzT9T2+4OONn
	 jclnsFTOREThmiMRgvyFamm0kZxigTDwOmEna0HP4jTI9xHkTSumVH2BIGNg9qk0dR
	 U6UMjhLl9MI3A==
Date: Thu, 25 Jun 2026 12:39:20 -0700
Subject: [PATCH 10/10] debian: update packaging for fuse4fs service
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <178241606992.1810414.16666596094778986801.stgit@frogsfrogsfrogs>
In-Reply-To: <178241606773.1810414.1910863348345107939.stgit@frogsfrogsfrogs>
References: <178241606773.1810414.1910863348345107939.stgit@frogsfrogsfrogs>
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

