Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793126611;
	b=EsMbTLchduUxLRopG08TEu4LrMWTp0omJcgI36BdNrOboRCzOK3REyb2/oKS+CuA9j5b
	 wrzp4vkSwkKY+N2MuLS98kdwL/4EdoZJKmYQ7s6wvKj13DdqrgRvqU4wOmYSmd2tsbx5L
	 NXGzl3yFpF5aTAec/8FbVXXn+/AgUWm4j4IraTOA8cbvoi6YL76Woq6mmM+GzjiQW9xUB
	 up76hD05J1JwVExu+6BbfIx15Wuu5atH+94nPrS858pfP+DIyMBlkTE0fuK8lzAVyDmSy
	 zd/oL4uvsMWbNCxhXLZvLdXd9cOHf1uYZWhx4XXnZ8U7yBnXaMKEgcRlVmqg9fiQe4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793126611;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=/3tibRvQ76ExQ0W3ZkBRUL/Y1H2AP4fK7D1nRgB0KTM=;
	b=rdwZKn8E1PY4vln2huB3UdCdgvzQaWI9PONnW5MIiZn6W55qd1o46iaqzJcqY2osmsY5
	 o/6lKIL/LDRk2jZLRxaGUwSnP6JKARLMNfZtsJ68WvYoLzDDIUZuT8xlq8A7MTU7aou0p
	 Z4eHQmQzdscodT0lTsIp1HjzPec9IfCAzDxDrcLc8sRITY/jUVX7l8eyavz5oQl7wmWuJ
	 uzjFsj2U0JbbQaGMSTTZVdpSuvFqAOa9VEge0Lt3WDM33mBoOVXLumP8jASDO0P1qPSuA
	 NZ2IAStFOy5aZsA2ULbQbaHOKTQGyEl9gXCnW+t+E+fvxJXMlif9MGM4cNxk7PWDxew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b="aL/2Qb2A";
	arc=none smtp.remote-ip=209.85.219.45
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095DD606A31A
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 18:43:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 095DD606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=aL/2Qb2A
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-91791ec1b83so2009706d6.1
        for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 11:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793126610; x=1793731410; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/3tibRvQ76ExQ0W3ZkBRUL/Y1H2AP4fK7D1nRgB0KTM=;
        b=aL/2Qb2A6wIg62sataJ4dhl7YCi8CuF/ywKK2ZkdAMm/4r+vwoyJNNQgWpuMhAe5Hu
         DOoKVXejH35OXH31pDusY1ns6/OsrpceBFGvQsT8fySizIjyxjJiyKP3MW4xslN8ckcw
         sEqavfAF8QVq8cnobdZLdkGDdscMHzgbUlcbAKWDFrjZ62LvAS9RDfmo9Q4sUyhnQO76
         VfccEHnwoU+9Czq+7TFzm5UBcdGf+VvrQRdtcjKVeD1CMV752Y/EJZ5y8IRWMkT7p5rj
         hC0TjbjuIIqEqX0sMCEnkaBA5dSaAt2pRP8jUvi5RESHrom6vO0akDM9Yd3ph49smflz
         BLVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793126610; x=1793731410;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=/3tibRvQ76ExQ0W3ZkBRUL/Y1H2AP4fK7D1nRgB0KTM=;
        b=vZjlfLGLnS8Ka8ub3++d5kwcHPHonFYSJRLEJi+FJdNtCRf34LM+tVnqF9x3h+ZN+A
         TmxkblEboOxNdwNEfza3etILnCrtZDRgC0X69llsLIbitXTJikHoIeo2bUc0zAPQ982c
         Odr+iWgT2LagZ4tUv/GUbbRa+vSqDk50KAixNmKEIzwMVbmWjpNYVJ+y0niMuywZHuJj
         RjTfzOgYe7pq/0UUnZXKKngtLzOoENhWlhks1oCKSHONZU2uuvifpI9TL/950Ai0jXDF
         UF6qEylGMH0kP3W7w6T2bJTVXJN0dQs4YSgSI8T3rvlYV5032cuZgIN1QI2JXIbs85JT
         EB9w==
X-Gm-Message-State: AFq9FYKt6WgmNJm6LGKSAkjgrvRarQYRR4P6YQ4UsewYA888HJmWTssd
	z1dNlKfOrHaW4I/f/3BU44b8YyVIV+Zdmp2TeIXSpEbvX4DQ7za/WYAX59V9/6ukIGo=
X-Gm-Gg: AYBFou2DtGOae+bl10Sm3evU7VR8jTNspdNBgyTWbEcIJpSf0zhP+o0Pbwx1vy81a+o
	u1gNhGWqmDgbaeX49NNhp3gokXSQ6ZN1Y9BcE1u09MyHmL6CeoJPZ17A7mIkeLUZeC5qSx/Kac4
	EAuXNkXFBFrfzU0lAhpMsBq9uOLYQq2Y80rKLQUXjgPzLtNRpr0HmCgbdYRklQ2dfQjmRCtfev6
	SMyvaD2Hv0r5SnjunyU9EF6974nItEiv+ljJJJp+NZxrST1OTmAfLfiluTKTCPsblfNmvBuUPNh
	3tJQJEgs0JSdHWpCgDP+HM1SZeJvEJUZCsEGkpeTuR4I5KaizVx0arW8/cg2uOij0L23ZtltUXa
	XV1Hda0EtL3ckN7MfhzsiSQh9ZgTqIBklbsvTI7W/NHAPQHBUU3GyMrkSBQ8LiDTZ+Vcz8FPE96
	NDF59d7AWT+gzrvJHry8l2RcY/ex/BGPuZ8aRi7CJrMINm1GxjsC9b69iHTe3KpXUltD5HjT8PR
	YBBN3tYBPoNGJjUJzRvP+KId07vFy0jiamx2jTpSNor9BVosnpV69kSysGA3Cn2oepnlfENyICm
	2dtpMkRC9UioTCwM+v30T5+QhIlaFFWXaU2GkrfIoX24Q1A=
X-Received: by 2002:a05:6214:4198:b0:91b:5d3a:5106 with SMTP id 6a1803df08f44-91c48e86a0amr179280536d6.52.1793126609742;
        Tue, 27 Oct 2026 11:43:29 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.253])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c6e20ba4fsm31819396d6.14.2026.10.27.11.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 11:43:29 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 18:43:14 +0000
Subject: [PATCH] ext2: only flush DIRSYNC directories on every change
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-b4-ext2-dirsync-v1-1-3dcd012d518d@toxicpanda.com>
X-B4-Tracking: v=1; b=H4sIAMHw4GoC/03MMQ7CMAyF4atUnrFIolAQV0EMsWuoGQKKCyqqe
 ncSWBg/y+9fwKSoGBy7BYq81PSeK/ymAx5TvgrqUA3Bhd67sEeKKPMUcNBi78x46Dn56PwuEkN
 dPYpcdP4WT+ef7Uk34all2gclE6SSMo/t1Lj9T8K6fgAPV658lwAAAA==
X-Change-ID: 20261027-b4-ext2-dirsync-86ca140154bc
To: Jan Kara <jack@suse.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793126607; l=1707;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=+K3FWhF6zDMGz/BBYD/9H90CCViXMrrzDaS65J+qi7Q=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QBPzjtD6VIdsn/SXpO6bRWXb/ppKa0VePG+69S+DwXUp6u+Lkjsi6IoVmuGN1N2uwOUijesbDuS
 IeNJ5pTVCCAc=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

Every change of an ext2 directory is written to disk before the system call
returns, whether the directory is DIRSYNC or not: its pages with
filemap_write_and_wait() and its inode with sync_inode_metadata().

Writes which reach the device for 2000 files, and 200 directories, in a
directory without DIRSYNC, with the flusher turned off:

            create   rename   unlink   mkdir
    before    4000     8000     4000     800
    after        0        0        0       0

In a directory with chattr +D the numbers are those of "before", before and
after.

commit bc943f4872a7 ("ext2: Don't flush page immediately for DIRSYNC
directories") moved the flush from ext2_commit_chunk() to the new
ext2_handle_dirsync().  The IS_DIRSYNC() check which was around it didn't
move along.

Fix by putting the check into ext2_handle_dirsync().

Fixes: bc943f4872a7 ("ext2: Don't flush page immediately for DIRSYNC directories")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
I ran into this while testing an overlayfs series with ext2 as the upper
file system. Directory entries were always on disk after a crash, also
the ones nobody had synced.
---
 fs/ext2/dir.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index e17bbc7598c1..5de32c221a83 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -442,6 +442,9 @@ static int ext2_handle_dirsync(struct inode *dir)
 {
 	int err;
 
+	if (!IS_DIRSYNC(dir))
+		return 0;
+
 	err = filemap_write_and_wait(dir->i_mapping);
 	if (!err)
 		err = sync_inode_metadata(dir, 1);

---
base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
change-id: 20261027-b4-ext2-dirsync-86ca140154bc

