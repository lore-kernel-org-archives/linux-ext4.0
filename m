Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34673403F1
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 02:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789700075; cv=none; b=FOsLTrU/ydo3/eTFAmLQXVMewkcJk0+x3gNVDWpJdVoFuwN1IViRy8Zej0GogWGvbrhoR7f+DuC5beT+eoqoeZSZFjndHpE+iqWKbpsCoaq8H02INhKFWnDWGdmTI4oqCB+WYfORnlI4ZmY5Su5SbfoateVDREeTrqjgfz10CL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789700075; c=relaxed/simple;
	bh=2bVE7fhet16ab5mllsWynugJSrF4uivNNn96Z3BFawo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=BUCDwyOf3EY0J33Rn/5L7X/+yGA69KbBhCyhlu3VH1zXjqWHxrxg5K8DXtTjEvLecAUNGoWmrdQTPvR9eE4EXtG+kyI6KQSmiAxnOC/T0nWFRTQ5l32K5tQdiAtWYXSKQk3a32HP+Fu8IvlbY0q+sYa2ZARcHSrXvy6NiTpKp5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dhavale.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vf4HkUM0; arc=none smtp.client-ip=209.85.210.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dhavale.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vf4HkUM0"
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-86a2639398cso673724b3a.3
        for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2026 19:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789700066; x=1790304866; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ArDSd6GkQg59jFzVp+fPSiUtMuPFzpUHpaeLqMAfALM=;
        b=Vf4HkUM0lzvw9DTNu/Mn58S+0JJoczY2uLrOJ/7qOy2BMFw0hUUlYzOpdsYx69yDAs
         QqNgeAymxcN9j231ZEXsY06NWm69TkMNV5RqxihSeHzll2tMQHOTcv3FRleYn4K3YOjm
         EyO61+A59VNuODUzFk44YWkxye7Rvm/tz4nDFO8qPQHQSovD92Aevw6HGlwoP5AMevR4
         yAmaSl6j+tAwWK9x4kHINexOUGtyi2gqndLtpctXwFOzatpexY3YxsUC9DGiKmkMpfIt
         rvfP2J+ZCXhDaVPZA63vfE4vlE8Ri4sKRhmYL4ee+A+Ir/K4kx3RsQ/ld9OMuU7pyTYs
         UOVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789700066; x=1790304866;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ArDSd6GkQg59jFzVp+fPSiUtMuPFzpUHpaeLqMAfALM=;
        b=nni1oUG8oaaZHdsSDRtyLDf6jpBk5wHK2O838G+himfo7yXxSzFCRHiUuVfhhq2Z5U
         nln93keL1bwDPa96jsoT2uUiNF2S3wJ+1nlANYL3Ng1oHzp9YYbdv7sk2AExzMSD78v4
         IpD6Z/Nmbj8RWIcBfDiiKqMsldHAWZa0SITRtGZP2NApb5BsZaeXN/rp7Y/uFTdWX9bc
         SMDlnN2hco+/hoW15VOxoV1B7vu3vRdXq9JX5UIVgyzwyq1uzWyYrIZXczeN7bXUZKGQ
         8FFUdCIpP3oUwMfSFq5pZEg4WXS6DJmlEeG1XWygSvMUkhRercQNbkdn7KITIKHDjNV4
         FTAA==
X-Forwarded-Encrypted: i=1; AKwUvBzn1SCSuWgm9zkbWG6ihtZ2w51fT3pXYwNVtRf+p4u2yLGvXmwMnLlEo/Pwr0R3w31gV4UoweVDZG0B@vger.kernel.org
X-Gm-Message-State: AFuF++k4y7Gw+5nLxNKptfWi73681mQFDyUvsQ8WzC0DXm8aKW8H4g7Q
	Ax+Qa0VBE9uo/1bXOe4fig3X3vktSyvI6E50+KhmHGhatY9Rrv6i4oXOrotXf4//Ej5ORU7c5sZ
	4duJW3oqnNw==
X-Received: from dyng28.prod.google.com ([2002:a05:7300:7f1c:b0:313:fcd2:67e5])
 (user=dhavale job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6194:b0:3cc:f008:8123
 with SMTP id adf61e73a8af0-3dd8c3fe021mr2586692637.8.1789700066243; Thu, 17
 Sep 2026 19:54:26 -0700 (PDT)
Date: Thu, 17 Sep 2026 19:54:15 -0700
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918025416.604297-1-dhavale@google.com>
Subject: [PATCH] ext4: fix race between inline dir conversion and folio read
From: Sandeep Dhavale <dhavale@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: kernel-team@android.com, Sandeep Dhavale <dhavale@google.com>, stable@vger.kernel.org, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Commit 90f097b1403f ("ext4: refactor the inline directory conversion and
new directory codepaths") moved directory block initialization in
ext4_convert_inline_data_nolock() into ext4_init_dirblock(), unlocking
data_bh before setting BH_Uptodate.

When block size is smaller than PAGE_SIZE, multiple buffer heads share a
single block device folio. If a concurrent read on that folio runs via
block_read_full_folio() while data_bh is unlocked and not uptodate, it
locks data_bh and submits a disk read for the uninitialized block.

Because ext4_init_dirblock() initializes bh->b_data without holding the
buffer lock, the disk read races with and overwrites the initialized
directory entries and checksum tail, corrupting the directory block:

  EXT4-fs warning: ext4_dirblock_csum_verify:375: inode #...:
    No space for directory leaf checksum. Please run e2fsck -D.
  EXT4-fs error: __ext4_find_entry:1626: inode #...:
    checksumming directory block 0

To fix this, mark data_bh uptodate before unlocking it in
ext4_convert_inline_data_nolock(), just like the regular file path
does. Additionally, hold lock_buffer(bh) in ext4_init_dirblock() while
populating the directory entries and checksum tail so any buffer
modifications are properly serialized.

Fixes: 90f097b1403f ("ext4: refactor the inline directory conversion and new directory codepaths")
Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.8-flash
Signed-off-by: Sandeep Dhavale <dhavale@google.com>
---
Note:
This issue was reported by an Android partner encountering kernel panics
in ext4_dirblock_csum_verify() ("No space for directory leaf checksum")
on 16KB page size kernels mounting a 4KB block size ext4 filesystem.

We verified with a standalone reproducer that the race reproduces
deterministically on Iteration 0 (< 1s) on both ARM64 (16KB page size,
4KB ext4 blocks) and upstream ext4-tree/dev on x86_64 (4KB page size,
1KB ext4 blocks), and confirmed that this patch resolves the issue.

 fs/ext4/inline.c | 1 +
 fs/ext4/namei.c  | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index ceee69a66482..0aa14cee3310 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1167,6 +1167,7 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
 		error = ext4_handle_dirty_metadata(handle,
 						   inode, data_bh);
 	} else {
+		set_buffer_uptodate(data_bh);
 		unlock_buffer(data_bh);
 		inode->i_size = inode->i_sb->s_blocksize;
 		i_size_write(inode, inode->i_sb->s_blocksize);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 3b9740c1c16d..6550102fb56b 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2933,6 +2933,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 	if (ext4_has_feature_metadata_csum(inode->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
+	lock_buffer(bh);
 	de->inode = cpu_to_le32(inode->i_ino);
 	de->name_len = 1;
 	de->rec_len = ext4_rec_len_to_disk(ext4_dir_rec_len(de->name_len, NULL),
@@ -2965,6 +2966,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 	BUFFER_TRACE(dir_block, "call ext4_handle_dirty_metadata");
 	set_buffer_uptodate(bh);
 	set_buffer_verified(bh);
+	unlock_buffer(bh);
 	return ext4_handle_dirty_dirblock(handle, inode, bh);
 }
 
-- 
2.55.0.1082.g2b9226bbc0-goog

