Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBEE3E120C;
	Mon, 31 Aug 2026 08:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788164576; cv=none; b=LSGavYLK2Z0MmoUqNQ/qxVbntJVrObcaF6xvctL+KbnMWCjRXJqkf7KnSNPAC2iWSMCeOeFvkhO01DedRSzoIaRAF5LypM2HU+6goLHzOCvZEyWq6gLLPPMWn+LaoHRxA2R6YU51XkJGo+D3iDWctXo4Suxhe3hX7RlnOAp4wRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788164576; c=relaxed/simple;
	bh=wnOb710GDzXvB78jABPqDFMRlLh8C3NnDR9JYFb6Gvo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=n1bjO5deoVe1SfpRYRo6jbMcGaqQkYjmOuKa20eWV4oNP+7CHTy0sTewAS4bNFAJGMAbFoioI/MKND3N74wLy8SkKep3kbKJg+wWCjSuhlq9GYnpmPu2rvPAYUeuviD7Gn/HhEQuR6NlBiP9f1GntFp3c7dFCVAqyBsveARP70Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kDuLGYij; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kDuLGYij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734C01F000E9;
	Mon, 31 Aug 2026 08:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788164574;
	bh=lmGgmlxDbGLbhuLXzpdjg1bjgsmwZj4DcRmR+5yii2Q=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=kDuLGYijTZY4L/lJ/eKPEPZ79jZ7Xzmksn4BPj95fcn4/heyZX5sB2+cMA38oBDso
	 6JiwxxbpqX3bnt+aDaYhdskRY0eL3Elp2ksONcUTyVNV1yDn40MOWzowF4/4iQkzpX
	 FUSGofyobRO9WCZ7d7+xpLahTeq+0fu4OdkWhOsrufaSThIk5kbwJwdQ9YJ5Q1xDNA
	 kR4jaXnYHcWCmBy+b7/VhvLvCK6Me5gvxHj/PJ1rGpI+P8epCwSyDdHQCO5RMKeTBV
	 W52ImWhGYlJDU0FChhsUy6to3arDCcjLQYzjxxGO6D4zx/2cdFUAG4ATb69hZtdThq
	 hgWE7GVrWnesQ==
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, 
 Chao Shi <coshi036@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
 Zhang Yi <yi.zhang@huaweicloud.com>, Bob Copeland <me@bobcopeland.com>, 
 Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
 Yuezhang Mo <yuezhang.mo@sony.com>, 
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Andreas Gruenbacher <agruenba@redhat.com>, linux-ext4@vger.kernel.org, 
 ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
 linux-kernel@vger.kernel.org
In-Reply-To: <cover.1785951556.git.coshi036@gmail.com>
References: <cover.1785951556.git.coshi036@gmail.com>
Subject: Re: [PATCH v2 00/21] buffer: stop clearing BH_Uptodate when a
 write fails
Message-Id: <20260831-lauwarm-gedruckt-salzkartoffel-67b444e6977e@brauner>
Date: Mon, 31 Aug 2026 10:20:39 +0200
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3922; i=brauner@kernel.org;
 h=from:subject:message-id; bh=wnOb710GDzXvB78jABPqDFMRlLh8C3NnDR9JYFb6Gvo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNtbzJ87J41a5rDh88SrxLj019wMf7ZdaNyWoRf36K7
 5nGYlVR2VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjAR0V8M/7PsK/maZ50rW/Aw
 se7TNPM5UrPXVnCy82ZtVAs3EXx0LZKRYYvaOo7NJmWzWpcEBVrvZ7rOsdFfq4dnq69PApPHBjt
 fbgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Thu, 06 Aug 2026 12:58:23 -0400, Chao Shi wrote:
> buffer: stop clearing BH_Uptodate when a write fails
> 
> When a metadata write fails, the buffer_head completion handlers clear
> BH_Uptodate.  The buffer still holds exactly the data the filesystem asked
> to be written - it is the disk that is stale, not the buffer - and saying
> otherwise has consequences:
> 
> [...]

Tbh, the commit message reads a bit LLMy. It would be nice if people
could take the time - provided they have sufficient language skills - to
massage the artificial tone out of them.

---

Applied to the vfs-7.4.bh branch of the vfs/vfs.git tree.
Patches in the vfs-7.4.bh branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.4.bh

[01/21] buffer_head: Remove b_page
        https://git.kernel.org/vfs/vfs/c/719ecb98ffe7
[02/21] buffer: allow a buffer_head to point at memory outside the page cache
        https://git.kernel.org/vfs/vfs/c/8deae2284976
[03/21] jbd2: point the shadow buffer at the frozen data directly
        https://git.kernel.org/vfs/vfs/c/5febcba29792
[04/21] buffer: read the folio's mapping directly in buffer_set_crypto_ctx()
        https://git.kernel.org/vfs/vfs/c/14cbade7d773
[05/21] buffer: clear BH_Write_EIO when a buffer is forgotten
        https://git.kernel.org/vfs/vfs/c/d59fe9111f4f
[06/21] buffer: discard BH_Write_EIO along with the rest of the buffer state
        https://git.kernel.org/vfs/vfs/c/bbcd6f7456b2
[07/21] buffer: detect metadata write errors with buffer_write_io_error()
        https://git.kernel.org/vfs/vfs/c/7032ded0a1fa
[08/21] adfs: check for a directory write error with buffer_write_io_error()
        https://git.kernel.org/vfs/vfs/c/613e12102111
[09/21] ext2: check for an xattr block write error with buffer_write_io_error()
        https://git.kernel.org/vfs/vfs/c/583913a40f2e
[10/21] omfs: check for an inode write error with buffer_write_io_error()
        https://git.kernel.org/vfs/vfs/c/a269f6fade99
[11/21] exfat: check for a directory write error with buffer_write_io_error()
        https://git.kernel.org/vfs/vfs/c/4a53ece574b5
[12/21] fat: check for a metadata write error with buffer_write_io_error()
        https://git.kernel.org/vfs/vfs/c/a93ff8e2e398
[13/21] ext4: check for a metadata write error with buffer_write_io_error()
        https://git.kernel.org/vfs/vfs/c/0f44b420e6c7
[14/21] ocfs2: check for a metadata write error with buffer_write_io_error()
        https://git.kernel.org/vfs/vfs/c/3f90f64f8187
[15/21] ocfs2: check for a stale write error before reusing a metadata buffer
        https://git.kernel.org/vfs/vfs/c/a87462d7b604
[16/21] gfs2: check for a metadata write error with buffer_write_io_error()
        https://git.kernel.org/vfs/vfs/c/47552ff5ebf9
[17/21] jbd2: report journal write errors with BH_Write_EIO
        https://git.kernel.org/vfs/vfs/c/0c6c46fbf4d8
[18/21] jbd2: say what jbd2_freeze_jh_data()'s assertion is actually checking
        https://git.kernel.org/vfs/vfs/c/50cf8c8e532c
[19/21] ext4, jbd2: report fast commit write errors with BH_Write_EIO
        https://git.kernel.org/vfs/vfs/c/a49d8a9d5d49
[20/21] buffer: stop touching BH_Uptodate on write completion
        https://git.kernel.org/vfs/vfs/c/1f2304e87b83
[21/21] buffer: clear BH_Write_EIO when a write succeeds, not when one starts
        https://git.kernel.org/vfs/vfs/c/e038f1016c6f

