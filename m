From: Tvrtko Ursulin <tvrtko@ursulin.net>
Subject: Re: [2.6.33-rc2] kernel BUG at fs/ext4/inode.c:1063!
Date: Mon, 4 Jan 2010 08:14:06 +0000
Message-ID: <201001040814.07013.tvrtko@ursulin.net>
References: <201001031638.57331.tvrtko@ursulin.net> <20100104010836.GA4527@thunk.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mk-outboundfilter-3.mail.uk.tiscali.com ([212.74.114.23]:59212
	"EHLO mk-outboundfilter-3.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753219Ab0ADIOL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Jan 2010 03:14:11 -0500
In-Reply-To: <20100104010836.GA4527@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Monday 04 Jan 2010 01:08:36 tytso@mit.edu wrote:
> On Sun, Jan 03, 2010 at 04:38:57PM +0000, Tvrtko Ursulin wrote:
> > As much as it was visible, all writeout stopped after this happened so I
> > could only capture it with the camera. Please see the attachment.
> 
> This is a known bug.  The the latest mainline version of Linux (I
> think 2.6.33-rc2-git4 includes the necessary patch) will no longer
> BUG.  There are two more patches which I'm about to push to Linus that
> are necessary to fix up a typo and some potential undesirable side
> effects of the initial fix of the problem.  If you want to get all of
> the fixes, pull in the changes from:
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
>  for_linus

Was it triggered by no free space? Later I realised that may be what happened 
when this triggered. I was writing out a large file which may filled the 
filesystem. After reboot file in question had zero size, due to journal replay I 
think, but given the amount of free space on the filesystem I think it might 
have used all space while writing out.

If this is related I will wait for -rc3 and just make sure I don't run out of 
space. :) (So far I avoided starting to build git trees etc)

Tvrtko
