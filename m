Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2E27DA66
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 01:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780967267; cv=none; b=ny3j/IYAeJJVhHCruzQQFp9/rcXbOoRXoy5L+YfLNYhE74I3VbE6+iAhSgcoOURURbDdwmC1+WBnudDxPlz7w2HiBx+yIZJRYvNFi/W6kVGAAXTWAAUT0kHtX9eMnkdUl7ln9mtm9roJYwYybv2fiDhTI0KxJWq06DUNTuc5ieI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780967267; c=relaxed/simple;
	bh=zwBe7/hkdjUPgzwxRlPr5RmYm34d3HMpEuUs6aL/aEI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g1pPhaBlpwrmXoJbjHqF0WAw7I1HS6h46xIZz+i8nBIzsLczlYOAFXcEWQIuVeUiVSaBHWZEnaNA/lUiZepc7uHC3T/g2CVeghQv2UQ6a7XfVAFdhbX/T9qFVYR2x1IDHDP5rV0iw0xpNWD/egu675fMdn0c6aDUV4ZDCy1XD1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=njcmd2BA; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="njcmd2BA"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2c0c35980fdso50166235ad.2
        for <linux-ext4@vger.kernel.org>; Mon, 08 Jun 2026 18:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1780967265; x=1781572065; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KNiqkyKQkWFNsS53gti7qg+BegULIzqBfpRtHZi50H0=;
        b=njcmd2BAYfE8iM4MsaHjWY99lrJ7tgJ+VhP+JEcAGWBpD25iRNHF1Onbqjc6a4xlqk
         APcFpvwexcW9qqNLJW8ZFOxdh2uq1bDyYqQ2qz4N+ChBGltV7KhHW3QoKuL6DEezNSfw
         Ba+K1upCqLuGipdOTcYUVOFTN2RYHCGs5lfnUTcI6RiO30AkSetenxYu7rhlgAPGQrv+
         Mzg6ZR+mUNc6iGwqcoGEiKhRRpAFa+RK68Jla7dtrp0s0Wxdmt2ISsKHCZxZx9yJbx94
         O1JXx5UakcIzEawGoDsH5OTGJliwfujCgxqOSQCTBBckeQNbuXZFB2R2HJy/z5RBCx5L
         Gr5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780967265; x=1781572065;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KNiqkyKQkWFNsS53gti7qg+BegULIzqBfpRtHZi50H0=;
        b=rR/We7uxwZHC0BpCxAbUUPOG/YKP1upt3o5++Q8KTCoHfifqXpoYd23LwIGCGrVkl2
         2wsusqyos8cQ70wRS/Eysv/Az9YY7pJOTvISELBAoR1dWKiJBqWjrGl0oyCz7YKkVnKS
         I9Tx4esNMEMkvDCbL0vvUuUN8x1hKgfKWFqSN160wun3UgT3/wxM77qSTma+9nKgdGbo
         bYpQR754WQD+W7EO3iY4RkV4yz+7YK84GzBn5Yqngk28tk5hLqQiQMkP0Xg5JmTk+gav
         PpCYKj7k32I43VeL798uK7fm9/sZ5VH1korJ5yQ/oiN8cPzQN/HwBvQWEkfjhl3X7UsV
         F25A==
X-Gm-Message-State: AOJu0YxcaDl99RRZI4i8XVUonkf79Eb1AE6wV6IfoSYKaX/hS+plEDxA
	WH09g2/DeREQE/1KHUvIQm9zM3XJxhk6EQ0IDYkCL5MaWqAk8fWc+6oEUf6TVQZdCD6ZlO1ZLOF
	H1Ids/Q==
X-Gm-Gg: Acq92OFv22rrcLesgUOvfGNWBOftt9g/nkYKDcyUzlTgxMaVy8In6SwPL3FUkzdu97c
	RIbrFmaMfJFt3CKjGP9EbJ7WIU4gwiSzdQ4TZDsMSSVyFvjBsMlQrWsf/6izu1g8wchme/JYcZH
	RqNQhtCMxTRrKHYjkBVd/VjsSEJD4OmOsPIUHiojTfTRhvm4Gl11iJCwcMUAp7VR7fmbmicTzx9
	oozL7+WyhPejrgLvrIMrR6tupayK+aYluASC/XdIVdB7/RZ9p2FzE9hs7Wks1CpbP9yzVqpqoEs
	TNV/jnsas9ZTZFyXjDemlyuAkUL9UFje7oBi7yaaXPIabilTzW332/gHC+Xm7IWDZL/ZlF6LDnH
	TXOL1RiIk04PUWAQsfSIu0Ev2JHyLXtnKDPYiajgFbywjcPCsUA8mBtf0Xu0o3cRY1rbb6ZB4w5
	ZWjBi36UCDzCHuXZMLUJE=
X-Received: by 2002:a17:903:3885:b0:2c2:245a:3368 with SMTP id d9443c01a7336-2c2245a3649mr163029525ad.14.1780967264912;
        Mon, 08 Jun 2026 18:07:44 -0700 (PDT)
Received: from p1.. ([2607:fb91:1526:188d:d085:3143:4422:bc50])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f6d37esm256841705ad.9.2026.06.08.18.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 18:07:44 -0700 (PDT)
From: Xiang Mei <xmei5@asu.edu>
To: linux-ext4@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH net v2] ext4: fix out-of-bounds read in ext4_read_inline_dir()
Date: Mon,  8 Jun 2026 18:07:39 -0700
Message-ID: <20260609010739.2278172-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_read_inline_dir() reads de->rec_len / de->name past the end of its
inline buffer for a crafted or corrupted inline directory, triggering a
slab-out-of-bounds read during getdents64():

  BUG: KASAN: slab-out-of-bounds in filldir64 (fs/readdir.c:371)
  Read of size 8 at addr ffff88800fd3da3c by task exploit/146
   ...
   kasan_report (mm/kasan/report.c:595)
   filldir64 (fs/readdir.c:371)
   iterate_dir (fs/readdir.c:110)
   ...

The payload is copied into a buffer of exactly inline_size bytes:

	dir_buf = kmalloc(inline_size, GFP_NOFS);

but iteration runs in a logical position space extra_offset bytes larger
than the buffer (extra_size = extra_offset + inline_size), so the synthetic
"." and ".." entries land at the offsets they would have in a block-based
directory. A real dirent is formed at "dir_buf + pos - extra_offset", yet
the loop bounds and the ext4_check_dir_entry() length argument are all
expressed in the larger extra_size. Two reachable sites dereference a
dirent before confirming its physical offset is inside the allocation:

In the main loop, ctx->pos is attacker-controlled via lseek() and the entry
is validated with extra_size, so ext4_check_dir_entry() accepts a dirent
running up to extra_offset bytes past the allocation before its length
check fires. ctx->pos is also a signed loff_t: an lseek() to a small value
below extra_offset makes "ctx->pos - extra_offset" negative, so a check
that only bounds the top of the buffer is bypassed by underflow and de is
formed before dir_buf.

In the cookie-rescan loop, entered when i_version changed since the last
readdir(2), the walk restarts from the beginning with i bounded by
extra_size, so as i approaches extra_size the unconditional read of
de->rec_len runs past the allocation before any validation.

Both are the same defect, logical extra_size space versus the physical
inline_size buffer. In each loop, reject a dirent whose header would not
fit within inline_size before forming de, and in the main loop also reject a
position that underflows below extra_offset. Validate the main-loop entry
against inline_size rather than extra_size. Entries that legitimately fill
the inline data still pass.

Fixes: c4d8b0235aa9 ("ext4: fix readdir error in case inline_data+^dir_index.")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
---
v2: check the both bounds

 fs/ext4/inline.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8045e4ff270c..bbe93f1b56b2 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1454,6 +1454,9 @@ int ext4_read_inline_dir(struct file *file,
 			/* for other entry, the real offset in
 			 * the buf has to be tuned accordingly.
 			 */
+			if (i - extra_offset + ext4_dir_rec_len(1, NULL) >
+			    inline_size)
+				break;
 			de = (struct ext4_dir_entry_2 *)
 				(dir_buf + i - extra_offset);
 			/* It's too expensive to do a full
@@ -1488,10 +1491,20 @@ int ext4_read_inline_dir(struct file *file,
 			continue;
 		}
 
+		/*
+		 * de lives at dir_buf + ctx->pos - extra_offset, so the dirent
+		 * header must fit within inline_size.  ctx->pos is a signed,
+		 * lseek()-controlled loff_t: check the lower bound first, or
+		 * ctx->pos < extra_offset underflows and points de before dir_buf.
+		 */
+		if (ctx->pos < extra_offset ||
+		    ctx->pos - extra_offset + ext4_dir_rec_len(1, NULL) >
+		    inline_size)
+			goto out;
 		de = (struct ext4_dir_entry_2 *)
 			(dir_buf + ctx->pos - extra_offset);
 		if (ext4_check_dir_entry(inode, file, de, iloc.bh, dir_buf,
-					 extra_size, ctx->pos))
+					 inline_size, ctx->pos))
 			goto out;
 		if (le32_to_cpu(de->inode)) {
 			if (!dir_emit(ctx, de->name, de->name_len,
-- 
2.43.0

