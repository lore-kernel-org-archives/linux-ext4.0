From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Some thoughts about providing data block checksumming for ext4
Date: Wed, 26 Nov 2014 16:39:23 -0800
Message-ID: <20141127003923.GQ10043@birch.djwong.org>
References: <20141103233308.GA27842@thunk.org>
 <20141126234706.GN10043@birch.djwong.org>
 <20141127000722.GA310@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, dm-devel@redhat.com,
	linux-ext4@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35988 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaK0Ajb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Nov 2014 19:39:31 -0500
Content-Disposition: inline
In-Reply-To: <20141127000722.GA310@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 26, 2014 at 07:07:22PM -0500, Mike Snitzer wrote:
> On Wed, Nov 26 2014 at  6:47pm -0500,
> Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> > Sigh...
> > 
> > Well, I wrote up a preliminary version of dm-checksum and then
> > realized that I've pretty much just built a crappier version of
> > dm-dedupe, but without the dedupe part.  Given that it stores
> > checksums in a btree which claims to be robust through failures and
> > gives us automatic deduplication, I wonder if it we could achieve our
> > aims by modifying dm-dedupe to verify the checksums on the read path?
> > 
> > I guess it would be interesting to see how bad the performance hit is
> > with the online dedupe part enabled or disabled.  dm-dedupe v2 went
> > out on the mailing list last August, which I missed. :(
> > 
> > Unless... there's a specific reason nobody mentioned dm-dedupe here?
> 
> As you may have seen in the dm-dedup thread, we need to actively
> review/test that target

It was in fact today's exchange on that thread that made me slap myself on
the forehead and utter "D'oh!".

> (if your initial review focus is on extending it
> to _optionally_ verify the checksums on the read path then so be it).

Yes, sorry, I meant to say "optionally to verify" in there.  Adding a minor
feature like that might be a good check to make sure I actually understand
what's going on. :)

> See: https://www.redhat.com/archives/dm-devel/2014-November/msg00114.html
> Specifically, the git branch that builds on v2 based on my initial
> review of v2:
> 
> git://git.fsl.cs.stonybrook.edu/scm/git/linux-dmdedup
> branch: dm-dedup-devel
> 
> Your help on getting dm-dedup upstream would be very much appreciated.

<-- reading the OLS paper, as a start.  What happens to the metadata btree if
someone sets the chunk size to 4KB?  Will it become ungainly huge?  The thing
that I wrote simply wrote a block's worth of checksums inline with the data,
which required a certain amount of slicing and dicing of bios but wasn't too
horrible with performance.

--D

> 
> Thanks,
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
