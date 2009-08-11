From: Chris Mason <chris.mason@oracle.com>
Subject: Re: What happened to data=guarded? (was: ext3: Update Kconfig
 description of EXT3_DEFAULTS_TO_ORDERED)
Date: Tue, 11 Aug 2009 09:37:21 -0400
Message-ID: <20090811133721.GD29224@think>
References: <1249934623-15939-1-git-send-email-tytso@mit.edu>
 <200908111535.37927.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, jack@suse.cz,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Frans Pop <elendil@planet.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:18141 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbZHKNha (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Aug 2009 09:37:30 -0400
Content-Disposition: inline
In-Reply-To: <200908111535.37927.elendil@planet.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 11, 2009 at 03:35:36PM +0200, Frans Pop wrote:
> > The old description for this configuration option was perhaps not
> > completely balanced in terms of describing the tradeoffs of using a
> > default of data=writeback vs. data=ordered.
> 
> Somewhat unrelated, but what happened to the data=guarded patches Chris 
> Mason proposed back in April?

I missed 2.6.31 but plan on sending for 2.6.32.  I promised to send
along a forward port of the patches a while back, but I finally have one
in testing here.  It should go out shortly.

-chris

