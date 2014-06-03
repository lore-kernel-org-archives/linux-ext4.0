From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] ext4: fix bug in ext4_mb_normalize_request()
Date: Tue, 3 Jun 2014 20:43:40 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406032040210.2095@localhost.localdomain>
References: <1393855228-13592-1-git-send-email-mlombard@redhat.com> <1393855228-13592-3-git-send-email-mlombard@redhat.com> <20140306154407.GA28226@thunk.org> <20140306165416.GA2182@dhcp-27-189.brq.redhat.com> <alpine.LFD.2.00.1403061842240.2249@localhost.localdomain>
 <20140526165010.GN22284@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1182484741-1401821024=:2095"
Cc: Maurizio Lombardi <mlombard@redhat.com>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbaFCSnu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jun 2014 14:43:50 -0400
In-Reply-To: <20140526165010.GN22284@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1182484741-1401821024=:2095
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 26 May 2014, Theodore Ts'o wrote:

> Date: Mon, 26 May 2014 12:50:10 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Maurizio Lombardi <mlombard@redhat.com>, adilger.kernel@dilger.ca,
>     linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
> Subject: Re: [PATCH 2/2] ext4: fix bug in ext4_mb_normalize_request()
> 
> On Thu, Mar 06, 2014 at 06:54:05PM +0100, Lukáš Czerner wrote:
> > Yes it tries to align down the start_off of the bigger requests to the 512,
> > 1024, 2048, or 4096 respectively. What the reason for it is really I have
> > no idea. The fact is however that this will only affect file systems
> > with bs smaller than 4k since the start_off will be always aligned to
> > block size afterwards (obviously).
> > 
> > That said this alignment is only done when the request is "big
> > enough". With your change we also do it when the block group is
> > "small enough" which is the change in behaviour which I think was
> > not really intended.
> > 
> > Honestly I do not think this really matters a lot but this alignment
> > you've added is not necessary.
> > 
> > All that said, I was getting to rewrite this mess a long time ago,
> > it's just a reminder that it's something that needs to be done.
> > Especially since the bigger requests are getting split unnecessarily
> > which hurts especially in fallocate case.
> 
> Hey Lukas, where are we with respect to your plans to fix up this
> code?
> 
> I'm trying to figure out what we should do with Maurizio's bug fix.
> Should we apply it even though it's making some changes to the
> existing behavior.
> 
> As far as to why the existing code is trying to align the starting
> offset to a power of two, I believe the idea is to avoid
> fragmentation, since the normalize_request function will tend to round
> up allocaiton requests to the same power of two.

Hi Ted,

I think that leaving the alignment of the start offset for the small
files/allocation is not good idea. We might end up with suboptimal
file layout for smaller files. While this is not a big deal for
bigger files, with smaller ones it might cause some troubles.

Maurizio, can you resend the patch without the alignment ?

Also I started looking into normalize_request and hopefully I'll
have a patch soon. Ted, do you have any suggestion for a test to
make sure that I do not make things worse ? You mentioned something
simple on LSF, but I do not remember what it was.

Thanks!
-Lukas


> 
>    	      	       	      	   	    - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-1182484741-1401821024=:2095--
