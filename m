From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 0/6 v2] Introduce FALLOC_FL_ZERO_RANGE flag for
 fallocate
Date: Tue, 18 Mar 2014 12:37:47 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1403181230270.2121@localhost.localdomain>
References: <1393355679-11160-1-git-send-email-lczerner@redhat.com> <20140316190820.GB14162@thunk.org> <alpine.LFD.2.00.1403171358580.30625@localhost.localdomain> <20140317210030.GB15218@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1989491716-1395142670=:2121"
Cc: =?utf-8?B?THVrw6HFoSBDemVybmVyIDxsY3plcm5lckByZWRoYXQuY29tPg==?=@thunk.org,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbaCRLhz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Mar 2014 07:37:55 -0400
In-Reply-To: <20140317210030.GB15218@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1989491716-1395142670=:2121
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 17 Mar 2014, tytso@mit.edu wrote:

> Date: Mon, 17 Mar 2014 17:00:30 -0400
> From: tytso@mit.edu
> To: =?utf-8?B?THVrw6HFoSBDemVybmVyIDxsY3plcm5lckByZWRoYXQuY29tPg==?=@thunk.org
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 0/6 v2] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
> 
> On Mon, Mar 17, 2014 at 01:59:35PM +0100, Lukáš Czerner wrote:
> > > The "dev2" branch in the ext4 git tree has all the patches in this
> > > series (1, 2, and 5) --- 3 was included earlier applied on top of the
> > > "dev" branch.  The "test" branch is the dev2 branch with the
> > > xfs-collapse-range branch pulled in, which actually enables the
> > > ZERO_RANGE flags (as well as the collapse range patches).
> > > 
> > > When I tried testing with the "test" branch, things failed pretty
> > > quickly.  I've attached two of these in this patch set.  I'm guessing
> > > it's some kind of memory corruption problem.  These failures are
> > > pretty repeatable, and it fails fast.
> 
> Can you let me know when you've had a chance to take a look at this
> failure?  Once we put back the EOFBLOCK_FL code, I suspect we should
> be fine with the first two patches in this patch series, but patch #5
> plus the xfs-collapse-range branch appears to still have issues.
> 
> Thanks!!
> 
> 						- Ted
> 

Ok, finally I got it. The problem is that we now have commit 

97d39798f77aef626130db8590cc79195300227b ext4: delete path dealloc
code in ext4_ext_handle_uninitialized_extents

which I was not aware of before. And when merging you have used the
same out2 label out of the function. However when creating my new
function ext4_ext_convert_initialized_exten() so I've done the same
thing as with ext4_ext_handle_uninitialized_extents() and freed the
path. And since we do not set path to NULL in ext4_ext_map_blocks
after calling ext4_ext_convert_initialized_extent() when we hit the
condition at the out2:

	if (path) {
		ext4_ext_drop_refs(path);
		kfree(path);
	}

we will double-free possibly destroying data from someone else. That
is why we've seen what looked like a random memory corruption.

I'll resend the patches including the EOFBLOCK_FL fixes.

Thanks!
-Lukas


--8323328-1989491716-1395142670=:2121--
