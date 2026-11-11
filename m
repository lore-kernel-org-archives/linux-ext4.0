Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794438168;
	b=DJLhZSERCgOURVQ5Wiz1WCjdqVWe9/adZ1DCNZml/uLp5HMpNRGYdMZu6xL53p7lBgjf
	 iigSo7GGqsJN+e3xQHbjNDaO+DnguGKM50LSrz69lTHG4KLkYwkYQDMnGMQ1b+AFS+KNJ
	 oWKes4tILXIno0wGa65zD9jdHDsXMrwlLfq+W9w+Kgm/amIhJEo08XTcOpbtaz8ynJv76
	 ZwWEnpZ5q1x9+v6zMSpYo36R5/lLxNNdbCN3tBR0MmZqt8DT5PCw8usIoqInBQNhF+P0P
	 6mGO81mB5HDv1rtK1tOb6EPRRReGuLs7sV6L7fmWG2KqU4wfUtunVotouPvvo+FJYXw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794438168;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=GkbLgIgtCim/iHCCDO2bpXBs7U28FdvGuAwbpA41NoI=;
	b=LGkiH+AxrECU2AnUWykSfdc26r/noPFJKn+Rmz3ntZRXKL5IIIfjhA6+bIHF0Bh+x2Bj
	 YVrcd3hXzLjEG/sO7/OuaEv8pMC9jn3kwUtAPcJUq8FQtTY5nxEOU5Qs1xp5rtDNegNPD
	 X9LmCCD6rxhtn3NMNXh/OAresSdI04itQUrJ1Cyzgc9dSC0hCO+RfGV+xWvMFstOfnnV+
	 tXCxJQ09jH14UzXCCSZOV5ONj3Vm42wWVss/HaxFcxslAc1LjCoQrM4JAr0zhFfWYrySf
	 qVpshAz5K3+A1smJDefti+Dy7cw+xCcqopDoeaZy1XpsdHShBbcVLLpOtPt8LXvI3nQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FyA+w+T8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B8C60A380B;
	Wed, 11 Nov 2026 23:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FyA+w+T8
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794438168;
	b=XI7EoZjzaTkr9TYNfKIIpQLVnSZctfBBQvZcnV0mckG1u0j4T4bIDgl4bsEAv3RXypJH
	 l1me5SHIwM2lS+++R+dh0IiYFvhygResQD/+8dOBDuE0nBOOSNmxQIEzPLbW9/E52AZ3f
	 uYYqfu8BmqofpCe+sucj0AGv+nqFeZiCzp0LfAt9DImhp/t1EWTK2FbWOqUJGWdeuPkbB
	 J4GJD0u8ZmsIhHmimFw1UqyA/R3YuVcNPAO3ztA+o1eXBJv8eQTeofUd42XD5qNahr+aW
	 rrDM6wzJIYHg3f6xP27R5Aricv9MYJgFpql8iT/WrJJ4qO4YmujhDlGLyTFgIQp43SQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794438168;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=GkbLgIgtCim/iHCCDO2bpXBs7U28FdvGuAwbpA41NoI=;
	b=q1pACOoLZfbrRFu78EuXTn790ldi2K9Z4FNuPbgKlrBmN9DGTVwfKW4P1JSKl+3DP+vr
	 XcNISSXFqt7ubdVvhqb6ZIN2C1T+eIoOL/FEou2IkrOyIHbA4gQPeQeN5elXgkBh1x9M1
	 FnEOp+yNNH1ThoGFbi/XHwWyqPzLg2UtBZmBpBFAgg21aom8IaMr9zYBxKddA6vgzHesB
	 l7HvTf1ABkaYoDeUxZTCHfcJdyepk3yhW0VApUSlP3FNcuJ5tIT6IB2oMNSvRoDBOMMN/
	 6Kyg7EYsFkIJv1sMQmUy0HdANNIOsOJr73qq9KVBn7orRoNKLuyTDeXsCr4hFJHlnrw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8BA6E1F00A12;
	Wed, 11 Nov 2026 23:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794438167;
	bh=GkbLgIgtCim/iHCCDO2bpXBs7U28FdvGuAwbpA41NoI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=FyA+w+T8gS2R6pBkhb4SF801IHVFfnECdY5wQbhq/Qg4ddwrEXiyoB5XpJIwhRfFk
	 YqQ5tf7riDChMBAFS3gMIISP74+25MM17/p4oM3wTWZg2qK8ay7pXy0zvH1lcQAmUp
	 WbFo281cQOIf14fUi5jJXvN/g7GGhUPsDs0Mez69JXmvV8mFDV5DSnfAiFziWfzs7t
	 y2GMHhk0nrU8PGvvxOxSmHbu3qOEPtgFGFzOBRAKYyZw6p9X73cc4FJclDEtGCBIyq
	 9S1arlkck1Pua2PliY7DoiWHFXSPdVEKlp+7fUuzClHPy2Y0RNm7wmX5y5yZbtVpyb
	 t/FwGYQkoMHUg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 0B5944915D;
	Wed, 11 Nov 2026 23:02:46 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Wed, 11 Nov 2026 18:02:46 -0500
Subject: [PATCH 2/3] ext4: fix directory i_blocks after fast commit replay
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
Message-Id: <20261111-ext4-fc-replay-mkdir-v1-2-4b20be29aed8@columbia.edu>
References: <20261111-ext4-fc-replay-mkdir-v1-0-4b20be29aed8@columbia.edu>
In-Reply-To: <20261111-ext4-fc-replay-mkdir-v1-0-4b20be29aed8@columbia.edu>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Zhang Yi <yi.zhang@huawei.com>, 
 Harshad Shirwadkar <harshadshirwadkar@gmail.com>, 
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 tz2294@columbia.edu, stable@vger.kernel.org, 
 Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794438165; l=1920;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=A5ACAB6Z0i4TBNy9KhffX8CQhE5dPPIFkDuhFNEF+7c=;
 b=z5Kta/OwhshDxOiEjtidL+vwkayVVceG47GP/Sq70YARwqVC6VvEdzAqCqaoQi9sPNaXycTMO
 Cq6o2Z+Ja+/BsmSoWd0wocqDDzIyu5dVzlZQKiGjf7XdG0aULKBSA55
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
Content-Transfer-Encoding: 7bit

From: Mani Tofigh <mt4022@columbia.edu>

After a crash, a directory created by the fast commit replay has an
i_blocks of 0.  e2fsck reports:

  Inode 14, i_blocks is 0, should be 8.

The same happens to a directory that gets new blocks while the replay
adds entries to it, e.g., a new directory that got many files in the
same fast commit:

  Inode 14, i_blocks is 8, should be 24.

Fast commits don't track directories.  The replay allocates their
blocks in ext4_init_new_dir() and __ext4_link() through
ext4_mb_new_blocks_simple(), which leaves i_blocks alone.  For regular
files ext4_fc_replay_inode() recounts i_blocks with
ext4_ext_replay_set_iblocks().  Nothing does that for directories.

Recount i_blocks of the new directory after ext4_init_new_dir() and of
the parent after a new entry is added.

With the fix, e2fsck doesn't find a wrong i_blocks after the replay
anymore.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Cc: stable@vger.kernel.org
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
 fs/ext4/fast_commit.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 0eac7be3f58c..9c170986f0b2 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1858,6 +1858,9 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
 		goto out;
 	}
 
+	/* The replay allocator doesn't count blocks added to the dir */
+	if (!ret && !ext4_test_inode_flag(dir, EXT4_INODE_INLINE_DATA))
+		ext4_ext_replay_set_iblocks(dir);
 	ret = 0;
 out:
 	if (dir)
@@ -2070,6 +2073,9 @@ static int ext4_fc_replay_create(struct super_block *sb,
 			ret = 0;
 			goto out;
 		}
+		/* The replay allocator doesn't count the new dir block */
+		if (!ext4_test_inode_flag(inode, EXT4_INODE_INLINE_DATA))
+			ext4_ext_replay_set_iblocks(inode);
 	}
 	ret = ext4_fc_replay_link_internal(sb, &darg, inode);
 	if (ret)

-- 
2.53.0


