Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80063C2BB0
	for <linux-ext4@vger.kernel.org>; Sat,  1 Aug 2026 22:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621694; cv=none; b=XQkhySsj3Mm1i8ybT/DoxqM8iIUCPZlcA+aMzGEgA316C3kLcKEERmHG7oIEFsNWF/DL9BK3QpcyQ/7aJUkkypOlm+oVuQ97QDto3NSk/IcA72th0O3MuvsTWp4uA4wtr7hzz5wNCySdo+T/MTBaO6LXo0d2NeExB/kpk6m506g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621694; c=relaxed/simple;
	bh=tojfuYvzfAMfs0bsJ/hEKkMgCSJ1prAxAJ+lK0XKzIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRWhqwZda9KJkA0RUB7r2RK7sqtlIkWRVGWqIaNeUBxI6e3HzaqhP4NC4THqJXOu/SN7Va1M2ZOyEL4Nj+b1gorSqHpWUE2DWgBIOoVThV3nbLeZ+ZeITqind6nh9+KsNPeNKsabOg+Cj+qyExywwJHIQHz+OI8u+yXQ0tqDpls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TYuH/kaP; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TYuH/kaP"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-80dc4a68e4aso24229567b3.0
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 15:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621687; x=1786226487; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S5d9GJjjHaj8KTJ0WAU1dmfHtrReZ7Fn8M10/pEoUFY=;
        b=TYuH/kaPqP7d3Q7Zz/nxr5ocNgCXUXsytaGpbw8XVlGTRRue8C5+ds4Pe7Tpr3sHIh
         Ezdxkj+G20pbV5xDuU60LWV7zhMUGZn3z0EnZhoVoLXXtQT7qj/b308VvG++6RsjEb2U
         whA8yDVvrOZzxlCZUQDDCV/rbn6w+clpklfhyn+XrjEVWJqu1xkps+7ncse+c+NjQC7s
         cU1iFfbfnVMW4EzHN562s7P0lFKwYphttpFHXtUywAzwB4hT3OnXwtWPrl4MwZnEPSyO
         QL9g51u6/yhB5U7T/7nJT2m+HMXX22Tzb6G1/Nh2GPn1yTtXlyTtUYas9n+bmaX9hq05
         6Fow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621687; x=1786226487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=S5d9GJjjHaj8KTJ0WAU1dmfHtrReZ7Fn8M10/pEoUFY=;
        b=ipAlYLV6+sTbN78pGQYNvA/hBAi33Axyq5gexwS89bN05JeojMMeAcWUy7fONbPgUb
         yRFcKqt+L5Ktb2Toxn49mbyqzJKuCMfc96GioSsDGJbvuTBjtVcQxPsbspRDcaoyMSPd
         ATW+52Mt8qwgEMaqYMagu58OYFASITr3ApOQvREdNWaF+b5FIPk0KwmXv+dljy6F1CuI
         I80bN2Kb8P0rngJehDG5hnNP+Ie1dMjjya9bpT69X2c2ru8gYRX5cKQLeaR+Zn4QWFHK
         Fa17rGx1cFR/tYjRtk3AaHwpqOn+ZaLHxwmzDrwWrUni4iSta92taEEgaGIldmHmNhv/
         91hw==
X-Forwarded-Encrypted: i=1; AHgh+RpamaCPyeEBMyqB8QBMAF2/0fjtA636YePY98tBt1dKFAefMeOFTdia+zZ4nv0R0bwoSy1pE/XsuCot@vger.kernel.org
X-Gm-Message-State: AOJu0YyG/eNfJwDzCrS0R/K92Vq3Pa4At8xrSKQmfjDbxNk/0gMfC6t5
	0x2542RRrDFjNUjfNjND0THebkNaprg52ZR6CBR3MJs0osutJb7y6HU0
X-Gm-Gg: AR+sD11V9XzQAGdL7JttsSZ2i8Pdeq9coprPRjTNAWQkm5bRlf4YLdzit/dgixwcMl3
	XrRJlIbwyL+qMehtnLlLqcjmcv9Z8YO4mDEsKqXgw9Os096TbgFejG0ghwytl2cPO3miOyviHFG
	e9bQCGQP3xeQLyx2p79OFCHA7gF03K1cwN6PSpgMtwDl5q+gVvTnX8No1RektdGmo+yecaHefp0
	0IW0kQBQzvBR8fDMjyIRUGTgqMRTYABy0ag0yiMeiieIResIVx2lma5t8vFOfYud90ICdxqb2L9
	eX3z/4OlHr5Bk/l5EnveRY08m5QmJhJW8tJGzjAAfiRjrqZ/8CbMa4CV4uA9l+NBtwKmj9DKV3a
	JS0wgiy4MujI9jznp/M5rk7jqdyGm9NuLsBApyKXOyZXMwtQPamW7nydLYBSF4EBapSCbrxbt2Q
	KYm7rGvwu5BjgA9XDNs95dPxwjse9K/drC+Xmdqic4/yXmwVYGV7sYRM4wKVHxfV/Zp0GKrjAfu
	dbkfVI=
X-Received: by 2002:a05:690c:48c3:b0:81e:d792:a019 with SMTP id 00721157ae682-81fd4a64bcbmr74354127b3.6.1785621686736;
        Sat, 01 Aug 2026 15:01:26 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:26 -0700 (PDT)
From: Chao Shi <coshi036@gmail.com>
To: Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Bob Copeland <me@bobcopeland.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-karma-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>
Subject: [PATCH 12/19] ext4: check for a metadata write error with buffer_write_io_error()
Date: Sat,  1 Aug 2026 18:00:56 -0400
Message-ID: <844d01d43111830a299346d0f3c6fddd62f22cc4.1785621505.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785621505.git.coshi036@gmail.com>
References: <cover.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two places detect a failed metadata write by testing !buffer_uptodate()
after waiting for it.  That relies on the write completion handler clearing
BH_Uptodate on error, which this series removes: a buffer whose write
failed still holds the data the filesystem asked to be written, so
declaring it not up to date is wrong and makes callers re-read it.

ext4 already does this correctly for the superblock - see
ext4_commit_super(), which tests buffer_write_io_error() - so this brings
the other two into line.

In __ext4_handle_dirty_metadata() the old test also required BH_Req.
BH_Write_EIO implies it, so the pair collapses into one test.  The new test
is also strictly stronger than consuming sync_dirty_buffer()'s return
value, because it still fires when the buffer was written by background
writeback and that write hit an error, which sync_dirty_buffer() does not
report.

Note that BH_Write_EIO stays set until the buffer is written again,
forgotten or invalidated, so an unrepaired itable block now reports on
every subsequent sync of that inode rather than only on the write that
failed.  That is the intended behaviour and matches what ocfs2 has always
done with this flag.

No behaviour change today - a failed write sets BH_Write_EIO and clears
BH_Uptodate together.  It stops being a no-op at the end of the series,
where the new test is the one that still works.

Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/ext4/ext4_jbd2.c | 2 +-
 fs/ext4/mmp.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 02b066299164..f338d6e3c29f 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -413,7 +413,7 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 		}
 		if (inode && inode_needs_sync(inode)) {
 			sync_dirty_buffer(bh);
-			if (buffer_req(bh) && !buffer_uptodate(bh)) {
+			if (buffer_write_io_error(bh)) {
 				ext4_error_inode_err(inode, where, line,
 						     bh->b_blocknr, EIO,
 					"IO error syncing itable block");
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 7ce361484b38..4b18ddef468d 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -49,7 +49,7 @@ static int write_mmp_block_thawed(struct super_block *sb,
 	bh_submit(bh, REQ_OP_WRITE | REQ_SYNC | REQ_META | REQ_PRIO,
 			bh_end_write);
 	wait_on_buffer(bh);
-	if (unlikely(!buffer_uptodate(bh)))
+	if (unlikely(buffer_write_io_error(bh)))
 		return -EIO;
 	return 0;
 }
-- 
2.43.0

