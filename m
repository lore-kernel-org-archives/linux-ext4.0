Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823BD374721;
	Mon, 27 Jul 2026 15:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785167558; cv=none; b=WypnDFp52ssaCViMK1Q1edPkV88doDNqsVsGvf+qW52YuD8sQclVCcTT1WPvg9H8ssYkg5B2uCHnkFgzJXk5nEiN7s1uF4OSRl0gNv5yjgBR+A1vQowAQgWfa6dWhX1NRxu+mtEYbaiGyuVHYrMzV6HcUgEoA2gvbCTDDKiTOgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785167558; c=relaxed/simple;
	bh=YrK348zcvhxP6xWev2I4G64QFyFRv3xOkuEDBbklTIE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ns6G4VY+i4v9jhR8NwWLYTKjIVU9MFatZ6JSMIFdJUV3RWmZNPzUlOjSerodN0BhZ2tUPo8QH3UnnlnGvRsiYWRMOIIYE4NWxZqtfwrBN6E8F5M8oHvtY+Lm9lWWICbTnLCIjIiAuiNRT0TEqQNsD8zFZp9sN/fggPaM1cXkEvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RlzSUtjn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RlzSUtjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E339A1F00AC4;
	Mon, 27 Jul 2026 15:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785167557;
	bh=bzdTRmSAqyB7WTxM5zg+XJa+NCeY8Pu4qyXJvySLEVA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=RlzSUtjnBfusLroHgHFq2zuO6F4NJYQlRJNFPMyOhi2AjJmyAhWjYtd6YqKvubhxQ
	 zW5A3Uc8srKibOqowGF8JhW/DgdbG6hhhRaCqNH8IOkcvoByiBbP6pLV34xyN16oay
	 6Kluh2mapq/exa51PcwujgMDbBdbCkQvkvyHm8JBq8KqZsdajmIVVebVsnZeRlx8vn
	 s9XgLfMrwLazhjA3j47mQR87iApudWw4POx7wrY3QIwxOqXl5e8At/9NwBCiUu10gk
	 4FiD2Ibj+d8lgpknNUk9bwy6thN8hsKWW+mC1t+KnxuLBEqGjZSBKkkaHg4dCQEURD
	 fUWxlzdhnubiA==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Cc: aivazian.tigran@gmail.com, Ted Tso <tytso@mit.edu>, 
 linux-ext4@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
In-Reply-To: <20260727101509.21667-1-jack@suse.cz>
References: <20260727101509.21667-1-jack@suse.cz>
Subject: Re: [PATCH v5 0/20] fs: Fix missed inode write during fsync
Message-Id: <20260727-wallung-umzingeln-fuhren-749ee08538cf@brauner>
Date: Mon, 27 Jul 2026 17:51:56 +0200
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-09492
X-Developer-Signature: v=1; a=openpgp-sha256; l=3497; i=brauner@kernel.org;
 h=from:subject:message-id; bh=YrK348zcvhxP6xWev2I4G64QFyFRv3xOkuEDBbklTIE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSl1x2OmyHEsuao+DSBPbJNjbEhU50sl3pKzym/f+r1b
 pbTnuLbO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACaiZ8/I8GVimKhxfJl/n8Sj
 Wd6sRq3KF170vTi+QWjy/vTfJx5Hz2P4Z+h0jmfvX+7drJdPezmLnlx2jjmrZ2v43MLy3Y7G5Xm
 xrAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Mon, 27 Jul 2026 12:49:18 +0200, Jan Kara wrote:
> fs: Fix missed inode write during fsync
> 
> Hello,
> 
> here is v5 of the patch series which fixes the possibly missing inode write
> during fsync(2) for filesystems using generic metadata bh tracking. This
> revision contains mostly small fixes and improvements since v3, neither
> Sashiko nor Christian found fundamental issues with this approach.
> 
> [...]

I've put three patches on top of vfs-7.3.sync that fix Sashiko reported
bugs. @Jan, please take a look. If that looks fine to you I can fold
them down.

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

[01/20] affs: Drop support for metadata bh tracking
        https://git.kernel.org/vfs/vfs/c/b637f52f2f26
[02/20] fs: Fix possible UAF in mark_buffer_write_io_error()
        https://git.kernel.org/vfs/vfs/c/b0bca4e95b03
[03/20] fs: Fix missed inode writeback when racing with __writeback_single_inode
        https://git.kernel.org/vfs/vfs/c/5a499dad2c79
[04/20] ext4: Allocate mapping_metadata_bhs struct on demand
        https://git.kernel.org/vfs/vfs/c/daca0f43a934
[05/20] fs: Provide way for filesystem to wait for metadata writeback
        https://git.kernel.org/vfs/vfs/c/c474bc56b6d1
[06/20] ext2: Fix lost inode updates for IS_SYNC inodes
        https://git.kernel.org/vfs/vfs/c/356984d1a5c3
[07/20] ext2: Drop __ext2_write_inode()
        https://git.kernel.org/vfs/vfs/c/4efd6a43a92f
[08/20] ext2: Avoid unnecessary inode buffer writeback for sync(2)
        https://git.kernel.org/vfs/vfs/c/74d4faaa76b8
[09/20] ext2: Fix data integrity writeout issues
        https://git.kernel.org/vfs/vfs/c/917e583992e5
[10/20] udf: Fix data integrity writeout issues
        https://git.kernel.org/vfs/vfs/c/1ec98214ccf0
[11/20] udf: Use sync_inode_metadata() to writeout IS_SYNC inode
        https://git.kernel.org/vfs/vfs/c/061d83911da5
[12/20] udf: Drop udf_sync_inode()
        https://git.kernel.org/vfs/vfs/c/c87c0098cf61
[13/20] udf: Use sync_inode_metadata() in udf_evict_inode()
        https://git.kernel.org/vfs/vfs/c/e0e30479c756
[14/20] udf: Fold udf_update_inode() into udf_write_inode()
        https://git.kernel.org/vfs/vfs/c/5b2e45c33565
[15/20] bfs: Fix data integrity writeout issues
        https://git.kernel.org/vfs/vfs/c/0cee81a3fd9f
[16/20] minix: Fix data integrity writeout issues
        https://git.kernel.org/vfs/vfs/c/84af7c3b3462
[17/20] ext4: Fix data integrity writeout issues in nojournal mode
        https://git.kernel.org/vfs/vfs/c/c26339e1df33
[18/20] fat: Fix missed inode writeback during fsync(2)
        https://git.kernel.org/vfs/vfs/c/525da4f40a7c
[19/20] fat: Replace fat_sync_inode() with sync_inode_metadata()
        https://git.kernel.org/vfs/vfs/c/e668e0668181
[20/20] vfs: Remove mmb_fsync()
        https://git.kernel.org/vfs/vfs/c/dc78399717c4

