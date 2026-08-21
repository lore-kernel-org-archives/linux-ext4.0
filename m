Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F34247D93B
	for <linux-ext4@vger.kernel.org>; Fri, 21 Aug 2026 11:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787313490; cv=none; b=OwTlqbHxvCmvyGVew6yj/7xNwKwYlH44HlqeOg0xFACB43KWCNvmfoFDZE6oB87ZJfQOL5b8XbH640TkUBKeum1HpUOgdQVo/BIKe29du7Sqvrfn8vkdEHhvQdO+b+L7/VaUuDjGlnE86pGd4zZBc85WMd4Zs8pwohj3hWhsvnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787313490; c=relaxed/simple;
	bh=njlkASrkVwf4yI8yFn0JMifZFp6VM3n9Hjw+Iomjl0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AQsjHyGKlMXnir0zH+Hs9HsSWwRXHS370uK1QPaSgXqAaQRhqT1aIXXLqwUP3Oivtyxa3I/sl3O86kSdSKXcxntVxmajqFdwZWqDkITXcIPznGYM//DJAyi7tuFN0JXGO29tupQ0+RV2fXV4UA8mO6FQPvwKtS9WfpXII/dc5Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oiihQej7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oiihQej7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2151F000E9;
	Fri, 21 Aug 2026 11:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787313486;
	bh=OaPcqh5YcPQoKaksVkeLnY2FD7GWOJX6KF58uQStaZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oiihQej7E+30/hH/3P9Kco3mKMa9AVRUx4jjQfym9EfBOiwXOEagsVDWD/L8dn5TN
	 bIIAJxPHf0eI8WFmpxLkwMbTnrG38U1LW8gaGq0S/2M6eZULs/1yMGYAhTxE+VNiB+
	 aN3Z0UkWLKe3+TCcyBsyCxUDTfbikvrF95A/tYUpPRBaE3dD4Cp8lvUu/lc9u6Z1ty
	 cM5g6yYNxw8xiGPK0KCquJZUas2Raz3yB0Y1XFKB6Lg5VBrvaI1p/NTkvg4+ggSkqJ
	 LJghsaKT+kqhmn9IHawkwqK4I7/4/qhIG3k0rVRvvxwZDr5QrtVvxc4uLeoepP3AtZ
	 sh2O51YnvuYjw==
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-ext4@vger.kernel.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: Re: [PATCH] ext4: Avoid entering writeback paths during fastcommit replay
Date: Fri, 21 Aug 2026 13:58:00 +0200
Message-ID: <20260821-heterogen-exerzierplatz-tassen-9303c83deb16@brauner>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260804104112.93202-2-jack@suse.cz>
References: <20260804104112.93202-2-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1393; i=brauner@kernel.org; h=from:subject:message-id; bh=njlkASrkVwf4yI8yFn0JMifZFp6VM3n9Hjw+Iomjl0Q=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR12HreebRym8Nq72vv53wLlKiZ0Rvkfl33Gt/nZP3F5 /I/5K+y7yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjI0ReMDPN9U50XXOxKCt3W z3hpm/HiJ3apd343cTraBJc6RB5u0WL4Z/HAaImc6S6f3GdmE47VT7eOn9h6Q+sKx+krC6V37jp tyAAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Tue, 04 Aug 2026 12:41:13 +0200, Jan Kara wrote:
> Fastcommit replay effectively happens in nojournal mode. This results in
> ext4_mark_iloc_dirty() setting I_METADATA_WRITEBACK flag and as a result
> we end up entering filesystem writeback functions. However during
> fastcommit replay s_writepages_rwsem isn't initialized yet and hence we
> crash.
> 
> Fix the problem by avoiding setting I_METADATA_WRITEBACK during
> fastcommit replay. Journal replay flushes the whole block device after
> replay anyway so all metadata is properly persisted and replay is faster
> this way as a bonus.
> 
> [...]

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] ext4: Avoid entering writeback paths during fastcommit replay
      https://git.kernel.org/vfs/vfs/c/0ecd56573c1f
