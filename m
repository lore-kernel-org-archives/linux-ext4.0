Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF5930F7FA;
	Wed, 29 Apr 2026 14:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777472450; cv=none; b=NXu61zreO6yrkUjYN61BjFDuSx5iIpnTiyER48zpObglIlZV0Jew047+/iCXjqQDv75nZNVK3e6Q02Hqwul5YRS8anbX7pY4dL5nDltA2dcCo4fddecPDN+cH5NryS/6eBi7VOJyTXr06DjVf2CiTDYEOWAAntpb9dZH9CCfin4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777472450; c=relaxed/simple;
	bh=y9RoxwDWwv5l1xLUc04ksBCTA4/2rGpKLDVdR+BKAH8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TVfJ7n1c4JxMghxJ1C/ExLX5dHyt3T6dLE2SiGxPGgf1J0ZSWiGHb3fLAV8stoIOw60FyUr+C2qE5qz0Tw4o/TAmWdgWV18a5xOBuvDu55HEhcwmuXEPMJtsjC/wPRkga778xRflBOW69sZGx8vDk0mgwgMH10xCb5IEoQHwuSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tQHiohkG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tQHiohkG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A657C19425;
	Wed, 29 Apr 2026 14:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777472450;
	bh=y9RoxwDWwv5l1xLUc04ksBCTA4/2rGpKLDVdR+BKAH8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tQHiohkGS6rRVBwQ79CypVZU7Eu9C0vXs7LoSA3t9K788cqaQRnoSWMdtT+ag/NI8
	 32/mp2FNlmRnOciiHh5I95zbQt8PxyzwYTppHl+65d1fvag47dfp1um/4ypd4kMcYK
	 vLRS+dSrX0S1Q35N9r1njYAgOzbuBRUVrrJJITZPBe6Rvu9NnIDhON9RR4MuOjVWLk
	 kR1haVGzyHojG1YaXJJ+I4+GRRD4Iz5dSuwFNCXceKoJh/TE0V4/bRORq1ZsaIREsn
	 l9gZjXpom8ZOeCddICBX2wYSJFugp/CvyW0sRC9lrG6coRIH2jaP2KX07tCKGAiwZN
	 j9a1PQHNG12/w==
Date: Wed, 29 Apr 2026 07:20:49 -0700
Subject: [PATCHSET v8 3/6] fuse4fs: adapt iomap for fuse services
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747215017.4109882.630706253054166885.stgit@frogsfrogsfrogs>
In-Reply-To: <20260429141253.GQ7739@frogsfrogsfrogs>
References: <20260429141253.GQ7739@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series adapts the iomap code to work in systemd service mode.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

e2fsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/e2fsprogs.git/log/?h=fuse4fs-iomap-service
---
Commits in this patchset:
 * fuse4fs: configure iomap when running as a service
 * fuse4fs: set iomap backing device blocksize
 * fuse4fs: ask for loop devices when opening via fuservicemount
---
 fuse4fs/fuse4fs.c |   94 +++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 83 insertions(+), 11 deletions(-)

