From: Petr Baudis <pasky@suse.cz>
Subject: Re: Oops, incorrect tag: v1.40.5 in e2fsprogs git repository
Date: Tue, 29 Jan 2008 01:43:31 +0100
Message-ID: <20080129004331.GB14100@machine.or.cz>
References: <20080128181923.GB24206@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from w241.dkm.cz ([62.24.88.241]:35647 "EHLO machine.or.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbYA2AwJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2008 19:52:09 -0500
Content-Disposition: inline
In-Reply-To: <20080128181923.GB24206@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Mon, Jan 28, 2008 at 01:19:23PM -0500, Theodore Tso wrote:
> I screwed up, and incorrectly tagged v1.40.5 in the e2fsprogs git
> repository.  I accidentally tagged the "next" branch instead of the
> "maint" branch, so the the wrong commit was tagged as v1.40.5.  Argh...
> 
> This has been fixed on git.kernel.org, but it's still busted on
> repo.or.cz.  
> 
> If you've pulled from the e2fsprogs git repository incorrectly, you'll
> need to run the command:
> 
>      git tag -d v1.40.5
> 
> ... and then re-pull from the git repository to get the correct tag.
> 
> Petr, if you could run the same command on the e2fsprogs repository on
> repo.or.cz, it would be much appreciated!!

  Done, though it should be doable from your side as well by something
like

	git push reporepo :refs/tags/v1.40.5

I believe.

-- 
				Petr "Pasky" Baudis
We don't know who it was that discovered water, but we're pretty sure
that it wasn't a fish.		-- Marshall McLuhan
