From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 0/6 v2] Introduce FALLOC_FL_ZERO_RANGE flag for
 fallocate
Date: Tue, 18 Mar 2014 13:52:55 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1403181350590.2121@localhost.localdomain>
References: <1393355679-11160-1-git-send-email-lczerner@redhat.com> <20140316190820.GB14162@thunk.org> <alpine.LFD.2.00.1403171358580.30625@localhost.localdomain> <20140317210030.GB15218@thunk.org> <alpine.LFD.2.00.1403181230270.2121@localhost.localdomain>
 <20140318123919.GA25897@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-84230380-1395147183=:2121"
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259AbaCRMxa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Mar 2014 08:53:30 -0400
In-Reply-To: <20140318123919.GA25897@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-84230380-1395147183=:2121
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 18 Mar 2014, tytso@mit.edu wrote:

> Date: Tue, 18 Mar 2014 08:39:19 -0400
> From: tytso@mit.edu
> To: =?utf-8?B?THVrw6HFoSBDemVybmVyIDxsY3plcm5lckByZWRoYXQuY29tPg==?=@thunk.org
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 0/6 v2] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
> 
> On Tue, Mar 18, 2014 at 12:37:47PM +0100, Lukáš Czerner wrote:
> > Ok, finally I got it. The problem is that we now have commit 
> > 
> > 97d39798f77aef626130db8590cc79195300227b ext4: delete path dealloc
> > code in ext4_ext_handle_uninitialized_extents
> > 
> > which I was not aware of before. And when merging you have used the
> > same out2 label out of the function. However when creating my new
> > function ext4_ext_convert_initialized_exten() so I've done the same
> > thing as with ext4_ext_handle_uninitialized_extents() and freed the
> > path. And since we do not set path to NULL in ext4_ext_map_blocks
> > after calling ext4_ext_convert_initialized_extent() when we hit the
> > condition at the out2:
> > 
> > 	if (path) {
> > 		ext4_ext_drop_refs(path);
> > 		kfree(path);
> > 	}
> > 
> > we will double-free possibly destroying data from someone else. That
> > is why we've seen what looked like a random memory corruption.
> 
> My bad!  I remember noticing that particular semantic conflict, and I
> *thought* I had fixed it up.  The fixup must have gotten lost when I
> was doing some patch wrangling (I was moving aronud some patch hunks
> around to be the most logical with respect to the COLLAPSE RANGE, and
> I must have dropped the fixup somewhere along the way).
> 
> Thanks for finding it!
> 
> 						- Ted
> 

No problem. I am running some tests right now to make sure that
everything is in order and will send out patches 1, 2, and 5 once
again in a separate patch set based on ext4/dev branch.

Thanks!
-Lukas
--8323328-84230380-1395147183=:2121--
