From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: e2fsck dies with error "this should never happen!!!"
Date: Fri, 22 Feb 2008 14:48:26 -0500
Message-ID: <20080222194826.GW20118@mit.edu>
References: <47BEBAF1.4090505@tuxes.nl> <20080222123852.GI20118@mit.edu> <47BECAC0.5010707@tuxes.nl> <20832.81.207.193.3.1203702265.squirrel@guust.tuxes.nl> <47BF0A7B.50902@redhat.com> <20909.81.207.193.3.1203702913.squirrel@guust.tuxes.nl> <47BF0DAC.9080200@redhat.com> <21151.81.207.193.3.1203703570.squirrel@guust.tuxes.nl> <20080222182711.GT20118@mit.edu> <21200.81.207.193.3.1203708673.squirrel@guust.tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Bas van Schaik <bas@tuxes.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:49293 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764516AbYBVTsd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Feb 2008 14:48:33 -0500
Content-Disposition: inline
In-Reply-To: <21200.81.207.193.3.1203708673.squirrel@guust.tuxes.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 22, 2008 at 08:31:13PM +0100, Bas van Schaik wrote:
> > Yeah, it could be quite big, given that you have a 3TB filesystem.  That's
> > why I suggested the "or given me login access to the system", although
> > understand there could be all sorts of privacy and security issues
> > involved with that request.
> 
> The dump is not ready yet...
> 
> Whatever we will do, it will have to wait for a week and a half. For now I
> really appreciate all the help.

Ok, when you get back, I should also have a patch for you that will
allow the "XXX should never happen" message to display more
information, so if the dump is too big for us to move over the
network, I'll have another way of doing some remote debugging.

	      	   	       	  	- Ted
