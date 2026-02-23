Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7243330B22;
	Mon, 23 Feb 2026 23:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771887651; cv=none; b=KG6Dkoow1Pq0QolLQmBDbv1NqBA9rscMijGqUTrlxopYaYCtuIxASXQ8lKxxvONAZALS6FnyPJ6Ma13N7UY+qBW0a872iPsy3ourZ57kwL99I7iPkc5isEybSp4Djvxit9tAxlN8xkivcAjCmp8CcplyTorLgeser+OeKqMvI6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771887651; c=relaxed/simple;
	bh=9HVAzDb00eNGfsPwVwJCwiFQi56si2iPirb9y1aaOc4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s7Yzv+8jGzexo0+jcCaR4TU24jmL8ECFqyC3KfzzgZLSo8kVkCO1Azxs1wJDUvLNnuGEk4qrHtYWRQCnNb5/PK6Wz9RqLmngYneS7dlq4sUUf6AvhnwYn4O3cylBBIy7tcgeA3dNYIvu0mGHuPe0w7Bu6wcyNNtbfWZWeZyEmS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RjSAYEg9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RjSAYEg9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62423C116C6;
	Mon, 23 Feb 2026 23:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771887651;
	bh=9HVAzDb00eNGfsPwVwJCwiFQi56si2iPirb9y1aaOc4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RjSAYEg9ylqcfSrdOX65Iq+avufhDTittqvac5FkVWLdeYmIOtsS15uLFz8/kNWF5
	 CPb/wvZbJSBgg05jMbo5rTtbouNrHeHjuLO4Xlw2yESR07DS7zCoqRVMf5kSvqpY8S
	 ZSdnV5P5lJopajP3U/TkDSkxWw3u1ADCBc9CtVFnqSGmRr8zNQeZl18LU321xzLKG7
	 T6cM8R8fuuqnU81OXnhb3H6MXFxZi0KLwWF+0KgXbg2GeoWmhu6c823ZweBUPsPxTz
	 0Rk0I+55Ksu0QrxPmbq9hr1+J5ZchonWizbBd5GH75xggziyXpQEGDecE9KMfmT2I7
	 22C86N7pGKjFQ==
Date: Mon, 23 Feb 2026 15:00:50 -0800
Subject: [PATCHSET v7 2/9] iomap: cleanups ahead of adding fuse support
From: "Darrick J. Wong" <djwong@kernel.org>
To: brauner@kernel.org, miklos@szeredi.hu, djwong@kernel.org
Cc: bpf@vger.kernel.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org
Message-ID: <177188733433.3935463.11119081161286211234.stgit@frogsfrogsfrogs>
In-Reply-To: <20260223224617.GA2390314@frogsfrogsfrogs>
References: <20260223224617.GA2390314@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

In preparation for making fuse use the fs/iomap code for regular file
data IO, fix a few bugs in fuse and apply a couple of tweaks to iomap.
These patches can go in immediately.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=iomap-fuse-prep
---
Commits in this patchset:
 * iomap: allow directio callers to supply _COMP_WORK
 * iomap: allow NULL swap info bdev when activating swapfile
---
 include/linux/iomap.h |    3 +++
 fs/iomap/direct-io.c  |    5 +++--
 fs/iomap/swapfile.c   |   17 +++++++++++++++++
 3 files changed, 23 insertions(+), 2 deletions(-)

