Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60D339EB5B;
	Mon, 12 Oct 2026 10:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801732; cv=none; b=eh3UYGRq+fa3n/jHxY8Qx2L+Epo8nXpkG9y4MKOKfN4tAzL4OLCAN0+zBUFEFRTE4UT5g0BD5SrqI52zX98g9CXm9/bUuV+du3bI2IUHcu8t4FI2L1yxKu+a4FbcJh6dCCawYIaI6Ly8xp6IA1ZlBNtAWm/m6qKFxGV7zLfNcas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801732; c=relaxed/simple;
	bh=o27eM5988rmeHc6Wl/ktBGCOoh6BTZxx0Tx40pDWtnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cdzvCnV6sB+hwbvvTz87ZVJTk4OKmgPiGRewhlKDxvASPHgkNE090BRQ/J2LcRSXpMIqH8JPk2SZDvgDloaJWwiKIYSseGgXpcWNNTHaB7VBndVa/Nc8Emc3FjTxdZ1TFBhvZNw2MnOyoh7tjbkQddybDe97ds0Gg6OSM77NVZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RuUr3tDd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RuUr3tDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5EC41F0089B;
	Mon, 12 Oct 2026 10:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801731;
	bh=k7JPldLcVG1lkMzLDS2nPfYwi1SwyLu22FtP8Z5jWgM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RuUr3tDdDXg+pCOzmOMcVxwWhySLjEB4oaYo/KMOudemt5kLpDA2P3NUDxNPuWnC2
	 42jZE0FKQ8a/2trIGhWlW4JMNePTL/sgzdJN/7xbqdB/NSCGzoIUcnZz1B8rOzwyiU
	 qclXTTiFvWu1Nbt3iBwR4wNG+IqUgFaWd9M0eWiaWlJMcnbzlnchKzeR08tmR74rb3
	 nelzbn25y7NuhVKVHG9arq/5EC+YvApGxVJhYfuO8VB1sgYhfMr43poOyVagkrmShC
	 dOZKhXoBQv/X0/XMgg9H6OJxHGqdfyuC7xMHOLq3NbYMGJ0K0Sje/EYcX2cJxWM3rV
	 LHuQxW9rZhArA==
Date: Mon, 12 Oct 2026 12:42:06 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, 
	v9fs@lists.linux.dev, linux-trace-kernel@vger.kernel.org, ntfs3@lists.linux.dev, 
	stable@vger.kernel.org
Subject: Re: [PATCH 0/8] fs: fix a range of UAFs during rcu pathwalk caused
 by non-rcu frees
Message-ID: <20261012-gaukeln-zeltlager-etikettieren-73ae50ccac01@brauner>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
 <r72foycb4ol4hywl5m2sj6h6yxee3nladaw7g2zdxhejmhrkgc@v24cfppcak2h>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <r72foycb4ol4hywl5m2sj6h6yxee3nladaw7g2zdxhejmhrkgc@v24cfppcak2h>

On Mon, Oct 12, 2026 at 12:36:15PM +0200, Jan Kara wrote:
> On Fri 09-10-26 23:51:50, Christian Brauner wrote:
> > While working on eliding the grace period in namespace_unlock() I went
> > through what filesystems free when they're shut down and what a pathwalk
> > in rcu mode can still read at that point. Since 66a97c2ec953's rcu
> > pathwalk fixes that's the filesystem's job. Whatever ->permission(),
> > ->d_revalidate(), ->get_link(), ->d_hash() and ->d_compare() look at in
> > rcu mode has to be freed after a grace period. A few filesystems don't
> > do that.
> > 
> > Most of it is hidden by umount(2). namespace_unlock() waits for a grace
> > period before it drops the mounts, so a walker that was inside the
> > filesystem is gone by the time the filesystem is shut down.
> > 
> > But the last reference to a mount doesn't have to go away in umount(2).
> > A chdir() out of a lazily unmounted directory or the close() of the last
> > file on it drops it without a grace period. A walker can then still be
> > in the filesystem while ->put_super() and ->kill_sb() free what it
> > reads.
> 
> Good catches! But I find it very counter-intuitive that pathname lookups
> can still be running against a filesystem while its ->put_super is called.
> People will keep forgetting about that and as a result these UAF bugs will
> be introduced again. Isn't it feasible we'd guarantee to the filesystem
> ->put_super() gets called only after all lookups are done (i.e., after RCU
> grace period expires)?
> 
> I understand this is a hairy bussiness because this has userspace visible
> implications (like when filesystem's sysfs files disappear, when the bdev
> really gets unused, etc.) but keeping all filesystems safe to run RCU
> lookup after ->put_super() will be IMHO a headache.

I don't think delaying put_super() or freeing the superblock helps.
That's not where the issue is. The issue is with sb->s_fs_info being
available after a grace period and that can go away in different
locations ->put_super() or ->kill_sb(). Bringing put_super() into the
argument was maybe not my best idea. We also need to backport this
stuff.
