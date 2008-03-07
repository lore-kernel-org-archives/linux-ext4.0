From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsck dies with error "this should never happen!!!"
Date: Fri, 07 Mar 2008 09:50:46 -0600
Message-ID: <47D16456.6030400@redhat.com>
References: <47BEBAF1.4090505@tuxes.nl> <20080222123852.GI20118@mit.edu> <47BECAC0.5010707@tuxes.nl> <20832.81.207.193.3.1203702265.squirrel@guust.tuxes.nl> <47BF0A7B.50902@redhat.com> <20909.81.207.193.3.1203702913.squirrel@guust.tuxes.nl> <47BF0DAC.9080200@redhat.com> <21151.81.207.193.3.1203703570.squirrel@guust.tuxes.nl> <20080222182711.GT20118@mit.edu> <21200.81.207.193.3.1203708673.squirrel@guust.tuxes.nl> <20080222194826.GW20118@mit.edu> <47CAFB3F.2010409@tuxes.nl> <47D145F8.3040300@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@MIT.EDU>, linux-ext4@vger.kernel.org
To: Bas van Schaik <bas@tuxes.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763524AbYCGPvV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Mar 2008 10:51:21 -0500
In-Reply-To: <47D145F8.3040300@tuxes.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Bas van Schaik wrote:

> Why is e2image refusing to restore the metadata, and what does "File too
> large" mean?

How big are things really?  stracing the command would show you what is
returning the error...

-Eric

> I think this is pretty much the moment were I can say "HELP!!!"
> 
>   -- Bas

