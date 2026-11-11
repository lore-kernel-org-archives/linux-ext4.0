Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794438167;
	b=ttuB4unMJ4mKOB0Sj5YObiuVnhcprQ9QK12i/v0850sIp0fIaYmqBiLblB4hjt5Ooh/4
	 wY/ThNuJLmsGbIzFj8M2e5Y4JBN2PTHTE2eRRsdNNOyzdt8wkM6QpQJw49GkUIEMAQyOi
	 VuCLo9ZvjT18d3XbyVPuJdYVZFtEKB+CMtom5wqOfEAoag6mmTqEZeQLkC4nJLVd3nDEF
	 PRS6RLPxufDo8iNOW8Ej6RFcYfA/c/BnBTkw08sdwlFzHnBZ0D1vRLMbHYjVTNJtyYgI9
	 p3CyLq+CF4DYfVbuhfBu5TPbH59WdSBTFPSPAJ+to+P2hlKC96ZR5dIimFZgLuzFrOA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794438167;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=8/FmsCQwKQnur9e1uQv7EeBDMG1dNqw9Shxj/XD9eIw=;
	b=dXdOsYIl7UsiVoPlTkoueu/MW3uAr8hbYl4Sis4oAAHYtudw0sF8l4dpIdlBEFITWgqf
	 Jv80VIzitARBUqhpUQmLmMF9QumUzJ/4MgYEOr7Sq/twfsHBUt7DphLI1BYArE2bB55L+
	 xj146hCys9MkZj4Z57uKYPesbsh72KSs8RHRvHLTWadhzE+I2TCzBmeMCPvaEC7fY892S
	 HygmtKINEuKjeUMauXyVjMnSS8KCMdwv88Mwpf+XDvFNy6RpVBEhluNbZ4Qbv6EaDwyqP
	 Dk+LYP5dAwYI2MWy9uC7IBiQ6suQeFEnnl3ZUUXjnt0kUN/06GOOYGqUFefb2IVXn7w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XJ2ghmJg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1038960A2607;
	Wed, 11 Nov 2026 23:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XJ2ghmJg
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794438166;
	b=ml2pcFBurdhkviseGIbDIWwRH9hvsj6xvDLIdP6snDin74YwwfQzNPlyvY1F8nCRZmk1
	 WGyyrQvzFSiuiRwMllt4zs5hafoAbjKsFSBEnc+yzjc2lI6S64wnjWHpRZmUFE6+oWrb2
	 vsJ/O2PHGCjMuffHtViT9hCwYkdqBWLQ+KIbkxmDYjx/eYdL6Yi6T7e3p8LdvZoOUgAfL
	 BFxD3UYZj8F2erOz/aqUv2f3iCGGB2XzBpSvbTSOb+6w+6o9pH3YCHOLSjgeNCGcW1HrD
	 z4n0QgPn+nwi83f/o2s5zBst6imT1010RlZ6krkbmABpmCI9JIw/clusVPGZ/8vM7ZA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794438166;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=8/FmsCQwKQnur9e1uQv7EeBDMG1dNqw9Shxj/XD9eIw=;
	b=EKmJKrey6Q3fw6vE+G6LXdWLgcf5olV/UyskJfKqYjTzRnVpTsGAq5a0E+pKOuehKK7y
	 ew76A6yT7h/FawZ6Z5DNXkKPX64cgPbkkV2VeC255wB8HyYcg6VZKfv3fnYQeojD6OeoQ
	 aYu6G7lYQPIcT2SJP1rGPgim9tnwh1H/Et6DWD3HDqUAdPJak26OUp09gIf/4YwX2Xnkk
	 PIBC14QFoQBt+B8llpUVFHWE6G1EJFEZMIdPWTO1qqaIMfqLiQM2G2MPCAsT94M+w33pU
	 QdpwG0yXEjnxJc5to0cmad3fGdMyTSeS5C3EEYbcFs7b7W6zlIvRbqTIC9VbZYNmGcw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4E9291F00A0B;
	Wed, 11 Nov 2026 23:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794438166;
	bh=8/FmsCQwKQnur9e1uQv7EeBDMG1dNqw9Shxj/XD9eIw=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=XJ2ghmJgcXw6OCkPEPYpX6/aRteUFzt55UbilmlbdPMrPvGmrUTN/Zkhbk3tINfjK
	 XN1Hyphbrw7ZDXPxQmKpiJRVQSioOkCitz33d01hWaG2/o6FZX6QL+T9xqJzDppn41
	 G5XQRYNVkL+2Ff2SknVzPbGi/7F0UJxSLcabfcmMOouCxUyEeKX2FNyHyzzFcJa7Wv
	 3Av8Im+znsq6asf0oRmLZUgn1KWVDLWksbbAvqdFTXwsXohwiQBp1ADbvpBS+u8dHy
	 wUN3DnIyc2sVHRX1CmKdPk3dggN//ViVn/uDAxFk9gVI8+zkKGu4dFr0W3gl1BUc27
	 l+XlXchqxAmfw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id B2D8349153;
	Wed, 11 Nov 2026 23:02:45 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Subject: [PATCH 0/3] ext4: fix counts left by fast commit replay of a mkdir
Date: Wed, 11 Nov 2026 18:02:44 -0500
Message-Id: <20261111-ext4-fc-replay-mkdir-v1-0-4b20be29aed8@columbia.edu>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMSw6DMAxF0a0gj7FEKEXQraAOQuKA+RU5tAIh9
 t4Ab3YG7+7gSZg8vKIdhH7s+TMFqDgC0+qpIWQbDGmS5ioMaV0ydAaF5kFvOPaWBR8m0dYV2VO
 rEsJ1FnK8Xtnqfdt/647McrbgOP45FbLPeAAAAA==
X-Change-ID: 20261111-ext4-fc-replay-mkdir-3c0adf845a19
To: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Zhang Yi <yi.zhang@huawei.com>, 
 Harshad Shirwadkar <harshadshirwadkar@gmail.com>, 
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 tz2294@columbia.edu, stable@vger.kernel.org, 
 Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794438165; l=1985;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=s9EkpYwpSolR0KtDZVkWqHGcJwk8MoygE6T++8LQ7sM=;
 b=VpVkrzKAvefNpNbgr52Wh3U42SQ1jXdqRJVWgknqB+j4rUFcniNknG2d4PR+K9EcFf4bmjAp+
 JUeAJX8X0RrAjkLkqVT/I9tj7H8ePv9G1bBNCu4oJ3rwYZnU47qSNRO
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu

On ext4 with fast_commit, a crash after an fsync of a file in a new
directory leaves counts that e2fsck has to fix.  The mount works, but
e2fsck -fn reports:

  Inode 14, i_blocks is 0, should be 8.  Fix? no
  Inode 2 ref count is 3, should be 4.  Fix? no
  Inode 14 ref count is 1, should be 2.  Fix? no
  Directories count wrong for group #0 (2, counted=3).

All it takes is

  mkdir a
  fd = creat a/f0
  fsync(fd)
  <crash>

Fast commits don't track directories, so the replay of a CREAT tag has
to redo what ext4_mkdir() does and misses each of these counts.  The
replay of an rmdir has the opposite problem with the link counts.
There's one patch per count.  Patch 1 has to go before patch 3, since
with patch 3 the replay of an rmdir frees the directory and lowers the
directory count.

Baokun has the same fix as patch 1 in his LBS RFC [1], plus a flex_bg
update that never runs during replay since s_log_groups_per_flex is
still 0 then.  Baokun, happy to drop patch 1 if you'd rather send yours.

This bug was identified and confirmed with the help of a deterministic
hypervisor currently under development.  The C reproducer below however
hits it every time.

Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/ext4fcmkdir.c

[1] https://lore.kernel.org/linux-ext4/20260508121539.4174601-12-libaokun@linux.alibaba.com/

---
Mani Tofigh (3):
      ext4: fix directory count after fast commit replay
      ext4: fix directory i_blocks after fast commit replay
      ext4: fix directory link counts after fast commit replay

 fs/ext4/ext4.h        |  4 +++-
 fs/ext4/fast_commit.c | 34 ++++++++++++++++++++++++++--------
 fs/ext4/ialloc.c      |  4 +++-
 fs/ext4/namei.c       |  4 ++--
 4 files changed, 34 insertions(+), 12 deletions(-)
---
base-commit: 067c5c24cef23d913b67eaaf71ae67e7169a6620
change-id: 20261111-ext4-fc-replay-mkdir-3c0adf845a19

Best regards,
--  
Mani Tofigh <mt4022@columbia.edu>


