From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Report max_batch_time option correctly
Date: Wed, 4 Jan 2012 21:23:10 -0500
Message-ID: <20120105022310.GA24494@thunk.org>
References: <1325513582.13595.213.camel@deadeye>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Russell Coker <russell@coker.com.au>,
	654206@bugs.debian.org
To: Ben Hutchings <ben@decadent.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58185 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757768Ab2AECXS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jan 2012 21:23:18 -0500
Content-Disposition: inline
In-Reply-To: <1325513582.13595.213.camel@deadeye>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 02, 2012 at 02:13:02PM +0000, Ben Hutchings wrote:
> Currently the value reported for max_batch_time is really the
> value of min_batch_time.
> 
> Reported-by: Russell Coker <russell@coker.com.au>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Applied, thanks.

					- Ted
