Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B956B256C6D;
	Fri, 19 Jun 2026 13:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781876085; cv=none; b=Br+E3WKiO7+56mW0VaN7FX0CJIUiknPkzBlE4Hmv8HtOrd1/vdTG+gIrrs0DCw4QIpJZYslrHOau17a+Sn829Tnk7E94FVCRkasJH99s6TZG3xZ4FRqhGqRowkTu4c3/b/PfFTRmgjOZTuu5wUhJOBIvEfT546Ym/VH/9DknlI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781876085; c=relaxed/simple;
	bh=wJSYTDKPdve4Hglr/PTBasRjzxbdQ3Wtx3k0E8HsWgQ=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=qH6k+88k0MeDltbSRUZTeTlOsKNYuWFC73DOae1BbRSOZhCVd99c8+kHW+yEcu1bt3suAe9Dat8/7/A/AXKhtupbMujOd+uhUTsQQW2cqPTSbGZFQgNhC/ddZ8hMfoOjJENkQV2U130gcl9YPAaIC3w345F1KmARulEawm/EzNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gP8uGFLd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gP8uGFLd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF9A1F000E9;
	Fri, 19 Jun 2026 13:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781876084;
	bh=gn17cQCePjBQfMUfpssQOXYu0z2N4p1QUEwYP/AkeOE=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=gP8uGFLdmhQRsFrwmrRvVGv/xTtkN6phv+9xfrbqMbvvmj9yo5lErBl6FcAz0hFOQ
	 9BWf1sBT5/gBEGNFsYncOqt/jLN9cuZ3HEPU8h6m7N4OmeOJd2KWdUDbuGpmQs+kIS
	 zXwQd102jX3vZ0RiKGixBxRe8bE1ZuzRbFnGWE6z44Pxu9/ZjzrB570X6dEs973POz
	 Afie79FuNgbtrk/9No/u0HNU2hhQyH+xOVNSylBQwotVeuBlGOiyrcsPex+MjdL1/T
	 9Sde4/BoWWTGwWjauFT4bYLfhR9Ll3S6J4dLg6qJcvE0asX04s3AL3jjt9Q/Yx4IKg
	 eAbIhL/E5GgwQ==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
 shuo chen <1289151713@qq.com>, Theodore Ts'o <tytso@mit.edu>, 
 linux-kernel-mentees@lists.linux.dev, shuah@kernel.org, 
 patch-reply@agatha.dev, Agatha Isabelle Moreira <code@agatha.dev>
In-Reply-To: <ag4PEP52c8rxrYPc@guidai>
References: <ag4PEP52c8rxrYPc@guidai>
Subject: Re: [PATCH 0/2] fs: refactor code to use clear_and_wake_up_bit()
Message-Id: <178187607630.350634.13398595827280324425.b4-ty@b4>
Date: Fri, 19 Jun 2026 15:34:36 +0200
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-aeb64
X-Developer-Signature: v=1; a=openpgp-sha256; l=1208; i=brauner@kernel.org;
 h=from:subject:message-id; bh=wJSYTDKPdve4Hglr/PTBasRjzxbdQ3Wtx3k0E8HsWgQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSZuhb+LWnfVJRhI2RgnpfNPVd4ys0pb0sCo3/L/7+vp
 iBd3ynYUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMJGFcxkZrlxSmJS6TdssoUu8
 Vbtf/92aS58nFHtcXckU5aiW4pV7i+EPf99uQf9Nm7z8JhfWGP2wPP7+2hPjHf/9/+9R235BvIS
 FFwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Wed, 20 May 2026 16:45:35 -0300, Agatha Isabelle Moreira wrote:
> fs: refactor code to use clear_and_wake_up_bit()
> 
> Refactor code to use `clear_and_wake_up_bit()` instead of manual calls
> to:
>        	clear_bit_unlock();
> 	smp_mb__after_atomic();
> 	wake_up_bit();
> 
> [...]

Applied to the vfs-7.3.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.3.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.3.misc

[1/2] fs: buffer: use clear_and_wake_up_bit() in unlock_buffer()
      https://git.kernel.org/vfs/vfs/c/1a6e4692deca
[2/2] fs: jbd2: use clear_and_wake_up_bit() in journal_end_buffer_io_sync()
      https://git.kernel.org/vfs/vfs/c/8efd38683c81

