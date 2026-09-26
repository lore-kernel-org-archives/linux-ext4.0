Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4B32E2663
	for <linux-ext4@vger.kernel.org>; Sat, 26 Sep 2026 15:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790438240; cv=none; b=EdIIPmD0P3uxGTGnBC0OhE64ICtBE3wZ6ABwNrrs618VG9NUjj5l09TfS5Wt+1FvCLIa3BxnZ4cvE2reoNvF4AFtggtLhp4JmshkZyNvDPFjBgwzQXDNHSc4qgivFDvt106VgeVmaoHyQoGkjEOLsxYKhcsirh9DeDIpmBYlRL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790438240; c=relaxed/simple;
	bh=2AjfjZH1w+HWcQJWQpbX3DTRZbyNj0PM3epFqCHsfck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CFPs9MzGzouJwlOUe2YzN5ZK1REwdnq98J+tLgrRbif8kWn4ESREMjS2ApgsVw70tBMf1bEUnYXnWX0B9B9PKSf0Oee7VX4kbyjalaBfXUiGa7qmQ4B8BlM2Kdb2fEBqLADZpoVlz+ZBt/6HZ4vZFOZnQ3lquBHsKjqEPV3NxFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q1gkFnjk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q1gkFnjk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004B41F000FF;
	Sat, 26 Sep 2026 15:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790438239;
	bh=V49SISosnBx/tC1P1BEEomuPQO1RxydhnRYlY8+7udE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q1gkFnjkPHD2OWLHHQF5zNH/8KqXfQhb+xjqz5nUNQilZiSSE4MrCUTgRvcNKJWD4
	 9L6UFj9mA0XlNliCbdGXLUiXq/RmhKrARSHL5cDrvqmFhgfcyJTJu3JXxd+9m8gB4F
	 kFzZPUNqW8gdYnHSIPnxW/52P5OyIRuISDWqjmBbtJLwbROaIKoK0j1Aj1Sx3QIV2H
	 hlvNZOz8QbI3A9WuyAVKUlAon8dR1wsjwDOBZKomJDLozH/77sZDG2+7r7NR6WBq3g
	 CgGJ+ha11J65+ax2Zf8XWxlsAFmo7eb4ZKUaLjnAOy7nra6jHWfTdiD/ekdbGBR0sT
	 iObE9zuw29r2g==
Date: Sat, 26 Sep 2026 17:57:15 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	dlemoal@kernel.org
Subject: Re: [PATCH] MAINTAINERS: name the ext4 dev branch
Message-ID: <arfrW8NmQ4tsCF2I@ryzen>
References: <20260923101749.3505886-1-matthias.goergens@gmail.com>
 <arSMwd1bGO1vrif-@mit.edu>
 <20260924033200.3615554-1-matthias.goergens@gmail.com>
 <20260924040030.GB5048@sol>
 <arZx1GSVS61EFaiQ@ryzen>
 <20260926061101.3812389-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926061101.3812389-1-matthias.goergens@gmail.com>

On Sat, Sep 26, 2026 at 02:11:01PM +0800, Matthias Goergens wrote:
> Hi Niklas,
> 
> On Fri, Sep 25, 2026 at 03:06:28PM +0200, Niklas Cassel wrote:
> > For the record, there is no need to use a gitolite specific command,
> > regular:
> >
> > $ git remote set-head libata for-next
> >
> > works.
> 
> Did you mean this as a way to change the server's default branch, or
> for each consumer to run in its own clone?
> 
> For the server, I tried it with a scratch bare repository that has
> master and for-next, and it looks to me as if set-head only moves
> refs/remotes/origin/HEAD in the clone where it runs.  The server's HEAD
> stays on master, and so do ls-remote and a fresh clone.  With git
> 2.55.0, this script:
> 
>   git init --quiet --bare --initial-branch=master server.git
>   git clone --quiet server.git work
>   git -C work commit --quiet --allow-empty --message one
>   git -C work push --quiet origin HEAD:master HEAD:for-next
>   git --git-dir=server.git symbolic-ref HEAD
>   git -C work remote set-head origin for-next
>   git -C work symbolic-ref refs/remotes/origin/HEAD
>   git --git-dir=server.git symbolic-ref HEAD
>   git ls-remote --symref server.git HEAD
>   git clone --quiet server.git consumer
>   git -C consumer symbolic-ref refs/remotes/origin/HEAD
> 
> prints
> 
>   refs/heads/master
>   refs/remotes/origin/for-next
>   refs/heads/master
>   ref: refs/heads/master  HEAD
>   (object id)  HEAD
>   refs/remotes/origin/master
> 
> For each consumer's own clone, it works, as long as the consumer knows
> which branch to pick; for tools that read MAINTAINERS, that is what
> naming the branch in the T: entry would tell them.  Have I missed
> something?

You are right.

Even though:
https://git-scm.com/docs/git-remote#Documentation/git-remote.txt-set-head

says:
Set or delete the default branch (i.e. the target of the symbolic-ref
refs/remotes/<name>/HEAD) for the named remote.

And:

$ git symbolic-ref refs/remotes/libata/HEAD

gets updated, it still only seems to get applied in my local repo,
even after a git push.

Seems like gitolite commands are actually needed then.
I'm sorry for misleading you guys.


Kind regards,
Niklas
