Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115863;
	b=kjqaPxwKME3Swp04/o9T0UITc0I+2JKeal+n1+Uukzu1JuglX9Jl+HbKyc5+lyzYFNwY
	 oXoe/Xl1jhKqJlDeyKwe8luNIiBrfah7ilXz+ZqK3y88rH2ys0gVnEgcrvVxm3G8aLpV8
	 0Kte8ja3tWUp8LWs9ggRgQq7YHltFzk4SqpPU+p9tHRUaGRlkQJy+jqKSeqMrpOJyIaPl
	 ZTcmhD6+EI3xaoqip/6yCc0mIqsa37gJmqNNhC0Zqaf/l2nLY9ciH0ht7HaKGuuwxLoiG
	 d6Xz3jAVwwsId8TYOkDq56niEuPbbYhxcgSEb1Fqu1U3YL6t97isp6U3sOHNluPZB4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115863;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=W45QNNFRJO4sOTHRQYLnYHi84AL+cTdCLwjF7PJWjuI=;
	b=ArEeD87+vxugz31W2eI0uk2XExeZM9/IK0smlf2Oe1HC75UHpKM8j1noSjpbrHFkiI8r
	 6EfaBmsyrklJm4PBoGWeelX0xxpcLlJ9B8CByB1k7gA9BSo9xfZYkF1/rVMiClPdb8b+w
	 ug99h+lhFvLGaHRFFdgWG2Nm+z5rIOl4LAtQSGk+bZpSXMYi48ETznnABFDzpfJMoARa2
	 p1wNl/mOoCmlpIbLewy9O2N/igby8bPM5PmWTwG6r+4BA5pgjwQXVodjohapthgFT2EBf
	 yDB7kyvSlxDc7iftwGhkzREGQyBYluSIdvbc1+PtqEsrCdwSP84ua0afonEuZbas+hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=L1tzy9OZ;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14926606A32F
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14926606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=L1tzy9OZ
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHY7T029988
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115855; bh=W45QNNFRJO4sOTHRQYLnYHi84AL+cTdCLwjF7PJWjuI=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=L1tzy9OZgNHR2d+UTblwZ3XMCtL/lq3GQS/sJEQMsw+62nqk5th4wuGTc8pU9DvcI
	 Gj4Ye1m6LEO5r0/0S6SC20uCtt436iYTxWi+gcyFtvadWC8M1TOug9M1rxIkNsHyrt
	 qRFvyoUWcQeyym5tW+RtFd2FCgheHjN9gywpsvYW/IzxANam1lh10KOCtlJ36ryqU9
	 lNuA3sxkpwSRnPq2NTg4cqzlYYEBZP3iJhuH2JF/vTzO/xeVYk3un4l6xgy4eymbri
	 xX/iozTGF0NVSJczj/ZnbOxwPcZjO26uJoZTew64jb6RUyBMAOCAWeJglWBAAeU/g4
	 yhHhnkjpPSPXQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 6BB8D2E0161; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH -v2 28/32] ext4: use atomic iversion accessors in swap_inode_data()
Date: Thu, 19 Nov 2026 14:17:15 -0500
Message-ID: <20261119191719.1943298-29-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261119191719.1943298-1-tytso@mit.edu>
References: <20261119191719.1943298-1-tytso@mit.edu>
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

swap_inode_data() currently uses swap(inode1->i_version, inode2->i_version)
to exchange the two inodes' i_version counters.  Because inode->i_version
is an atomic64_t, swapping the structs directly performs plain non-atomic
loads and stores, which can expose torn 64-bit values to concurrent
lockless readers (such as inode_peek_iversion_raw()) on 32-bit SMP systems.

Exchange the raw i_version values using inode_peek_iversion_raw() and
inode_set_iversion_raw() instead, and update
test_swap_inode_data_and_seed() in fs/ext4/ioctl-test.c to verify full
64-bit i_version values across both swaps.

Fixes: f02a9ad1f15d ("fs: handle inode->i_version more efficiently")
Cc: stable@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ioctl-test.c | 14 ++++++++++----
 fs/ext4/ioctl.c      |  5 ++++-
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ioctl-test.c b/fs/ext4/ioctl-test.c
index f24102f8dbd9..710e9ea51186 100644
--- a/fs/ext4/ioctl-test.c
+++ b/fs/ext4/ioctl-test.c
@@ -1140,8 +1140,8 @@ static void test_swap_inode_data_and_seed(struct kunit *test)
 	ei2->i_disksize = 0x22000;
 	i_size_write(inode1, 0x10500);
 	i_size_write(inode2, 0x20500);
-	inode_set_iversion_raw(inode1, 10);
-	inode_set_iversion_raw(inode2, 20);
+	inode_set_iversion_raw(inode1, 0x123456789abcdef0ULL);
+	inode_set_iversion_raw(inode2, 0xfedcba9876543210ULL);
 	inode_set_atime_to_ts(inode1, at1);
 	inode_set_atime_to_ts(inode2, at2);
 	inode_set_mtime_to_ts(inode1, mt1);
@@ -1164,8 +1164,10 @@ static void test_swap_inode_data_and_seed(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, ei2->i_disksize, (loff_t)0x11000);
 	KUNIT_EXPECT_EQ(test, i_size_read(inode1), (loff_t)0x20500);
 	KUNIT_EXPECT_EQ(test, i_size_read(inode2), (loff_t)0x10500);
-	KUNIT_EXPECT_EQ(test, inode_peek_iversion_raw(inode1), 20ULL);
-	KUNIT_EXPECT_EQ(test, inode_peek_iversion_raw(inode2), 10ULL);
+	KUNIT_EXPECT_EQ(test, inode_peek_iversion_raw(inode1),
+			0xfedcba9876543210ULL);
+	KUNIT_EXPECT_EQ(test, inode_peek_iversion_raw(inode2),
+			0x123456789abcdef0ULL);
 	KUNIT_EXPECT_EQ(test, inode_get_atime_sec(inode1), 2000LL);
 	KUNIT_EXPECT_EQ(test, inode_get_mtime_sec(inode1), 4000LL);
 	KUNIT_EXPECT_EQ(test, ei1->i_es_all_nr, 0U);
@@ -1181,6 +1183,10 @@ static void test_swap_inode_data_and_seed(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, ei2->i_flags, (u32)EXT4_NOATIME_FL);
 	KUNIT_EXPECT_EQ(test, ei1->i_disksize, (loff_t)0x11000);
 	KUNIT_EXPECT_EQ(test, i_size_read(inode1), (loff_t)0x10500);
+	KUNIT_EXPECT_EQ(test, inode_peek_iversion_raw(inode1),
+			0x123456789abcdef0ULL);
+	KUNIT_EXPECT_EQ(test, inode_peek_iversion_raw(inode2),
+			0xfedcba9876543210ULL);
 
 	/* ext4_reset_inode_seed with and without metadata_csum */
 	inode1->i_ino = 42;
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index b279ffe1d621..180e7906b086 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -331,11 +331,14 @@ static void swap_inode_data(struct inode *inode1, struct inode *inode2)
 	struct ext4_inode_info *ei2;
 	unsigned long tmp;
 	struct timespec64 ts1, ts2;
+	u64 iversion;
 
 	ei1 = EXT4_I(inode1);
 	ei2 = EXT4_I(inode2);
 
-	swap(inode1->i_version, inode2->i_version);
+	iversion = inode_peek_iversion_raw(inode1);
+	inode_set_iversion_raw(inode1, inode_peek_iversion_raw(inode2));
+	inode_set_iversion_raw(inode2, iversion);
 
 	ts1 = inode_get_atime(inode1);
 	ts2 = inode_get_atime(inode2);
-- 
2.56.1.708.g77570a6a1d-goog

