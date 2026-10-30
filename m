Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793391858;
	b=so+zxPqhxza+0kEkQP1H2/pZM11cy/GR7bTktAvqg1zeAHeaioH8w6BnCfqKnBpf2QFj
	 LTrQZyOog+BjkLtUCa/gUvn8HyhYXgCE4hjZ22wEZmlaUQ5vgJwP63p0+CPu4ALqK/LBM
	 +r/9Pr/PJZnE55UYD1kuXsmyU6HjnHm0BkvdeD2Iidcmtc2L25B1kVXlycXyJ77n7tIVE
	 u+hg5vay089MMtJc/TJV3k818X2/8asrfTrA6HhWoVrn01iS14TgWUbBUcgHL7NsmXXGI
	 1Rz3n3GWVJ0GigRF+cjoapJzVPhKf2zsFf751D5cMXanMiwNwjZwxdxrwtSp8y8X1xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793391858;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition;
	bh=WC+rINZI/Abs3FuxrW/a0CrEA1iVBadeiLmHbsQKgvY=;
	b=k8u1HiS2EIKD6/BdOOxUAoYT0zQxalUvBy8RIUz+AVQcv0E4VouL+2rvfZKFd0kry6v2
	 cokar3N2i4IwVbH/ukIc4HhiecVy37MP2A6n0IrtIWRp4kUzubfsCw4MW0HvBqtEMx3sY
	 2rHjH4hBU8rkpBSbJXATIxkqIewT2yaUDtkKw76NM6vdaskDYbOx3vVi0vaFcHiT7AMLw
	 xQ6aWOJhHJ1iIHKBpqdQZT0hrJ+9+cXnJO5r9XTkVOXF8D/43lol/txGOVHycnr7rG2Et
	 WGNZ7L9kZOU3qcoDTnqZT0x3YStiFMn2fSMYYDw06Q8CGNLzQqlh/G4k0zqCx3renEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=chGqW+Fu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF2F606A31A;
	Fri, 30 Oct 2026 20:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=chGqW+Fu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AD81F000C1;
	Fri, 30 Oct 2026 20:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793391857;
	bh=WC+rINZI/Abs3FuxrW/a0CrEA1iVBadeiLmHbsQKgvY=;
	h=Date:From:To:Cc:Subject;
	b=chGqW+FuI7AmI2PLpHQ0vbtXIS+kpFG36nwCXWm+d6UmjhAvs78Vsw+1lIPkobJEn
	 vzF3qtwn1ur8J89sjm35daORUTn2OUtmopzMWVCCN4sRzK3IPmSgQ/z+D2v2JqEM6A
	 mGWDKnZFfuqSlgC6CFX6fFmltO3SjNi6xHzqlYM7o3C2nQI2YESzrbcvUJiZsDPFBp
	 +O1pzPazIn3q9Dn7HcXp4+q/fjgnMLkZQeiyfbEGmB5H6rQsAS56UVwEyDDo2sb2c0
	 EsekZF8dpsBz7H9uf+41b+NRz2qAkUd4OzldBgNzuPkRp2qawHrMail7/ycnH5ffkF
	 XU9obUBbeM+OA==
Date: Fri, 30 Oct 2026 13:24:15 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>, Fan Wu <wufan@kernel.org>
Subject: [GIT PULL] fsverity fixes for v7.4-rc1
Message-ID: <20261030202415.GA1967@quark>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 8a36f53fd5ec3eff01f1b637d42cbdc3821d0493:

  Merge tag 'mm-stable-2026-10-25-19-27' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm (2026-10-27 12:23:17 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/fs/fsverity/linux.git tags/fsverity-for-linus

for you to fetch changes up to c349b233d6ab0fc3517401a1e2d36f5f90eb8c9b:

  fsverity: Set S_VERITY only after rollback is no longer possible (2026-10-28 10:53:43 -0700)

----------------------------------------------------------------

Fixes for several bugs found by LLMs:

- Fix bypass of IPE's fsverity support, and a use-after-free in
  certain cases, when FS_IOC_ENABLE_VERITY fails when almost done.

- Fix FS_IOC_MEASURE_VERITY and FS_IOC_READ_VERITY_METADATA to no
  longer bypass Landlock and AppArmor's read permission checks.

- Be robust against the filesystem returning different values for a
  file's verity descriptor length in two successive queries.

----------------------------------------------------------------
Eric Biggers (4):
      fsverity: Explicitly require FMODE_READ to retrieve hashes
      fsverity: Be more careful with return value of ->get_verity_descriptor()
      fsverity: Tell LSMs about signature only after verity is enabled
      fsverity: Set S_VERITY only after rollback is no longer possible

 Documentation/filesystems/fsverity.rst |  3 ++
 fs/btrfs/verity.c                      |  7 +++--
 fs/ext4/verity.c                       |  4 ++-
 fs/verity/enable.c                     | 20 ++++++++-----
 fs/verity/fsverity_private.h           |  8 +++++
 fs/verity/measure.c                    | 10 +++++++
 fs/verity/open.c                       | 47 +++++++++++++++++------------
 fs/verity/read_metadata.c              | 14 ++++++---
 fs/verity/signature.c                  | 55 ++++++++++++++++++++++++----------
 include/linux/fsverity.h               | 12 ++++----
 10 files changed, 126 insertions(+), 54 deletions(-)
