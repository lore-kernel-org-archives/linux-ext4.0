From: Ted Ts'o <tytso@mit.edu>
Subject: Re: fsck performance.
Date: Wed, 23 Feb 2011 18:17:39 -0500
Message-ID: <20110223231739.GS2924@thunk.org>
References: <C5662C0F-10E3-4AC3-8ACA-4CBBF4F36D70@dilger.ca>
 <20110222102056.GH21917@bitwizard.nl>
 <20110222133652.GI21917@bitwizard.nl>
 <20110222135431.GK21917@bitwizard.nl>
 <386B23FA-CE6E-4D9C-9799-C121B2E8C3BB@dilger.ca>
 <20110222221304.GH2924@thunk.org>
 <20110223044427.GM21917@bitwizard.nl>
 <DC8EC4D5-BB64-4908-985B-C6D3EDA955E3@mit.edu>
 <20110223205309.GA16661@bitwizard.nl>
 <F03E2EAC-9D44-4D8E-93AC-902FDFC22B92@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rogier Wolff <R.E.Wolff@bitwizard.nl>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56851 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582Ab1BWXRq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Feb 2011 18:17:46 -0500
Content-Disposition: inline
In-Reply-To: <F03E2EAC-9D44-4D8E-93AC-902FDFC22B92@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 23, 2011 at 03:24:18PM -0700, Andreas Dilger wrote:
> 
> If you have the opportunity, I wonder whether the entire need for
> tdb can be avoided in your case by using swap and the icount
> optimization patches previously posted?  

Unfortunately, there are people who are still using 32-bit CPU's, so
no, swap is not a solution here.   

> I'd really like to get that patch included upstream, but it needs
> testing in an environment like yours where icount is a significant
> factor.  This would avoid all of the tdb overhead.

Adjusting the tdb hash parameters, and changing the tdb hash functions
shouldn't be hard to get into upstream.  We should really improve our
testing for [scratch files], but that's always been true....

	    	     	     	 	- Ted
