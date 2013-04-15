From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: xfstests failure generic/299
Date: Mon, 15 Apr 2013 14:43:18 -0400
Message-ID: <20130415184318.GA5602@thunk.org>
References: <nsxvc7ra2cv.fsf@closure.thunk.org>
 <87sj2uokzc.fsf@openvz.org>
 <20130414224712.GC12542@thunk.org>
 <87k3o4xih1.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34398 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756677Ab3DOSnX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Apr 2013 14:43:23 -0400
Content-Disposition: inline
In-Reply-To: <87k3o4xih1.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 15, 2013 at 01:15:38PM +0400, Dmitry Monakhov wrote:
> > Unfortunately, I don't have the time to debug this, so at least for
> > now I'm going to exclude generic/299 from my automated test runs.
> Actually fix is quite simple, after this everything works fine.

Thanks for the patch!  I take it fio isn't gcc -Wall clean?  

Since otherwise this should have been caught much earlier....  :-(

       	       	       	      	     - Ted
