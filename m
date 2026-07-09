Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477F243F8D3
	for <linux-ext4@vger.kernel.org>; Thu,  9 Jul 2026 18:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783622466; cv=none; b=Svcwdf7kvJp0EXBH6NHeDAdf4oTfNcG+kAVei9mZ37oGe116dsyz5w0WhjI+BqSAiPGDvfolagzSVsRy0gF5xMmpZOoU5G0ILlEwr6TSe/MvIWjWKY3yZQ24q7NyCDLBeOcvOuNGWJp1SFq4oyjz5BsE+Ou7m2f6euwvyYAqb/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783622466; c=relaxed/simple;
	bh=uC8jGenWvPPUrLqieeG8Dn5ZbJuBhOjtGXhF6/iuRag=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WouCXw0uNfmIO/ILI5JR0SKcjKAXwfJ20r0ZGxyaopymVtNT44rwq+LQccyKQqEWVURWZePXdshlPqjHOAVC1/1jfKFsZSSALUJWPwrpDtLdYD1XP405E2q77GAGpv0I/0DpETAQc5+xrdOvABCq0480LNG5r+tke/72vkAhBhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=ia5bIMPA; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="ia5bIMPA"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c99eaa1f020so131406a12.2
        for <linux-ext4@vger.kernel.org>; Thu, 09 Jul 2026 11:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1783622465; x=1784227265; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qliqq22RlVOUYT3SfgSB8aDBVuBlyTjHYWh8Vj8hnwM=;
        b=ia5bIMPAzlI+bbmXgk4xK5ovlI34ZSvzBXCC7/4BTHS/3j5G3/UgK/JmFSb+RLZv3N
         XvTCEO7ReRJkKYCjC7F4B/DuRkHm4DlkA+NwO+tCOhgV6WNA6LYAhTZvWlB3I+CIaQJQ
         gphexPcfqRRPA9+y2TxnGNfrHfWCyboDCD8HRZavqjyL6nbn3XPpNXj9bV9qz7Qm/7L9
         LBxWAz5xKA+hrDgPkt+VWdOrcuMGHdxMMtFfHSbYjlroViOmemBQUwvXrlojPz0NiPCV
         xiWU0O6DnswTmv7+2UjA2QD3oVykg/bSqGBtyGJtvHWsEGr7sNArkXifshHyK5ByOWlm
         PoRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783622465; x=1784227265;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qliqq22RlVOUYT3SfgSB8aDBVuBlyTjHYWh8Vj8hnwM=;
        b=CGNMo3+xhZ8AbB7w5QLgQEYASEzEeI3NryvXvI78Ugxt4LRPeOhhQI60Nn/uW9Qznn
         gwdXRHuku5wpKcsML78Lsk3YHaGW6mLLZLeoy+p3uwqFoySyPZNQy0JTAaNYzmEiUZKk
         kbbykGoGN9cecCQxl/S8IBbc4hopdo182JyLMCKv2KEMmXJa1Y4jz54j1FzVZ6a7M/m8
         t1gawtzWBLHwZ4sdjKWMwZVzQ8gpJYWpJH2EuznPB2AwuYxcnqUiWRlxHVWixAi0qQPz
         X1lO7RHblgkej/25RlAeliHqgeBvHqZYlqdzSpDIjx8BWhqu0skxzbExTzu/SqKAosmz
         PNSQ==
X-Gm-Message-State: AOJu0YydfeM0H0odTFSYP7V0D49DaZ75+8f7nzBkHhdMFlR7DuvVc61g
	PyUUgYd56S5SUYmD+5COLnjmvaYtFmIBWlLflYseoZ8tNoryH2K6O1L75ZZY+iz5tQ==
X-Gm-Gg: AfdE7cnuKoc6G1dd3nmfPKYAKZymOD0TWnA8acEXHeP3gTmioOhDDMccNFsanD+GboA
	9KLMXRocOYht9pcQOtfK9mVfaaygP63tj8v5Ylj7XGc/iCYTxtkdfdn7G3qOBZGQUD46m7hWSnY
	qsOf0DSHd80KxI2N+SyDfbZyYQG7pHWhMTZnncFK4Yaon5vx81/Re2abKjvnNd7U89eGlI9Zq28
	zVSRtcrRvmr4yomFNkkYwhHP1sEU0HZi3BdldzBpD+7d8B5hYvEPAzrO4k0D47JJB6odCtnj1S2
	Xk3iw1w9/O0HNrRL3eamHUGAzppPKH17es9UE/eJYoPvGiQrNaZTQVgivGe3KRXYtzs64rTg1e7
	s+03W8LLzNANxCwBnJmj0yK3Nemdmg0Hi4lTW/1fCFoWS/bmBQwbvutNav+oz9F/cbxn+CgGChw
	==
X-Received: by 2002:a05:6a21:700b:b0:3c0:9c1b:d0bf with SMTP id adf61e73a8af0-3c0bd332198mr10352678637.74.1783622464760;
        Thu, 09 Jul 2026 11:41:04 -0700 (PDT)
Received: from p1.. ([2607:fb91:150b:cc44:818f:4933:fede:4fa8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5afeb060bsm4171263a12.14.2026.07.09.11.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 11:41:04 -0700 (PDT)
From: Xiang Mei <xmei5@asu.edu>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Daniel Rosenberg <drosen@google.com>,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH] ext4: check dir entry fits before reading the hash trailer in ext4_search_dir()
Date: Thu,  9 Jul 2026 11:41:01 -0700
Message-ID: <20260709184101.441348-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For casefolded encrypted directories ext4 stores an 8-byte hash trailer
after the name (EXT4_DIRENT_HASHES()), at an offset derived from
de->name_len.  On the sb_no_casefold_compat_fallback() path ext4_match()
reads that trailer, but ext4_search_dir()'s by-hand pre-check only tests
de->name + de->name_len <= dlimit, which proves the name fits, not the
rounded trailer.  A crafted entry whose name ends at the block boundary
passes the check while EXT4_DIRENT_HASHES(de) lands past the block end,
so ext4_match() reads out of bounds on an ordinary lookup.  KASAN reports
it as a use-after-free when the page after the directory block holds a
freed object:

  BUG: KASAN: use-after-free in ext4_match (fs/ext4/namei.c:1435)
  Read of size 4 at addr ffff888010458000 by task exploit
  Call Trace:
   ext4_match (fs/ext4/namei.c:1435)
   ext4_search_dir (fs/ext4/namei.c:1470)
   __ext4_find_entry (fs/ext4/namei.c:1268 fs/ext4/namei.c:1632)
   ext4_lookup (fs/ext4/namei.c:1703 fs/ext4/namei.c:1769)
   ...
   filename_lookup (fs/namei.c:2842)
   vfs_statx (fs/stat.c:353)
   __do_sys_newfstatat (fs/stat.c:538)
   do_syscall_64 (arch/x86/entry/syscall_64.c:94)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

Require, for hash-in-dirent directories, that the whole entry including
the rounded trailer fits before calling ext4_match().  This is the same
bound ext4_check_dir_entry() already enforces via ext4_dir_rec_len(), so
no well-formed entry is rejected.  The other caller, ext4_find_dest_de(),
runs ext4_check_dir_entry() first and is unaffected.

Fixes: 471fbbea7ff7 ("ext4: handle casefolding with encryption")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
---
 fs/ext4/namei.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index cc49ae04a6f6..3b9740c1c16d 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1467,6 +1467,8 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 		/* this code is executed quadratically often */
 		/* do minimal checking `by hand' */
 		if (de->name + de->name_len <= dlimit &&
+		    (!ext4_hash_in_dirent(dir) ||
+		     (char *)de + ext4_dir_rec_len(de->name_len, dir) <= dlimit) &&
 		    ext4_match(dir, fname, de)) {
 			/* found a match - just to be sure, do
 			 * a full check */
-- 
2.43.0

