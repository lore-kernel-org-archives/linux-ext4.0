From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH -resend] jbd2: revert must-not-fail allocation loops back
 to GFP_NOFAIL
Date: Mon, 8 Jun 2015 17:37:40 +0200
Message-ID: <20150608153740.GC1390@dhcp22.suse.cz>
References: <1433770124-19614-1-git-send-email-mhocko@suse.cz>
 <20150608145432.GB19168@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, David Rientjes <rientjes@google.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	LKML <linux-kernel@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150608145432.GB19168@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 08-06-15 10:54:32, Theodore Ts'o wrote:
> On Mon, Jun 08, 2015 at 03:28:44PM +0200, Michal Hocko wrote:
> > This basically reverts 47def82672b3 (jbd2: Remove __GFP_NOFAIL from jbd2
> > layer). The deprecation of __GFP_NOFAIL was a bad choice because it led
> > to open coding the endless loop around the allocator rather than
> > removing the dependency on the non failing allocation. So the
> > deprecation was a clear failure and the reality tells us that
> > __GFP_NOFAIL is not even close to go away.
> > 
> > It is still true that __GFP_NOFAIL allocations are generally discouraged
> > and new uses should be evaluated and an alternative (pre-allocations or
> > reservations) should be considered but it doesn't make any sense to lie
> > the allocator about the requirements. Allocator can take steps to help
> > making a progress if it knows the requirements.
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > Acked-by: David Rientjes <rientjes@google.com>
> 
> Applied, thanks.

Thanks!
-- 
Michal Hocko
SUSE Labs
