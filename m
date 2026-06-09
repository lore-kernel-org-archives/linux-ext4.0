Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663CF2F260C
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 04:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780978655; cv=none; b=Fk+peLJxJXxkCFR/ZBHOBK3lUbNQnXhF5K9J2Qj7qQiSqBL6HrbU0XVUKUloqU2W3NcpANxeeY5J5CUF88gA0cb+1iOnbZPJ6fxSdbIZZ1vicZjFhIYENvMqp7zSCTo/289okCTnb8cTGV5Si5xgaC1Eckv5PofmcZIehB7eG38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780978655; c=relaxed/simple;
	bh=U4Np9Ii9wtElKPYq5/Att3d025QkxteJXmh4QQc94mc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sGJXejO8O5lusKdNh8rVxQXLClWqvT4ls/qX2gcujFOY8w2B1eE3G97IcxXgYSEOI+mkW7oGX4kdNRDQDqYxInj1nA0SSyJi05Rt9yMtc1lBcTtsB/J0idTe8wDHpzgos6kB4Ft1g5x/DvaKRjvAfHONqNxc/VbxN4ALUYB3YEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZcJTYbNM; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZcJTYbNM"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2c168baac83so23324415ad.2
        for <linux-ext4@vger.kernel.org>; Mon, 08 Jun 2026 21:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780978653; x=1781583453; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=q406pH5lUADnbt61DxG138tUfOLYKP8K5yUgAEXHh5w=;
        b=ZcJTYbNME++VZEHgAwsJFlkKFtxJL0POKkbjHAqrsTEoIVJBHcpx3rP/p6FitVUQKs
         ATiWIQ04W2ufoan+N+l0+1ZRvwOjuStV64VzcNViTES1eL9tf+4YQKi6LKoq8R8xh08C
         i5abNhwZUzJsvbg26lGOaU+qH1OkaSlFrR1AoBh0UO8f4KTIF+4oDqBygB9NyS4RRRaH
         +7olvecBlprSD8fu2pdWS/Ry/TmMF4N1P9vp/T6fcYVIXhRQYCUVn+hzPAB+weBHJdy0
         jGq464bYWJ2nD4GViEWTjBr2/aBzxOQCG74EyIXjtH8qNbyEijd4yfw2CiccgZIPsxUe
         DqOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780978653; x=1781583453;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q406pH5lUADnbt61DxG138tUfOLYKP8K5yUgAEXHh5w=;
        b=K59VJKw/vvQNrtUUrYreRto0oeXVMfJsNnqMJ7Q+JHb1QcWec/ziYAYIL63xytQehD
         BaPF3z+FY6f99h6+09JXIhbIb6YXQ3VCPkKdfxvenPRdqns/j2eGAF9fNGQfDgbhC07O
         AL1IdO0d7cbBFhfhNjliAqNk7H1XZNKCZ8AcbifVa/K6IasfL0ACYfuQs6A4+7vytNAA
         oNW+KVxpMzXICEvP6weFTmCy3BCrPNZ4+8qMANordEWGNr3P8cVCg+GgNy3Ye1nmc/VY
         xttOAuXT06My2Bsk+/WozHW1VeI/RBJb+T2MIO82Tyw46LLOkgIr0ZvdZ7iP8tBM3YSk
         4SbQ==
X-Forwarded-Encrypted: i=1; AFNElJ/lHqgxzu3fnjq+0MrX2SQxY5GJUuwDe4beZdZMUk7F9m2LSEE38VrTc3VPsw4Tn8MYsi4DxEyEpCLQ@vger.kernel.org
X-Gm-Message-State: AOJu0YyAS4qEIASwRM150AoWFLhkbgN+16BlKc8wpIyODZp+D3E+Yuzt
	OVR0RienSZBiVrxkBihs0F/wzpTSNcP6tCuYnPnSGe8iUH2vvLy3EJAB
X-Gm-Gg: Acq92OHAO6nj3UzpUi0DeOJo77sMTh06SXX+/xDiakti02Id1PNiZg7Q/ibPjZUJSPI
	ZegOiZeMfJxKr7RI+Feo0nVwGwxudvSbC2UWUCBpK4ZEd+LdR10vza7Hvyv082+E8V8+jE/p+7r
	II7wfARwdQu0YGElTHURLwirO7GEGEy/Y+AUGkFza91FQR+rJkvB9iKuhCiCiJrPQl8dnykoAzM
	QXNd5JALuffkrfzYo3u7mU4/XMI2YLgRFW8eRdFx2lOx9+7qrSj2EsDgbkRPcn61f15ts7O8bg/
	u1rdoY1syEauslgNGFlHztuOV1xcEuFCMxcfEA8BVV/oaUoth69FxkklnW25GXGi6HXyQJ0fE7M
	YeS8lBUhO0rIkMSCnevguGy1lKCVbv9/ohSi0Lj5AMekx2J7EX3hdynMlo5/6zMbU9jsWrCgTcg
	/gvr3wdNVEsEw+YefJSiAQe/ssXUO17OAuTzggBG9MTZw5S1UhlbLIArguSGOidU6qsKDSm2G2Y
	U+Gok+0khlS4FU5VnxSapJ6axlLkvhh2PHBglhN+3d+gZ41SjjGphbFrd0O9O5fiJz3gqEIBJmC
	DXk7QrWsYFJCS/aTnCygOH1g+TMU3UcPA8fnI88m8uAb/S4/9A==
X-Received: by 2002:a17:903:2450:b0:2c1:27a3:6859 with SMTP id d9443c01a7336-2c1e79e22dcmr216110905ad.7.1780978652716;
        Mon, 08 Jun 2026 21:17:32 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-b.c.d33bddc1d573818c7-tp.internal (192.152.126.34.bc.googleusercontent.com. [34.126.152.192])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c249aeb62csm74641005ad.68.2026.06.08.21.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 21:17:32 -0700 (PDT)
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	sashiko-reviews@lists.linux.dev,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>,
	syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
Subject: [PATCH v2] ext4: fix kernel BUG in ext4_write_inline_data_end
Date: Tue,  9 Jun 2026 04:17:03 +0000
Message-ID: <20260609041704.1709-1-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the data=journal mount option is used, the ext4_journalled_write_end()
function incorrectly calls ext4_write_inline_data_end() without checking
if the EXT4_STATE_MAY_INLINE_DATA flag is still set on the inode.

If a previous attempt to convert the inline data to an extent failed (e.g.
due to ENOSPC), the EXT4_STATE_MAY_INLINE_DATA flag is cleared, but
the EXT4_INODE_INLINE_DATA flag remains set. In this scenario, the next
call to ext4_write_begin() will not prepare the inline data xattr for
writing, but ext4_journalled_write_end() will incorrectly attempt to write
to it, triggering a BUG_ON(pos + len > EXT4_I(inode)->i_inline_size) in
ext4_write_inline_data() since i_inline_size was not expanded.

Additionally, a concurrent ext4_page_mkwrite() can execute
ext4_convert_inline_data() between ext4_write_begin() and ext4_write_end()
since it only takes xattr_sem. This concurrent path converts the inline
data to an extent and clears both the EXT4_INODE_INLINE_DATA and
EXT4_STATE_MAY_INLINE_DATA flags. Since the block buffers were not
allocated in ext4_write_begin(), falling through to the block fallback path
causes a NULL pointer dereference because folio_buffers(folio) is NULL.

Fix this by ensuring that the write_end functions (including
ext4_write_end() and ext4_da_do_write_end()) safely return 0 to trigger
a VFS retry if they detect folio_buffers(folio) is NULL after falling
through from the inline data check. Returning 0 signals
generic_perform_write() to revert the write iterator and retry the
entire write operation, which will then properly allocate block buffers.

Reported-by: syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0c89d865531d053abb2d
Fixes: 3fdcfb668fd7 ("ext4: add journalled write support for inline data")
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
---
v2:
  - Address TOCTOU race condition (reported by Sashiko AI review):
    A concurrent ext4_page_mkwrite() can execute ext4_convert_inline_data()
    which takes xattr_sem and converts the inline data to extents, clearing
    both EXT4_INODE_INLINE_DATA and EXT4_STATE_MAY_INLINE_DATA flags between
    ext4_write_begin() and write_end().
  - Safely return 0 from write_end functions if folio_buffers(folio) is NULL
    to trigger a VFS retry. This prevents a NULL pointer dereference in
    ext4_journalled_zero_new_buffers() and ext4_walk_page_buffers().
  - Add check for ext4_write_end() and ext4_da_do_write_end().
 fs/ext4/inode.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c2c2d6ac7f3d..d6c934b2ae31 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1455,6 +1455,13 @@ static int ext4_write_end(const struct kiocb *iocb,
 		return ext4_write_inline_data_end(inode, pos, len, copied,
 						  folio);
 
+	if (unlikely(!folio_buffers(folio))) {
+		folio_unlock(folio);
+		folio_put(folio);
+		ext4_journal_stop(handle);
+		return 0;
+	}
+
 	copied = block_write_end(pos, len, copied, folio);
 	/*
 	 * it's important to update i_size while still holding folio lock:
@@ -1560,10 +1567,18 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
 
 	BUG_ON(!ext4_handle_valid(handle));
 
-	if (ext4_has_inline_data(inode))
+	if (ext4_has_inline_data(inode) &&
+	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
 		return ext4_write_inline_data_end(inode, pos, len, copied,
 						  folio);
 
+	if (unlikely(!folio_buffers(folio))) {
+		folio_unlock(folio);
+		folio_put(folio);
+		ext4_journal_stop(handle);
+		return 0;
+	}
+
 	if (unlikely(copied < len) && !folio_test_uptodate(folio)) {
 		copied = 0;
 		ext4_journalled_zero_new_buffers(handle, inode, folio,
@@ -3231,7 +3246,7 @@ static int ext4_da_do_write_end(struct address_space *mapping,
 	if (unlikely(!folio_buffers(folio))) {
 		folio_unlock(folio);
 		folio_put(folio);
-		return -EIO;
+		return 0;
 	}
 	/*
 	 * block_write_end() will mark the inode as dirty with I_DIRTY_PAGES
-- 
2.47.3

