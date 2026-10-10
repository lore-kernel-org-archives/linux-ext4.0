Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E576345D5FC;
	Sat, 10 Oct 2026 12:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791636875; cv=none; b=oPGwWpLgynDJrLI02N3v17Jcors6zcy1WbY2Ee8vsDaNiIJMLY3p+qaHi/c5i3iDLUJrSUY7azVRu78ae+/SaguKOSVkPzNjE8WBEISnv1pPZwQzW7ocVGkAnMz3p4JwTuBDIoCN0hlExBFrsgnkeJwy2JB/AQo0g6ACv/duV9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791636875; c=relaxed/simple;
	bh=ZcrCwafbniEewCzWv1MZiFYJQ5X4fHmk7ltpbIe8dVg=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SfUIvd64DRqWjDZliuNyNgandJFnIc+L1S5Rx99qTyt/CLI7GczJFeO4/iwJFsZ4KMDBoP+A1XNEWX4s4OicjXX3hPkJtjg2IvOoXMCOELjkWP008BqHkKMGhdxLtxCOwy7ggJNgjPN+n9IH0jlI4E4KeQ6XOnlydraH8TDBPSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q/qQqSlf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q/qQqSlf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471BF1F000FF;
	Sat, 10 Oct 2026 12:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791636874;
	bh=ZcrCwafbniEewCzWv1MZiFYJQ5X4fHmk7ltpbIe8dVg=;
	h=Date:From:To:Subject:References:In-Reply-To;
	b=Q/qQqSlf62cH1TJxDffYqyRk2dfWWBuMJBUm95IE6dEYWjB0axS+ihRYUasmWweGl
	 kByE5DMqaoLj4kmSHAdISzmsb53vUnuwpnmxfuD41Z5+QL5JwmOKaVuSUWqk+iwZnQ
	 ya6PPttk0FvmkFsj/u3msXE0HMqDCdqJ6u1WrG0QACvNAgDiwCox9XMee34k6/5VxV
	 u8JbnFICrG9XPafeKuBva/4ZZV0RJC9tXtEnKFpT7G8B/p2xji89qFlJQdR2xhlVIc
	 9te2vVIj/v29TkuIlZPqBhaOKDE7j4qsdGKAKj9z+qkjwhX71k97zczQ91IDlIYiWS
	 rAEX2VNwQRMQA==
Date: Sat, 10 Oct 2026 14:54:29 +0200
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, 
	linux-afs@lists.infradead.org, v9fs@lists.linux.dev, linux-trace-kernel@vger.kernel.org, 
	ntfs3@lists.linux.dev, tytso@mit.edu, stable@vger.kernel.org
Subject: Re: [PATCH 2/8] afs: free the super info after a grace period
Message-ID: <20261010-veranda-allemal-frivol-5ee6b359d2c8@brauner>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
 <20261009-work-fixes-rcu-v1-2-7446d2d335e6@kernel.org>
 <sashiko-outbox-166125@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-166125@kernel.org>

On Fri, Oct 09, 2026 at 10:07:58PM +0000, sashiko-bot@kernel.org wrote:
> Does this regression introduce a TOCTOU race in afs_atcell_get_link() that
> can cause a NULL dereference?
>
> By leaving put_net() executing before the RCU grace period, afs_net_exit() can
> tear down the namespace while pathwalks are still active. If cleanup_net()
> calls afs_cell_purge(), it replaces net->ws_cell with NULL.

No. This patch doesn't touch put_net(). It's called in the same place
as before.

The only place that sets net->ws_cell to NULL is afs_cell_purge() from
afs_net_exit(). The superblock pins the network namespace via
as->net_ns and once the last reference is gone cleanup_net() does a
synchronize_rcu() before it calls any ->exit() method. So
afs_cell_purge() can't run while a pathwalk is still in
afs_atcell_get_link() in rcu mode.

The double load of net->ws_cell is a bit sloppy but it's harmless.

> Can net->ws_cell be cleared to NULL before the lock is acquired, causing a
> NULL dereference here as well?

No. Without rcu the caller holds references to the dentry and the
mount. So the superblock and with it the network namespace can't go
away underneath it.
