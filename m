From: Ingo Molnar <mingo@elte.hu>
Subject: Re: -tip: origin tree build failure (was: [GIT PULL] ext4 update for
 2.6.37)
Date: Thu, 28 Oct 2010 18:38:54 +0200
Message-ID: <20101028163854.GA15450@elte.hu>
References: <E1PBKT9-0004Uk-Sm@tytso-glaptop>
 <20101028075631.GA7690@elte.hu>
 <AANLkTi=8SbOZizWpxLg=Bgp7atdgr8MsR6tnRDYr1+eW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=8SbOZizWpxLg=Bgp7atdgr8MsR6tnRDYr1+eW@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Oct 28, 2010 at 12:56 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Today's -tip fails to build due to upstream commit 5dabfc7 ("ext4: rename 
> > {exit,init}_ext4_*() to ext4_{exit,init}_*()"), on all[yes/mod]config with 
> > CONFIG_EXT4_FS_XATTR disabled:
> 
> Btw, could you try to write these things so that the changelog doesn't have to be 
> totally rewritten? Now I always end up having to move things around and edit them 
> to be useful from a long-term perspective, which is kind of silly.

Heh, i was just lazy and used sfr's linux-next build bug reporting mails as a 
template ;-)

Point taken in any case, i'll read your edited changelog and will change the 
template accordingly.

Would this:

  Upstream commit 5dabfc7 ("ext4: rename {exit,init}_ext4_*() to 
  ext4_{exit,init}_*()"), breaks the build on all[yes/mod]config with
  CONFIG_EXT4_FS_XATTR disabled:

  ...

have been better?

Thanks,

	Ingo
