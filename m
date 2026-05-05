Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6091448BD25
	for <linux-ext4@vger.kernel.org>; Tue,  5 May 2026 15:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777996702; cv=none; b=oQ2o8Lq514Rz1WC/Ais1g8YoHrfDShYvPmPvK4UGdaqyOo6vSJb6n4sNAKwiwPwPFmnZ3QAfYxGlQFcnd7LLhPnqyulxD/jVriBaG5Whg+SdqeNltP2PJd2DvbaQ90fbDEOeBeNxxKhh4MujdGdr6QAGpUCGnde262ShUn3j0ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777996702; c=relaxed/simple;
	bh=Nheo8h2niu2QxR8aCJB3JUUG+HMXCNetFiH7iJDnfsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rcv9KaU5qvInjWAJXHtkbfVp97btA1dJsgwl7C4Nt1dSKvP7ZHzCwqAINxE1ZJfw4yWANwXCm0M+nC0/5xsGe9JL102d4z/V6RAH9LO/E4cUzIFqxSgwpn1NPyDFVaCtWYm0I1rxCSoRsr8zFPKkCm3LYAoKaJBxl3sME3QKzSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EpgpRQqw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EpgpRQqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA607C2BCB4;
	Tue,  5 May 2026 15:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777996702;
	bh=Nheo8h2niu2QxR8aCJB3JUUG+HMXCNetFiH7iJDnfsg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EpgpRQqwpTZsWkv7kBFZh7LO4lAwDDnZvGdLySMwmz5/i906SfyxfSL6LpGjZHUSA
	 IhwLqnQ1PsT6SYpowAJ+vJtqwThbpOZ4CdPMlkLRv8Mnejdp7ZmGHDHTI5T+mWP0qs
	 7yTheR6gtaezfrIWS7qCjBP2hg5DSVa6BWusx6PlZozDR1YyDT91PnJKMELQBYP4SK
	 WqmxQAAGAp+Bf0nipTrdKnhMM0LjW5a+BflV75uDEctT7GPiLQFFwlOo+LSeBCOk8M
	 gQwIGKUzKLWUBL2jQU/g64UjuKxe0EBtP5J39JTIsGwUR7JuU5nn5rDBtyMBaBSZqI
	 KBJmCYeGaAqfQ==
Date: Tue, 5 May 2026 08:58:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 0/7] fix up issues from djwong/fuse4fs-fork
Message-ID: <20260505155821.GI1101423@frogsfrogsfrogs>
References: <20260504233301.2345652-1-tytso@mit.edu>
 <20260505000831.GA1101423@frogsfrogsfrogs>
 <20260505072144.GC16497@macsyma-wired.lan>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505072144.GC16497@macsyma-wired.lan>

On Tue, May 05, 2026 at 09:21:44AM +0200, Theodore Tso wrote:
> On Mon, May 04, 2026 at 05:08:31PM -0700, Darrick J. Wong wrote:
> > Hm, curious.  It's regrettable that I no longer have a Mac, and
> > therefore can't really do much investigating.  If you give
> > -o default_permissions,allow_other , does that fix the problem?
> > If that fixes it, then fuse2fs has a bug somewhere in its own
> > permissions checking.
> 
> Nice catch!  Yes, using default_permissions does fix things.  So now I
> need to figure out what changed between v1.47.4 and next, and what
> default_permissions does.  I notice that in kernel mode we enable
> default_permissions?

Yes.  Though the addition of allow_other and default_permissions was
exactly the same in 1.47.4.

> Can you give me a suggestion at what I might try to look at next?

Hrm.  A bisect would be the best (but least conference-friendly) option
to narrow things down.

On Linux, adding "default_permissions" means that the kernel uses the
same permission checking code that it uses for in-kernel filesystems.
Without it, the fuse server is responsible for doing all permission
checking.

And now that I've tried it, there are bugs in fuse2fs' permission
checking (aka !default_permissions):

# fuse2fs /dev/sda /mnt -d -f -o iomap=0,allow_other
# mkdir /mnt/lost+found/frogs
# su - djwong
$ ls -d /mnt/ /mnt/lost+found/ /mnt/lost+found/frogs/
drwxr-xr-x 3 root root  4096 May  5 08:32 /mnt//
drwx------ 3 root root 16384 May  5 08:49 /mnt/lost+found//
drwxr-xr-x 2 root root  4096 May  5 08:49 /mnt/lost+found/frogs//

So I guess I'm still confused.  I've wondered if fuse2fs should always
inject default_permissions?

--D
