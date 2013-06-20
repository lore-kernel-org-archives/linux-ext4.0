From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v4 15/20] ext4: use ext4_zero_partial_blocks in
 punch_hole
Date: Thu, 20 Jun 2013 11:12:02 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1306201110220.1929@localhost.localdomain>
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com> <1368549454-8930-16-git-send-email-lczerner@redhat.com> <20130614030154.GA18731@thunk.org> <alpine.LFD.2.00.1306191831210.2085@localhost.localdomain> <20130619234243.GE24587@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1096263112-1371719525=:1929"
Cc: linux-ext4@vger.kernel.org,
	Ashish Sangwan <ashishsangwan2@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935296Ab3FTJMI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Jun 2013 05:12:08 -0400
In-Reply-To: <20130619234243.GE24587@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1096263112-1371719525=:1929
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 19 Jun 2013, Theodore Ts'o wrote:

> Date: Wed, 19 Jun 2013 19:42:43 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, Ashish Sangwan <ashishsangwan2@gmail.com>
> Subject: Re: [PATCH v4 15/20] ext4: use ext4_zero_partial_blocks in punch_hole
> 
> On Wed, Jun 19, 2013 at 06:37:53PM +0200, Lukáš Czerner wrote:
> > 
> > I think I've got this. The problem actually is in
> > ext4_zero_partial_blocks() where we would attempt to zero out page
> > which has been previously released by truncate_pagecache_range().
> > This might happen when we're punching out just a single page because
> > in ext4_zero_partial_blocks() we do not check whether we're dealing
> > with the whole, or partial page. At the point we're going to zero it
> > out it might have been already released and reused by someone else.
> > 
> > This patch should fix this issue. And indeed with this applied I do
> > not see the problem anymore but I am still testing.
> 
> Thanks for finding this!  I'm still doing testing of your trial patch
> myself, but initial results seem to indicate that this also solves the
> failures 269 and 270 which was apparently uncovered by Ashish's patch
> "ext4: optimize extent selection for block removal in case of hole
> punch".
> 
> 	 		      	    - Ted

Hi Ted,

from my testing I still see problems with test 269, however I've
seen this even without the patch #15 so I am not sure that it's
caused by this.

I'll send a proper patch soon.

Thanks!
-Lukas
--8323328-1096263112-1371719525=:1929--
