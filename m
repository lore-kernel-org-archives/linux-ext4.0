Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792788792;
	b=vzIm4/TOaFEeF8IGjf1j2HXwIEiWkA4IAOLs6I1FKzt65w8Xs0H6/RIgWyI4gfKjUe++
	 b95WEY/SpKseZrEzWWc4XQVtnzRDgij/gZFVLz1uUF5erCPsKMQtI0tZeEtOEPQ4bHInd
	 R5bG0jQ/KdN/8X6U09tq2zGQnTzgrnAf8psKeAXGwRF+1KykR5pJdY7JFxNhsrqxJ7stA
	 SVv7nzcUYbg/NrvwFpwyC5k4jtvyvCdpQFhffjoU0rLQ0G+xnSc5WiJDiPQnvEWGo7Ey6
	 KHuAitlKlhGLIQXXhQ0I0U0lMk8JIn3WX/1/YJO8J98GOlLtlKBjibY8rjMCcUL7shA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792788792;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=4HZ7/B6K41WI+OjSL2WoUlyq+xEMh77iLnsD3cjbDk8=;
	b=aWkxPK2KNY7YGFCORy8tnhC16ErMOOt08WnwkCGAjiGPii9tAiz48a62r3JFlvl/Xavu
	 MEDKt5CrLBehNDlE9JG3jaThtz/tqjw9jLoruxdoeYWjuMNDKuvrOqL5T3cYVxS+I32MM
	 3iNz5ExwhyWa+awHFT+OezLrAzuAZNrA76HdU3iFMvv4NIJafnDfjE6QQYkUcUuVLM0FH
	 k4JkJXS0O96egDpPCALz3meRdo+9Cn3q3INmyFmRPWtQvi6G1OIj18F15S0mp/qmi9qZZ
	 EonDttNikN70I783wJvpWS/U1ox8fgsudIpZFW+Cfk+palX4GllXidTgGZjLJmHUEvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TtqZjM5q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDB9606A326;
	Fri, 23 Oct 2026 20:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TtqZjM5q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE68C1F01829;
	Fri, 23 Oct 2026 20:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792788791;
	bh=4HZ7/B6K41WI+OjSL2WoUlyq+xEMh77iLnsD3cjbDk8=;
	h=From:Date:Subject:To:Cc;
	b=TtqZjM5q5rNTZOxYZWGatBueLAxHHbgcjQW7YC1RebGfN6lAq7G8sg1yumKJJXxcK
	 s8yFfp2NCSEgJGF1MG8fdFiVbKCyvRmIg9/fPHTxhgRNmx1kawAGtBIvF4MamHt4JW
	 DcK0fU+XpSBJ/9nh/5zXkIAcq8iCy0C5pFgiqini/DmIHGFc0WuCq0J88RTfBp/h3/
	 XxyfdCfopxLn2ptHJJJ2vtd5gqSAevMqSTbvf1tH08N1AdYmE0Jg05w0viyC1mBZik
	 3efp4XBst+MSnb2A2SgUjBrcqU7+AzCLgnMLJvYwmyPR+UQhKbMumsgG2b4xmgAe/H
	 UxudyA71+czfQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 23 Oct 2026 13:53:03 -0700
Subject: [PATCH] ext2: Make sbi an proper alias for EXT2_SB(sb) in
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
Message-Id: <20261023-ext2-fix-context-analysis-clang-24-v1-1-2b35c33cd0fa@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/yXN2wrCMAwG4FcZuTbQpauIryJedG3UyOikqTIZe
 3ejXn7wH1ZQrsIKx26Fyi9RmYuh33WQbrFcGSWbgRzte0ceeWmEF1kwzaUZMJY4vVUU02R5pAG
 DG8aQc/DOH8CGHpWt8Ds5nf/W53jn1L7LsG0f1qXLrYYAAAA=
X-Change-ID: 20261023-ext2-fix-context-analysis-clang-24-504b5dd53038
To: Jan Kara <jack@suse.com>
Cc: Marco Elver <elver@google.com>, 
 Timothy Day <timday@thelustrecollective.com>, linux-ext4@vger.kernel.org, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2862; i=nathan@kernel.org;
 h=from:subject:message-id; bh=CBjGob9Wbjsm2H69+Nh8omZetImtL3LfrjGHo1E6V5k=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDFm3TxoltPQ8r4jJa/h1boOTnkO29vaAeZ+61eTZtirlu
 ftUNet1lLIwiHExyIopslQ/Vj1uaDjnLOONU5Ng5rAygQxh4OIUgImkbGH4K3BPbI/N+iuPPifv
 9udfUrGU8V6Uw4rHc/7/t3YRXbazpoORYYIx1/8dD6NZmqr+fNNZ2n7LuqT7yJJdsk2XmFca5MX
 qcwIA
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
 fs/ext2/super.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index fb217ef2d69f..b55f9ce3267f 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -883,17 +883,18 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc)
 	__le32 features;
 	int err;
 
-	sbi = kzalloc_obj(*sbi);
-	if (!sbi)
+	sb->s_fs_info = kzalloc_obj(*sb->s_fs_info);
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

