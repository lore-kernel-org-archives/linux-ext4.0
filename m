From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [RFC] Btrfs mainline plans
Date: Thu, 9 Oct 2008 11:22:34 +0300
Message-ID: <20081009082234.GA17013@cs181140183.pp.htv.fi>
References: <1222717460.30627.56.camel@think.oraclecorp.com> <20081005141113.GA6132@us.ibm.com> <20081005150957.GC12047@cs181140183.pp.htv.fi> <200810081433.32766.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Daniel Phillips <phillips@phunq.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:34863 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbYJIIXP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Oct 2008 04:23:15 -0400
Content-Disposition: inline
In-Reply-To: <200810081433.32766.phillips@phunq.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 08, 2008 at 02:33:32PM -0700, Daniel Phillips wrote:
> On Sunday 05 October 2008 08:09, Adrian Bunk wrote:
> > "accelerate its development and will broaden its developer base" is not 
> > about users/testers but about people doing code development.
> > 
> > For people wanting to try WIP code you don't need it in mainline.
> 
> But it saves time for the user, who does not have to run around chasing
> links, carefully checking for a kernel match, downloading, patching,
> building and installing a single purpose kernel, and bringing it up on
> a machine that would probably have only required one click on the new
> filesystem option otherwise.  The considerable time thus saved can be
> invested profitably in running test cases and filing bug reports.

Bug reports against a 3-6 months old snapshot of a filesystem being 
under heavy development.

Ted said back in August in the announcement of an ext4 patchset:

"As before I've also released updated the patch set vs. the 2.6.26 stock
 kernel, for those people who don't want to play with development 
 kernels but who still want to test out ext4." [1]

When running stable kernels you still have to patch, build and install
a single purpose kernel for testing ext4 although ext4 is in mainline.

>...
> > This is not meant as a statement on the quality of ext4 or btrfs, or any 
> > comparison of the development times of ext4 and btrfs, but for ext4 the 
> > advantages Andrew thinks would happen with an early btrfs merge do not 
> > seem to have happened.
> 
> Are you sure about that?  I see 33 messages on linux-ext4 yesterday,
> from a broad range of contributors.  Versus eight from a much narrower
> range of contributors, Oct 4 a year ago.

There are lies, damn lies, and statistics.  ;)

Single day statistics about mailing list postings are not very good
indicators for anything.

And since linux-ext4 is for all of ext2/ext3/ext4 the data you gave 
could equally be used to prove that ext3 recently became much more
buggy or that ext2 development vastly increased...

> There is little question that an early merge helps both developers and
> users employ their time more efficiently,

Regarding users see my comment above.

Regarding developers it would be interesting to hear some experiences 
from ext4 developers about their experiences (or get a pointer to them 
in case I missed that they already expressed it somewhere).

> once a project is past the
> point where we wonder about its value and/or viability.  In my opinion,
> Btrfs clearly has both.
>...

2 years ago ext4 was in a similar situation of being regarded as an 
important future filesystem.

> Regards,
> 
> Daniel

cu
Adrian

BTW: My comments are not in any way meant against btrfs or ext4.
     I just question the advantages of merging them early.


[1] http://lwn.net/Articles/294784/

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

