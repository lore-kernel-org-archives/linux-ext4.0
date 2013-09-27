From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] e2image: Print a warning if running over a mounted
 filesystem
Date: Thu, 26 Sep 2013 21:48:33 -0300
Message-ID: <20130927004832.GA15078@orion.maiolino.org>
References: <1380229204-32526-1-git-send-email-cmaiolino@redhat.com>
 <20130926235658.GD6011@thunk.org>
 <5244D3C2.4090606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab3I0Asm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Sep 2013 20:48:42 -0400
Content-Disposition: inline
In-Reply-To: <5244D3C2.4090606@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hey, sorry my late answer, I'm experimenting some new mutt configuration.


> > If the user is trying to capture a raw or qcow image file, I agree
> > that requiring that the file systme either be mounted read-only, not
> > mounted at all, or that a force option be specified, makes sense.
> 
> cool.  :)
> 
> -Eric

I'd suggest then to need a force when using -r or -q on a RW image. In case of a
normal image, just a warning but continue.

Ted, as Eric said, I've got some useless images in the past too and just a
warning won't really avoid the problem IMHO since, most of users don't even read
what's being printed :-) so, request a force when getting at least a raw or
QCOW2 image is very useful IMHO.

any comments?
> 
> > 	   	   	  	       	  - Ted

-- 
Carlos
