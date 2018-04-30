From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix bitmap position validation
Date: Mon, 30 Apr 2018 12:45:07 -0400
Message-ID: <20180430164507.GC20585@thunk.org>
References: <1524567414-19046-1-git-send-email-lczerner@redhat.com>
 <20180424154329.GB30619@thunk.org>
 <20180425073929.egtd5ucpmdn2jbs2@rh_laptop>
 <20180430082453.c7b6lihc6v46jyfe@rh_laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, stable@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180430082453.c7b6lihc6v46jyfe@rh_laptop>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 30, 2018 at 10:24:53AM +0200, Lukas Czerner wrote:
> 
> Well, so much for a discussion :-/ The patch is upstream now...

Sorry, it's been crazy busy and there were other fixes I really needed
to get upstream.

If it really is superfluous, the compiler will optimize it away.  I
have been bitten more times than I can count with fuzz testers and C's
_fine_ signed vs. unsigned integer semantics.  So I prefer to be
careful here.

If we can really be sure it's safe, we can always remove the extra
comparison in a separate patch, since that's unrelated to the real bug
we're trying to fix.

						- Ted
