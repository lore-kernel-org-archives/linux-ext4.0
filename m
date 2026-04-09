Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879E730BF6D;
	Thu,  9 Apr 2026 13:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775741916; cv=none; b=t/Uf7WtUVzDrJl3ylr4EgAS/EAGVFFe5QPMI5rIYyi+ywSY7p50MZWqlqDsomPx2f99Q0S8J7kM12vr0dsF1vsC9dMMPg7wEM1F6TH1Kvmi64v1BHTFRsuCAtgE5HHM6xN2xHgVs5RfzL0qwwTd4JmHWoxR6UqR2yU/R7NpRsG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775741916; c=relaxed/simple;
	bh=ZZTegXgr9pUaseE17m2ATJSgkEL6TWH6qbyHnwiViJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dd32ptqYhkFoNT1PaRjYP/JUDhbr78/mUqDoEkluPSqHCDVp/6smZdzrRHN8GzXPSisgbAGlvFY0BRmaM4QfJwsnsalza9Oup2PdnssM+DXLni1mrJBHqG/D0fyMs5UCrEgrJkdsWhAvuc1HFGMZ7fxEtkzAkaUfk+5VhwJBupU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ubRxbUba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ubRxbUba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B74DC4CEF7;
	Thu,  9 Apr 2026 13:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775741916;
	bh=ZZTegXgr9pUaseE17m2ATJSgkEL6TWH6qbyHnwiViJg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ubRxbUbaV2ZuKcyHWFhmbZuLOrwRH02qOI4yuICGL8GEcVt9kNosuqWeoF0hOqEK0
	 LlcRO4PAuuWe6hS7Ir5Mv4JGnDEeYUYOKNfi8IZfeksJxEeNCCwFRAJy7vF40uXvA7
	 zNejjEi7ec6pN2yZaz8mRJVOMh6Il/WOZKKI9vLOD/YNi+n7VLaBfNPwz+PY16fC1q
	 cSZvtmXIXJfoPUbVpOUMgFe8IKzPk9gdhL3zJ1x25fKK5Lj/dTL16EUdeU3P+6TSYP
	 HezU9r7PKGwlW/hjCJe+FOHFK1uCsUGUP1haycbUSMmYB0latNB3nJffoo6+RzAsCR
	 wyJz4Q50xWXEw==
Date: Thu, 9 Apr 2026 15:38:31 +0200
From: Christian Brauner <brauner@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Sean Smith <defendthedisabled@gmail.com>, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	dsterba@suse.com, david@fromorbit.com, osandov@osandov.com, 
	hirofumi@mail.parknet.co.jp, linkinjeon@kernel.org
Subject: Re: [RFC PATCH v1 0/6] provenance_time (ptime): a new settable
 timestamp for cross-filesystem provenance
Message-ID: <20260409-hinblick-anregen-b50f248bd7e4@brauner>
References: <20260405225442.GA1763@macsyma-wired.lan>
 <20260407000558.417-1-DefendTheDisabled@gmail.com>
 <20260407233618.GB12536@macsyma-wired.lan>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260407233618.GB12536@macsyma-wired.lan>

On Tue, Apr 07, 2026 at 07:36:18PM -0400, Theodore Ts'o wrote:
> On Mon, Apr 06, 2026 at 07:05:55PM -0500, Sean Smith wrote:
> > The patches implement rename-over preservation in all 5
> > filesystem rename handlers. When rename(source, target)
> > replaces an existing file, and the source has ptime=0 (the
> > default for any newly-created temp file) while the target
> > has ptime != 0, the filesystem copies the target's ptime to
> > the source before destroying the target's inode. This runs
> > inside the rename transaction, atomic with the rename itself.
> 
> Yelch.   This is so *very* non-Unixy / non-POSIX / non-Linux.

I think you meant to type "N", "A", and "K".
