Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01A12FE066;
	Thu, 30 Apr 2026 21:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777583859; cv=none; b=gb+TyaAR13aLo6CsFCuyA6qvjJ4CIO+98SMKreqSpj8cotOVFAZp/V0K1/CsBQoandHRi47eBYF8ru7EJtrxd9sJo9BC1DSVnVPDhz/bCCh/rIY7xQnLXjpPn3VpLAMqhRBF5lZj3q9yQh5285I7pTlxNDz6uAJVySpbhhHRODA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777583859; c=relaxed/simple;
	bh=UNCbDvUix/6fcD3ir7GQaG2O0AXlLax60sqntYviLZM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dNxelXFsNz5Vwe9nCKTa3LZG/7SkzfYD4ecE/XgFc1dW9YWIDP6rDaH2WuCJWGfWPvs2TkQpDx3SkrVo72nnTpiFK14n8c6Zo0WJFKlcZg1EvfCzmvMSfATuaEQQE0y1G1cs6nxazvd/yZQ2FgUTlQ+lpqzChHmkaaQs6wi6PJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LMXm0wUi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LMXm0wUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784F6C2BCB3;
	Thu, 30 Apr 2026 21:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777583858;
	bh=UNCbDvUix/6fcD3ir7GQaG2O0AXlLax60sqntYviLZM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LMXm0wUiMfMZNpeVuWyeT139GgaLa+Y9MDxCr0aLohFqdUFGIQkwikXMYk/qK4nGK
	 jjNrMFGpOncNWJchh3wiObTATYYcNF+lPZGsm5lIthXF5WMhDsN1UBZNXOMoDWgs8A
	 EAqFQUr13RgD5LC8Cjkvimy4J6Q6qLi/pG+shptnNYmrct2dZqa1xfaTWjtzhMt/xl
	 LS+I1wFqf7vQtKwFFgiILy4tZHzGB5H/+nmLcw+aNJZ4KoKLNuhAI35WZQWGeWcS92
	 RMMAbT1zccRhwowPhfBm8VacXoe6xmGy4tsOoT9KVTnQ4crZ3U9Ql8RdakRlgz5ngR
	 cNlVXAQp4KAkg==
Date: Thu, 30 Apr 2026 14:17:37 -0700
Subject: [PATCH 10/13] mount_service: allow installation as a setuid program
From: "Darrick J. Wong" <djwong@kernel.org>
To: bernd@bsbernd.com, djwong@kernel.org
Cc: linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-ext4@vger.kernel.org, miklos@szeredi.hu, neal@gompa.dev,
 joannelkoong@gmail.com
Message-ID: <177758363712.1314717.16316935834409248821.stgit@frogsfrogsfrogs>
In-Reply-To: <177758363484.1314717.11777978893472254088.stgit@frogsfrogsfrogs>
References: <177758363484.1314717.11777978893472254088.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Allow installation of the mount service helper as a setuid program so
that regular users can access containerized filesystem drivers.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 README.md              |    3 +++
 test/ci-build.sh       |   14 ++++++++++++++
 util/install_helper.sh |    6 ++++++
 util/meson.build       |    3 ++-
 4 files changed, 25 insertions(+), 1 deletion(-)


diff --git a/README.md b/README.md
index 6cf23cd870109a..92b85522e7890a 100644
--- a/README.md
+++ b/README.md
@@ -98,6 +98,9 @@ Security implications
 
 The *fusermount3* program is installed setuid root. This is done to
 allow normal users to mount their own filesystem implementations.
+If built, the *fuservicemount3* program will also be installed setuid
+root so that normal users can access containerized filesystem
+implementations.
 
 To limit the harm that malicious users can do this way, *fusermount3*
 enforces the following limitations:
diff --git a/test/ci-build.sh b/test/ci-build.sh
index 8b019a0b5e52c1..f6e6c3d9de4e4e 100755
--- a/test/ci-build.sh
+++ b/test/ci-build.sh
@@ -60,11 +60,18 @@ non_sanitized_build()
 
         # libfuse will first try the install path and then system defaults
         sudo chmod 4755 ${PREFIX_DIR}/bin/fusermount3
+        test -x "${PREFIX_DIR}/sbin/fuservicemount3" && \
+                sudo chmod 4755 ${PREFIX_DIR}/sbin/fuservicemount3
 
         # also needed for some of the tests
         sudo chown root:root util/fusermount3
         sudo chmod 4755 util/fusermount3
 
+        if [ -x util/fuservicemount3 ]; then
+                sudo chown root:root util/fuservicemount3
+                sudo chmod 4755 util/fuservicemount3
+        fi
+
         ${TEST_CMD}
         popd
         rm -fr build-${CC}
@@ -101,11 +108,18 @@ sanitized_build()
     ninja
     sudo env PATH=$PATH ninja install
     sudo chmod 4755 ${PREFIX_DIR}/bin/fusermount3
+    test -x "${PREFIX_DIR}/sbin/fuservicemount3" && \
+        sudo chmod 4755 ${PREFIX_DIR}/sbin/fuservicemount3
 
     # also needed for some of the tests
     sudo chown root:root util/fusermount3
     sudo chmod 4755 util/fusermount3
 
+    if [ -x util/fuservicemount3 ]; then
+        sudo chown root:root util/fuservicemount3
+        sudo chmod 4755 util/fuservicemount3
+    fi
+
     # Test as root and regular user
     sudo env PATH=$PATH ${TEST_CMD}
     # Cleanup temporary files (since they are now owned by root)
diff --git a/util/install_helper.sh b/util/install_helper.sh
index 76f2b47fe6c8f9..4c6f9dc3dc70aa 100755
--- a/util/install_helper.sh
+++ b/util/install_helper.sh
@@ -11,6 +11,7 @@ bindir="$2"
 udevrulesdir="$3"
 useroot="$4"
 initscriptdir="$5"
+sbindir="$6"
 
 # Both sysconfdir and bindir are absolute paths (since they are joined
 # with --prefix in meson.build), but need to be interpreted relative
@@ -31,6 +32,11 @@ if $useroot; then
     chown root:root "${DESTDIR}${bindir}/fusermount3"
     chmod u+s "${DESTDIR}${bindir}/fusermount3"
 
+    if [ -e "${DESTDIR}${sbindir}/fuservicemount3" ]; then
+        chown root:root "${DESTDIR}${sbindir}/fuservicemount3"
+        chmod u+s "${DESTDIR}${sbindir}/fuservicemount3"
+    fi
+
     if test ! -e "${DESTDIR}/dev/fuse"; then
         mkdir -p "${DESTDIR}/dev"
         mknod "${DESTDIR}/dev/fuse" -m 0666 c 10 229
diff --git a/util/meson.build b/util/meson.build
index 85b54d5d322dcb..e15dd9bbb0c486 100644
--- a/util/meson.build
+++ b/util/meson.build
@@ -46,4 +46,5 @@ meson.add_install_script('install_helper.sh',
                          join_paths(get_option('prefix'), get_option('bindir')),
                          udevrulesdir,
                          '@0@'.format(get_option('useroot')),
-                         get_option('initscriptdir'))
+                         get_option('initscriptdir'),
+                         join_paths(get_option('prefix'), get_option('sbindir')))

