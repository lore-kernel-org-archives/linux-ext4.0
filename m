Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935C94ADD83
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 14:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788444311; cv=none; b=fDTim/xjSr2hdZl83dIxbINtPjE044kDppRY8+aLNIFaEZxeBI1GROei3qIuteB+KPX0kFq2FGA8osCpBKW2rm7XWv/0dNPONtgq4gIHP60X6dZH1WK9AdnfwBhRKlcMOf521InM4MEfaCVq8/6EDWGv9joB8fWV4J6XfWOkgFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788444311; c=relaxed/simple;
	bh=hsJtwhwSdGSHKFm6o8Dl2gskzQfM3rupgGuZYeSZO2E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WG6qHOGjBXL+tZMp3NBYu/E71mnJ3eFD3M3Gcbk3zUijf7QtbPxGZIJF0oNaDUcRf5gV/MuUy9qmTsZtSUa0HxHycrsl2TgSMQ6Jf6VzKl+5CZYaJgUW9P1soXwcTkhlnPIu7BZbBuIn1KsJFJbaBk+88ovh1anCqEthRntm6/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jvDKPbRO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jvDKPbRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A92D1F00A3A;
	Thu,  3 Sep 2026 14:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788444297;
	bh=mZeu6Z1vkbLX0/7T5aUkfLWRs9DfbTq9zv134BBeaC4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jvDKPbROrswwHIIdMNxg0eN1uAG1ZE7AeL2qIHoRlt1VvTAucDXwJVNzv2xjDLi2X
	 JlINZl8piu6QAsRnbTJ3FrvYx7/B47duwWfXAlY+xFq7fG4/lJN+8Po20AFzTt6O4N
	 MMUzF3lvtxizfsWsXMlLGj5+8d3NKt7tc7LVjS7lO2jh6bZnZExlYofIeUiOO20NSl
	 r13fEJtlV6eDK8OiScR/0xp0sUo7qz/yliU+JLalDxNZwijXpcpcOu9FDB8GPGbQfB
	 kNtllZB7n9oRRdTQjCS0LiuVBd1raB6LHDkzH2/kRlUPqXrpmDsVMiXYd3CCJxgSUF
	 YZqt/wJ4BQs5Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 30/31] ext4: partially enable iomap for the buffered
 I/O path of regular files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260903124017.2325538-2-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903124017.2325538-2-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 14:04:57 +0000
Message-Id: <20260903140457.8A92D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Concurrent buffered reads during dynamic transition of the journal=
 data flag cause type confusion on folio->private, leading to memory corrup=
tion.
--

commit a5650f621dac34bfe427e11f706ab1c16d533afc
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: partially enable iomap for the buffered I/O path of regular files

This commit introduces ext4_enable_buffered_iomap() to determine whether a
regular file inode should use the iomap buffered I/O path. It also modifies
ext4_change_inode_journal_flag() to dynamically toggle the buffered I/O
path and address_space operations on an active inode when the per-inode
data journal flag is changed.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
[ ... ]
> @@ -7598,9 +7695,10 @@ int ext4_change_inode_journal_flag(struct inode *i=
node, int val)
>  	 * the inode's in-core data-journaling state flag now.
>  	 */
> =20
> -	if (val)
> +	if (val) {
>  		ext4_set_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
> -	else {
> +		ext4_disable_buffered_iomap(inode);
> +	} else {
>  		err =3D jbd2_journal_flush(journal, 0);
>  		if (err < 0) {
>  			jbd2_journal_unlock_updates(journal);
> @@ -7609,6 +7707,7 @@ int ext4_change_inode_journal_flag(struct inode *in=
ode, int val)
>  			return err;
>  		}
>  		ext4_clear_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
> +		ext4_enable_buffered_iomap(inode);
>  	}
>  	ext4_set_aops(inode);

[Severity: High]
Can this lead to memory corruption due to a type confusion on folio->privat=
e?

When toggling the journal data flag on an active file,
ext4_change_inode_journal_flag() truncates the page cache, but then blocks
on jbd2_journal_lock_updates(journal).

During this blocking window, a concurrent thread could perform a buffered
read on the same file. Because ext4_file_read_iter() calls
generic_file_read_iter(), which handles buffered reads without acquiring
the inode lock or invalidate_lock, the concurrent read can instantiate new
folios into the page cache using the old address space operations (for
example, attaching a buffer_head structure to folio->private).

When jbd2_journal_lock_updates() returns, this thread will proceed to
switch the operations via ext4_set_aops(inode).

Will subsequent operations on those concurrently populated folios invoke the
new iomap operations, misinterpreting the buffer_head pointer in
folio->private as an iomap_folio_state pointer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D30
