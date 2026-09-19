Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EC73CB543
	for <linux-ext4@vger.kernel.org>; Sat, 19 Sep 2026 11:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789818003; cv=none; b=Q1NZkPKnP0BJRKsaA/xTXsdMRKB81+8FEfBdELfsb/AB8UsZvLhjyG9pmPPQbFzcDgiWLmpPtsay94hf0XjLtwV2A2Cjdtcdpu7q1U5j6qEWc8lWNga33Vj2GintG8dfZvzmMFWgUM3JliTsf3UcqjRv9q+Vx/a5jj6K45OlkQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789818003; c=relaxed/simple;
	bh=EvOJG+8Pl4ielrPZXBMTsv+Ae+YdDXMfiQGv0B2VxL8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pWXALRZ4XFYtGNQc/cGU+lTHopm8NwrgxRRqyaqc/htpjieLCPMajGhyw7ASJPvpByIrE+6FV7334qIUiXyE17WSNgFXcoCgSq/oEIxZlI7s5X7zFCmWBPd7hCmXBwwvctfBUkcZRAPTFfkOn02Y/WK4dUayvypOK2PeRn2kPOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KTWynX0T; arc=none smtp.client-ip=74.125.228.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KTWynX0T"
Received: by mail-pz2-f42.google.com with SMTP id d2e1a72fcca58-86e6d007703so1408879b3a.0
        for <linux-ext4@vger.kernel.org>; Sat, 19 Sep 2026 04:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789818002; x=1790422802; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NPmuBQ9EGkU1scMbe6c8dUYzaaf0Kac0wlnce9t1ryI=;
        b=KTWynX0TPpODpaXm2RCLsjDQ1cOJbcRpOuQGq2AK1rmTImeyLKcV+3//UXDVb62MFY
         IuDN/Fpp4oAUTZklbUDrHqY9ALOASzzwSg5b+VrTqfaCNTIR+FM8rdBcRP5AKsdqk/Z4
         pKLhUx5VylCrhsGoMtxo2jEms5Pa63P9HAqHZ4Ndj0tcp4lzBQHRnH8BXr3SdjitSOHb
         w+9NKMIT4wf73eThwzd+ZIBClrpAM5Sel2bjUrifqvU3Xk4BTqVZv1k0vHcgRk+8znjX
         /La4767KBnLAUdH1+BIBiLdwDaErYqUyN69NaFTtgXM3kyDZlJ3Jq9BSwYQLwe8P7HaZ
         U7wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789818002; x=1790422802;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NPmuBQ9EGkU1scMbe6c8dUYzaaf0Kac0wlnce9t1ryI=;
        b=FwLTuFNAXspDPk7ZscfxNlCbB+UAmJ75BMO+a0y76g2SfiIS2bSXw9OAQGMgHb9AkI
         ZoIvaImcM7KeRhRgOvzPPh6LquOoeDPG5IAOB1vLrUabsoCGrGrwVYFI1L7UBOZUuPid
         CqkcnR9LHhdlKy6yHgKa/Vm38orn6yyoAdDlhwGFardvx/7RgwQUJZGCOLpymg3fu28b
         a6Q8TwahwkABZcup8v5bPTlbb3wIrcDRUlcupCF/bzWGeuN/CsQxsBVG3RsSIoZgBUl2
         RbRlTAgEX33Gzqu+XdFCjSfsJpXzfQc0tmmv+5vyZBp9vtfeZ8axAddliPstb39KSIu6
         6ZKg==
X-Forwarded-Encrypted: i=1; AKwUvBx0o16w/ajgfOTtYS4/86CIVJynnrY5R+iDOaH/kJSfYMjqz4E1Ian5VqjpB3gZSDxRmHOHNKpSC13k@vger.kernel.org
X-Gm-Message-State: AFuF++mcTTq5m96IuHoOksMInF07mTTDs/D7Jyu4U6Cmx/nHXKrQO0te
	GGkJX2IzQTDbcEy+q7QrgMMtUybMclMRMMfZ1cd2/0k5SVeEBzWWehtq
X-Gm-Gg: AYBFou0DdCREH8iBKzr7ohMV/g86NB+HSSgXC/q9mhNr+QE5XiQQ8hzzWKW3L4bKDh3
	1N3BifX8DxFMTDW8hNumiVP9L0TVmFneMta2iMvAXF65HSg7QMHqMbHcn42aacYokSa+zjcaH3H
	pPjA62wXqqpnp0iz6TXPRFULJVqGZs4eDrvLQh/GNRCRKJ0hU8LIIk7ifrDXGPr/MGRSSSLjrQy
	9sAAgx2Cc8NN1ZE75MJiVlYbQ1vvDvqQAD1bA3FhKOddbCKYzQ89xQoPZz1zDD2I+kt+dQC+oem
	r5u7fVJfeJTVLFc+R+XoqsWm4yfoiZd97ZAQcdlD3qM2cL0i7qKEBHhNS3QPDy2x10LWAWCPsCO
	GZYF6Sn7z5SQKGZMQnuJiC1xQKgMgWqk7+oHERwAnhBIE/aigYAZj/c9m2njibWeuN+cmucAbDh
	s07kFjr+L0P1gEUh+jLK7xCX+0x+9jl3WE+Kzu9HJdqP5Aus1K1IOkrjRk9frPxt4KYTdF/iFsc
	wjg0Lg5eUMer2gRHkfv0hSIVgCjCRvejsAF
X-Received: by 2002:a05:6a00:1788:b0:878:3811:23a with SMTP id d2e1a72fcca58-878381109aamr1195454b3a.54.1789818001831;
        Sat, 19 Sep 2026 04:40:01 -0700 (PDT)
Received: from csl-conti-dell7859.ntu.edu.sg ([155.69.199.57])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-877a94f4ab3sm968471b3a.23.2026.09.19.04.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 04:40:00 -0700 (PDT)
From: Kaixuan Li <kaixuanli0131@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Kaixuan Li <kaixuanli0131@gmail.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: stop verify_reserved_gdb() one entry short of the block
Date: Sat, 19 Sep 2026 19:39:40 +0800
Message-Id: <20260919113940.1823559-1-kaixuanli0131@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

verify_reserved_gdb() walks the backup group list, reading one __le32 from
the reserved GDT block per iteration, and bounds the walk after the read:

	if (le32_to_cpu(*p++) !=
	    grp * EXT4_BLOCKS_PER_GROUP(sb) + blk){
		...
		return -EINVAL;
	}
	if (++gdbackups > EXT4_ADDR_PER_BLOCK(sb))
		return -EFBIG;

The block holds exactly EXT4_ADDR_PER_BLOCK(sb) entries, so when gdbackups
reaches that value the test is false, the loop runs once more, and *p++
reads one entry past the block before -EFBIG is returned. The same value is
also the largest gdbackups the function can return, and
reserve_backup_gdb() then uses it as an index into a block of exactly that
many entries:

	data = (__le32 *)primary[i]->b_data;
	data[gdbackups] = cpu_to_le32(blk + primary[i]->b_blocknr);

which writes one entry past. Comparing with >= stops the walk before the
read and caps the return value one lower, which closes both.

The walk enumerates the groups ext4_list_backups() produces -- the powers
of 3, 5 and 7 below the group being added -- so EXT4_ADDR_PER_BLOCK of
them, 256 at a 1K block size and 1024 at 4K, cannot occur within a 32-bit
group number. The entry the old bound went on to read was therefore never a
real backup.

Signed-off-by: Kaixuan Li <kaixuanli0131@gmail.com>
---
Reproduced on v7.2.4 x86_64 with KASAN enabled, and on v6.12.9 before that.
Three images, one reproducer, the resize target passed on the kernel
command line:

	case                     stock                  patched
	A plain, 8 -> 32 groups  0, 65537 -> 262145     0, 65537 -> 262145
	B group 257 (APB + 1)    0, 2105345 -> 2113537  -EFBIG, no growth
	C ^sparse_super walk     -EINVAL                -EFBIG

	(APB is EXT4_ADDR_PER_BLOCK, 256 at the 1K block size used here.)

B is the write, and the thing to notice is that the resize SUCCEEDS on the
stock kernel -- this is not an operation that aborts after the access:

	BUG: KASAN: slab-use-after-free in ext4_flex_group_add+0x50f0/0x5680

C is the read:

	BUG: KASAN: slab-use-after-free in verify_reserved_gdb.isra.0+0x270/0x290

A is the control that matters for a one-character change: an ordinary
online resize goes through reserve_backup_gdb() -> verify_reserved_gdb()
and is unchanged by the patch, same return value and same resulting block
count.

Building B needs the group being added to be exactly EXT4_ADDR_PER_BLOCK+1:
below that the index is in bounds, above it the read defect trips -EFBIG
first and the call aborts before the write. At a 1K block size that is
group 257, so the image is built with groups 0..256 already present and the
resize adds only 257. sparse_super is cleared with debugfs so the walk runs
end-1 times rather than skipping most groups.

Mounting a crafted image is not a Linux kernel vulnerability
(Documentation/process/threat-model.rst), and I am not reporting it as one.
I have not attached a Fixes: tag: the bound reads the same in v2.6.32, so
it predates the git history I can bisect over.
---
 fs/ext4/resize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -794,11 +794,11 @@ static int verify_reserved_gdb(struct super_block *sb,
 				     grp *
 				     (ext4_fsblk_t)EXT4_BLOCKS_PER_GROUP(sb) +
 				     blk);
 			return -EINVAL;
 		}
-		if (++gdbackups > EXT4_ADDR_PER_BLOCK(sb))
+		if (++gdbackups >= EXT4_ADDR_PER_BLOCK(sb))
 			return -EFBIG;
 	}
 
 	return gdbackups;
 }
