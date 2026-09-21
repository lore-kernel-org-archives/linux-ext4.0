Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2A6376BEF
	for <linux-ext4@vger.kernel.org>; Mon, 21 Sep 2026 19:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790018136; cv=none; b=tXHsF5L/DT79TK7neLxxlUF0r3P+f83FIJqPuXMp8mSc8DAlWCkEdS5N2TrgWybvALs0veHUPomuJqcS+CpkMsDfOhn5ndZhN5wyJKMxofldxFfL/n5rBAIXXJukLcQyyl/IDWNH4dd71MsAvp0wTbXBsKuYq8ohyLzobPBk6og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790018136; c=relaxed/simple;
	bh=hmrg+XpJNYLDdfEEkchfSyVuGEd3NatTTVR60RLKvr0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c4Rq4auWNXiTtyS4+5eRK6l2soVKUD7iIZ1fbtpyM4w+nyxZYu3MBa+AZd30yg5b5vaPGWkx/e1mc5rUrh1zHqDT1choIA2Rq2qYjjB6+eBV57+ToGZ5tWOiFnByEpUeNMT8Jf0JUEshyUu5f4Dp25yeNOJE3O7obo1wszaqbAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mZVthxjB; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mZVthxjB"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912df756so23355575e9.3
        for <linux-ext4@vger.kernel.org>; Mon, 21 Sep 2026 12:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790018133; x=1790622933; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wULW290f2x1A0UN781hUcJJzFUUq+lwGDJV+sTEYl00=;
        b=mZVthxjB0B6HZDQMOUaGQEY0i1Byfn9wju+wcKSBUC7rENgaErIp5hghlg8FODXZRs
         Z65NuwSujrxcqTv9/BlKSc4L3sqlAbwWwUnBhlYMofve7/FY6dpLsQ8DjK3KisldAQjF
         kReLz/nhcAibL0NqYHDCWh+CZb00Y4cLopPJooqo81bIl3Yl+Ez1av9L8k4q6cXRcPuv
         OFkbd8KLx7QNbDEw925S6R6/fkPmizNULJhmawlPxlz+1oK5H58BaoC2iW2ZHC2BVeKI
         EsQZ+/Q7ALnLfTDZdTtHhVCNsUVlyK528MvpO+ENUBU22uOpQNFGMAkSp2ZmrYGVM4Io
         Z1SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790018133; x=1790622933;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wULW290f2x1A0UN781hUcJJzFUUq+lwGDJV+sTEYl00=;
        b=yO2ge3CkEp+UQDeCUqAPXWlGgdUPT4NRqMm3COv3PMpnfqNdujnofB2nanD1iJ7WjB
         AiVXlaZZlLZVhkMSmFbSeAlEjfq7QnFjSCtEKExLPm8z68b5M/8inMVQEXq1DUddLJgH
         u09P3vFgqvGcUwfZBAbqaB5SZsb/4SN431QMA2/JoUBktdRBp/Dd7VPyK7uiuIepFhUL
         9wEzc588IS5H8g8BtDywFqjnLkv7/chGnJl57FQ9ZlcooqjdpCVHutxFl9sTIoOsOqoo
         8rw9wjRvPJ/eDOaECpnrU0vjCeLTjIWmISNB/Zm0UJcvHjidEY4dQDg62Vu1DOz6gHG8
         pFQQ==
X-Gm-Message-State: AFuF++ktSdK0AXZacrWtgZq5JglXnCeaH8PMOmtlqt5ZQcOCGEpXlHgz
	5sgoeoQf0gi/y7CnmSCypH2W03HgGB0OagD9YPaO76HBRiDUCGAzzKKNJs2DvZVa
X-Gm-Gg: AYBFou2YWiCMKQvuIilws/arQY+1qXYSwv1GfRY5tx0UhY5fl7QajRYqiGTaAheEYkt
	JMBIefbtlcRzsdtS6/7z73llEPIiOQf1vCwkbwV53Y0sRjTmS50Vu1EKURJzA800J77vvi/k+6U
	lRwg7MsRxhRP+Xl9NKEWj/JFb/NmXOjonBo4bpWdvAg/OjjY8nrArec6QZgFH7R6jumOsuyhRea
	6udsZF72uVXRwhcnocKH10dEfCvOAYe3ldfBa17eZlAmM5FUPmZz0Vxvxyw8DEvkUSD7jW8sp3b
	0PosFiNTTogB+sx5up5jXXM58ZiEJR/wWQpoD4g84pqBrtICRy1RL0FuehpRr/Y7Tt774J2im6j
	6shPF56kVZ5YI25gbDLvsnHVo6PSGVH3x32jdNzhHKKzvTH9gxe+CBOjlh2m1G3ONscXWaUW/rc
	NUNfQqPE4F2Slo054R3jcjAJsHQP11SqWhR/jLpdJqxnog1t2FCYmuMoeNvUfnIH59Kg==
X-Received: by 2002:a05:600c:a410:b0:49f:d58f:1f8b with SMTP id 5b1f17b1804b1-49fd58f214fmr36767535e9.18.1790018133240;
        Mon, 21 Sep 2026 12:15:33 -0700 (PDT)
Received: from xxxxxx.net ([2a10:8012:d:183:329c:23ff:fe37:f855])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fd8cabe7fsm14988155e9.11.2026.09.21.12.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 12:15:32 -0700 (PDT)
From: Shachar Sharon <synarete@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	fuse-devel@lists.linux.dev,
	Shachar Sharon <synarete@gmail.com>
Subject: [PATCH] lib/e2p: fix stack smashing on EXT2_IOC_GET/SETVERSION over FUSE
Date: Mon, 21 Sep 2026 22:15:23 +0300
Message-ID: <20260921191524.44198-1-synarete@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When using utilities like lsattr/chattr on a FUSE backing file-system,
invoking the fgetversion or fsetversion functions can result in an
abort crash due to "*** stack smashing detected ***".

The underlying cause lies in a data structure mismatch between the
variable allocation space in user-space and the ioctl encoding
expectations defined by Linux: the ioctl command token incorporates the
'long' primitive data size, so the kernel explicitly encodes a 64-bit
target memory region pointer when deployed on x86_64. FUSE driver
enforce the _IOR-decoded payload envelope, hence it uses 8-byte buffer
to accommodate the incoming user-space daemon response. When finalizing
the ioctl transaction back down to user space, it writes all 8-bytes
directly into the 4-bytes memory reference provided by e2fsprogs.

Reproduce: compile with '-fstack-protector-strong' and
'-D_FORTIFY_SOURCE=3' (fedor44, 7.2.5-200.fc44.x86_64):

  $ lsattr -v ./foo
  *** stack smashing detected ***: terminated
  Aborted                    (core dumped) lsattr -v ./foo

Solution: change ioctl arg to 'long' but use only lower 32-bits of
result.

Signed-off-by: Shachar Sharon <synarete@gmail.com>
---
 lib/e2p/fgetversion.c | 4 ++--
 lib/e2p/fsetversion.c | 7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/lib/e2p/fgetversion.c b/lib/e2p/fgetversion.c
index f3a5b4cd..eaac46c6 100644
--- a/lib/e2p/fgetversion.c
+++ b/lib/e2p/fgetversion.c
@@ -45,7 +45,7 @@
 
 int fgetversion(const char *name, unsigned long *version)
 {
-	unsigned int ver = -1;
+	long ver = 0;
 	int rc = -1;
 #if HAVE_EXT2_IOCTLS
 # if !APPLE_DARWIN
@@ -68,7 +68,7 @@ int fgetversion(const char *name, unsigned long *version)
 	errno = EOPNOTSUPP;
 #endif /* ! HAVE_EXT2_IOCTLS */
 	if (rc == 0)
-		*version = ver;
+		*version = (unsigned long)ver & 0xffffffffUL;
 
 	return rc;
 }
diff --git a/lib/e2p/fsetversion.c b/lib/e2p/fsetversion.c
index 5f844b55..9b599c19 100644
--- a/lib/e2p/fsetversion.c
+++ b/lib/e2p/fsetversion.c
@@ -47,12 +47,13 @@ int fsetversion (const char * name, unsigned long version)
 {
 #if HAVE_EXT2_IOCTLS
 #if !APPLE_DARWIN
-	int fd, r, ver, save_errno = 0;
+	int fd, r, save_errno = 0;
+	long ver;
 
 	fd = open (name, OPEN_FLAGS);
 	if (fd == -1)
 		return -1;
-	ver = (int) version;
+	ver = (long) (version & 0xffffffffUL);
 	r = ioctl (fd, EXT2_IOC_SETVERSION, &ver);
 	if (r == -1)
 		save_errno = errno;
@@ -61,7 +62,7 @@ int fsetversion (const char * name, unsigned long version)
 		errno = save_errno;
 	return r;
 #else
-   int ver = (int)version;
+	long ver = (long)(version & 0xffffffffUL);
    return syscall(SYS_fsctl, name, EXT2_IOC_SETVERSION, &ver, 0);
 #endif
 #else /* ! HAVE_EXT2_IOCTLS */
-- 
2.55.0

