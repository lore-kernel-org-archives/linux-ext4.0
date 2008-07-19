From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/2] lock block groups when initializing
Date: Sat, 19 Jul 2008 13:19:29 -0400
Message-ID: <20080719171929.GA9424@mit.edu>
References: <4880F5D3.8080805@redhat.com> <20080719145057.GB8165@mit.edu> <48821218.1020301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:34774 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750989AbYGSRTb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Jul 2008 13:19:31 -0400
Content-Disposition: inline
In-Reply-To: <48821218.1020301@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 19, 2008 at 11:11:04AM -0500, Eric Sandeen wrote:
> Theodore Tso wrote:
> > I've added both of these patches to the ext4 patch queue for testing.
> > 
> >      	   	   	 	    	- Ted
> 
> Thanks, I'm hesitant to add my own patches w/o some review first :)
> 

I haven't done a full review yet; just a "quick eyeball" of the patch,
and then I put it on my laptop and noted that it hadn't destroyed my
home directory.  :-)

I'll try to do a full review in the few days; I'll move it into the
stable queue and push it and a few other patches to the mainline
(although it appears that Linus went on vacation before pushing out
-rc1; Alan mentioned in another message that Linus might be gone for
"a week or two", which surprises me if he really went on vacation for
that length of time without pushing out -rc1 first.)

     	       	      	     	    	- Ted

