From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] Handle unusual results from find_tempdir.
Date: Tue, 5 Feb 2008 10:35:10 -0500
Message-ID: <20080205153510.GA18392@mit.edu>
References: <87hcgna9f3.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:42445 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316AbYBEPfS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Feb 2008 10:35:18 -0500
Content-Disposition: inline
In-Reply-To: <87hcgna9f3.fsf@rho.meyering.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 05, 2008 at 01:13:04PM +0100, Jim Meyering wrote:
> An alternative: make find_tempdir set tempdir to default_tempdir
> upon malloc failure.
> 
> * arch/um/os-Linux/mem.c (make_tempfile): Handle NULL tempdir.
> Don't let a long tempdir (e.g., via TMPDIR) provoke heap corruption.

This wasn't meant for the linux-ext4 list, was it?  I think maybe you
typo'ed the mailing list this patch was supposed to be sent to?

Regards,

	    	    	      	    	- Ted
