Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7942DAFA8;
	Mon,  2 Feb 2026 19:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770059473; cv=none; b=YNVOV/anF6+PFerKwCilVRfSZQeSwIBTHBgarO6Dyq8Q88rVgDpTtbn/ccti9kYQr1MCTrWyWuhDu+0Fzr4EtYw6CdGrrEG2ux3B8ZaofS5p3t9j1FHlRhTLGQCbWCaMmqwE+YooZsgNho7xxYfNisqIhV8v8Nc05fTo4dZ8Pv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770059473; c=relaxed/simple;
	bh=fcHzZdtzaFALOJq5fZ+j/tp78dQw8X4VxkS8T4fT8rg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dsdxHVuIFutII0k/FYUMyaEVaPNWXbHaq6oXOLOxVyDElwzqedfDigqF2M3k+rjKyQ3gbcvnJB3fsog9L5k9v/tfArM62fTFqarpNAJfjXkRbJrqq3dRgSXO94YZQ7fvjHHax8ORZHNbiFT2x3O4D0HPAN+M81LcMYwK/PQpkaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K0V5zoQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K0V5zoQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA80C116C6;
	Mon,  2 Feb 2026 19:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770059473;
	bh=fcHzZdtzaFALOJq5fZ+j/tp78dQw8X4VxkS8T4fT8rg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K0V5zoQAGNLdPN9RmJZmfJwUPaflrPQ8HqchsaQi850iQyrq1nHDvEWgWwMFVIBWU
	 +vlO2mc8Rl9SE8xcsj3SeCdtuDr4SEscSY472hhUqiTulGChP/tNsBVpHJkrpx7705
	 bwYykGharLopqxuEU5+Gq/v8fBtwKv8pm2p3ddfvoFdAJSVXYfiM13J469B0IMhZhk
	 ofX2yHLscazJ4yzYIxCPd0tXestN9KhP6tdcbCAvGPVrwsbTeCP76+H6eJVjT4XRU/
	 clawCzFBIu9DZEQ14IfnjuirsM6M5dJ3gWzO08Yf6xrtBlp69W/2coflEj42W62Vq7
	 9H0w6U5VCI4GA==
Date: Mon, 02 Feb 2026 11:11:12 -0800
Subject: [PATCH 1/3] xfs/018: remove inline xattr recovery tests
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <177005945298.2432878.17951687824065765554.stgit@frogsfrogsfrogs>
In-Reply-To: <177005945267.2432878.7105483366958924034.stgit@frogsfrogsfrogs>
References: <177005945267.2432878.7105483366958924034.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we can do xattr updates in a single transaction (as opposed to
using the attr intent machinery) if we keep the attr structure in short
format, remove the attr intent item log recovery tests.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/018     |   24 ------------------------
 tests/xfs/018.out |   45 ---------------------------------------------
 2 files changed, 69 deletions(-)


diff --git a/tests/xfs/018 b/tests/xfs/018
index 8b6a3e1c508045..9b69c9cb14b33d 100755
--- a/tests/xfs/018
+++ b/tests/xfs/018
@@ -127,16 +127,6 @@ mkdir $testdir
 
 require_larp
 
-# empty, inline
-create_test_file empty_file1 0
-test_attr_replay empty_file1 "attr_name" $attr64 "s" "larp"
-test_attr_replay empty_file1 "attr_name" $attr64 "r" "larp"
-
-# empty, inline with an unaligned value
-create_test_file empty_fileX 0
-test_attr_replay empty_fileX "attr_nameX" $attr17 "s" "larp"
-test_attr_replay empty_fileX "attr_nameX" $attr17 "r" "larp"
-
 # empty, internal
 create_test_file empty_file2 0
 test_attr_replay empty_file2 "attr_name" $attr1k "s" "larp"
@@ -152,16 +142,6 @@ create_test_file empty_fileY 0
 test_attr_replay empty_fileY "attr_name" $attr32l "s" "larp"
 test_attr_replay empty_fileY "attr_name" $attr32l "r" "larp"
 
-# inline, inline
-create_test_file inline_file1 1 $attr16
-test_attr_replay inline_file1 "attr_name2" $attr64 "s" "larp"
-test_attr_replay inline_file1 "attr_name2" $attr64 "r" "larp"
-
-# inline, internal
-create_test_file inline_file2 1 $attr16
-test_attr_replay inline_file2 "attr_name2" $attr1k "s" "larp"
-test_attr_replay inline_file2 "attr_name2" $attr1k "r" "larp"
-
 # inline, remote
 create_test_file inline_file3 1 $attr16
 test_attr_replay inline_file3 "attr_name2" $attr64k "s" "larp"
@@ -195,10 +175,6 @@ create_test_file remote_file2 1 $attr64k
 test_attr_replay remote_file2 "attr_name2" $attr64k "s" "larp"
 test_attr_replay remote_file2 "attr_name2" $attr64k "r" "larp"
 
-# replace shortform with different value
-create_test_file sf_file 2 $attr64
-test_attr_replay sf_file "attr_name2" $attr16 "s" "larp"
-
 # replace leaf with different value
 create_test_file leaf_file 3 $attr1k
 test_attr_replay leaf_file "attr_name2" $attr256 "s" "larp"
diff --git a/tests/xfs/018.out b/tests/xfs/018.out
index ad8fd5266f06d0..be1d6422af65a5 100644
--- a/tests/xfs/018.out
+++ b/tests/xfs/018.out
@@ -1,26 +1,6 @@
 QA output created by 018
 *** mkfs
 *** mount FS
-attr_set: Input/output error
-Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file1
-touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1': Input/output error
-attr_name: e889d82dd111d6315d7b1edce2b1b30f  -
-
-attr_remove: Input/output error
-Could not remove "attr_name" for SCRATCH_MNT/testdir/empty_file1
-touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1': Input/output error
-attr_name: d41d8cd98f00b204e9800998ecf8427e  -
-
-attr_set: Input/output error
-Could not set "attr_nameX" for SCRATCH_MNT/testdir/empty_fileX
-touch: cannot touch 'SCRATCH_MNT/testdir/empty_fileX': Input/output error
-attr_nameX: cb72c43fb97dd3cb4ac6ad2d9bd365e1  -
-
-attr_remove: Input/output error
-Could not remove "attr_nameX" for SCRATCH_MNT/testdir/empty_fileX
-touch: cannot touch 'SCRATCH_MNT/testdir/empty_fileX': Input/output error
-attr_nameX: d41d8cd98f00b204e9800998ecf8427e  -
-
 attr_set: Input/output error
 Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file2
 touch: cannot touch 'SCRATCH_MNT/testdir/empty_file2': Input/output error
@@ -51,26 +31,6 @@ Could not remove "attr_name" for SCRATCH_MNT/testdir/empty_fileY
 touch: cannot touch 'SCRATCH_MNT/testdir/empty_fileY': Input/output error
 attr_name: d41d8cd98f00b204e9800998ecf8427e  -
 
-attr_set: Input/output error
-Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file1
-touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1': Input/output error
-attr_name2: e889d82dd111d6315d7b1edce2b1b30f  -
-
-attr_remove: Input/output error
-Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file1
-touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1': Input/output error
-attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
-
-attr_set: Input/output error
-Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file2
-touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2': Input/output error
-attr_name2: 4198214ee02e6ad7ac39559cd3e70070  -
-
-attr_remove: Input/output error
-Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file2
-touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2': Input/output error
-attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
-
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file3
 touch: cannot touch 'SCRATCH_MNT/testdir/inline_file3': Input/output error
@@ -131,11 +91,6 @@ Could not remove "attr_name2" for SCRATCH_MNT/testdir/remote_file2
 touch: cannot touch 'SCRATCH_MNT/testdir/remote_file2': Input/output error
 attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 
-attr_set: Input/output error
-Could not set "attr_name2" for SCRATCH_MNT/testdir/sf_file
-touch: cannot touch 'SCRATCH_MNT/testdir/sf_file': Input/output error
-attr_name2: e43df9b5a46b755ea8f1b4dd08265544  -
-
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/leaf_file
 touch: cannot touch 'SCRATCH_MNT/testdir/leaf_file': Input/output error

