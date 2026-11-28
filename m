Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795893797;
	b=MWCH+tg2gtKd2Fdc6kuW8q6zvMlwPzOV1dHc9L5HnDvTe1P43qU8KTfWnV3EaFOQ8yWL
	 +yycBn6lAU6+3nnpyLV4Q8ArZ4HVz2/HfLoOd6HUypbK54Jkt++9qjJBR+hq8+ankW0pm
	 8Ih5zGRUTJ0qFB3O4DGVQ0IaZJasQEJ9BOJELctu+VyZCavbtmJgZ6PbylYwXvYKrl2Ux
	 eH+M2S4WrktGJ4Nrk+mwECBoERotoAWWpFETT16BBC98Vn0LLcOdxkXN1zJGBfUvwWB23
	 QwVBjPDVHwbOeNb5AdcEqlvSmsOgiBjv9rhM+v2FiU++dqp1s1dgRL41JgK5rmR6wnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795893797;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=S5U9mvhX7FgMjWgJVB7xnuiHXthEITKHDY+rY72aCwQ=;
	b=nQav4FXp9PGL8kuYv/YIZ/098YMIPU6ZomA9/lBBALjj1T5hqtyX0jXdjKvaSxxc82iV
	 Ml/1BJcgfM/E6lvTSYs7GjBsVtTIoW6c8mA8GDEa8CSv8yBQto47WnBKvB62XWXux6q9B
	 ag7wJGhsWP2uxCJ6XBNXy0LzqdC05B0qO/UazZntCJvg7I9KE2TNmgidok3Afx0kRv7zm
	 SeKCWAqeEaD0nkfFAtKV9AelOipYECQlcZrl6QnY0HYf5PIgrhaNjmG5BhZW2YVIGVgyP
	 1+PP8MX/3e1dciN0fMegJowu0mxpGgzkhbME3eVBwCqUEZs9OJt0NCTiOphYIm0FzoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b="ASvhI/3F";
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC844606A31C
	for <linux-ext4@vger.kernel.org>; Sat, 28 Nov 2026 19:23:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC844606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=ASvhI/3F
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6ASJMsn7002553
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 28 Nov 2026 14:22:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795893776; bh=S5U9mvhX7FgMjWgJVB7xnuiHXthEITKHDY+rY72aCwQ=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=ASvhI/3FIGQL2XvIc7Z3nU0Mfd244d2VDdtcRTge5WD+ZBbaoTFt0l+L72yktEuz5
	 1a7EVOSDR7WHQA3tfodc9FZBSOXamjEXdx/BVeNUIwz08VdkpcCKFh1ui/ak3YWZ7Y
	 eyD7+Bkf6aj2AUjoe9mnhnFUlOewtzoEDJA/Abyxyvz5lA39dgHbp+nGCBZzlnkmt2
	 BeqbOhgC1YF1JmS3z+cuV/zKWAk9+mflTC2hRbB544reCXZwO1PTJJru/WkwnbY9MM
	 pWFBw2XseGB4r8yoBWjC8qfoAAYiAVGos5c4zCwPeV+IQI783vtO863wO5rjeraq6O
	 ZfRkW56/1l2PQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id F23062E011A; Sat, 28 Nov 2026 14:22:53 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        linuxquota-devel@lists.sourceforge.net
Subject: [PATCH] quotasys: silence errors caused by vanishing mounts in the mount table
Date: Sat, 28 Nov 2026 14:22:45 -0500
Message-ID: <20261128192248.148122-1-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Even when setquota is given a single explicit mountpoint (such as
/xt-vdc), it walks the entire mount table and opens mountpoints three
times (once each for user, group. and project quotas), before
filtering out the user-specified mountpoint.  Unfortunately (as is the
case with xfstests's generic/234), if setquota is racing with systemd
creating and removing the tmpfs mount /run/user/31415 when commands
are run under "su fsgqa", this can cause a spurious error messages
resulting in generic/234 failing intermittently.

Fix this by suppressing the error message while scanning the mount
table; since we take a snapshot of the mounts and then iterate over
them, it is quite normal that we might have some mounts that might
appear or disappear while we populate the in-memory mount information.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 quotasys.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/quotasys.c b/quotasys.c
index 7cbc864..6ee920a 100644
--- a/quotasys.c
+++ b/quotasys.c
@@ -440,7 +440,17 @@ int do_quotactl(int cmd, const char *dev, const char *mnt, int id, caddr_t addr)
 		int fd = open(mnt, O_DIRECTORY | O_PATH);
 
 		if (fd < 0) {
-			errstr(_("Unable to get a filedescriptor from mountpoint: %s\n"), mnt);
+			/*
+			 * The mount table we scan is only a snapshot; a
+			 * mount point which has been removed in the mean
+			 * time (e.g. /run/user/<uid>) is not worth a message.
+			 *
+			 * Besides, if quotactl_fd(2) is not available, the
+			 * fallback where we call quotactl(2) doesn't print
+			 * any error messages, but just returns -1 and sets errno.
+			 */
+			if (errno != ENOENT)
+				errstr(_("Unable to get a filedescriptor from mountpoint: %s: %s\n"), mnt, strerror(errno));
 			return fd;
 		}
 
@@ -1090,13 +1100,16 @@ alloc:
 		}
 			
 		if (!realpath(mnt->mnt_dir, mntpointbuf)) {
-			errstr(_("Cannot resolve mountpoint path %s: %s\n"), mnt->mnt_dir, strerror(errno));
+			/* Unmounted and removed since we read the mount table? */
+			if (errno != ENOENT)
+				errstr(_("Cannot resolve mountpoint path %s: %s\n"), mnt->mnt_dir, strerror(errno));
 			free((char *)devname);
 			continue;
 		}
 		
 		if (statfs(mntpointbuf, &fsstat) != 0) {
-			errstr(_("Cannot statfs() %s: %s\n"), mntpointbuf, strerror(errno));
+			if (errno != ENOENT)
+				errstr(_("Cannot statfs() %s: %s\n"), mntpointbuf, strerror(errno));
 			free((char *)devname);
 			continue;
 		}
-- 
2.56.1.839.g22a8290db9-goog

