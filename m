Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28932285CB3
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 21:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773349259; cv=none; b=uALucKtu0TLbOtOVj66GsAuC0iJON7P9RnnYaNZbXS2NvsaeYJmnlb3W8oBkWNzyUxLx99vya6iGPnVfagJnfj38qsSrVAoOJyaeES3FmW659bVn9d2I+XadgV5qqUMpH5r7lHz6daXpukoI5iF7iELdQI/DWJhfeL8qx20Qe3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773349259; c=relaxed/simple;
	bh=O60ttzuFRUUo/SyNnydrLIXq83RZEQKzDR8/cC7n3U4=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=FWuxt4ZIBrLpTSbFPsLQ/9Vx/Uay9XtAlOH6XB1F+n+CSaJTnEtzyU7VASF/nu9KMH27nLSTmzWwDs1dwntHCF+Rff/uyr0OtD17qqs8YOVZaOtUtTuDxLLP7xgHI4AEpXrI/GZRwhlcdUcqRpxEEzrnNddS5J+wG2v+luJ7sT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UUf2KvxC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UUf2KvxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAB1C4CEF7;
	Thu, 12 Mar 2026 21:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773349258;
	bh=O60ttzuFRUUo/SyNnydrLIXq83RZEQKzDR8/cC7n3U4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UUf2KvxCAy96xeGxJlvznX66wnYhVOATDO7RmC8a/xularx6ZGYw6qBLpviKTAWQI
	 4OPuBubUFkDlr2M86hCCxwXMtBG34mOa9KsFC4O7bPwQ68Mya1TxsTlmuckxvlaaCI
	 1DM/BBydKuMS6CNutW/mY0RBKLxstg+58sYZ7r7E7QRrSHczWrcuLXgY4i51ru11IH
	 kZ/2OPC47o4Khax100TGAkZuMvpfVKbr9zqRkGq/t8VF3WnrEHsyq6Pf6yrNzFHdAr
	 YmvjMw8gFv47HsGsC+btV4BWlwGxcjT+4ofHTUSWOUmlgfjGedtn9aH8dHqMCxitJv
	 eKH/Qb6m9eh/A==
Date: Thu, 12 Mar 2026 14:00:58 -0700
Subject: [GIT PULL 6/9] fuse2fs: improve operation tracing
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: djwong@kernel.org, linux-ext4@vger.kernel.org
Message-ID: <177334916604.3254574.11968947765826043346.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260312205728.GA6004@frogsfrogsfrogs>
References: <20260312205728.GA6004@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Ted,

Please pull this branch with changes for ext4.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 9476b1377d887872f96d7144a81d2107cff3df1f:

fuse2fs: adjust OOM killer score if possible (2026-03-08 19:14:05 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.git tags/fuse2fs-tracing_2026-03-12

for you to fetch changes up to fe8281316fd37133eb78474040affabb3f060e24:

fuse2fs: record thread id in debug trace data (2026-03-08 19:14:06 -0700)

----------------------------------------------------------------
fuse2fs: improve operation tracing [06/18]

This series improves the ability for developers to trace the activities
of fuse2fs by adding more debugging printfs and tracing abilities of
fuse2fs.  It also registers a com_err handler for libext2fs so we can
capture errors coming out of there, and changes filesystem error
reporting to tell us the function name instead of just fuse2fs.c.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
fuse2fs: hook library error message printing
fuse2fs: print the function name in error messages, not the file name
fuse2fs: improve tracing for file range operations
fuse2fs: record thread id in debug trace data

misc/fuse2fs.c | 93 +++++++++++++++++++++++++++++++++++++++++++---------------
1 file changed, 69 insertions(+), 24 deletions(-)

