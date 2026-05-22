Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6730A39B493;
	Fri, 22 May 2026 13:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779455666; cv=none; b=MnNaGjZDCa+hhs6HJeG8WW2nHoSRYvGcpNxZcTNqlvgNhkd1L4EyKUPXyqv02uOIhf4EydnQgKMxwUSq6gmYpdiB1xp3F/W+ItnX13k0h0uOZ0+0fkuYlo7/pyY/o4RXSHO9DZ3c5fUEqKZlNbpBc4BRdaqicRx40TzlIQhaOdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779455666; c=relaxed/simple;
	bh=19BUhZeBRFbqH1dOz6+dvcgORyB5in17U9Z8PrbfosM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M660S7Jp8cwTqXTLbGnjUJItb7om33y0ObnTJpbaHxpPMOsgcnWunTieZsUaCkuTdk8dQWXdjYxoYH4Jt7WmyAl2ZF+s60W6F79Ve6Qpo804i9HEyMrW2+tr5IGSPQx72O2es+CXYMbJA0BU8xr6DVhUtUBtLjlaHz73XouwJpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fN+iQIrc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fN+iQIrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6431C1F000E9;
	Fri, 22 May 2026 13:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779455665;
	bh=oTOZhRnZg/S8lp7cqzj//8FbXWhycToktj6BH9J8l9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fN+iQIrcbf1QvP7xP6/TKEbXwGxDwiy+556Er/P+LlnfJGjeNHc3vXA6B/rawgPDR
	 YLhmm7wLihuTqWaqJ/PZdB/wvpQhnxqy9vt4bOTq04ikKOc5CxPkP7CBC2o3HR2Ltm
	 rGepHh3A2EIyoZUCKoYHVZhSZS98Zq176Py6klbx8zV6APKeado2qBV4IhoQG8rWQM
	 /hZEi6LxeVa7ZsvQN9lAEVk9Pdw94/tU8bCGz8GW3wMhV2fHcwoukmrkKI9bVXmRGG
	 mnr8Gb6m6w7P+/fyv0sxeymrcrtoIYkH1Y56ojdq+Aus6sshLB+RY38362K07dwaJc
	 Rqc+q9nZjnmdQ==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	shuo chen <1289151713@qq.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-kernel-mentees@lists.linux.dev,
	shuah@kernel.org,
	patch-reply@agatha.dev,
	Agatha Isabelle Moreira <code@agatha.dev>
Cc: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 0/2] fs: refactor code to use clear_and_wake_up_bit()
Date: Fri, 22 May 2026 15:14:18 +0200
Message-ID: <20260522-besingen-runden-matrosen-17fb41f27f81@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ag4PEP52c8rxrYPc@guidai>
References: <ag4PEP52c8rxrYPc@guidai>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1406; i=brauner@kernel.org; h=from:subject:message-id; bh=19BUhZeBRFbqH1dOz6+dvcgORyB5in17U9Z8PrbfosM=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQJhK2OELu01HrXo5PHO7i6pGLcmXM/bYtyZsxzXOf49 wCLf19rRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwET6VBkZeif2aloe9d99mW+i gazBlIg719Mszrgp6v20F3D8L7nXhpFh4S+Ho+fOn42fpa/NYHu6tnYR27zmlh9uPVd040M27ZB lAgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Wed, 20 May 2026 16:45:35 -0300, Agatha Isabelle Moreira wrote:
> Refactor code to use `clear_and_wake_up_bit()` instead of manual calls
> to:
>        	clear_bit_unlock();
> 	smp_mb__after_atomic();
> 	wake_up_bit();
> 
> The helper function `clear_and_wake_up_bit()` was introduced in
> 'commit 8236b0ae31c83 ("bdi: wake up concurrent wb_shutdown()
> callers.")' as a generic way of doing the same sequence of operations,
> but several pieces of code still remain.
> 
> [...]

Applied to the vfs-7.2.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.2.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.2.misc

[1/2] fs: buffer: use clear_and_wake_up_bit() in unlock_buffer()
      https://git.kernel.org/vfs/vfs/c/89aafbd6d52b
[2/2] fs: jbd2: use clear_and_wake_up_bit() in journal_end_buffer_io_sync()
      https://git.kernel.org/vfs/vfs/c/d7a7e95e5f50
