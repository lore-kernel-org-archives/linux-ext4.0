Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0171335E943;
	Fri,  3 Jul 2026 10:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783073171; cv=none; b=gWmXLwrDYPitKRJjXTIw1aYZd1s6khNFcJgqKSKAJN0UoY31BZMSjwvFtsDEHDnNTHe25HgMX5k+DruJ2n2NShkXPrJF+d8m9RJNy7ICyokFvpBhYp/hsoZr3E+h/ptHXh5OS0HmoQAJ3auCm65cl8bw9HZOeYsqBODVqFnUiOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783073171; c=relaxed/simple;
	bh=C+K38JQV3U8nAS53ul7tBSwx8zmluxYsIe+skzZ3osc=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=tY+pFVVvSfDXia+nd4dgHRfs93CnG2cMTx4NAP4UDto8KKniTGmUUf+HFqwcYxbcmEOmW+wMkACqO60DQ2uyNOT9aNJrST/n1FGwQfzEGAuMkMDWXQzUNv1+G2XWJjOzkY6CdByo4QbIGP+y7jCKkjg3ky0ytBGD9Oeu/3SPbok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FTbFrCL7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FTbFrCL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC9E1F000E9;
	Fri,  3 Jul 2026 10:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783073169;
	bh=p0OQHhrZLqdCqfvfGJ6wVmjbF8luVBLgWSOjJtyEDmk=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=FTbFrCL7WsvLqIH9xuxCphTFAhPwKNcNHNiLsLXbebv1V7ODIGajLCiQBGVKIBHbx
	 NI2R0jNuEhx+js/Qhp5dPmvZocwNBaGdF3AiyKGMA7g1HXN7BZVKRMihBNslJOmx7E
	 eEuns42onTx8hH2pa9M7k1giQvhr+3gDoRFQJeYyhZQAup2uh5C2Uy3BcGoZuOAy4C
	 myfrUZtCd1hguDQo2dFF4CiWSgXgQj6uSUJiwSfmxnptre9rJskY93ibBXEKxlo3dq
	 9FDeD7vxozr2e25KzNH54lo4pBT9jZshRHZ4efAWwacFjI8LNJyiOmn7vrnVmeYago
	 qNbILk5/hGuZw==
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 07/19] fs: Provide way for filesystem to wait for
 metadata writeback
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
 aivazian.tigran@gmail.com, Ted Tso <tytso@mit.edu>, 
 linux-ext4@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
In-Reply-To: <20260702182057.2832980-26-jack@suse.cz>
References: <20260702175436.12226-1-jack@suse.cz>
 <20260702182057.2832980-26-jack@suse.cz>
Date: Fri, 03 Jul 2026 12:06:05 +0200
Message-Id: <20260703-erdumlaufbahn-sippenhaft-windungen-c95dd273fffc@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=3385; i=brauner@kernel.org;
 h=from:subject:message-id; bh=C+K38JQV3U8nAS53ul7tBSwx8zmluxYsIe+skzZ3osc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS5d/Z3sb1c8WChcECJEoc+1/cb/zzElrZlH9jq3pRot
 mjL1bUbOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZSV8nwv0LurQaHwC7pqV06
 C7iOX/2yI2X5Zu5Dl0VOFr45+VLxvRcjw2Rf1fkiKS1qbWbbH709sHbXbB2et4LnOy5c99mXtGY
 CAx8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

> Currently, inode and in general metadata writeback is handled in a lazy
> manner. When inode is dirty, __writeback_single_inode() calls
> .write_inode method which for lots of filesystems just copies inode
> metadata into the underlying block buffer. Writeback of other metadata
> associated with the inode (as well as buffers underlying inodes) is
> usually handled completely separately and implicitely during writeback
> of block device inode. This is good for efficiency of WB_SYNC_NONE
> writeback or sync(2). However it becomes problematic for situations
> where we want to make sure inode and its metadata is really persistent
> on disk. fsync(2) is the most pronounced example of this and thus we
> have grown a special file operation and various helper functions to
> assist with this task. However fsync(2) is not the only case, For
> example directories with DIRSYNC flag need similar functionality and
> current use of sync_inode_metadata() for this task in filesystems
> generally misses writeout of necessary metadata.
> 
> Furthermore even fsync(2) handling as implemented by simple_fsync() or
> similar helpers is racy and can fail to properly persist the inode. The
> problem is that WB_SYNC_NONE writeback can copy inode metadata into
> underlying buffer and clean inode dirty bits. Following fsync(2) will
> see inode is clean and will fail to make sure underlying buffer is
> written out.
> 
> When multiple fsync(2) calls race, there's also another type of race
> involving mmb_fsync(). There the problem is buffers already submitted to
> the disk are no longer tracked in the mmb list and so racing mmb_sync()
> can return before all of the IO completes.
> 
> Provide a new inode state bit I_METADATA_WRITEBACK tracking whether
> writeback of inode related metadata may be needed for successful data
> integrity sync and if this bit is set __writeback_single_inode() for
> data integrity writeback will call new superblock operation
> .sync_inode_metadata whose task is to make sure all metadata associated
> with the inode (including the inode itself) is properly persisted. This
> will allow filesystems to address the data integrity issues described
> above and at the same time somewhat simplify our fsync implementations.
> Issues with racing fsync(2) calls will be addressed by synchronization on
> I_SYNC inode state which is set while calling .sync_inode_metadata, issues
> with missed inode buffer writeback are fixed by filesystems looking up
> corresponding buffer head and writing it out if needed.

Very clear description, thanks!

> 
> Signed-off-by: Jan Kara <jack@suse.cz>
>
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index fdb8766d275a..9d96357731a3 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1851,6 +1851,22 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>  		if (ret == 0)
>  			ret = err;
>  	}
> +
> +	/*
> +	 * Do we need to wait for inode metadata IO possibly submitted
> +	 * by previous WB_SYNC_NONE writeback?
> +	 */
> +	if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync &&

Does this patch need to come earlier in the series before the ext2 and
ext4 changes? I'm asking because ext2 - I think - changes behavior in a
similar manner in an earlier patch.

-- 
Christian Brauner <brauner@kernel.org>
