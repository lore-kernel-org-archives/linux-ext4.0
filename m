Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694C93F4831;
	Fri, 24 Jul 2026 09:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784886801; cv=none; b=XBhgZFzsvr2Vlqu89rJnM0S/zHObdk29KITDwLIMCG5DmoCO9AgmzyQzCgM2Qd3AzgM87h3m6JhwyAs45JT2Ep1EfxHipVjXRUGjorH4xnRPGii9oOipJInqWxjphED7/N28mHat0ZrxLmnsArdYXyJxvmY/Qnzirqddd1Dxur8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784886801; c=relaxed/simple;
	bh=qbheOk0qDo6B9pUyZ7jklGnVheiw2kM1wuk1U1kQJMA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=QSnE0Zy8wXr+HXFOUEf4YfPl0AnFQIiPNMYIIjlWHA5KuyCBXOdOjfh+6DpsYkgJcm7q9vi48pSjGYZWrS/cNkcuXopjUKkSz+5GXHvIm9V756ua17ZTfht4eXcYuSewxTIyxllSh3/HN8Um/S/1mnTBxE1czkKqNwkotTbqT9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fe7yxT6K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fe7yxT6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDD41F000E9;
	Fri, 24 Jul 2026 09:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784886800;
	bh=1t+ynSssKoLM/byqDJsmQHgdHfk3hykhxZKWvgZlTqA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Fe7yxT6K6sYKWCUzY0JJpLaFQ28BuT0b6kxfd9oMU+L7NHkFguHiCAWl/IiGy0e72
	 v5rRW7+E47M614irn4TP3+k8o/2AvBTWfsTTSfXfTZU0v1Yc8VJgzCURj819sYaDJs
	 JXcjUqKIXbF+h4EOr2WkoUvAHiNUgBRBQvNY3RJpNnTXeRfibxzDzS67fM05LNE+uH
	 jPpCLIJaA+A/+kM+4L3Is2AGMtNnAoKbcfoB/YETIF6j+S+JnBH/Ocd5TZZK0SeFMa
	 ws7+3lAaqImWOWx2LV53x4aHiN9+oiQ3VAx+/Zk/PFIUhqXIkanPJPC9dZ+5w3QbUT
	 Hy2YZzgFtLSpA==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Cc: aivazian.tigran@gmail.com, Ted Tso <tytso@mit.edu>, 
 linux-ext4@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
In-Reply-To: <20260716145359.28639-1-jack@suse.cz>
References: <20260716145359.28639-1-jack@suse.cz>
Subject: Re: [PATCH v4 0/21] fs: Fix missed inode write during fsync
Message-Id: <20260724-einmieten-beatmen-glossar-63c4b3962e07@brauner>
Date: Fri, 24 Jul 2026 11:52:31 +0200
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-401aa
X-Developer-Signature: v=1; a=openpgp-sha256; l=3612; i=brauner@kernel.org;
 h=from:subject:message-id; bh=qbheOk0qDo6B9pUyZ7jklGnVheiw2kM1wuk1U1kQJMA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQlm/E1d4ur1kReXVJxnfnnu92zCvNuzqjNWPLl9YJT8
 //fcv72taOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiN/QZ/soF/mVLntS3cO5z
 XpWZ1hrXO19sYrJPOBSa83qz+/QDX/Yx/M9ItGqSq44Oac7fFOiUa8d4faqI+Cw92Zr1J45dT35
 0mR8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Thu, 16 Jul 2026 16:55:22 +0200, Jan Kara wrote:
> fs: Fix missed inode write during fsync
> 
> Hello,
> 
> here is v4 of the patch series which fixes the possibly missing inode write
> during fsync(2) for filesystems using generic metadata bh tracking. This
> revision contains mostly small fixes and improvements since v3, neither
> Sashiko nor Christian found fundamental issues with this approach.
> 
> [...]

I think there's some outstanding sashiko reviews for this one. Feel free
to just send follow-up fixes if the changes are small enough! Thanks,
Jan!

---

Applied to the vfs-7.3.sync branch of the vfs/vfs.git tree.
Patches in the vfs-7.3.sync branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.3.sync

[01/21] affs: Drop support for metadata bh tracking
        https://git.kernel.org/vfs/vfs/c/af4c5cc0e9bb
[02/21] fs: Fix possible UAF in mark_buffer_write_io_error()
        https://git.kernel.org/vfs/vfs/c/2a04965facca
[03/21] fs: Fix missed inode writeback when racing with __writeback_single_inode
        https://git.kernel.org/vfs/vfs/c/cd7af599673d
[04/21] ext4: Allocate mapping_metadata_bhs struct on demand
        https://git.kernel.org/vfs/vfs/c/daa81c4646af
[05/21] fs: Provide way for filesystem to wait for metadata writeback
        https://git.kernel.org/vfs/vfs/c/2efb5551bfd6
[06/21] ext2: Fix lost inode updates for IS_SYNC inodes
        https://git.kernel.org/vfs/vfs/c/8818c2c722bc
[07/21] ext2: Drop __ext2_write_inode()
        https://git.kernel.org/vfs/vfs/c/9df72fe0ce0d
[08/21] ext2: Avoid unnecessary inode buffer writeback for sync(2)
        https://git.kernel.org/vfs/vfs/c/596fcded9d2c
[09/21] ext2: Fix data integrity writeout issues
        https://git.kernel.org/vfs/vfs/c/354fbcf66801
[10/21] udf: Fix data integrity writeout issues
        https://git.kernel.org/vfs/vfs/c/44472b524843
[11/21] udf: Use sync_inode_metadata() to writeout IS_SYNC inode
        https://git.kernel.org/vfs/vfs/c/9f270048c816
[12/21] udf: Drop udf_sync_inode()
        https://git.kernel.org/vfs/vfs/c/5058a428058b
[13/21] udf: Use sync_inode_metadata() in udf_evict_inode()
        https://git.kernel.org/vfs/vfs/c/7523fe432c0e
[14/21] udf: Fold udf_update_inode() into udf_write_inode()
        https://git.kernel.org/vfs/vfs/c/6f9f30e52869
[15/21] bfs: Fix data integrity writeout issues
        https://git.kernel.org/vfs/vfs/c/763d78b5dbba
[16/21] minix: Fix data integrity writeout issues
        https://git.kernel.org/vfs/vfs/c/66355af99066
[17/21] ext4: Fix data integrity writeout issues in nojournal mode
        https://git.kernel.org/vfs/vfs/c/15f87bd659d2
[18/21] fat: Fix missed inode writeback during fsync(2)
        https://git.kernel.org/vfs/vfs/c/a4d79cb28359
[19/21] fat: Remove some superfluous sync_dirty_buffer() calls
        https://git.kernel.org/vfs/vfs/c/8fea9a46ea6c
[20/21] fat: Replace fat_sync_inode() with sync_inode_metadata()
        https://git.kernel.org/vfs/vfs/c/02019179198b
[21/21] vfs: Remove mmb_fsync()
        https://git.kernel.org/vfs/vfs/c/7747b73ad29a

