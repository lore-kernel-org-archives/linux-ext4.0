From: tytso@mit.edu
Subject: Re: writev corruption and 64-bit quota patches for 2.6.33-rc1?
Date: Tue, 8 Dec 2009 16:21:09 -0500
Message-ID: <20091208212109.GT27692@thunk.org>
References: <20091208110043.GC4095@quack.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51078 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966439AbZLHVVI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Dec 2009 16:21:08 -0500
Content-Disposition: inline
In-Reply-To: <20091208110043.GC4095@quack.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 08, 2009 at 12:00:43PM +0100, Jan Kara wrote:
>   Hi Ted,
> 
>   do you plan on merging my fixes for writev filesystem corruption and
> 64-bit quota patches? The writev patch is independent of any other patch
> and should go in ASAP, 64-bit quota patch depends on generic quota code
> change so either I can merge it or you can merge a bit later (it's a small
> change for ext4).

Why don't I take the writev patch, and let you merge the 64-bit quota
patch along with the generic quota changes?  Does that make sense?

The only thing that worries me a tiny bit is that there are some quota
bug fixes which the OpenVZ folks have submitted, that I need to review
and haven't gotten to yet, and there's a chance they may conflict with
your 64-bit ext4 quota changes.  But I'm sure we can deal with any
potential merge conflicts should they come up.

Regards,

	  		  	      	   - Ted
