Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDC81A08AF;
	Thu, 30 Apr 2026 21:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777583780; cv=none; b=imw/TkNOF5mrOnzmESp1hXGun/epiJwXg4ZC1x1jdRRqrzE7Nd/PGIq186pbtXvwXDNPMfKt0HUCdjYhlGYmJzvtCdJ152OfurWJ1I+/rQX3ETlXNrzpqRiXIdiNLX9Gy+CsZZ0FqHR+QzbKqbJevWZdgp2vzvdvWa01bWpr5XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777583780; c=relaxed/simple;
	bh=9mgB2mB1YnfDFua4CNi1SAWbnO+CjtvvDNJtl1MOJyk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o2teHwM8HyzQI6rgYz7As/vO3T6gdxFAuiZNzW2SiugDsPSCa9JD8g8XgL4WN039k9QwUcsFvjbgqRRxt6RQ0J/LAm1xlbr8d5jbUKvHRm+VlUxBhoEghOw2BgGxgHeXIedDHgY+IZkV9+jM/DQUbAjZqVksw5lZKcHJLigLOCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RLVlkmp2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RLVlkmp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58271C2BCB3;
	Thu, 30 Apr 2026 21:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777583780;
	bh=9mgB2mB1YnfDFua4CNi1SAWbnO+CjtvvDNJtl1MOJyk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RLVlkmp2o2a1RPPArdwziDZ+OEf8jG5fKhtQIFRz6IQRqy7gkR5TnehXUvwILWEjl
	 Ko7fcKBOPWTdEM/2BJHAJyVMT3ZPEZhRpi5ZXq8Bv0lfV8qWtBymQc3h7692j6Dz/b
	 FL0pRx5h6nBlaoVVBfxapUBJguCzUI+oaVek41cJgh+VkWBpENYLBTkp9UH8vZkYPk
	 AH7t7yixaOO6ISsBiCBzRQEwMq969KIIRv8xmgquOoCrLT/kP8xRcSU2j8QvyE5TLE
	 EGvXf/Kj+cnQP5sKq2d2ex16dvIY5kg3/Ea/tDhCJGhwBh8opMhKRZxqnLL2vtjs8L
	 T5K7thLmw5LBA==
Date: Thu, 30 Apr 2026 14:16:19 -0700
Subject: [PATCH 05/13] mount_service: update mtab after a successful mount
From: "Darrick J. Wong" <djwong@kernel.org>
To: bernd@bsbernd.com, djwong@kernel.org
Cc: linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-ext4@vger.kernel.org, miklos@szeredi.hu, neal@gompa.dev,
 joannelkoong@gmail.com
Message-ID: <177758363622.1314717.3266454364549497435.stgit@frogsfrogsfrogs>
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

Update "mtab" so that non-kernel mount options (e.g. "x-fubar=XXX") are
recorded somewhere so that userspace utilities can pick that up.  Note
that this likely is not the venerable /etc/mtab, which has been a
symlink to procfs for years.  On a modern system, these non-kernel
options end up /run/mount/utab.

But that's not a detail that libfuse has to worry about directly; it's
really just calling mount -f(ake) to make the changes it wants.  Old
hats may remember the use of mount -f to update /etc/mtab after mounting
the root filesystem.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 include/fuse_service_priv.h |    1 
 lib/mount_common_i.h        |    1 
 lib/fuse_service.c          |   15 +++++++
 lib/mount.c                 |    7 +++
 util/mount_service.c        |   95 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 119 insertions(+)


diff --git a/include/fuse_service_priv.h b/include/fuse_service_priv.h
index a3773d90c7db7e..8560b1ac610143 100644
--- a/include/fuse_service_priv.h
+++ b/include/fuse_service_priv.h
@@ -39,6 +39,7 @@ struct fuse_service_memfd_argv {
 #define FUSE_SERVICE_MOUNT_CMD		0x444f4954	/* DOIT */
 #define FUSE_SERVICE_UNMOUNT_CMD	0x554d4e54	/* UMNT */
 #define FUSE_SERVICE_BYE_CMD		0x42594545	/* BYEE */
+#define FUSE_SERVICE_MTABOPTS_CMD	0x4d544142	/* MTAB */
 
 /* mount.service sends replies to the fuse server */
 #define FUSE_SERVICE_OPEN_REPLY		0x46494c45	/* FILE */
diff --git a/lib/mount_common_i.h b/lib/mount_common_i.h
index 631dff3e6f8aaf..541cdebae4f47a 100644
--- a/lib/mount_common_i.h
+++ b/lib/mount_common_i.h
@@ -15,6 +15,7 @@ struct mount_opts;
 char *fuse_mnt_build_source(const struct mount_opts *mo);
 char *fuse_mnt_build_type(const struct mount_opts *mo);
 char *fuse_mnt_kernel_opts(const struct mount_opts *mo);
+char *fuse_mnt_mtab_opts(const struct mount_opts *mo);
 unsigned int fuse_mnt_flags(const struct mount_opts *mo);
 
 
diff --git a/lib/fuse_service.c b/lib/fuse_service.c
index ef512c76120a0f..83c1d564a18b0c 100644
--- a/lib/fuse_service.c
+++ b/lib/fuse_service.c
@@ -992,6 +992,7 @@ int fuse_service_session_mount(struct fuse_service *sf, struct fuse_session *se,
 	char *fstype = fuse_mnt_build_type(se->mo);
 	char *source = fuse_mnt_build_source(se->mo);
 	char *mntopts = fuse_mnt_kernel_opts(se->mo);
+	char *mtabopts = fuse_mnt_mtab_opts(se->mo);
 	char path[32];
 	int ret;
 	int error = 0;
@@ -1062,6 +1063,19 @@ int fuse_service_session_mount(struct fuse_service *sf, struct fuse_session *se,
 		}
 	}
 
+	if (mtabopts) {
+		ret = send_string(sf, FUSE_SERVICE_MTABOPTS_CMD, mtabopts,
+				  &error);
+		if (ret)
+			goto out_strings;
+		if (error) {
+			fuse_log(FUSE_LOG_ERR, "fuse: service fs mtab options: %s\n",
+				 strerror(error));
+			ret = -error;
+			goto out_strings;
+		}
+	}
+
 	ret = send_mount(sf, fuse_mnt_flags(se->mo), &error);
 	if (ret)
 		goto out_strings;
@@ -1082,6 +1096,7 @@ int fuse_service_session_mount(struct fuse_service *sf, struct fuse_session *se,
 	(void)chdir("/");
 
 out_strings:
+	free(mtabopts);
 	free(mntopts);
 	free(source);
 	free(fstype);
diff --git a/lib/mount.c b/lib/mount.c
index 952d8899dcf218..84c73579ab2daf 100644
--- a/lib/mount.c
+++ b/lib/mount.c
@@ -758,6 +758,13 @@ char *fuse_mnt_kernel_opts(const struct mount_opts *mo)
 	return NULL;
 }
 
+char *fuse_mnt_mtab_opts(const struct mount_opts *mo)
+{
+	if (mo->mtab_opts)
+		return strdup(mo->mtab_opts);
+	return NULL;
+}
+
 unsigned int fuse_mnt_flags(const struct mount_opts *mo)
 {
 	return mo->flags;
diff --git a/util/mount_service.c b/util/mount_service.c
index f2a515a2cc3b37..915a0c4b610792 100644
--- a/util/mount_service.c
+++ b/util/mount_service.c
@@ -61,6 +61,9 @@ struct mount_service {
 	/* mount options */
 	char *mntopts;
 
+	/* mtab options */
+	char *mtabopts;
+
 	/* socket fd */
 	int sockfd;
 
@@ -86,6 +89,13 @@ struct mount_service {
 	bool fuseblk;
 };
 
+static char IGNORE_MTAB;
+
+static inline bool have_real_mtabopts(const struct mount_service *mo)
+{
+	return mo->mtabopts && mo->mtabopts != &IGNORE_MTAB;
+}
+
 static ssize_t __send_fd(struct mount_service *mo,
 			 struct fuse_service_requested_file *req,
 			 size_t req_sz, int fd)
@@ -1018,6 +1028,55 @@ static int mount_service_handle_mntopts_cmd(struct mount_service *mo,
 	return mount_service_send_reply(mo, 0);
 }
 
+static int mount_service_handle_mtabopts_cmd(struct mount_service *mo,
+					     const struct fuse_service_packet *p,
+					     size_t psz)
+{
+	struct fuse_service_string_command *oc =
+			container_of(p, struct fuse_service_string_command, p);
+	char *tokstr = oc->value;
+	char *tok, *savetok;
+
+	if (psz < sizeof_fuse_service_string_command(1)) {
+		fprintf(stderr, "%s: mtab options command too small\n",
+			mo->msgtag);
+		return mount_service_send_reply(mo, EINVAL);
+	}
+
+	if (!check_null_endbyte(p, psz)) {
+		fprintf(stderr, "%s: mtab options command must be null terminated\n",
+			mo->msgtag);
+		return mount_service_send_reply(mo, EINVAL);
+	}
+
+	if (mo->mtabopts) {
+		fprintf(stderr, "%s: mtab options respecified!\n",
+			mo->msgtag);
+		return mount_service_send_reply(mo, EINVAL);
+	}
+
+	mo->mtabopts = strdup(oc->value);
+	if (!mo->mtabopts) {
+		int error = errno;
+
+		fprintf(stderr, "%s: alloc mtab options string: %s\n",
+			mo->msgtag, strerror(error));
+		return mount_service_send_reply(mo, error);
+	}
+
+	/* strtok_r mutates tokstr aka oc->value */
+	while ((tok = strtok_r(tokstr, ",", &savetok)) != NULL) {
+		if (!strcmp(tok, "-n")) {
+			free(mo->mtabopts);
+			mo->mtabopts = &IGNORE_MTAB;
+		}
+
+		tokstr = NULL;
+	}
+
+	return mount_service_send_reply(mo, 0);
+}
+
 static int attach_to_mountpoint(struct mount_service *mo, mode_t expected_fmt,
 				char *mntpt)
 {
@@ -1293,6 +1352,14 @@ static int mount_service_regular_mount(struct mount_service *mo,
 		goto out_fstype;
 	}
 
+	/*
+	 * The mount succeeded, so we send a positive reply even if the mtab
+	 * update fails.
+	 */
+	if (have_real_mtabopts(mo))
+		fuse_mnt_add_mount(mo->msgtag, mo->source, mo->resv_mountpoint,
+				   fstype, mo->mtabopts);
+
 	mo->mounted = true;
 	ret = mount_service_send_reply(mo, 0);
 out_fstype:
@@ -1485,6 +1552,22 @@ static int mount_service_fsopen_mount(struct mount_service *mo,
 		goto fail_mount;
 	}
 
+	/*
+	 * The mount succeeded, so we send a positive reply even if the mtab
+	 * update fails.
+	 */
+	if (have_real_mtabopts(mo)) {
+		char *fstype = NULL;
+
+		asprintf(&fstype, "%s.%s", fsname(mo), mo->subtype);
+		if (fstype) {
+			fuse_mnt_add_mount(mo->msgtag, mo->source,
+					   mo->resv_mountpoint, fstype,
+					   mo->mtabopts);
+			free(fstype);
+		}
+	}
+
 	mo->mounted = true;
 	return mount_service_send_reply(mo, 0);
 
@@ -1592,6 +1675,13 @@ static int mount_service_handle_unmount_cmd(struct mount_service *mo,
 		return mount_service_send_reply(mo, error);
 	}
 
+	/*
+	 * The unmount succeeded, so we send a positive reply even if the mtab
+	 * update fails.
+	 */
+	if (have_real_mtabopts(mo))
+		fuse_mnt_remove_mount(mo->msgtag, mo->resv_mountpoint);
+
 	mo->mounted = false;
 	return mount_service_send_reply(mo, 0);
 }
@@ -1631,6 +1721,8 @@ static void mount_service_destroy(struct mount_service *mo)
 	free(mo->mountpoint);
 	free(mo->real_mountpoint);
 	free(mo->resv_mountpoint);
+	if (have_real_mtabopts(mo))
+		free(mo->mtabopts);
 	free(mo->mntopts);
 	free(mo->subtype);
 
@@ -1720,6 +1812,9 @@ int mount_service_main(int argc, char *argv[])
 			ret = mount_service_handle_mountpoint_cmd(&mo, p, sz,
 								  argc, argv);
 			break;
+		case FUSE_SERVICE_MTABOPTS_CMD:
+			ret = mount_service_handle_mtabopts_cmd(&mo, p, sz);
+			break;
 		case FUSE_SERVICE_MOUNT_CMD:
 			ret = mount_service_handle_mount_cmd(&mo, p, sz);
 			break;

