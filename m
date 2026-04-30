Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BA4175A5;
	Thu, 30 Apr 2026 21:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777583764; cv=none; b=PV5y7EEV32FNwn38wHVnLklvo7OHcPB2u0p9rL6Frzwyq3f1l9trUuDDqzlx0JvmqePvK6neefoZoskVE12wyv7JgpzdwXnY3VqPMQwhkfqsEry3cPWuio1J2DXvIN3VQg9qYxG5L4oWbrJL2NwL5abB3tSa4vTi9H4YDjE/vaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777583764; c=relaxed/simple;
	bh=zBeHADBPSY0fHb6BGs6WaRFYGtkHkmbZ2SWR3rfLHW8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iYVJS8sfnF9fuKDYVXJBfPX9XrBkJV8rfQmmmzrM01jR5qCAr3lfw9OVvK8ybzBwcMU0Hj5YIeLtCzz5hV0N3OoErBrek3klduixbs74O7bcIl1KqepVzFFPNgk2qJppB0lHLmpk0n49Pwzkf8LSQfvwtN8agrSQbL/G0dy55lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VNG85iN9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VNG85iN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3321C2BCB3;
	Thu, 30 Apr 2026 21:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777583764;
	bh=zBeHADBPSY0fHb6BGs6WaRFYGtkHkmbZ2SWR3rfLHW8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VNG85iN9F8Qbce/EhnjlzyBexJjA8BKNDNXB3AejldSIcIRcNwutwXEuU+l/piyxC
	 56nUPbG/oGtJ7UhhosaRPnHyCQY46KTcsmw3Vp3/G5/BFCrrh1N/9/qxM16HF8Vl9p
	 O+wlS902u1FMBOxSXcxfeDeHpbA+CZGRoIQKfbjGaZSCOQ81aWM9+nPef3zUBtyHPQ
	 0MFtMCEAt5D5K9E2TSWcqsxDglzfB5AO5VSgO+J1recV2rBjPeEGlvFYDX3DQK5DOh
	 22xCw2Pbcmn8yjIJqthHOSTO9BQsWS4prdYkZSvUKzT0D3GsR8xgTd4s51qmJSX0Ys
	 9BgK5o0D+Kehw==
Date: Thu, 30 Apr 2026 14:16:04 -0700
Subject: [PATCH 04/13] mount_service: use the new mount api for the mount
 service
From: "Darrick J. Wong" <djwong@kernel.org>
To: bernd@bsbernd.com, djwong@kernel.org
Cc: linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-ext4@vger.kernel.org, miklos@szeredi.hu, neal@gompa.dev,
 joannelkoong@gmail.com
Message-ID: <177758363604.1314717.1565554096353858559.stgit@frogsfrogsfrogs>
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

Use the new fsopen/fsmount system calls to mount the filesystem so that
we get somewhat better diagnostics if something gets screwed up.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 lib/fuse_i.h         |    3 
 meson.build          |   15 ++
 util/mount_service.c |  332 +++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 346 insertions(+), 4 deletions(-)


diff --git a/lib/fuse_i.h b/lib/fuse_i.h
index 0ca13d132585f6..1710a872e19c72 100644
--- a/lib/fuse_i.h
+++ b/lib/fuse_i.h
@@ -215,6 +215,9 @@ struct fuse_chan *fuse_chan_get(struct fuse_chan *ch);
  */
 void fuse_chan_put(struct fuse_chan *ch);
 
+/* Special return value for mount functions to indicate fallback to fusermount3 is needed */
+#define FUSE_MOUNT_FALLBACK_NEEDED (-2)
+
 struct mount_opts *parse_mount_opts(struct fuse_args *args);
 void destroy_mount_opts(struct mount_opts *mo);
 void fuse_mount_version(void);
diff --git a/meson.build b/meson.build
index 66425a0d4cc16f..c8326b79fcee8f 100644
--- a/meson.build
+++ b/meson.build
@@ -135,6 +135,21 @@ special_funcs = {
 	int main(int argc, char *argv[]) {
           return SD_LISTEN_FDS_START;
 	}
+    ''',
+    'new_mount_api': '''
+       #define _GNU_SOURCE
+       #include <sys/mount.h>
+       #include <linux/mount.h>
+       #include <unistd.h>
+       #include <fcntl.h>
+
+       int main(void) {
+           int fsfd = fsopen("fuse", FSOPEN_CLOEXEC);
+           int res = fsconfig(fsfd, FSCONFIG_SET_STRING, "source", "test", 0);
+           int mntfd = fsmount(fsfd, FSMOUNT_CLOEXEC, 0);
+           res = move_mount(mntfd, "", AT_FDCWD, "/mnt", MOVE_MOUNT_F_EMPTY_PATH | MOVE_MOUNT_T_EMPTY_PATH);
+           return 0;
+       }
     '''
 }
 
diff --git a/util/mount_service.c b/util/mount_service.c
index a43ff79c7bfb6f..f2a515a2cc3b37 100644
--- a/util/mount_service.c
+++ b/util/mount_service.c
@@ -28,6 +28,11 @@
 #include <sys/ioctl.h>
 #include <linux/fs.h>
 
+#ifdef HAVE_NEW_MOUNT_API
+#include <sys/mount.h>
+#include <linux/mount.h>
+#endif
+
 #include "mount_util.h"
 #include "util.h"
 #include "fuse_i.h"
@@ -68,6 +73,9 @@ struct mount_service {
 	/* fd for mount point */
 	int mountfd;
 
+	/* fd for fsopen */
+	int fsopenfd;
+
 	/* did we actually mount successfully? */
 	bool mounted;
 
@@ -187,6 +195,7 @@ static int mount_service_init(struct mount_service *mo, int argc, char *argv[])
 	mo->argvfd = -1;
 	mo->fusedevfd = -1;
 	mo->mountfd = -1;
+	mo->fsopenfd = -1;
 
 	for (i = 0; i < argc; i++) {
 		if (!strcmp(argv[i], "-t") && i + 1 < argc) {
@@ -782,6 +791,20 @@ static inline const char *fsname(const struct mount_service *mo)
 	return mo->fuseblk ? "fuseblk" : "fuse";
 }
 
+#ifdef HAVE_NEW_MOUNT_API
+static void try_fsopen(struct mount_service *mo)
+{
+	/*
+	 * As of Linux 7.0 you can pass subtypes to fsopen, but the manpage for
+	 * fsopen only says that you can pass any value of the second column of
+	 * /proc/filesystems into fsopen.
+	 */
+	mo->fsopenfd = fsopen(fsname(mo), FSOPEN_CLOEXEC);
+}
+#else
+# define try_fsopen(...)	((void)0)
+#endif
+
 static int mount_service_handle_fsopen_cmd(struct mount_service *mo,
 					   const struct fuse_service_packet *p,
 					   size_t psz)
@@ -820,15 +843,52 @@ static int mount_service_handle_fsopen_cmd(struct mount_service *mo,
 	}
 	mo->fsopened = true;
 
+	/* If this fails we fall back on mount(); oc->value is mutated */
+	try_fsopen(mo);
 	return mount_service_send_reply(mo, 0);
 }
 
+#ifdef HAVE_NEW_MOUNT_API
+/* callers must preserve errno */
+static void emit_fsconfig_messages(const struct mount_service *mo)
+{
+	uint8_t buf[BUFSIZ];
+	ssize_t sz;
+
+	while ((sz = read(mo->fsopenfd, buf, sizeof(buf) - 1)) >= 1) {
+		if (buf[sz - 1] == '\n')
+			buf[--sz] = '\0';
+		else
+			buf[sz] = '\0';
+
+		if (!*buf)
+			continue;
+
+		switch (buf[0]) {
+		case 'e':
+			fprintf(stderr, "Error: %s\n", buf + 2);
+			break;
+		case 'w':
+			fprintf(stderr, "Warning: %s\n", buf + 2);
+			break;
+		case 'i':
+			fprintf(stderr, "Info: %s\n", buf + 2);
+			break;
+		default:
+			fprintf(stderr, " %s\n", buf);
+			break;
+		}
+	}
+}
+#endif
+
 static int mount_service_handle_source_cmd(struct mount_service *mo,
 					   const struct fuse_service_packet *p,
 					   size_t psz)
 {
 	struct fuse_service_string_command *oc =
 			container_of(p, struct fuse_service_string_command, p);
+	char *source;
 
 	if (psz < sizeof_fuse_service_string_command(1)) {
 		fprintf(stderr, "%s: source command too small\n",
@@ -848,8 +908,8 @@ static int mount_service_handle_source_cmd(struct mount_service *mo,
 		return mount_service_send_reply(mo, EINVAL);
 	}
 
-	mo->source = strdup(oc->value);
-	if (!mo->source) {
+	source = strdup(oc->value);
+	if (!source) {
 		int error = errno;
 
 		fprintf(stderr, "%s: alloc source string: %s\n",
@@ -857,6 +917,23 @@ static int mount_service_handle_source_cmd(struct mount_service *mo,
 		return mount_service_send_reply(mo, error);
 	}
 
+#ifdef HAVE_NEW_MOUNT_API
+	if (mo->fsopenfd >= 0) {
+		int ret = fsconfig(mo->fsopenfd, FSCONFIG_SET_STRING, "source",
+			       oc->value, 0);
+		if (ret) {
+			int error = errno;
+
+			fprintf(stderr, "%s: fsconfig source: %s\n",
+				mo->msgtag, strerror(error));
+			emit_fsconfig_messages(mo);
+			free(source);
+			return mount_service_send_reply(mo, error);
+		}
+	}
+#endif
+
+	mo->source = source;
 	return mount_service_send_reply(mo, 0);
 }
 
@@ -866,6 +943,9 @@ static int mount_service_handle_mntopts_cmd(struct mount_service *mo,
 {
 	struct fuse_service_string_command *oc =
 			container_of(p, struct fuse_service_string_command, p);
+	char *tokstr = oc->value;
+	char *tok, *savetok;
+	char *mntopts;
 
 	if (psz < sizeof_fuse_service_string_command(1)) {
 		fprintf(stderr, "%s: mount options command too small\n",
@@ -885,8 +965,8 @@ static int mount_service_handle_mntopts_cmd(struct mount_service *mo,
 		return mount_service_send_reply(mo, EINVAL);
 	}
 
-	mo->mntopts = strdup(oc->value);
-	if (!mo->mntopts) {
+	mntopts = strdup(oc->value);
+	if (!mntopts) {
 		int error = errno;
 
 		fprintf(stderr, "%s: alloc mount options string: %s\n",
@@ -894,6 +974,47 @@ static int mount_service_handle_mntopts_cmd(struct mount_service *mo,
 		return mount_service_send_reply(mo, error);
 	}
 
+	/* strtok_r mutates tokstr aka oc->value */
+	while ((tok = strtok_r(tokstr, ",", &savetok)) != NULL) {
+		char *equals = strchr(tok, '=');
+		char oldchar = 0;
+
+		if (equals) {
+			oldchar = *equals;
+			*equals = 0;
+		}
+
+#ifdef HAVE_NEW_MOUNT_API
+		if (mo->fsopenfd >= 0) {
+			int ret;
+
+			if (equals)
+				ret = fsconfig(mo->fsopenfd,
+					       FSCONFIG_SET_STRING, tok,
+					       equals + 1, 0);
+			else
+				ret = fsconfig(mo->fsopenfd,
+					       FSCONFIG_SET_FLAG, tok,
+					       NULL, 0);
+			if (ret) {
+				int error = errno;
+
+				fprintf(stderr, "%s: set mount option: %s\n",
+					mo->msgtag, strerror(error));
+				emit_fsconfig_messages(mo);
+				free(mntopts);
+				return mount_service_send_reply(mo, error);
+			}
+		}
+#endif
+
+		if (equals)
+			*equals = oldchar;
+
+		tokstr = NULL;
+	}
+
+	mo->mntopts = mntopts;
 	return mount_service_send_reply(mo, 0);
 }
 
@@ -1181,6 +1302,201 @@ static int mount_service_regular_mount(struct mount_service *mo,
 	return ret;
 }
 
+#ifdef HAVE_NEW_MOUNT_API
+struct ms_to_mount_map {
+	unsigned long ms_flag;
+	unsigned int mount_attr_flag;
+};
+
+static const struct ms_to_mount_map attrs[] = {
+	{ MS_RDONLY,		MOUNT_ATTR_RDONLY },
+	{ MS_NOSUID,		MOUNT_ATTR_NOSUID },
+	{ MS_NODEV,		MOUNT_ATTR_NODEV },
+	{ MS_NOEXEC,		MOUNT_ATTR_NOEXEC },
+	{ MS_RELATIME,		MOUNT_ATTR_RELATIME },
+	{ MS_NOATIME,		MOUNT_ATTR_NOATIME },
+	{ MS_STRICTATIME,	MOUNT_ATTR_STRICTATIME },
+	{ MS_NODIRATIME,	MOUNT_ATTR_NODIRATIME },
+#ifdef MOUNT_ATTR_NOSYMFOLLOW
+	{ MS_NOSYMFOLLOW,	MOUNT_ATTR_NOSYMFOLLOW },
+#endif
+	{ 0, 0 },
+};
+
+static void get_mount_attr_flags(const struct fuse_service_mount_command *oc,
+				 unsigned int *attr_flags,
+				 unsigned long *leftover_ms_flags)
+{
+	const struct ms_to_mount_map *i;
+	unsigned int ms_flags = ntohl(oc->ms_flags);
+	unsigned int mount_attr_flags = 0;
+
+	for (i = attrs; i->ms_flag != 0; i++) {
+		if (ms_flags & i->ms_flag)
+			mount_attr_flags |= i->mount_attr_flag;
+		ms_flags &= ~i->ms_flag;
+	}
+
+	*leftover_ms_flags = ms_flags;
+	*attr_flags = mount_attr_flags;
+}
+
+struct ms_to_str_map {
+	unsigned long ms_flag;
+	const char *string;
+};
+
+static const struct ms_to_str_map strflags[] = {
+	{ MS_SYNCHRONOUS,	"sync" },
+	{ MS_DIRSYNC,		"dirsync" },
+	{ MS_LAZYTIME,		"lazytime" },
+	{ 0, 0 },
+};
+
+static int set_ms_flags(struct mount_service *mo, unsigned long ms_flags)
+{
+	const struct ms_to_str_map *i;
+	int ret;
+
+	for (i = strflags; i->ms_flag != 0; i++) {
+		if (!(ms_flags & i->ms_flag))
+			continue;
+
+		ret = fsconfig(mo->fsopenfd, FSCONFIG_SET_FLAG, i->string,
+			       NULL, 0);
+		if (ret) {
+			int error = errno;
+
+			fprintf(stderr, "%s: set %s option: %s\n",
+				mo->msgtag, i->string, strerror(error));
+			emit_fsconfig_messages(mo);
+
+			errno = error;
+			return -1;
+		}
+		ms_flags &= ~i->ms_flag;
+	}
+
+	/*
+	 * We can't translate all the supplied MS_ flags into MOUNT_ATTR_ flags
+	 * or string flags!  Return a magic code so the caller will fall back
+	 * to regular mount(2).
+	 */
+	if (ms_flags)
+		return FUSE_MOUNT_FALLBACK_NEEDED;
+
+	return 0;
+}
+
+static int mount_service_fsopen_mount(struct mount_service *mo,
+				      struct fuse_service_mount_command *oc,
+				      struct stat *stbuf)
+{
+	char tmp[64];
+	unsigned long ms_flags;
+	unsigned int attr_flags;
+	int mfd;
+	int error;
+	int ret;
+
+	get_mount_attr_flags(oc, &attr_flags, &ms_flags);
+
+	ret = set_ms_flags(mo, ms_flags);
+	if (ret == FUSE_MOUNT_FALLBACK_NEEDED)
+		return ret;
+	if (ret) {
+		error = errno;
+		goto fail_mount;
+	}
+
+	ret = fsconfig(mo->fsopenfd, FSCONFIG_SET_STRING, "subtype",
+		       mo->subtype, 0);
+	if (ret) {
+		error = errno;
+
+		/* The subtype option was merged after fsopen */
+		if (error == EINVAL)
+			return FUSE_MOUNT_FALLBACK_NEEDED;
+
+		fprintf(stderr, "%s: set subtype option: %s\n",
+			mo->msgtag, strerror(error));
+		goto fail_fsconfig;
+	}
+
+	snprintf(tmp, sizeof(tmp), "%i", mo->fusedevfd);
+	ret = fsconfig(mo->fsopenfd, FSCONFIG_SET_STRING, "fd", tmp, 0);
+	if (ret) {
+		error = errno;
+		fprintf(stderr, "%s: set fd option: %s\n",
+			mo->msgtag, strerror(error));
+		goto fail_fsconfig;
+	}
+
+	snprintf(tmp, sizeof(tmp), "%o", stbuf->st_mode & S_IFMT);
+	ret = fsconfig(mo->fsopenfd, FSCONFIG_SET_STRING, "rootmode", tmp, 0);
+	if (ret) {
+		error = errno;
+		fprintf(stderr, "%s: set rootmode option: %s\n",
+			mo->msgtag, strerror(error));
+		goto fail_fsconfig;
+	}
+
+	snprintf(tmp, sizeof(tmp), "%u", getuid());
+	ret = fsconfig(mo->fsopenfd, FSCONFIG_SET_STRING, "user_id", tmp, 0);
+	if (ret) {
+		error = errno;
+		fprintf(stderr, "%s: set user_id option: %s\n",
+			mo->msgtag, strerror(error));
+		goto fail_fsconfig;
+	}
+
+	snprintf(tmp, sizeof(tmp), "%u", getgid());
+	ret = fsconfig(mo->fsopenfd, FSCONFIG_SET_STRING, "group_id", tmp, 0);
+	if (ret) {
+		error = errno;
+		fprintf(stderr, "%s: set group_id option: %s\n",
+			mo->msgtag, strerror(error));
+		goto fail_fsconfig;
+	}
+
+	ret = fsconfig(mo->fsopenfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0);
+	if (ret) {
+		error = errno;
+		fprintf(stderr, "%s: creating filesystem: %s\n",
+			mo->msgtag, strerror(error));
+		goto fail_fsconfig;
+	}
+
+	mfd = fsmount(mo->fsopenfd, FSMOUNT_CLOEXEC, attr_flags);
+	if (mfd < 0) {
+		error = errno;
+		fprintf(stderr, "%s: fsmount: %s\n",
+			mo->msgtag, strerror(error));
+		goto fail_fsconfig;
+	}
+
+	ret = move_mount(mfd, "", mo->mountfd, "",
+			 MOVE_MOUNT_F_EMPTY_PATH | MOVE_MOUNT_T_EMPTY_PATH);
+	close(mfd);
+	if (ret) {
+		error = errno;
+		fprintf(stderr, "%s: move_mount: %s\n",
+			mo->msgtag, strerror(error));
+		goto fail_mount;
+	}
+
+	mo->mounted = true;
+	return mount_service_send_reply(mo, 0);
+
+fail_fsconfig:
+	emit_fsconfig_messages(mo);
+fail_mount:
+	return mount_service_send_reply(mo, error);
+}
+#else
+# define mount_service_fsopen_mount(...)	(FUSE_MOUNT_FALLBACK_NEEDED)
+#endif
+
 static int mount_service_handle_mount_cmd(struct mount_service *mo,
 					  struct fuse_service_packet *p,
 					  size_t psz)
@@ -1222,6 +1538,12 @@ static int mount_service_handle_mount_cmd(struct mount_service *mo,
 		return mount_service_send_reply(mo, error);
 	}
 
+	if (mo->fsopenfd >= 0) {
+		ret = mount_service_fsopen_mount(mo, oc, &stbuf);
+		if (ret != FUSE_MOUNT_FALLBACK_NEEDED)
+			return ret;
+	}
+
 	return mount_service_regular_mount(mo, oc, &stbuf);
 }
 
@@ -1301,6 +1623,7 @@ static void mount_service_destroy(struct mount_service *mo)
 	close(mo->mountfd);
 	close(mo->fusedevfd);
 	close(mo->argvfd);
+	close(mo->fsopenfd);
 	shutdown(mo->sockfd, SHUT_RDWR);
 	close(mo->sockfd);
 
@@ -1316,6 +1639,7 @@ static void mount_service_destroy(struct mount_service *mo)
 	mo->argvfd = -1;
 	mo->fusedevfd = -1;
 	mo->mountfd = -1;
+	mo->fsopenfd = -1;
 }
 
 int mount_service_main(int argc, char *argv[])

