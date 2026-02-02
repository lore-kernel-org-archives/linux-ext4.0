Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04052D060D;
	Mon,  2 Feb 2026 19:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770059468; cv=none; b=pgQV4+GjG4pbVegqt/EQ1R6vurylsiH+TJz6+5uQX5MFl/baBGGG17tq7z+aBcn4nz046QeqZnOZFqJHOqyQzeTL4943kgGUGn/OcsaOwacXfdXUYCrRtJImqZkLRX+v6vTv4YgkLguxahXk0dmgTfkzS19cWLOaHukF4Sc9SK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770059468; c=relaxed/simple;
	bh=DtfmcfHLZXouW2zGkC13NeSXG9RbkpZDUiAq3cEm7Y8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=uVODXrEeTCRxodkSr6g8nBvtTh0eg698wo1j5sXBddvjAJaqb+oI2IlKQR8HbCxIf85AsQIwWjxB9XDws0QdYkqShAodSEA8TM/FnA8zxNQ6xQEvDaHzuE2mBzVm5cItAqt+8oYq/vdtSrBeLJNX1hTmJkO+bTxPAxZQnUm7IiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T40s4yQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T40s4yQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7C3C116C6;
	Mon,  2 Feb 2026 19:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770059467;
	bh=DtfmcfHLZXouW2zGkC13NeSXG9RbkpZDUiAq3cEm7Y8=;
	h=Date:Subject:From:To:Cc:From;
	b=T40s4yQFsK7O10rJCWk7BzZmIUVV3sUm6XO2GE5JQX1PqTjROZd02DiquclfMzGtH
	 jwYVRpdb1jNIEBpu0q83RUqe0qWOxQRsUMpGx5oxByuSl45oWqG3v8pJ38t+f3kBKD
	 LhBdnMGP18+jtaiipmxWKKdA72QIlnMH+Bvh6kYCOFaRZaGmb09jGKQanEFB/21rek
	 UluGoLcufF+MuOEc8U3fV1ZVFENoDin0MPTR3s/nIDulQpU8Q7aI6RscbEQf8MI9H0
	 f6WxTOM8Kzs1YdaNf8dFcEw27KSgVdB0JaOUOtuQEoImNuDfvcC275QAEQg9EyOSB7
	 8d1hh4uaHUqQg==
Date: Mon, 02 Feb 2026 11:11:06 -0800
Subject: [PATCHSET] fstests: more random fixes for v2026.01.27
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
 fstests@vger.kernel.org
Message-ID: <177005945267.2432878.7105483366958924034.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's the usual odd fixes for fstests.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * xfs/018: remove inline xattr recovery tests
 * xfs/620: force xattr leaf format for this test
 * generic/749: don't write a ton of _mread output to seqres.full
---
 tests/generic/749 |   11 ++++++++---
 tests/xfs/018     |   24 ------------------------
 tests/xfs/018.out |   45 ---------------------------------------------
 tests/xfs/620     |    7 +++++--
 4 files changed, 13 insertions(+), 74 deletions(-)

