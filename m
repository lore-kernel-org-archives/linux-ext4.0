Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C57B3BE64B;
	Sat, 10 Oct 2026 12:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791636907; cv=none; b=C21mwFKdbDtcVP/Y8Hu5Ql1rerXKA3O6mhoqwzSKqXeOY1G3KsyTAQOglUUDPoM29Ua+q6v2Y/5dhxy0qxGowe+PJTtFCTfohzpD4tZIFY7PeDeSvfN3bjWnUMtBUTunxIZI2v8MVSPHodqij00CyyG3q8TZorn4T1mFwWQqvfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791636907; c=relaxed/simple;
	bh=Q5+aMWgY55Clan6SoRPJddFiutENi32J1rMwr/lqb50=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F27Ae6XGMU5ipxwrnlrTD6JBFouG9AozqkMHCAq64mlkoCZzGYEKX7Cs4sX81pDLOIuMlcGcLzki1B/AiKY4zJ7K4Kkfp/ZHaBWNWVgtPB473qoaGlNBgRPXffsG6uB8uQrLj32vdo84l9JH9vnnCay4K6VqceWUTGttsmH8Gwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SGxxiP1l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SGxxiP1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA8D1F000FF;
	Sat, 10 Oct 2026 12:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791636905;
	bh=Q5+aMWgY55Clan6SoRPJddFiutENi32J1rMwr/lqb50=;
	h=Date:From:To:Subject:References:In-Reply-To;
	b=SGxxiP1lxnZTv/3wZ1ooOOGNeYcAC7UMCYwG1+D3dSewJ/Irh8AWZ+yn7aaldV8XU
	 BrFsH+5N6uNLrcaUKNhqVlBLbONUWoiF0MWj8wYZKgUkSFwMSbTOWC1UKsMZmp1sKU
	 IbS/T9a6Oc+4yJKNnoek7f2pz06+vxutT3zQGCg+KNX/EUiR4LA79C/xZNXNZfAkla
	 NqX+mPjMEIyyp8jWnap+S8he54jlefn/ZiYZvum004Qx1mDFqJB5xeljDIn2HxLivQ
	 R3h33DVG8yZON6SuE0cTwjPquMiBTZOGF2Ey6ZAPVv+KqZrVrX8qupdi1vB175Pspv
	 6lfKNYPMs8ivg==
Date: Sat, 10 Oct 2026 14:55:01 +0200
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, 
	linux-afs@lists.infradead.org, v9fs@lists.linux.dev, linux-trace-kernel@vger.kernel.org, 
	ntfs3@lists.linux.dev, tytso@mit.edu, stable@vger.kernel.org
Subject: Re: [PATCH 8/8] ntfs3: free replaced mount options after a grace
 period
Message-ID: <20261010-kampagne-jubilieren-piloten-0c00c1f26aba@brauner>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
 <20261009-work-fixes-rcu-v1-8-7446d2d335e6@kernel.org>
 <sashiko-outbox-166120@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-166120@kernel.org>

On Fri, Oct 09, 2026 at 10:02:47PM +0000, sashiko-bot@kernel.org wrote:
> Does this change leave other readers of sbi->options vulnerable to a
> use-after-free?
>
> While this patch protects ntfs_nls_to_utf16(), other VFS operations appear
> to access sbi->options without holding rcu_read_lock() or s_umount. If a
> thread is preempted immediately after loading the sbi->options pointer, and
> a concurrent mount -o remount calls ntfs_fs_reconfigure() which replaces
> sbi->options and schedules its destruction via call_rcu(), the grace period
> can complete before the first thread resumes.

This is pre-existing. Before this patch ntfs_fs_reconfigure() swapped
the options and put_fs_context() freed the old ones right when the
remount returned. So all of these readers could already see freed
options and now they at least have to stay preempted for a whole grace
period.

Making every sbi->options reader safe against a concurrent remount is a
separate ntfs3 problem. This patch only cares about ntfs_nls_to_utf16()
because that's what rcu pathwalk calls.

> This problem wasn't introduced by this patch, but doesn't replacing
> sbi->options with new_opts cause a silent loss of mount options during
> remount?

That's how ntfs3 remount has worked since it switched to the new mount
api. Unrelated to this series.
