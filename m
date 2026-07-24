Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374173CAE76;
	Fri, 24 Jul 2026 08:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784880673; cv=none; b=HyuVk/jYXsZ2Fch1JQwWPIGZ8WB6VbfmdqRhht+0GMkw3I54vVlGcwz3NeoiucwRwEf/KN7aoouqEK+eFQJxoLAfgZnCDFL4mKn4nGkKFovursuYmhZmbImftrVx2Ip3PmBxtlw4ORDZU4HvxeDAOd8DycM6RX54G8SaXo0NNg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784880673; c=relaxed/simple;
	bh=RXoqh36aMPafKiZ1Xa3UtXkBtOeJhROwfmygWceuzjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jxIq8oPZAZpkEZerSHXCSzoqqdLOTcT3ZMe8ao7b9p2gvUxkrXICLVX2mm/FtS1S5GLSkMA/Tykh7I9uvjwJXemma0gWzPmWKASXwENcmMtN/hySCoOPfwoOHlCUY+IWFfVfQr7RW65fZRIkoYu1zKr9KIBSEQ4fz+0xv1spNo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F9v+m20X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F9v+m20X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336091F000E9;
	Fri, 24 Jul 2026 08:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784880667;
	bh=4G/Yo11qiLWYhyKRTRJwXnlSSJFkSlZfo8Yxr8PMjPE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F9v+m20XCj+nAI0ryiHPhyJlN0tNyf/ud7PWdjKh8iU1BUy36bz1daDo0I1RxpZXJ
	 AlE7CXK22KvyOT2v+A3FMLP5EE9x3VOiKRnZLMnvbqzW6qjQ8CkJyIfo2MxgW63+kD
	 3z4rCv+AoHTDkpH/C6EPfO8/wV8xuVIazkSd+UpyKSOlxD3XdGR7T2A6WNyHFP1LGL
	 WM/LHNR1q2kfoCNFfsIhlP9o1yCjiasCkarXqay/W+seYxNY/enFTCjU/lI0I/54QN
	 qz5P5gVVkbuzffvDiQCKg77HX/LC3QU1VUVkFcFx6WQAHAboE7+r0FzucNoQAhehbV
	 Q44Tw6HFWO+hg==
Date: Fri, 24 Jul 2026 10:11:01 +0200
From: Christian Brauner <brauner@kernel.org>
To: Luyao Bai <bailuyao1997@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: do not WARN when starting a journal on a frozen
 filesystem
Message-ID: <20260724-gaben-sachverhalt-medizin-312848359765@brauner>
References: <20260723205036.661832-1-bailuyao1997@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260723205036.661832-1-bailuyao1997@gmail.com>

On Thu, Jul 23, 2026 at 08:50:36PM +0000, Luyao Bai wrote:
> A WARNING is triggered in ext4_journal_check_start() when a background
> writeback thread attempts to start a journal transaction while the
> filesystem is in the SB_FREEZE_COMPLETE state:
> 
>   WARNING: CPU: 1 PID: 2903 at fs/ext4/ext4_jbd2.c:76
>            ext4_journal_check_start+0x1f8/0x250
>   Call Trace:
>    __ext4_journal_start_sb+0x181/0x600 fs/ext4/ext4_jbd2.c:105
>    __ext4_journal_start fs/ext4/ext4_jbd2.h:326 [inline]
>    ext4_do_writepages+0x112c/0x3d20 fs/ext4/inode.c:2707
>    ext4_writepages+0x213/0x3c0 fs/ext4/inode.c:2813
>    do_writepages+0x35f/0x870 mm/page-writeback.c:2683
>    __writeback_single_inode+0x14f/0x10d0 fs/fs-writeback.c:1658
>    writeback_sb_inodes+0x80c/0x1370 fs/fs-writeback.c:1954
>    wb_writeback+0x41b/0xbd0 fs/fs-writeback.c:2134
>    wb_workfn+0x410/0x1090 fs/fs-writeback.c:2321
> 
> The background writeback flusher does not take freeze protection, so it
> can legitimately reach ext4_do_writepages() and try to start a journal
> handle while the filesystem is frozen. This happens, for example, when
> ext4_writepages() failed earlier (e.g. -ENOSPC or -EDQUOT) during the
> sync_filesystem() phase of the freeze: sync_filesystem() can still
> return 0, the freeze completes, but dirty pages are left behind. A later
> writeback pass then tries to write them out on the now-frozen
> filesystem.
> 
> The same state is reachable through the EXT4_IOC_SHUTDOWN path: if
> fs_bdev_freeze() succeeds in freezing the superblock but the subsequent
> sync_blockdev() fails, the filesystem is left in SB_FREEZE_COMPLETE and
> dirty pages remain, so writeback eventually retries and trips the WARN.
> 
> Because this state can be reached without any kernel bug, WARN_ON() is
> the wrong tool here: WARN_ON() must only fire on conditions that should
> never happen. Replace it with an ext4_msg() error message and return
> -EROFS, rejecting the transaction cleanly. All callers of
> __ext4_journal_start_sb() already handle an error return (it is the same
> path used for the existing is_journal_aborted() -EROFS case), so the
> dirty pages are simply kept and written back once the filesystem is
> thawed.
> 
> This patch is intentionally limited to the ext4 journal-start check,
> which is the direct cause of the reported warning. Any improvements to
> the generic VFS freeze/thaw error handling in fs/super.c are a separate
> concern and are deliberately left out of this fix.
> 
> Reported-by: syzbot+b75d75f957975f3d40e3@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b75d75f957975f3d40e3
> Fixes: 49ef8832fb1a ("bdev: implement freeze and thaw holder operations")
> Signed-off-by: Luyao Bai <bailuyao1997@gmail.com>
> ---
> Tested with the syzbot reproducer under QEMU: the WARNING at
> fs/ext4/ext4_jbd2.c fires on a clean mainline build and no longer fires
> with this patch applied.
> 
>  fs/ext4/ext4_jbd2.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
> index 9a8c225f2..1756039b1 100644
> --- a/fs/ext4/ext4_jbd2.c
> +++ b/fs/ext4/ext4_jbd2.c
> @@ -75,7 +75,12 @@ static int ext4_journal_check_start(struct super_block *sb)
>  	if (WARN_ON_ONCE(sb_rdonly(sb)))
>  		return -EROFS;
> 
> -	WARN_ON(sb->s_writers.frozen == SB_FREEZE_COMPLETE);
> +	if (unlikely(sb->s_writers.frozen == SB_FREEZE_COMPLETE)) {
> +		ext4_msg(sb, KERN_ERR,
> +			 "Attempt to start a journal transaction on a frozen filesystem");
> +		return -EROFS;
> +	}

I can't say whether this is the right fix but it feels hacky and racy
unless this code holds s_umount - which it may well do.
