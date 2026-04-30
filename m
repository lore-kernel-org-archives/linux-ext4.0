Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0374D37998B;
	Thu, 30 Apr 2026 21:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777583812; cv=none; b=JRVy7vU5JVXBT7sVlLX0hfiMkkeUO4CT3UM3Yj3pADhnSWs6bMO6sYnpurfcchPIcAvsQ9lxH/Jm8T3yNOaGwoYEChjuFUy2IH9w2x26tpq/nppwqTfHjOC1jMmCktEWIV1JbmXvhrq2b2xq3E2pkr+g9h7AywOS3ST2fSUIo2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777583812; c=relaxed/simple;
	bh=w1brGK5tRgWmGiJWcBBv6lKY92WBP+QllTbc3cWUYr4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jcGf1ZJ8R2OaZd7cQOENFYlKCqTkNM6ZymQ/q9jbHupsVSrABh6vB4vyuOWde7CNeQUsHeVwyQ3jOok91+M43ArIatsJ0xJtaTNUbi93/f/OZ7kR4m/tNDGT9sRAE1pB17RIRchlQE/fFzQwE+b7+DlwcbF7fREMaibjsRA3dt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nDQKHARm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nDQKHARm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98548C2BCB3;
	Thu, 30 Apr 2026 21:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777583811;
	bh=w1brGK5tRgWmGiJWcBBv6lKY92WBP+QllTbc3cWUYr4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nDQKHARmbdQlXcy1nne805lNWE1cdK6nS3GFUKGWKij3AeuaM4GoIBFHG75c5zjnU
	 rbP5iIpVSlB5VO0Ryrm2oJqmYeZ0W8VjkJ92U2fjMoZBXEFASq9zhyqVq356gqk3N6
	 YcDB8j/l5hD81K0nobidfH24p0rECix0VgEwiQ5ubaT/3VJsfpcfgdF4pKWHWN9bkz
	 9cF/nqcpbsmRVHxyDXDUn2jL9UFiiCrpIIs5fGw1y1v+53AGLs0Zpx4gIdE2GjSIc9
	 RHVNbFDn9GrpcUOF5FMXrw9oK8TzlsEv840QXi9VmUMAPbQW9EeuOA1pewnHMmRmCi
	 knmxdUvBbgF6w==
Date: Thu, 30 Apr 2026 14:16:51 -0700
Subject: [PATCH 07/13] util: fix checkpatch complaints in fuser_conf.[ch]
From: "Darrick J. Wong" <djwong@kernel.org>
To: bernd@bsbernd.com, djwong@kernel.org
Cc: linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-ext4@vger.kernel.org, miklos@szeredi.hu, neal@gompa.dev,
 joannelkoong@gmail.com
Message-ID: <177758363658.1314717.5258534978153146037.stgit@frogsfrogsfrogs>
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

Fix the checkpatch complaints because we touched some code.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 util/fuser_conf.h |    3 ++-
 util/fuser_conf.c |   51 +++++++++++++++++++++++++++++++++------------------
 2 files changed, 35 insertions(+), 19 deletions(-)


diff --git a/util/fuser_conf.h b/util/fuser_conf.h
index 5afe70709c5152..55ed745c964ed8 100644
--- a/util/fuser_conf.h
+++ b/util/fuser_conf.h
@@ -23,7 +23,8 @@ void unescape(char *buf);
 static inline struct mntent *GETMNTENT(FILE *stream)
 {
 	struct mntent *entp = getmntent(stream);
-	if(entp != NULL) {
+
+	if (entp != NULL) {
 		unescape(entp->mnt_fsname);
 		unescape(entp->mnt_dir);
 		unescape(entp->mnt_type);
diff --git a/util/fuser_conf.c b/util/fuser_conf.c
index ad933de9cf7cbf..6553c7f6f929a5 100644
--- a/util/fuser_conf.c
+++ b/util/fuser_conf.c
@@ -30,7 +30,7 @@
 #include <stdint.h>
 #endif
 
-int user_allow_other = 0;
+int user_allow_other;
 int mount_max = 1000;
 static uid_t oldfsuid;
 static gid_t oldfsgid;
@@ -43,25 +43,27 @@ void unescape(char *buf)
 {
 	char *src = buf;
 	char *dest = buf;
+
 	while (1) {
 		char *next_src = strchrnul(src, '\\');
 		int offset = next_src - src;
+
 		memmove(dest, src, offset);
 		src = next_src;
 		dest += offset;
 
-		if(*src == '\0') {
+		if (*src == '\0') {
 			*dest = *src;
 			return;
 		}
 		src++;
 
-		if('0' <= src[0] && src[0] < '2' &&
-		   '0' <= src[1] && src[1] < '8' &&
-		   '0' <= src[2] && src[2] < '8') {
+		if ('0' <= src[0] && src[0] < '2' &&
+		    '0' <= src[1] && src[1] < '8' &&
+		    '0' <= src[2] && src[2] < '8') {
 			*dest++ = (src[0] - '0') << 6
-			        | (src[1] - '0') << 3
-			        | (src[2] - '0') << 0;
+				| (src[1] - '0') << 3
+				| (src[2] - '0') << 0;
 			src += 3;
 		} else if (src[0] == '\\') {
 			*dest++ = '\\';
@@ -79,6 +81,7 @@ static int count_fuse_fs_mtab(const char *progname)
 	int count = 0;
 	const char *mtab = _PATH_MOUNTED;
 	FILE *fp = setmntent(mtab, "r");
+
 	if (fp == NULL) {
 		fprintf(stderr, "%s: failed to open %s: %s\n", progname, mtab,
 			strerror(errno));
@@ -87,7 +90,7 @@ static int count_fuse_fs_mtab(const char *progname)
 	while ((entp = GETMNTENT(fp)) != NULL) {
 		if (strcmp(entp->mnt_type, "fuse") == 0 ||
 		    strncmp(entp->mnt_type, "fuse.", 5) == 0)
-			count ++;
+			count++;
 	}
 	endmntent(fp);
 	return count;
@@ -169,12 +172,15 @@ int count_fuse_fs(const char *progname)
 static void strip_line(char *line)
 {
 	char *s = strchr(line, '#');
+
 	if (s != NULL)
 		s[0] = '\0';
 	for (s = line + strlen(line) - 1;
-	     s >= line && isspace((unsigned char) *s); s--);
+	     s >= line && isspace((unsigned char) *s); s--) {
+	}
 	s[1] = '\0';
-	for (s = line; isspace((unsigned char) *s); s++);
+	for (s = line; isspace((unsigned char) *s); s++)
+		; /* empty */
 	if (s != line)
 		memmove(line, s, strlen(s)+1);
 }
@@ -182,11 +188,12 @@ static void strip_line(char *line)
 static void parse_line(const char *line, int linenum, const char *progname)
 {
 	int tmp;
+
 	if (strcmp(line, "user_allow_other") == 0)
 		user_allow_other = 1;
 	else if (sscanf(line, "mount_max = %i", &tmp) == 1)
 		mount_max = tmp;
-	else if(line[0])
+	else if (line[0])
 		fprintf(stderr,
 			"%s: unknown parameter in %s at line %i: '%s'\n",
 			progname, FUSE_CONF, linenum, line);
@@ -195,10 +202,12 @@ static void parse_line(const char *line, int linenum, const char *progname)
 void read_conf(const char *progname)
 {
 	FILE *fp = fopen(FUSE_CONF, "r");
+
 	if (fp != NULL) {
 		int linenum = 1;
 		char line[256];
 		int isnewline = 1;
+
 		while (fgets(line, sizeof(line), fp) != NULL) {
 			if (isnewline) {
 				if (line[strlen(line)-1] == '\n') {
@@ -207,16 +216,18 @@ void read_conf(const char *progname)
 				} else {
 					isnewline = 0;
 				}
-			} else if(line[strlen(line)-1] == '\n') {
-				fprintf(stderr, "%s: reading %s: line %i too long\n", progname, FUSE_CONF, linenum);
+			} else if (line[strlen(line)-1] == '\n') {
+				fprintf(stderr, "%s: reading %s: line %i too long\n",
+					progname, FUSE_CONF, linenum);
 
 				isnewline = 1;
 			}
 			if (isnewline)
-				linenum ++;
+				linenum++;
 		}
 		if (!isnewline) {
-			fprintf(stderr, "%s: reading %s: missing newline at end of file\n", progname, FUSE_CONF);
+			fprintf(stderr, "%s: reading %s: missing newline at end of file\n",
+				progname, FUSE_CONF);
 
 		}
 		if (ferror(fp)) {
@@ -289,6 +300,8 @@ int check_nonroot_dir_access(const char *progname, const char *origmnt,
 	return 0;
 }
 
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+
 int check_nonroot_fstype(const char *progname, const struct statfs *fs_buf)
 {
 	size_t i;
@@ -298,13 +311,15 @@ int check_nonroot_fstype(const char *progname, const struct statfs *fs_buf)
 	 * able to just put anything we want there.
 	 * Luckily, without allow_other, we can't get other users to actually
 	 * use any fake information we try to put there anyway.
-	 * Use a whitelist to be safe. */
+	 * Use a whitelist to be safe.
+	 */
 
 	/* Define permitted filesystems for the mount target. This was
 	 * originally the same list as used by the ecryptfs mount helper
 	 * (https://bazaar.launchpad.net/~ecryptfs/ecryptfs/trunk/view/head:/src/utils/mount.ecryptfs_private.c#L225)
 	 * but got expanded as we found more filesystems that needed to be
-	 * overlaid. */
+	 * overlaid.
+	 */
 	typeof(fs_buf->f_type) f_type_whitelist[] = {
 		0x61756673 /* AUFS_SUPER_MAGIC */,
 		0x00000187 /* AUTOFS_SUPER_MAGIC */,
@@ -345,7 +360,7 @@ int check_nonroot_fstype(const char *progname, const struct statfs *fs_buf)
 		0x2FC12FC1 /* ZFS_SUPER_MAGIC */,
 		0x858458f6 /* RAMFS_MAGIC */,
 	};
-	for (i = 0; i < sizeof(f_type_whitelist)/sizeof(f_type_whitelist[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(f_type_whitelist); i++) {
 		if (f_type_whitelist[i] == fs_buf->f_type)
 			return 0;
 	}

