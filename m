Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2D4175A9D
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2026 10:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792147073; cv=none; b=HH20sw3VKLMlzLcyEWkewFnE29BaYOVD0tFOiNfrQHBsCz8ZVQRVZ8ulL2HasE/0bhKMH1IyLcjk7ADAo4ERfb79sCNuCz/C4PBCA20CnTtqPKFIWBE412WHLQR+g/ehxdqZ82TXq3T51Pjit1HTkgv9Zi9xjteETu3xLjT6hRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792147073; c=relaxed/simple;
	bh=UsTtGHRl7YsiXbTcd8vpkD3E/t43DTNiHhxmC8Bxs4Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MJ3bB90L51HZ5RHZ1BsytR8QfHaCvR4Iy7Kr8hmRu+CrIw/eSTWnjdxqQhQ1fdDu/GRGwZvntXxrERkKnGht/PkyOZoRRF8P83PFdASMzkNl8CyyPYpupvQAqWUMVyxOifNFvBe4NtQmKfdkMUrtqXlxt7kN+e9zALNByQLkpdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VL/qQZUF; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VL/qQZUF"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4980fe6b3beso5320095e9.0
        for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2026 03:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792147069; x=1792751869; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=J1cLBp+fIudU+J+n4s6nKX2nnwxELgfGqb7A1F2ozo8=;
        b=VL/qQZUFx/6hBK9uogVlXcQTd8l3L3ifl4rM1ahUEW1y+jbpH0zrK58xdiv7ic0Vhl
         7D4uhuA5kb/HEJXf5fhveD+HglfJcDISodvzvSkRg3nJ/bVValOFKelrB94eoSFF/ZqE
         lpMcRkg3wuYK1jH1llvFBzP7mdf8dfUk7kcAPxxeTgikeTh0xTZLTDKXxY4+UuhQ0Nel
         7ak1M4dkBLfSsxeKuMFpalIUVQdynLx0QsoKKJiwUqk3s9a0Ob/z7kNSMa2Xh1zsmepQ
         peYgZwqZv1oZdN2nuaRWZ7wje1sLUVru1av83w2iOtwE5fUb4WrEQFaI272b3SHNOzjK
         NmFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792147069; x=1792751869;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J1cLBp+fIudU+J+n4s6nKX2nnwxELgfGqb7A1F2ozo8=;
        b=w3CPEeGdmG/1Tkhssu+JloIW5hTWSh0Jaj2VKngm4LPAZ5W6agGHOJh2QQ+IJDMGew
         jXRfe6n0C7EPZuAOgZorAs5PBBPbHad6CycU5XduArvMNkxDYqa8QoDV7VzZeu5kR8Rm
         nDnU3e37gIG3g/qNAhwSO+iiBe95xLK0VDGpRCYRc7+BMkr/vZjEKAB0vTlFXgHCu9gx
         zE3r5dDomqITG/ukq24Brd+UxBldA0N+5/Ptapb9qoYsuyNKyjl3k6uTqOack1Ua80Ll
         hlOSxHReW0pTU7bcKLsfAUO+e2B8m8wLJ2H3Cj+pEC6QOCl80tdBybZT3ySrxHeL8Z3c
         tSkw==
X-Forwarded-Encrypted: i=1; AKwUvBymPdNB62cc58W5Je3S+ALvzv4/D48xlUk01pJQEgZIciJi7IXSlmFwtVcEpfM115Xmjvhyepf2TUNe@vger.kernel.org
X-Gm-Message-State: AFq9FYJ6/26uLPsc66iNkbZr91/bmErF899dLb0N+YqEahjCbjsSGh+7
	7j/K4neQ0dcVA0n9WWNcH3xzlbT7ls/jL8WLR987+KQnzoTR2ZyfobLyrRJCme7b
X-Gm-Gg: AYBFou1Sr9vzNo3X7OiW9L2ViuEpAInlhUn1UhhlclBl7DoEfKXho/HYfdcexDagXTS
	FrNg09652cpQikYgfHxQZDV9DDUXMUlCW+5RlprOLjTlPqNmDX+9sCk/r3XfQmRA6eOIIMLifYh
	4VQ1dhCxIh1LWznKMNfJTSJEHwBFs1Usz6OsPdroLbvv7MVUBfU37PnasbKA/mZNcPuSPogYpBw
	yHLP57v/UMHPrnxt3Iwz1epcM0P8ouFcuA+FnHE/vs2BcgdPdZPZpLDIJaOg32kweUNPpQhszbk
	wS6jRSfBsNY0mUxfr1zBPbGxlan6Ykz3Ze0344mGBdSyjg8nX2f/2cU4JvdGjlpv8tCY5FnwwSI
	9K7uFopqZ6HDn0rKrcB784i7HDtkgUIqsPsyG23cLLrle6O63bBweDUw3Zeq+42MnSIQFMcd+m/
	O6dbmYI4xUuCpHWFIfUevijJiGNENiY+lJf/mn5tHuRjk972Dx4ev5rBsilvUX20Q1J05EikqBR
	YXDQi+SxSVyvBZDPa1yL7M9GshE3MmeX2+bGV5B0AdG50qm238FDsEImm0oY6m3K++NSvmPRPZg
	EWBnVgcHzsaF1q0EBmWCMAKfVbzX8d26WX7vScYim5G0Ny9Fd4tkhMt5T0mIKVhWEcqzlkjKkj2
	63w==
X-Received: by 2002:a05:600d:82f3:b0:4a0:ec5:46d9 with SMTP id 5b1f17b1804b1-4a1c65b9d1cmr74177055e9.0.1792147068524;
        Fri, 16 Oct 2026 03:37:48 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a951-9501-1471-d90c-a21f-9dd7.310.pool.telefonica.de. [2a02:3100:a951:9501:1471:d90c:a21f:9dd7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd9c001dsm136875975e9.12.2026.10.16.03.37.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 16 Oct 2026 03:37:48 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] ext4: return an error when a journal block is not mapped
Date: Fri, 16 Oct 2026 12:37:26 +0200
Message-Id: <20261016103726.98553-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the internal journal inode contains a hole, ext4_map_blocks() returns
0. ext4_journal_bmap() logs "journal bmap failed" and aborts the
journal, but also returns 0 and leaves *block unchanged.

jbd2_journal_bmap() takes that as success and uses the unchanged logical
journal block number as a physical filesystem block number. Journal I/O
can then overwrite filesystem blocks outside the journal despite the
abort.

Return -EFSCORRUPTED for a hole, matching the error passed to
jbd2_journal_abort(). Keep propagating negative mapping errors.

Fixes: 62913ae96de7 ("ext4, jbd2: add an optimized bmap for the journal inode")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
Changes in v2:
- Assign -EFSCORRUPTED to ret before aborting and returning (Markus, Jan).
- Add Reviewed-by tags from Jan Kara and Zhang Yi.
- Rebase onto v7.3-rc7.

v1: https://lore.kernel.org/r/20261004180629.27213-1-kmehltretter@gmail.com/

Found with an experimental clang that warns when a function returns 0
right after reporting a failure.

Recorded QEMU A/B testing used x86_64 kernels and a 1 KiB-block image
with a hole in the journal inode starting at logical block 40. The
unpatched kernel overwrote filesystem block 40, a reserved GDT block.
With the patch, none of the marker blocks changed. There were three
runs per kernel.

Both kernels logged the mapping failure and journal abort:

  EXT4-fs (vda): journal bmap failed: block 40 ret 0
  Aborting journal on device vda-8.

 fs/ext4/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d636b89090a2..1e959f196ffe 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5967,7 +5967,9 @@ static int ext4_journal_bmap(journal_t *journal, sector_t *block)
 		ext4_msg(journal->j_inode->i_sb, KERN_CRIT,
 			 "journal bmap failed: block %llu ret %d\n",
 			 *block, ret);
-		jbd2_journal_abort(journal, ret ? ret : -EFSCORRUPTED);
+		if (!ret)
+			ret = -EFSCORRUPTED;
+		jbd2_journal_abort(journal, ret);
 		return ret;
 	}
 	*block = map.m_pblk;

base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.39.5 (Apple Git-154)
