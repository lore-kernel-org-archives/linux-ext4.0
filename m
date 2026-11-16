Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794807879;
	b=tVW0LU0oJQUXSoHD1Ii8THQq2LTQlaWBUYFft5FbfzeoEIHuKD8MHlA3/nzlIPD7Px8S
	 oEY2iSQjAZpAg4PfM1iHvCIatyBYZVeko1tj4ixdQUldwuSEnvdCzdoekw/kz2+kZRJMq
	 eBdblxYvFqY9bQWCyFbio5WoOmet40lTjClpEpptIdYdt4gkyxHsMvba5ZLG+JzyzTV0g
	 b4N2cwdo6SyQIDAVKS4e98rfS4d5aYW2kUQadKEpiH9YaH73lstW8MbAqs54E0P8hToYV
	 4DpQ0vNPyj+Z6use0jtN0yy8/urzbHioFes2Mhq2bKLqMmvHM/UiaaMrQg6xs7KOPxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794807879;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=6juYiLwJPfjMMa1PV9mnBM+MXTPlKv5dj+C2Lcf3/rs=;
	b=5cz7BtoBWFfSuIix5PdorDsmBc9kgh7xC2+274a7OrlKTAVRxeXeKT91jrE2Hn8gg2uR
	 8BDaciNpiSJ8Z83U5QldcKc33E0U6ayykd3OASmddXx5Zji5tnxgQp0p8hdTZVjDrhbIX
	 KQyoTtnCk7N71qxDdzbn7qcaPXkoR/tcquPL+VtydLEcO7dQ7f5ooPI5xYGm1ZcgYjnfM
	 N+3G6k1+YwGONWyCgtkr4qGLlCnxH7S1huJIZ3peH6xU3BUUJEZUEZolJeyLhHlI5L5JO
	 +smsMdQJj0BRD487FxqQ+pW2FosR3a7PZXnh8eFFYrPU10nRK/OjDc8HGgfe1XEB1Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KbcyvYrO;
	arc=none smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D669F606A323
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 05:44:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D669F606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KbcyvYrO
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8b6a88e4341so1127660b3a.1
        for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2026 21:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794807878; x=1795412678; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6juYiLwJPfjMMa1PV9mnBM+MXTPlKv5dj+C2Lcf3/rs=;
        b=KbcyvYrOCF+jA/uX8xFI7qHAQ8AL6G1YvRWtN85kZR2PmGYHc7TC+9VQ3cPwdGWmqG
         H5j7xrNlK1JTWUj0vR7kLwPYPKw9X81xik+JOqeQ8WUFGlSTOQIRIpsQON7TTO3FdJ8G
         R8QsafxUs7UHjig0wcEilZjBOPXx9tl7royOiKw7YIV/cWdmmkNjgZ8yTcTGEFcj04qW
         m916fnhskK0NTAL0aAtfkttXYrnGzGg78TjjXXoBlGvsK6oGuFMbQErcPc+h0ui/vw0Z
         LsrJ1bwLNgL0RMknkL+OAfflZQH9zBLrmfKz8z34OTZqjW8yWVcyNcxgtgrBrRp2K8P+
         6blw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794807878; x=1795412678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6juYiLwJPfjMMa1PV9mnBM+MXTPlKv5dj+C2Lcf3/rs=;
        b=MTGFkCPN0MestcU2pTfsh+mZ24m8/xwFeUAgNb6zr3LHTQgG1G35eea3Dcuur4jx9p
         RkpaaFF8kxOC5y8X+AqqvStnZwBTd/LbCxCjrqfEa4vPcHKhicyZKbITy8vUJEv+1Xp2
         KEv9urCBrDRN7tptiO4dxPu1ThrdRVhSZaCp7g7Jef39iv8CNEbBko3ZbKkxhMd01ea3
         m6hkjpzxU7OtvQ/cL3YSweq7AHonJiNba/R4P5EZTJm3al8d2jSqxShNyJp16Hsrw7ca
         0t9nrZ1SWTZoEcRGwe0xJaCqwZf4rS8y66KuGeJMp7qlkrgNYpa5QRM9Tn7+BdBNzEt5
         XHNQ==
X-Forwarded-Encrypted: i=1; AL+hErHijQOoRpDROOkV+2gWGry3nuR/8sTfl0pFthn2LCqR5Xk2qu2HR8L0QuOzAX87p9mGJwrg/1ev/1Ze@vger.kernel.org
X-Gm-Message-State: APuU4Z/Ip6nYuRK1uLfUsMz634YAGld1cusv13DAOrilg4aY7vC3JWzu
	U5PmVK3P7ib28LQw9Eh/Z1sO9PIn3y41xrfQVvj7cvx0oPt8DSETAUFx
X-Gm-Gg: AYBFou1V98IUQJqEeE3DIP+FcF5VdneXuBBtNEuB/8iE97A7OPiDFZMNuV+s+MrYblN
	mqKoUFH+3GRtUcQ0RgCAtnBbDUA95SK1mhuzG0dhPOVjSC2dlDL2cKuwG1ZtMNAnMyha5dUxaEj
	mxCV/QhNdBhOHXgYUNKO0sp7WFfZTvcqhr/M137oGW9MpdJPMt0i7XodM1oLiIbf1YguADvoiUj
	xaj3W3Y/EjKJoVHt830QbxkvTH6/H+sASUx6+IHJ3sHNIgGlbEK5fdbUbFzdxUnaXpFjz9Qu4kq
	Bsa4WDhPtv+rQjkDzpxNnfFg5R1r2+jQflCcEHQGFswtNNm71myd4qu67Z7j4xF2UWcenYuCs6W
	HHh9KZFbWekc26xhqF7bLUqJKvevqS+pzyG254ogCNbBG7Sg+cttaNqdIvoH4H7fPmz8tomc0kb
	eqWUAh/LdbPJeHjYYB/es+kN2yj7XgZFenjhxMOisrtsj6pKGcEj9d5KWL26tQ+xG0pxtb5Ejhn
	13AFbwK9UuTDxoNmVqiER/ed10gwE8whlC3/d0iqgoG0HJYz0LvisHIa9VCwnnazCMIhBxfkmeh
	NqVtQ/woIXmKkIPf7yLE33oiRG/p82sg/ngYUowWnq0hJ2DYtHN1
X-Received: by 2002:a05:6a21:3d86:b0:3e2:26fc:2e06 with SMTP id adf61e73a8af0-3f7a77c053fmr6978259637.26.1794807878106;
        Sun, 15 Nov 2026 21:44:38 -0800 (PST)
Received: from localhost.localdomain ([152.136.45.109])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cddc18c7575sm3680304a12.27.2026.11.15.21.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 21:44:37 -0800 (PST)
From: Qing Zhang <diasyzhangqing@gmail.com>
X-Google-Original-From: Qing Zhang <diasyzhang@tencent.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	kartikey406@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qing Zhang <diasyzhang@tencent.com>,
	Ahmed Khan <ahmadpsn95@gmail.com>,
	syzbot+9c29b92a3b6500bb347d@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH] ext4: attach jinode before inline data conversion in setattr
Date: Mon, 16 Nov 2026 13:44:23 +0800
Message-ID: <20261116054424.62067-1-diasyzhang@tencent.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <6afa2521.84fe3b82.798c4.0005.GAE@google.com>
References: <6afa2521.84fe3b82.798c4.0005.GAE@google.com>
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

Commit ed9356a30e59 ("ext4: convert inline data to extents when
truncate exceeds inline size") added inline data conversion to
ext4_setattr(). Pathname-based truncate bypasses ext4_file_open(),
so the inode may lack a jinode. In ordered mode, the conversion
can pass this NULL jinode to jbd2_journal_file_inode(), causing a
NULL pointer dereference.

Attach the jinode before ext4_convert_inline_data() and propagate
attachment errors. The attachment in ext4_truncate_up() occurs
after the conversion and is too late.

Fixes: ed9356a30e59 ("ext4: convert inline data to extents when truncate exceeds inline size")
Reported-by: Ahmed Khan <ahmadpsn95@gmail.com>
Link: https://lore.kernel.org/r/CAOaS1==g3mdoqmS2AjOC0_-woXJbA_X0LJQt7+M7d1=+gfyQqw@mail.gmail.com
Reported-by: syzbot+9c29b92a3b6500bb347d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9c29b92a3b6500bb347d
Cc: stable@vger.kernel.org
Signed-off-by: Qing Zhang <diasyzhang@tencent.com>
---

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
 fs/ext4/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 10cd85d4c721..1e31933ae98c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -7127,6 +7127,9 @@ int ext4_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
 		 */
 		if (ext4_has_inline_data(inode) &&
 		    attr->ia_size > EXT4_I(inode)->i_inline_size) {
+			error = ext4_inode_attach_jinode(inode);
+			if (error)
+				goto err_out;
 			error = ext4_convert_inline_data(inode);
 			if (error)
 				goto err_out;
-- 
2.43.7

