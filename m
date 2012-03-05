From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1] ext4: Remove empty index blocks when punching holes
Date: Mon, 5 Mar 2012 18:54:30 -0500
Message-ID: <20120305235430.GA12796@thunk.org>
References: <1330501048-14109-1-git-send-email-achender@linux.vnet.ibm.com>
 <alpine.LFD.2.00.1202290841310.4926@dhcp-27-109.brq.redhat.com>
 <4F4DDE8D.6020203@linux.vnet.ibm.com>
 <alpine.LFD.2.00.1202290916590.4926@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40332 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757949Ab2CEXyh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Mar 2012 18:54:37 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1202290916590.4926@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 29, 2012 at 09:18:54AM +0100, Lukas Czerner wrote:
> > 
> > Alrighty then, sounds good.  This patch seemed to correct the loop discard bug
> > we saw earlier for me.  So please make sure you have some similar fix in your
> > new patch.  Basically we had some extra index blocks hanging around when the
> > depth was greater than one, so the patch just adds some code to free up those
> > index blocks in the path if they are empty.  Hope this helps!  Thx!  :)
> 
> Actually I started to modifying the punch hole code in order to find
> that bug and this problem does go away with my pathes. I'll CC
> you on the patches when I send them out.

OK, so my understanding is that Lukas's patches solve the same problem
as Allison's, and those are the patches I should review and integrate?

   	      	  	    		- Ted
