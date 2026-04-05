Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA0137B010
	for <linux-ext4@vger.kernel.org>; Sun,  5 Apr 2026 19:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775418633; cv=none; b=NLGE/P82awYTL3gXLR1+GZpqCyzNjvaOqDSSBwupOpmdyOMMOb/aVlu+kvxsZtBHZ5apelvnhmntf3Oq7BhLMW2eaoCcQCY1Q2CQWy0+x6P4aNmRqFReb/p1W/2i6FtIRQVgo3k/NCr3oqSpnYZMxhmjZ9JQn44mMPY2YNztGFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775418633; c=relaxed/simple;
	bh=eAS0CC0y+ljGDQRKHJmotWjYqP7vy5Qg1wjW0SfPpNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R214Dm9IZyzuDQDlrAGXAV4ZW3SQapwxnDRPNhSnLsECKb1oCLahfwW89wDssSckOSlLKtDanlbt04cEjqZ6NHBMiYDXlJPwYBE+d0RAVIPy2OoJEz4bJlPBjUlXyykjymJX291yj7u4l91WqYJnRRiTDo9AmNvKCVhSqSil7PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gf6h+E7X; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gf6h+E7X"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-470145d7e07so846174b6e.1
        for <linux-ext4@vger.kernel.org>; Sun, 05 Apr 2026 12:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775418629; x=1776023429; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ZQ0VkPeOJ/If+th1ogC495oRb3mBG/Wl1YVzp5b6bI=;
        b=gf6h+E7XmOIC0RSWsYfFX7CSaxEP6YAk0sBGFr/dVcS2HJm2pP2Q3Rb+2ozmIdX9Eu
         kWTSFaE17u/iwGgV7sQdlN6deke/RDr+a4Od6wfaXwu5XBMZvUy24NYfHxF2hy+Ktzs3
         am6NV81wd5aTymHXUoyqbBAGzOCIn75J3FvQmwW60XUnlXfbaYZ8jr8KF77UbL9j7Yb9
         xcjelQQ0VH2J5iSvl5v1pJ99nn1vHTyrHWU8l6X0Hcyd4EGCqvKgr/+7vj1Do8nVkxCj
         ODsBYy4I6i0tEPqemCjFpxmKXmnbzMbfywkAyLa1lhBB5s0VBxrXIOyMuVl6ejXUCmkV
         N50g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775418629; x=1776023429;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2ZQ0VkPeOJ/If+th1ogC495oRb3mBG/Wl1YVzp5b6bI=;
        b=V+okqFkK7ifBPVTF3HsMsnHHeuts8qNyvEbNshDc8LGq2w7LjQLsHR8dFiZiT5TrH1
         Ukjc6skazqON6aldwOmi01hwn0jmFh6ugfb2nU3aZ3yRMC76TSsWpKehrtB4/u/LqKxv
         /SObDBW1hVazRQYd+CZ/FyQNLyCpyN9f3w6gZGfISiFEOolBsGZM3+mukwX/N2RX7QW8
         8ojW2X7ELymnIqW6SqmU7n9+gpJ8Fst6jO7ma5N22wXHtG4Orc9zQOhOw7IS6Xm3RZ3e
         FHomS09QXSnlvREWda0ElVBBvhkoR305J1cgIMw0kSS9JxUJ/Tw/57R1bfbOYRy1rw4j
         EQmA==
X-Gm-Message-State: AOJu0YyxvkMoIdlex4VZUIbhDBFmv/uh1KqtTUCtXhRi4ki14nT+6X9s
	RhPMP5c0yxjD+L9lAyFHQXNNlblq8rg4ncaa/NQSUrF/OWUorExyNrV1
X-Gm-Gg: AeBDiesXiDEvuIn0EEC+cpxx7Pt4C31HO06b3KVhgNU1ABEmbGlW90ogLpXNj+WIjiM
	ECa5b+8DHWoEvMpJ6ZvE7iJjkj3LRwjilJ3RqGx2oItSKmzrP5svVFuItiL+g9nVGpqqpD/D6cK
	dz+atjAD3Q29tnwmrUZVs7coHnpxIu91hjFLn1hFzMwmIw2UguwcVQauGxNVcmfJNZZGTbrEH2j
	akRHh284yl5mo8Dr2YKaXCD/E16/De6C58Tj5I9Nm7U1SGAtkmQVoJwYCyx7CU/Bssw6sLgbOyG
	UyE3NecgrRKAXgJcU0XP6BGAb+bjldCILbxvtuX2rV7JbnNvDvxFfW9d5Xw0mS+eBedx4okH1sy
	hWXKC7r9GaFl99iI8RkpDs8q7tMGoLjwxCs1+vk/GDR+Ahs4mEwnnZ4JpGbPZlo/OWadsFDhG2q
	gBF4L8jrwuMR2ATneFU2Jg8ApeXcgmJGnY5xxH4MzwMtapfruRCGCKJroNNF4FJGTmFOPBdXilL
	NlDCMsAYyUsFMA116ZEtLwYAg==
X-Received: by 2002:a05:6808:5088:b0:46a:cb96:d2b7 with SMTP id 5614622812f47-46ef7e16ea0mr5583483b6e.35.1775418629222;
        Sun, 05 Apr 2026 12:50:29 -0700 (PDT)
Received: from localhost.localdomain (c-73-5-99-191.hsd1.la.comcast.net. [73.5.99.191])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46f46160155sm4547428b6e.17.2026.04.05.12.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 12:50:27 -0700 (PDT)
From: Sean Smith <defendthedisabled@gmail.com>
X-Google-Original-From: Sean Smith <DefendTheDisabled@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	tytso@mit.edu,
	dsterba@suse.com,
	david@fromorbit.com,
	brauner@kernel.org,
	osandov@osandov.com,
	almaz@kernel.org,
	hirofumi@mail.parknet.co.jp,
	linkinjeon@kernel.org,
	Sean Smith <DefendTheDisabled@gmail.com>
Subject: [PATCH 1/6] vfs: add provenance_time (ptime) infrastructure
Date: Sun,  5 Apr 2026 14:49:57 -0500
Message-ID: <20260405195007.1306-2-DefendTheDisabled@gmail.com>
X-Mailer: git-send-email 2.51.0.windows.1
In-Reply-To: <20260405195007.1306-1-DefendTheDisabled@gmail.com>
References: <20260405195007.1306-1-DefendTheDisabled@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new settable inode timestamp, provenance_time (ptime), for tracking
the original creation date of file content across filesystem boundaries.

ptime is distinct from btime (forensic, immutable): it records when file
content first came into existence on any filesystem, and is designed to
be set during cross-filesystem migration and preserved through copies.

VFS changes:
- ATTR_PTIME (bit 19) and ATTR_PTIME_SET (bit 20) in struct iattr
- STATX_PTIME (0x00040000) in struct statx at offset 0xC0
- AT_UTIME_PTIME (0x20000) flag for utimensat()
- ptime field in struct kstat
- Permission model matches mtime (owner or CAP_FOWNER)
- UTIME_NOW and UTIME_OMIT supported for ptime element
- All existing vfs_utimes() callers updated for new flags parameter

Signed-off-by: Sean Smith <DefendTheDisabled@gmail.com>
---
 fs/attr.c                  |  6 +++-
 fs/btrfs/volumes.c         |  2 +-
 fs/init.c                  |  2 +-
 fs/stat.c                  |  2 ++
 fs/utimes.c                | 56 +++++++++++++++++++++++++++++---------
 include/linux/fs.h         |  5 +++-
 include/linux/stat.h       |  1 +
 include/uapi/linux/fcntl.h |  3 ++
 include/uapi/linux/stat.h  |  4 ++-
 init/initramfs.c           |  2 +-
 10 files changed, 64 insertions(+), 19 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index b9ec6b47b..7fa9c01d1 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -206,7 +206,7 @@ int setattr_prepare(struct mnt_idmap *idmap, struct dentry *dentry,
 	}
 
 	/* Check for setting the inode time. */
-	if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET | ATTR_TIMES_SET)) {
+	if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET | ATTR_PTIME_SET | ATTR_TIMES_SET)) {
 		if (!inode_owner_or_capable(idmap, inode))
 			return -EPERM;
 	}
@@ -466,6 +466,10 @@ int notify_change(struct mnt_idmap *idmap, struct dentry *dentry,
 		attr->ia_mtime = timestamp_truncate(attr->ia_mtime, inode);
 	else
 		attr->ia_mtime = now;
+	if (ia_valid & ATTR_PTIME_SET)
+		attr->ia_ptime = timestamp_truncate(attr->ia_ptime, inode);
+	else if (ia_valid & ATTR_PTIME)
+		attr->ia_ptime = now;
 
 	if (ia_valid & ATTR_KILL_PRIV) {
 		error = security_inode_need_killpriv(dentry);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 052b830a0..0e81f2cc9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2117,7 +2117,7 @@ static void update_dev_time(const char *device_path)
 	struct path path;
 
 	if (!kern_path(device_path, LOOKUP_FOLLOW, &path)) {
-		vfs_utimes(&path, NULL);
+		vfs_utimes(&path, NULL, 0);
 		path_put(&path);
 	}
 }
diff --git a/fs/init.c b/fs/init.c
index e0f5429c0..e9a9f4d93 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -254,7 +254,7 @@ int __init init_utimes(char *filename, struct timespec64 *ts)
 	error = kern_path(filename, 0, &path);
 	if (error)
 		return error;
-	error = vfs_utimes(&path, ts);
+	error = vfs_utimes(&path, ts, 0);
 	path_put(&path);
 	return error;
 }
diff --git a/fs/stat.c b/fs/stat.c
index 6c79661e1..9284bb753 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -728,6 +728,8 @@ cp_statx(const struct kstat *stat, struct statx __user *buffer)
 	tmp.stx_atime.tv_nsec = stat->atime.tv_nsec;
 	tmp.stx_btime.tv_sec = stat->btime.tv_sec;
 	tmp.stx_btime.tv_nsec = stat->btime.tv_nsec;
+	tmp.stx_ptime.tv_sec = stat->ptime.tv_sec;
+	tmp.stx_ptime.tv_nsec = stat->ptime.tv_nsec;
 	tmp.stx_ctime.tv_sec = stat->ctime.tv_sec;
 	tmp.stx_ctime.tv_nsec = stat->ctime.tv_nsec;
 	tmp.stx_mtime.tv_sec = stat->mtime.tv_sec;
diff --git a/fs/utimes.c b/fs/utimes.c
index 86f8ce8cd..50b5ad296 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -17,10 +17,10 @@ static bool nsec_valid(long nsec)
 	return nsec >= 0 && nsec <= 999999999;
 }
 
-int vfs_utimes(const struct path *path, struct timespec64 *times)
+int vfs_utimes(const struct path *path, struct timespec64 *times, int flags)
 {
 	int error;
-	struct iattr newattrs;
+	struct iattr newattrs = {};
 	struct inode *inode = path->dentry->d_inode;
 	struct delegated_inode delegated_inode = { };
 
@@ -28,7 +28,11 @@ int vfs_utimes(const struct path *path, struct timespec64 *times)
 		if (!nsec_valid(times[0].tv_nsec) ||
 		    !nsec_valid(times[1].tv_nsec))
 			return -EINVAL;
-		if (times[0].tv_nsec == UTIME_NOW &&
+		if ((flags & AT_UTIME_PTIME) &&
+		    !nsec_valid(times[2].tv_nsec))
+			return -EINVAL;
+		if (!(flags & AT_UTIME_PTIME) &&
+		    times[0].tv_nsec == UTIME_NOW &&
 		    times[1].tv_nsec == UTIME_NOW)
 			times = NULL;
 	}
@@ -52,6 +56,15 @@ int vfs_utimes(const struct path *path, struct timespec64 *times)
 			newattrs.ia_mtime = times[1];
 			newattrs.ia_valid |= ATTR_MTIME_SET;
 		}
+		if (flags & AT_UTIME_PTIME) {
+			if (times[2].tv_nsec != UTIME_OMIT) {
+				newattrs.ia_valid |= ATTR_PTIME;
+				if (times[2].tv_nsec != UTIME_NOW) {
+					newattrs.ia_ptime = times[2];
+					newattrs.ia_valid |= ATTR_PTIME_SET;
+				}
+			}
+		}
 		/*
 		 * Tell setattr_prepare(), that this is an explicit time
 		 * update, even if neither ATTR_ATIME_SET nor ATTR_MTIME_SET
@@ -84,7 +97,7 @@ static int do_utimes_path(int dfd, const char __user *filename,
 	struct path path;
 	int lookup_flags = 0, error;
 
-	if (flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH))
+	if (flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH | AT_UTIME_PTIME))
 		return -EINVAL;
 
 	if (!(flags & AT_SYMLINK_NOFOLLOW))
@@ -97,7 +110,7 @@ static int do_utimes_path(int dfd, const char __user *filename,
 	if (error)
 		return error;
 
-	error = vfs_utimes(&path, times);
+	error = vfs_utimes(&path, times, flags);
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
@@ -109,13 +122,13 @@ static int do_utimes_path(int dfd, const char __user *filename,
 
 static int do_utimes_fd(int fd, struct timespec64 *times, int flags)
 {
-	if (flags)
+	if (flags & ~AT_UTIME_PTIME)
 		return -EINVAL;
 
 	CLASS(fd, f)(fd);
 	if (fd_empty(f))
 		return -EBADF;
-	return vfs_utimes(&fd_file(f)->f_path, times);
+	return vfs_utimes(&fd_file(f)->f_path, times, flags);
 }
 
 /*
@@ -144,16 +157,24 @@ long do_utimes(int dfd, const char __user *filename, struct timespec64 *times,
 SYSCALL_DEFINE4(utimensat, int, dfd, const char __user *, filename,
 		struct __kernel_timespec __user *, utimes, int, flags)
 {
-	struct timespec64 tstimes[2];
+	struct timespec64 tstimes[3];
+
+	if ((flags & AT_UTIME_PTIME) && !utimes)
+		return -EINVAL;
 
 	if (utimes) {
 		if ((get_timespec64(&tstimes[0], &utimes[0]) ||
-			get_timespec64(&tstimes[1], &utimes[1])))
+		     get_timespec64(&tstimes[1], &utimes[1])))
+			return -EFAULT;
+		if ((flags & AT_UTIME_PTIME) &&
+		    get_timespec64(&tstimes[2], &utimes[2]))
 			return -EFAULT;
 
 		/* Nothing to do, we must not even check the path.  */
 		if (tstimes[0].tv_nsec == UTIME_OMIT &&
-		    tstimes[1].tv_nsec == UTIME_OMIT)
+		    tstimes[1].tv_nsec == UTIME_OMIT &&
+		    (!(flags & AT_UTIME_PTIME) ||
+		     tstimes[2].tv_nsec == UTIME_OMIT))
 			return 0;
 	}
 
@@ -247,14 +268,23 @@ SYSCALL_DEFINE2(utime32, const char __user *, filename,
 
 SYSCALL_DEFINE4(utimensat_time32, unsigned int, dfd, const char __user *, filename, struct old_timespec32 __user *, t, int, flags)
 {
-	struct timespec64 tv[2];
+	struct timespec64 tv[3];
+
+	if ((flags & AT_UTIME_PTIME) && !t)
+		return -EINVAL;
 
-	if  (t) {
+	if (t) {
 		if (get_old_timespec32(&tv[0], &t[0]) ||
 		    get_old_timespec32(&tv[1], &t[1]))
 			return -EFAULT;
+		if ((flags & AT_UTIME_PTIME) &&
+		    get_old_timespec32(&tv[2], &t[2]))
+			return -EFAULT;
 
-		if (tv[0].tv_nsec == UTIME_OMIT && tv[1].tv_nsec == UTIME_OMIT)
+		if (tv[0].tv_nsec == UTIME_OMIT &&
+		    tv[1].tv_nsec == UTIME_OMIT &&
+		    (!(flags & AT_UTIME_PTIME) ||
+		     tv[2].tv_nsec == UTIME_OMIT))
 			return 0;
 	}
 	return do_utimes(dfd, filename, t ? tv : NULL, flags);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a01621fa6..07719e216 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -239,6 +239,8 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define ATTR_TIMES_SET	(1 << 16)
 #define ATTR_TOUCH	(1 << 17)
 #define ATTR_DELEG	(1 << 18) /* Delegated attrs. Don't break write delegations */
+#define ATTR_PTIME	(1 << 19) /* Set provenance time */
+#define ATTR_PTIME_SET	(1 << 20) /* Set provenance time to specific value */
 
 /*
  * Whiteout is represented by a char device.  The following constants define the
@@ -283,6 +285,7 @@ struct iattr {
 	struct timespec64 ia_atime;
 	struct timespec64 ia_mtime;
 	struct timespec64 ia_ctime;
+	struct timespec64 ia_ptime;
 
 	/*
 	 * Not an attribute, but an auxiliary info for filesystems wanting to
@@ -1814,7 +1817,7 @@ int vfs_mkobj(struct dentry *, umode_t,
 
 int vfs_fchown(struct file *file, uid_t user, gid_t group);
 int vfs_fchmod(struct file *file, umode_t mode);
-int vfs_utimes(const struct path *path, struct timespec64 *times);
+int vfs_utimes(const struct path *path, struct timespec64 *times, int flags);
 
 #ifdef CONFIG_COMPAT
 extern long compat_ptr_ioctl(struct file *file, unsigned int cmd,
diff --git a/include/linux/stat.h b/include/linux/stat.h
index e3d00e7bb..52272000c 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -48,6 +48,7 @@ struct kstat {
 	struct timespec64 mtime;
 	struct timespec64 ctime;
 	struct timespec64 btime;			/* File creation time */
+	struct timespec64 ptime;			/* Provenance time */
 	u64		blocks;
 	u64		mnt_id;
 	u64		change_cookie;
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index aadfbf6e0..f80ce0295 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -190,4 +190,7 @@ struct delegation {
 #define AT_EXECVE_CHECK		0x10000	/* Only perform a check if execution
 					   would be allowed. */
 
+/* Flag for utimensat(2): times[2] carries provenance time */
+#define AT_UTIME_PTIME		0x20000
+
 #endif /* _UAPI_LINUX_FCNTL_H */
diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
index 1686861aa..0c8db3715 100644
--- a/include/uapi/linux/stat.h
+++ b/include/uapi/linux/stat.h
@@ -187,7 +187,8 @@ struct statx {
 	__u32	__spare2[1];
 
 	/* 0xc0 */
-	__u64	__spare3[8];	/* Spare space for future expansion */
+	struct statx_timestamp	stx_ptime;	/* File provenance time */
+	__u64	__spare3[6];		/* Spare space for future expansion */
 
 	/* 0x100 */
 };
@@ -219,6 +220,7 @@ struct statx {
 #define STATX_SUBVOL		0x00008000U	/* Want/got stx_subvol */
 #define STATX_WRITE_ATOMIC	0x00010000U	/* Want/got atomic_write_* fields */
 #define STATX_DIO_READ_ALIGN	0x00020000U	/* Want/got dio read alignment info */
+#define STATX_PTIME		0x00040000U	/* Want/got stx_ptime */
 
 #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
 
diff --git a/init/initramfs.c b/init/initramfs.c
index 6ddbfb17f..e066b1fee 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -139,7 +139,7 @@ static void __init do_utime(char *filename, time64_t mtime)
 static void __init do_utime_path(const struct path *path, time64_t mtime)
 {
 	struct timespec64 t[2] = { { .tv_sec = mtime }, { .tv_sec = mtime } };
-	vfs_utimes(path, t);
+	vfs_utimes(path, t, 0);
 }
 
 static __initdata LIST_HEAD(dir_list);
-- 
2.53.0

