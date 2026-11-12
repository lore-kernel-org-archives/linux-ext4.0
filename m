Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794456423;
	b=vRd+H1tHJIj8qkxN/ywzoa62URUwsxdHCchTYjzSYZQd8jbnieR0JWMuQnj2meW3EUrN
	 Kkhwi+V61spXYRH8hscmN8Jk9dPF9ERmag+Jl2Gc8gdIsczoBslSh/ByVrcbOc4DHGbEJ
	 frdz3HFnk7NIEQhpTjFYk7EyE3ZxpnIA5LzDfXiOjCdUo4Ilpbr5H8Gx708I64CB3LxoO
	 xpDC0vNsiOK3vjBhSlkmPdVrYwi0GAuThwYBzWtE2zl8bPk0dUWQDiODBtcHss0rGOHjD
	 eWHRJT79HCwoSgukN6LJy6pH5eiGfwbSdXcUAT36Y+JTcGQwsfqM2YSxUVeV5bxXQsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794456423;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=iFjo1OyDyUlAsyl+0sfPFxW3oRbavzWh7w5UhIrwl9A=;
	b=MBsde/dcjSC4c1+ViK66TWzSRVv/r+kI3n6S0rFrd22tONgE474oD65EcMw3GbAUBGB7
	 eTXt3Hl/6VceIPTjFuAWCvJ0pnJZ6Q7CZOHdfcd5+3fZ0tcLEtC8SJNTQI5RA68/mjTQl
	 oCycpNKVcZydzuxfGzcOR37Ki6JVjL6IFKxeZY6OMlcvBM1OtfX0abDhpRhhU2GDPEi1p
	 YMKsaBgKMTpX5j1pJl4EKO1SHWBhB1RDg6RVYiKc8Cr94NadQBzXdTQh2bF6r1eX9SRUj
	 UdIWzNsDlLBYByNVfJo8yY4E/aunWc3CNjt4n9NoFatdGUUvt9PrsWSy3QTxQgxr3JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=NhZigQ6l;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D76606A321
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:07:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4D76606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=NhZigQ6l
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC46qbg016820
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:06:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794456414; bh=iFjo1OyDyUlAsyl+0sfPFxW3oRbavzWh7w5UhIrwl9A=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=NhZigQ6lasTjCid1bZ685UVSAp+Mb5vPNsHovuqyDZsN3k4NJDLmYQEOTrl5Mi3NQ
	 ZGI0Sy5ZCeMd8jVtUWG462TNCLEoe4s9IxcSqnZ0l1tfeXGY4IuGiuZ7QoZGcy3nRD
	 EyZAT5hJubHZkIE8cTmADxUOxGdLg+6Q170T/RykISkAyNOGLRLEi7GPtlWbTFCs+N
	 THgu2jk7F3Rd8v38mde3TyqoYUNhRyrHVmS7yyfTSChBaFsi7QJUQBPsXsN9VNCcjA
	 G2oBwQO62Pnay6qLzXi8lJouwgU26it8SP0tGxqZ4F8+pS1mIwhFYhHRI2iZDPQLLh
	 GDKfbV5lRmk2A==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 5535D2E014A; Wed, 11 Nov 2026 23:06:51 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 08/27] ext4: zero s_fc_replay_state in ext4_fc_replay_cleanup()
Date: Wed, 11 Nov 2026 23:06:19 -0500
Message-ID: <20261112040638.1576836-9-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261112040638.1576836-1-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
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

ext4_fc_replay_cleanup() frees sbi->s_fc_replay_state.fc_regions and
sbi->s_fc_replay_state.fc_modified_inodes, but leaves the dangling
pointers and non-zero size/usage counters in sbi->s_fc_replay_state.

This makes ext4_fc_replay_cleanup() non-idempotent: calling it more than
once triggers a slab double-free of fc_regions and fc_modified_inodes.
In particular, the ext4_fast_commit_test KUnit suite calls
ext4_fc_replay_cleanup() explicitly at the end of replay test cases and
again from its fc_cleanup_all() teardown action, causing SLUB
double-free errors in test_fc_replay_inode_and_dentries() and
test_fc_replay_ranges_and_end_to_end(). Leaving stale pointers and a
non-zero fc_regions_valid count in s_fc_replay_state after replay
completes also risks a use-after-free if ext4_fc_replay_check_excluded()
is ever invoked after cleanup, or a double-free if mount error paths are
updated to call ext4_fc_replay_cleanup().

Zero sbi->s_fc_replay_state in ext4_fc_replay_cleanup() after freeing
both buffers so the replay state is fully reset and repeated calls are
safe no-ops.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/fast_commit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 0cac890cf370..15bd040c2329 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -2398,6 +2398,7 @@ void ext4_fc_replay_cleanup(struct super_block *sb)
 	sbi->s_mount_state &= ~EXT4_FC_REPLAY;
 	kfree(sbi->s_fc_replay_state.fc_regions);
 	kfree(sbi->s_fc_replay_state.fc_modified_inodes);
+	memset(&sbi->s_fc_replay_state, 0, sizeof(sbi->s_fc_replay_state));
 }
 
 static bool ext4_fc_value_len_isvalid(struct ext4_sb_info *sbi,
-- 
2.56.0.542.g3ef89b7020-goog

