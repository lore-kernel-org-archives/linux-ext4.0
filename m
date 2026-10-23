Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792790755;
	b=yXvCNO6Ts9b2C47lPEMUFqOkYbHdn+YVF38HmMlSL42wAPSGcO6xG1VMHdhz888bXtVP
	 cul078mL8peqaEXnxZWtEO1jb20WDtF3sNoIghIlPVtZKdjD6blrNAjTjfpIKJF9Ivt64
	 uSehba5l5MkMa9AjzZ8S9GTlkKIgSSjzPgwDI6snv1z2XZNKaQadkJuudWNAOaziGlXiG
	 0bsNk7N6PQ727jARTGN6oTBP+V/nIs1p1UpQx9bCmtjkidoTNAdvyJkS+lLbvRjlvA33m
	 JQ48GwPM+4WbZP7okQ8IRhIKLT6El4H5SYBBSKLiOPtl6heEM8A75UKQobG+KtvCjVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792790755;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=wrEJlB0+GhfyKlvL7QNS3Hc46DaHpO9tDay0caS65O8=;
	b=tZYzkxjbpZNpJGvY4f+Pf7b4fMM0fGysYpQn1exPNWwE1/EchG8aTGeVYeDGknxRnIEU
	 SIxXrjfMTtqDxVcPcBYAws/CiOuuuzTggVX8WqhgjRlQPxe61hk9Q3lEuEaP7921keOBZ
	 lqv+OO02/TdC3tZ46F3QppvhJ3v8BKsYbbJGv1Xu3HsRBqYobgCClnilB/5hGcdBKBP4q
	 83RiFmodl69mSrEduG7eNTs7Lp2ytNQEUfKJOLzGFxedIURyN9/Xpktep1BRFVOPiE03J
	 FVxsPdbaCEiySPOlqh5+oVYnu9RcTuHYLukFYMCB0JAo3Ug+Z/ynoyqd/B9QMOx9nrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mUJQuS11;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5E8606A31A;
	Fri, 23 Oct 2026 21:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mUJQuS11
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4C21F01825;
	Fri, 23 Oct 2026 21:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792790754;
	bh=wrEJlB0+GhfyKlvL7QNS3Hc46DaHpO9tDay0caS65O8=;
	h=From:Date:Subject:To:Cc;
	b=mUJQuS11a+GX0VRvNJR7VYZnSq8lZ6UoXZQ4DvXQM2OR0XLzhjr16e/wcdKTSLxWd
	 NA3/wcUpieSoQPSUf1s37npJMv3Lbzq7RtQgo7ulC0JAlFzy7O6LlF45u+05Tszcyq
	 SmoWsOL7Sv5lqUDUkRbnbVUjCqUguv00mwzAdFR9bCEHabR5hqpjCypagwLjVYlbsC
	 aPLyiiMEK4QMRRVV6KmR11arE6EAQC4PbeVthIhfz2YRnP6GaPrGc4PVmmVkdfkRv/
	 fpXvHJ3kHRQ/Tu737pFF7uwmtwBWgJ8Q2SoY3mM4auxjMEvT8O1tLCiKN7lUla42Dc
	 sIA2k2AQ9Cxnw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 23 Oct 2026 14:25:02 -0700
Subject: [PATCH v2] ext2: Make sbi an proper alias for EXT2_SB(sb) in
 ext2_fill_super()
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
Message-Id: <20261023-ext2-fix-context-analysis-clang-24-v2-1-a33961453899@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/5WOTQ6DIBBGr2JYdxoYpGm66j0aFwij0hpogBqN8
 e5Fe4IuX/K+n5Ulio4Su1UrizS55IIvgKeKmUH7nsDZwgw5XgRHCTRnhM7NYILPBUB7PS7JJTB
 j8QFrULxulbVKcnllpegdqQSOkUfz4/Rpn2Ty3rwbg0s5xOV4MYnd+2twEiAAW6mMlMbyTt9fF
 D2N5xB71mzb9gWKEUmm5wAAAA==
X-Change-ID: 20261023-ext2-fix-context-analysis-clang-24-504b5dd53038
To: Jan Kara <jack@suse.com>
Cc: Marco Elver <elver@google.com>, 
 Timothy Day <timday@thelustrecollective.com>, linux-ext4@vger.kernel.org, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3093; i=nathan@kernel.org;
 h=from:subject:message-id; bh=u9u2g1UD0vzTIZM1IpXD8e2bUZrrmTudbZU7VDqIVRs=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDFm3L2wpvHknyD36qqxmjtWto8aifb4M3xhFg575eaZ4C
 z655K3VUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACaidISRYdHFALYnh39r/TjN
 kfrz79/SxMcMD/vOzZ80QcFb6OeP1/cZ/hn0FO6YffsXw5yGU2Kbf09eUy7l/GryGt3dy9xyPK7
 JGrADAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

A recent LLVM change to fix parsing and validating __guarded_by on
structure members [1] reveals a couple of warnings in ext2_fill_super()
from the annotations added by commit 023051c2d0f1 ("ext2: mark
s_mount_state as guarded by s_lock") and commit c23746524faf ("ext2:
annotate s_rsv_window_root as requiring s_rsv_window_lock"):

  fs/ext2/super.c:1040:7: error: writing variable 's_mount_state' requires holding spinlock '_res->s_lock' exclusively [-Werror,-Wthread-safety-precise]
   1040 |         sbi->s_mount_state = le16_to_cpu(es->s_state);
        |              ^
  fs/ext2/super.c:1040:7: note: found near match 'EXT2_SB(sb).s_lock'
  fs/ext2/super.c:1138:8: error: writing variable 's_rsv_window_root' requires holding spinlock '_res->s_rsv_window_lock' exclusively [-Werror,-Wthread-safety-precise]
   1138 |                 sbi->s_rsv_window_root = RB_ROOT;
        |                      ^
  fs/ext2/super.c:1138:8: note: found near match 'EXT2_SB(sb).s_rsv_window_lock'

Context analysis does very minimal alias detection [2], so it is not
able to figure out that sbi == sb->s_fs_info == EXT2_SB(sb). The only
reason there were no warnings before the above LLVM change is because
the annotation was not parsed and verified correctly.

Rework the allocation and assignment of sbi to have a direct assignment
of EXT2_SB(sb) to sbi so that the analysis knows that sbi and
EXT2_SB(sb) refer to the same object, clearing up the warnings.

Fixes: 9708538ba204 ("ext2: enable context analysis support for ext2 filesystem")
Link: https://github.com/llvm/llvm-project/commit/217e229a1f32785fccdd3b3f51429f0d309dea45 [1]
Link: https://clang.llvm.org/docs/ThreadSafetyAnalysis.html#no-alias-analysis [2]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Changes in v2:
- Fix allocation size (Sashiko). I thought that I checked that they
  were equivalent but I guess not :/
- Link to v1: https://patch.msgid.link/20261023-ext2-fix-context-analysis-clang-24-v1-1-2b35c33cd0fa@kernel.org
---
 fs/ext2/super.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index fb217ef2d69f..bde5b433776c 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -883,17 +883,18 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc)
 	__le32 features;
 	int err;
 
-	sbi = kzalloc_obj(*sbi);
-	if (!sbi)
+	sb->s_fs_info = kzalloc_obj(*sbi);
+	if (!sb->s_fs_info)
 		return -ENOMEM;
+	sbi = EXT2_SB(sb);
 
 	sbi->s_blockgroup_lock =
 		kzalloc_obj(struct blockgroup_lock);
 	if (!sbi->s_blockgroup_lock) {
-		kfree(sbi);
+		kfree(sb->s_fs_info);
+		sb->s_fs_info = NULL;
 		return -ENOMEM;
 	}
-	sb->s_fs_info = sbi;
 	sbi->s_sb_block = sb_block;
 
 	guard(spinlock_init)(&EXT2_SB(sb)->s_lock);

---
base-commit: 782654a3e9c4065dea2e9f10539899d348b7a1fc
base-tree: git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
change-id: 20261023-ext2-fix-context-analysis-clang-24-504b5dd53038

Best regards,
--  
Cheers,
Nathan

