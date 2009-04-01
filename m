From: Theodore Tso <tytso@mit.edu>
Subject: Re: No ext4 patches in 2.6.29.1?
Date: Wed, 1 Apr 2009 12:34:47 -0400
Message-ID: <20090401163447.GL4529@mit.edu>
References: <pan.2009.04.01.10.40.42.313375@wizards.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Holger Hoffstaette <holger@wizards.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:60148 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761066AbZDAQex (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Apr 2009 12:34:53 -0400
Content-Disposition: inline
In-Reply-To: <pan.2009.04.01.10.40.42.313375@wizards.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2009 at 12:40:53PM +0200, Holger Hoffstaette wrote:
> 
> Hi,
> 
> This is not a complaint or bug report. :)
> I've been following the recent ext4 activity (purely as an interested user
> already running ext4 everywhere) and am somewhat concerned that Chris
> Wright's recent announcement of 2.6.29.1 does not seem to contain any ext4
> related fixes, like the "brown paper bag" lock typo or others. Is this
> just an oversight? I've had no problems with ext4 so far (knock on wood)
> but reading about some of the bugs here I'd rather have fixes sooner than
> later..release consistency, peace of mind and all that. Is this not how
> the stable release process is meant to work?

I was delayed in getting the ext4 fixes for 2.6.30 pushed to Linus,
and they have to be accepted in mainline before I can push them to
stable.  Sorry, things have been crazy busy for me this past week.

	 	       	    	       	    - Ted
