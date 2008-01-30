From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] [0/7] Drop BKL in ext[234] ioctls
Date: Wed, 30 Jan 2008 01:30:55 -0500
Message-ID: <20080130063055.GD21944@mit.edu>
References: <200801281116.315497000@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:39881 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160AbYA3GbZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2008 01:31:25 -0500
Content-Disposition: inline
In-Reply-To: <200801281116.315497000@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 28, 2008 at 11:16:09AM +0100, Andi Kleen wrote:
> 
> Remove the BKL from the ext* ioctls.
> 
> This is a slightly updated version of the ext[2-4] patches that hit
> linux-fsdevel earlier.

Thanks, I've included these patches into the ext4 tree, and should
hopefully be pulled into the next -mm tree.

						- Ted
