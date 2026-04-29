Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62483148D2;
	Wed, 29 Apr 2026 14:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777472481; cv=none; b=IOXMi02q+WyJF5feClv3X830zgIU/QGBAzBlARKhrHb3PIMg4wOqphWoTVRZNwq12OHRT2JMu0Pv2aSv1hAENiDEayVRPHTsw7VgswkQ3dCIv+KxrKwZAah5gNtnoby+8TxGmExk3AuKUAlEuebnkTTPFarOFlvTokimrRkzgX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777472481; c=relaxed/simple;
	bh=U314RsHz0eK6Sj3sUzHusD/sSH04E+OsdWBA4IIRFuc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rp5zkI3ztOb9zJ+6qlmZOB69UVYecpQgraxBadSmp4EKVg62AR8elFzmqXCyYAY4nNUWStB2/QoGWhT5i+cce0bhTQPe66bWvdbP/54slbjUNs85El20J6h0B9kmtAAwmtL6yeapp5BlK5UL+/wIm8TvwMKHb0fref6YOeuDD+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FStHGUcr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FStHGUcr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74014C19425;
	Wed, 29 Apr 2026 14:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777472481;
	bh=U314RsHz0eK6Sj3sUzHusD/sSH04E+OsdWBA4IIRFuc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FStHGUcrheG/ZdNphpFI3T/Va6BL0CftYe5x7IAPhdwX3OvSeGyzV9w2Oj6P+Tlon
	 ql4PHVArN92eLB/7BqfZD5pLjEQTShDzDjh6Xc9VLhH8T3wnLUZuImZRTDAc44TkB2
	 x3nX1BFpIl0cjqRlvq9pixkEj8PqOiQHWq6+PMY/DyWkywXARZkF2hpkGuiVfnkO1b
	 jThFpPKJipPbet+Afsy7wTxWNBKm4eCCb13/6du83dBnBG7/jTg5hwOXS/IeI3hGJA
	 JvzJkFQ8hmTJcvljySX2NDL3yVhX5JlfHfMQl9LnOZM68081kipac3iNxcWHHOtxzS
	 7oJcZgAYyBOwA==
Date: Wed, 29 Apr 2026 07:21:21 -0700
Subject: [PATCHSET v8 5/6] fuse2fs: handle timestamps and ACLs correctly when
 iomap is enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747215344.4110156.17216553139316774040.stgit@frogsfrogsfrogs>
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

When iomap is enabled for a fuse file, we try to keep as much of the
file IO path in the kernel as we possibly can.  That means no calling
out to the fuse server in the IO path when we can avoid it.  However,
the existing FUSE architecture defers all file attributes to the fuse
server -- [cm]time updates, ACL metadata management, set[ug]id removal,
and permissions checking thereof, etc.

We'd really rather do all these attribute updates in the kernel, and
only push them to the fuse server when it's actually necessary (e.g.
fsync).  Furthermore, the POSIX ACL code has the weird behavior that if
the access ACL can be represented entirely by i_mode bits, it will
change the mode and delete the ACL, which fuse servers generally don't
seem to implement.

IOWs, we want consistent and correct (as defined by fstests) behavior
of file attributes in iomap mode.  Let's make the kernel manage all that
and push the results to userspace as needed.  This improves performance
even further, since it's sort of like writeback_cache mode but more
aggressive.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

e2fsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/e2fsprogs.git/log/?h=fuse2fs-iomap-attrs
---
Commits in this patchset:
 * fuse2fs: add strictatime/lazytime mount options
 * fuse2fs: skip permission checking on utimens when iomap is enabled
 * fuse2fs: let the kernel tell us about acl/mode updates
 * fuse2fs: better debugging for file mode updates
 * fuse2fs: debug timestamp updates
 * fuse2fs: use coarse timestamps for iomap mode
 * fuse2fs: add tracing for retrieving timestamps
 * fuse2fs: enable syncfs
 * fuse2fs: set sync, immutable, and append at file load time
 * fuse4fs: increase attribute timeout in iomap mode
---
 fuse4fs/fuse4fs.1.in |    6 +
 fuse4fs/fuse4fs.c    |  226 ++++++++++++++++++++++++++++++----------
 misc/fuse2fs.1.in    |    6 +
 misc/fuse2fs.c       |  282 +++++++++++++++++++++++++++++++++++++-------------
 4 files changed, 389 insertions(+), 131 deletions(-)

