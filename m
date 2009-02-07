From: Theodore Tso <tytso@mit.edu>
Subject: Re: htree indexing and 64-bit file systems
Date: Sat, 7 Feb 2009 10:54:32 -0500
Message-ID: <20090207155432.GF29213@mini-me.lan>
References: <20090203222202.GK20654@shell> <20090203233108.GW14762@mit.edu> <87vdrmiefj.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:57703 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbZBGR0Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Feb 2009 12:26:24 -0500
Content-Disposition: inline
In-Reply-To: <87vdrmiefj.fsf@frosties.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 07, 2009 at 02:06:56PM +0100, Goswin von Brederlow wrote:
> What if the directory is REALLY HUGE? :) Say >68.719.476.736 files.
> 
> Can ext4 64bit have directories >8TiB?

No, ext4 directories are limited to 2TB.  Htree directories are
currently limited to a depth of two, which for smaller block sizes
will be more of limitation than the maximum size limitation.

     	     		   	    	    - Ted
