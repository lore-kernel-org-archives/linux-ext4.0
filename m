From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: fix bitmap position validation
Date: Wed, 2 May 2018 13:44:32 +0200
Message-ID: <20180502114432.lsq3j4tegp2d5t2c@rh_laptop>
References: <1524567414-19046-1-git-send-email-lczerner@redhat.com>
 <20180424154329.GB30619@thunk.org>
 <20180425073929.egtd5ucpmdn2jbs2@rh_laptop>
 <20180430082453.c7b6lihc6v46jyfe@rh_laptop>
 <20180430164507.GC20585@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, stable@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180430164507.GC20585@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 30, 2018 at 12:45:07PM -0400, Theodore Y. Ts'o wrote:
> On Mon, Apr 30, 2018 at 10:24:53AM +0200, Lukas Czerner wrote:
> > 
> > Well, so much for a discussion :-/ The patch is upstream now...
> 
> Sorry, it's been crazy busy and there were other fixes I really needed
> to get upstream.

Yeah, I understand.

> 
> If it really is superfluous, the compiler will optimize it away.  I
> have been bitten more times than I can count with fuzz testers and C's
> _fine_ signed vs. unsigned integer semantics.  So I prefer to be
> careful here.
> 
> If we can really be sure it's safe, we can always remove the extra
> comparison in a separate patch, since that's unrelated to the real bug
> we're trying to fix.

That's fine, I understand that it was better to fix it sooner rather
than later and deal with the optimization at a different time. Short
reply stating that would have helped though, there is my sign-off below
the patch as well after all.

-Lukas

> 
> 						- Ted
