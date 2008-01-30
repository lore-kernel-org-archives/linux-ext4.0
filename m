From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [GIT PULL] ext4 update
Date: Wed, 30 Jan 2008 02:11:23 -0500
Message-ID: <20080130071123.GF21944@mit.edu>
References: <E1JJjMo-00011j-EU@closure.thunk.org> <20080129125307.GF6774@mit.edu> <Pine.LNX.4.64.0801292250110.14907@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:43284 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764AbYA3HRG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2008 02:17:06 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801292250110.14907@fbirervta.pbzchgretzou.qr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 29, 2008 at 10:54:03PM +0100, Jan Engelhardt wrote:
> 
> On Jan 29 2008 07:53, Theodore Tso wrote:
> >
> >>fwiw, diffstat is confused by git's diff output; you need to use
> >>'diffstat -p1'
> 
> I am seeing normal behavior:
>
> 22:52 sovereign:~/linux > git diff HEAD | diffstat

That's because you are doing a diff stat of changes that haven't been
checked in yet.  I was doing a "git log -p origin.. | diffstat -p1",
and in that incantation you definitely do need the -p1 to diffstat.

       	    		    	       	  - Ted
