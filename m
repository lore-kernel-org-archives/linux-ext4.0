From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/1] ext4: Remove empty index blocks when punching
 holes
Date: Tue, 6 Mar 2012 08:11:37 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1203060810430.5085@dhcp-27-109.brq.redhat.com>
References: <1330501048-14109-1-git-send-email-achender@linux.vnet.ibm.com> <alpine.LFD.2.00.1202290841310.4926@dhcp-27-109.brq.redhat.com> <4F4DDE8D.6020203@linux.vnet.ibm.com> <alpine.LFD.2.00.1202290916590.4926@dhcp-27-109.brq.redhat.com>
 <20120305235430.GA12796@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757592Ab2CFHLo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Mar 2012 02:11:44 -0500
In-Reply-To: <20120305235430.GA12796@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 5 Mar 2012, Ted Ts'o wrote:

> On Wed, Feb 29, 2012 at 09:18:54AM +0100, Lukas Czerner wrote:
> > > 
> > > Alrighty then, sounds good.  This patch seemed to correct the loop discard bug
> > > we saw earlier for me.  So please make sure you have some similar fix in your
> > > new patch.  Basically we had some extra index blocks hanging around when the
> > > depth was greater than one, so the patch just adds some code to free up those
> > > index blocks in the path if they are empty.  Hope this helps!  Thx!  :)
> > 
> > Actually I started to modifying the punch hole code in order to find
> > that bug and this problem does go away with my pathes. I'll CC
> > you on the patches when I send them out.
> 
> OK, so my understanding is that Lukas's patches solve the same problem
> as Allison's, and those are the patches I should review and integrate?
> 
>    	      	  	    		- Ted
> 

Hi Ted,

you're right my patches solves this problem (as I wrote in the commit
description) just because we now use a different code paths, which do
not have this problem.

Thanks!
-Lukas
