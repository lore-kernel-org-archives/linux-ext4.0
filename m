Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D04F38C403;
	Mon, 23 Mar 2026 10:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774261806; cv=none; b=RmGpf73fydz0Nr406Q7pUfBxROeY+WvGUuRXHwXz4jT69X0M51qeFQZG92lg8GhTomrr+h9bMbzGHhJOZJk/K29RvK+RZEqiBPzRkaWXugO8VpKh8FnsbQmCoBCPddyCHgRgZW4WoSrE0UMRuIFqvsCQqjMnDX3VYiSKVVgU3lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774261806; c=relaxed/simple;
	bh=CYVaduY/P84e+sSr1daS5pYdiCCw81Cl8IHz5x0n3/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DzW6607l8WOgs0gMP4GOjT5SkHO3m1ZegJ/kHnM6wIV2i6ZhRkr8UhbshxdQNdblw5Go2dr3tT6EnzS/agWesOImtlumEnObLBFr1cGXQBCWLbApEw/PBaFO4kvH8ERALKLRttGEZrisIibs71StGkgNpklIrAWdU8luAdwYSPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lPJK7q/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lPJK7q/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD25C4CEF7;
	Mon, 23 Mar 2026 10:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774261805;
	bh=CYVaduY/P84e+sSr1daS5pYdiCCw81Cl8IHz5x0n3/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPJK7q/Rchuq2wnqhTigey0tTOv0A4muIVq83a5xBa9JmKpmJKAll/yCjBDEDF1RT
	 CYzcr3xqrZvPYVy2qZ7CSi3s2RbkROJMBC1nzsvzYco/8OhMvl3C86Z5Ye70oQ2IMM
	 /2Qt/Lki1JRW8EM+RB02cf0HnCkvgUlqxr3gWOU8V9XSfrt+YyybRAHrNOeLx60eE2
	 lxhhyuBv9FqFlM8kfyTfm7khdp6JuWhJm+zFZ4hTKyh/9yT1VT2XeWzL43RZlEcXvl
	 IMRPa94L9FGpQoCov3RoWm/OPjgiIOhSQjVeBeOJ/F6LDkUKBlVGZm++RROb7HPWwt
	 GcfDz9/8xI3tQ==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-block@vger.kernel.org,
	Al Viro <viro@ZenIV.linux.org.uk>,
	linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-aio@kvack.org,
	Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH v2 0/41] fs: Move metadata bh tracking from address_space
Date: Mon, 23 Mar 2026 11:20:03 +0100
Message-ID: <20260323-dickicht-turnt-8353124f0f5d@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=6550; i=brauner@kernel.org; h=from:subject:message-id; bh=CYVaduY/P84e+sSr1daS5pYdiCCw81Cl8IHz5x0n3/E=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQeFFNpbFa80yHleljrV5G1AIOk9C3lHXvKwu761UxkO xv/X8Wlo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCJTBBn++9yYU9ES6lJk67FC 60Pwu/o+wU9WjdMjOycfe6B7ZamFMsM/hTXX3N66SqQ6/bHeudtnUtAbk96s7oNpCz7dvFEWWhP HBQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Fri, 20 Mar 2026 14:40:55 +0100, Jan Kara wrote:
> here is a next revision of the patchset cleaning up buffer head metadata
> tracking and use of address_space's private_list and private_lock.  The patches
> have survived some testing with fstests and ltp however I didn't test AFFS and
> KVM guest_memfd changes so a help with testing those would be very welcome.
> Thanks.
> 
> Changes since v1:
> * Fixed hugetlbfs handling of root directory
> * Reworked mapping_metadata_bhs handling functions to get the tracking
>   structure as an argument so we now don't need iops method to fetch the struct
>   from the inode
> * Reordered patches into more sensible order
> * Added patch to merge two mostly duplicate generic fsync implementations
> * Added Reviewed-by tags
> * Couple more minor changes that were requested during review
> 
> [...]

x86_64 (gcc, debian, ovl-fstests)  pass
x86_64 (gcc, debian, selftests)    pass
x86_64 (gcc, debian, xfstests)     pass
x86_64 (gcc, fedora, ovl-fstests)  pass
x86_64 (gcc, fedora, selftests)    pass
x86_64 (gcc, fedora, xfstests)     pass

---

Applied to the vfs-7.1.bh.metadata branch of the vfs/vfs.git tree.
Patches in the vfs-7.1.bh.metadata branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.1.bh.metadata

[01/41] ext4: Use inode_has_buffers()
        https://git.kernel.org/vfs/vfs/c/2caab145b54f
[02/41] gfs2: Don't zero i_private_data
        https://git.kernel.org/vfs/vfs/c/8395055f2455
[03/41] ntfs3: Drop pointless sync_mapping_buffers() and invalidate_inode_buffers() calls
        https://git.kernel.org/vfs/vfs/c/bed1ecade645
[04/41] ocfs2: Drop pointless sync_mapping_buffers() calls
        https://git.kernel.org/vfs/vfs/c/c40f470d21ae
[05/41] bdev: Drop pointless invalidate_inode_buffers() call
        https://git.kernel.org/vfs/vfs/c/4e001046c8a6
[06/41] ufs: Drop pointless invalidate_mapping_buffers() call
        https://git.kernel.org/vfs/vfs/c/26d88dcdb54b
[07/41] exfat: Drop pointless invalidate_inode_buffers() call
        https://git.kernel.org/vfs/vfs/c/8dbad3a0e39a
[08/41] udf: Switch to generic_buffers_fsync()
        https://git.kernel.org/vfs/vfs/c/0892d39092b3
[09/41] minix: Switch to generic_buffers_fsync()
        https://git.kernel.org/vfs/vfs/c/387a7a22307e
[10/41] bfs: Switch to generic_buffers_fsync()
        https://git.kernel.org/vfs/vfs/c/a59c3be58777
[11/41] fat: Switch to generic_buffers_fsync_noflush()
        https://git.kernel.org/vfs/vfs/c/e118e65dba18
[12/41] fs: Drop sync_mapping_buffers() from __generic_file_fsync()
        https://git.kernel.org/vfs/vfs/c/0bdc542b3faa
[13/41] fat: Sync and invalidate metadata buffers from fat_evict_inode()
        https://git.kernel.org/vfs/vfs/c/f2145333cd91
[14/41] udf: Sync and invalidate metadata buffers from udf_evict_inode()
        https://git.kernel.org/vfs/vfs/c/525acf32a4ad
[15/41] minix: Sync and invalidate metadata buffers from minix_evict_inode()
        https://git.kernel.org/vfs/vfs/c/60ef3750f238
[16/41] ext2: Sync and invalidate metadata buffers from ext2_evict_inode()
        https://git.kernel.org/vfs/vfs/c/52e995b1474d
[17/41] ext4: Sync and invalidate metadata buffers from ext4_evict_inode()
        https://git.kernel.org/vfs/vfs/c/36dc7f23446b
[18/41] bfs: Sync and invalidate metadata buffers from bfs_evict_inode()
        https://git.kernel.org/vfs/vfs/c/aa2caecd2b38
[19/41] affs: Sync and invalidate metadata buffers from affs_evict_inode()
        https://git.kernel.org/vfs/vfs/c/2779c362a490
[20/41] fs: Ignore inode metadata buffers in inode_lru_isolate()
        https://git.kernel.org/vfs/vfs/c/95c6bfdb5d3e
[21/41] fs: Stop using i_private_data for metadata bh tracking
        https://git.kernel.org/vfs/vfs/c/89f2eea7f6c3
[22/41] hugetlbfs: Stop using i_private_data
        https://git.kernel.org/vfs/vfs/c/8f3bf5b0ce4e
[23/41] aio: Stop using i_private_data and i_private_lock
        https://git.kernel.org/vfs/vfs/c/8514c0d15c45
[24/41] fs: Remove i_private_data
        https://git.kernel.org/vfs/vfs/c/aa7c3819d2db
[25/41] kvm: Use private inode list instead of i_private_list
        https://git.kernel.org/vfs/vfs/c/1e0cbe5bac95
[26/41] fs: Drop osync_buffers_list()
        https://git.kernel.org/vfs/vfs/c/f07ad1722cda
[27/41] fs: Fold fsync_buffers_list() into sync_mapping_buffers()
        https://git.kernel.org/vfs/vfs/c/e7cd907f2326
[28/41] fs: Move metadata bhs tracking to a separate struct
        https://git.kernel.org/vfs/vfs/c/a3b0a90f1e93
[29/41] fs: Make bhs point to mapping_metadata_bhs
        https://git.kernel.org/vfs/vfs/c/d8b6d9ff9552
[30/41] fs: Switch inode_has_buffers() to take mapping_metadata_bhs
        https://git.kernel.org/vfs/vfs/c/9e5f33d8201e
[31/41] fs: Provide functions for handling mapping_metadata_bhs directly
        https://git.kernel.org/vfs/vfs/c/a13a480c81b1
[32/41] ext2: Track metadata bhs in fs-private inode part
        https://git.kernel.org/vfs/vfs/c/107b7505d866
[33/41] affs: Track metadata bhs in fs-private inode part
        https://git.kernel.org/vfs/vfs/c/592eacdd5928
[34/41] bfs: Track metadata bhs in fs-private inode part
        https://git.kernel.org/vfs/vfs/c/c6661db8efc0
[35/41] fat: Track metadata bhs in fs-private inode part
        https://git.kernel.org/vfs/vfs/c/b5d84862f99d
[36/41] udf: Track metadata bhs in fs-private inode part
        https://git.kernel.org/vfs/vfs/c/7d37ac2bba4c
[37/41] minix: Track metadata bhs in fs-private inode part
        https://git.kernel.org/vfs/vfs/c/37da66baf00c
[38/41] ext4: Track metadata bhs in fs-private inode part
        https://git.kernel.org/vfs/vfs/c/ebcf10f6f905
[39/41] fs: Drop mapping_metadata_bhs from address space
        https://git.kernel.org/vfs/vfs/c/ecfcd39c0ab0
[40/41] fs: Drop i_private_list from address_space
        https://git.kernel.org/vfs/vfs/c/b39f532b7a2e
[41/41] fs: Unify generic_file_fsync() with mmb methods
        https://git.kernel.org/vfs/vfs/c/24b45fa837a4
