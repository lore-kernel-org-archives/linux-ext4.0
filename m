Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794446138;
	b=bTPAPlw/1L/yTTOrWztOt0YH569fBpSCO0IdhtvjLRkWKN0cE6VIqnbDS8K42HivH7vZ
	 Dd85rbHGCegbVCEHUFltOmpAXdQkkwQV6Ekq2B+TSkviT4BrURttwl059zeNFah7qkn6N
	 eAY7WDG2lhQ2cbO4JawRxCgBi4JejqcFYOFjX2JaOUT19t2DpTq0VeMTylOykqPpA7W4x
	 tIpNa3AT/DNr/dgM5gxvb/RLSxXruN6nqUPgKALqPAVQcy/ea1DkOauBo2cwsWlD2JDOM
	 k3DLzp0ygjCt+DB0jZc213Xj5coHIfrE8KqJ7k9qSts6camjl/RdgYVuzN9/WIk45Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794446138;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p45hEBivDyS+zkZ3j2d4UiBGxOIx5DTBE2EBZ8OQudU=;
	b=TKWSrzf/zz6e7Tgt4fMHWjnxkA+gSPGH56IbAPzjy4stznKDsGy34NGXSuoM1u4UQuKP
	 AqJsdCYNlROeKUt+rFuH5XWtTs6KHg+pswsDBeC32ufHFSBhoCsFvb45juuAdRrZ+h5OO
	 j0WMv3AKFefU0OLra8w2rQSl4IBcrueGNJkbM5yVJRaEWXenlqdVrtGZjKFd6+MrOALr9
	 wqWvCeH4DNcXLub+V8WE/YX6n1RaCRynGoysLelHqc5mKViHE9pAlHT0z8yeRZm/WEguw
	 e1FndLngwRdjs347j3Q7IZAbYldwWtsx0s5EVDFzLe6FUB7fGFk/3RhO+0MsLVQJ3mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b="ITiY/YN+";
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88C23606A332;
	Thu, 12 Nov 2026 01:15:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88C23606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=ITiY/YN+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=ITiY/YN+MtIoxydiEa+f/zefORJH3E+9imJqo0TH3mvATFOT6VDoGPq9UsO5zmDq3KsDwD1xQYQfP
	 HhTW5ysY6oNNM1c51JK5YD0Kbo9NSVZj01wKuyLzPKdc7lFS1wa4gsAdqjTDeebvfLWSFZsrORKrIW
	 mxFYmcnq5c6KdzSE=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app09-12009 (RichMail) with SMTP id 2ee96af513368b8-e0cab;
	Thu, 12 Nov 2026 09:15:36 +0800 (CST)
X-RM-TRANSID:2ee96af513368b8-e0cab
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from [25.255.2.225] (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr02-12002 (RichMail) with SMTP id 2ee26af51336d55-ed12a;
	Thu, 12 Nov 2026 09:15:36 +0800 (CST)
X-RM-TRANSID:2ee26af51336d55-ed12a
From: Jiahao Xu <xujiahao@cmss.chinamobile.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Guikun Yang <yangguikun19@qq.com>, Jiahao Xu <xujiahao@cmss.chinamobile.com>
Subject: [PATCH] ext4: fix out-of-bounds read in ext4_inlinedir_to_tree()
Date: Thu, 12 Nov 2026 09:13:03 +0800
Message-ID: <20261112091303.723243-1-xujiahao@cmss.chinamobile.com>
In-Reply-To: <tencent_4F47889D184C7FA2287DC2A33A52F3BE9F09@qq.com>
References: <tencent_4F47889D184C7FA2287DC2A33A52F3BE9F09@qq.com>
X-Mailer: git-send-email 2.43.0
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

ext4_inlinedir_to_tree() reads the on-disk dirent hash trailer without
checking that it lies inside the inline directory payload:

	if (ext4_hash_in_dirent(dir)) {
		hinfo->hash = EXT4_DIRENT_HASH(de);
		hinfo->minor_hash = EXT4_DIRENT_MINOR_HASH(de);
	}

EXT4_DIRENT_HASHES() derives the offset of the trailer from
de->name_len alone, so for an entry whose rec_len ends exactly at
inline_size the read starts past the kmalloc(inline_size) buffer that
holds the payload.  Listing such an image with getdents64() gives:

	BUG: KASAN: slab-out-of-bounds in ext4_inlinedir_to_tree+0xb6c/0xc00
	Read of size 4 at addr ffff8880052496bc by task init/1
	...
	The address is at offset 0x3c of a kmalloc(60) object

A 12-byte entry only gets that far because __ext4_check_dir_entry()
classifies it as fake and then validates rec_len against
ext4_dir_rec_len(de->name_len, fake ? NULL : dir), a length that does
not account for the 8-byte trailer:

	else if (unlikely(rlen < ext4_dir_rec_len(de->name_len,
							fake ? NULL : dir)))

is_fake_dir_entry() is true for a "."/".." name or for
file_type == EXT4_FT_DIR_CSUM (0xDE); the crafted entry in the report
uses the latter.  An ordinary entry with the same rec_len is rejected
by "rec_len is smaller than minimal" instead, because for it
ext4_dir_rec_len() does include the trailer.  Reaching the read also
needs ext4_hash_in_dirent(), i.e. S_CASEFOLD and S_ENCRYPTED on the
directory.

Guard the read where the entry is known to be a real one, right after
ext4_check_dir_entry() in the entry loop, by requiring that the entry
including its rounded trailer fits in the payload.  This is the same
bound ext4_check_dir_entry() enforces for non-fake entries, so no
well-formed entry is rejected, and it is the shape of c7e6b863d298
("ext4: check dir entry fits before reading the hash trailer in
ext4_search_dir()") and 9333cc809f ("ext4: fix out-of-bounds read in
ext4_read_inline_dir()"), which fixed the lookup path and the plain
inline readdir path.

The check is deliberately not added to the shared
"if (ext4_hash_in_dirent(dir))" block in front of both reads.  That
block is also reached by the synthesized "." and ".." entries, for
which de points at the on-stack fake buffer instead of into dir_buf,
and whose fake.rec_len is ext4_dir_rec_len(name_len, NULL) = 12 while
the trailer bound is ext4_dir_rec_len(name_len, dir) = 20.  A bound
written as "rec_len does not cover the trailer" fires on the first loop
iteration, and a bound against dir_buf + inline_size compares unrelated
addresses.  Either way ext4_inlinedir_to_tree() would return 0 for
every casefolded and encrypted inline directory, and ext4_dx_readdir()
takes a 0 return as end-of-directory, so getdents64() would silently
report the directory as empty.

Only this read is guarded here.  The hash of the synthesized entries
above is taken from uninitialized stack bytes, which is a separate
issue, and the remaining trailer readers that bypass
ext4_check_dir_entry() are left for their own fixes.

Fixes: 471fbbea7ff7 ("ext4: handle casefolding with encryption")
Reported-by: Guikun Yang <yangguikun19@qq.com>
Closes: https://lore.kernel.org/all/tencent_4F47889D184C7FA2287DC2A33A52F3BE9F09@qq.com/
Cc: stable@vger.kernel.org
Signed-off-by: Jiahao Xu <xujiahao@cmss.chinamobile.com>
---
 fs/ext4/inline.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index ceee69a66..a48db32f9 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1342,6 +1342,18 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 				ret = count;
 				goto out;
 			}
+			/*
+			 * ext4_check_dir_entry() accepts an entry it treats as
+			 * fake (file_type == EXT4_FT_DIR_CSUM, or "."/"..")
+			 * without room for the hash trailer, so make sure the
+			 * trailer is inside the inline payload.
+			 */
+			if (ext4_hash_in_dirent(dir) &&
+			    (char *)de + ext4_dir_rec_len(de->name_len, dir) >
+			    (char *)dir_buf + inline_size) {
+				ret = count;
+				goto out;
+			}
 		}
 
 		if (ext4_hash_in_dirent(dir)) {
-- 
2.43.0


