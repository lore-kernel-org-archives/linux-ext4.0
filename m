From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] extX: convert prink(KERN_WARNING) to extX_warning()
Date: Tue, 24 Jun 2008 00:47:07 -0600
Message-ID: <20080624064707.GF6239@webber.adilger.int>
References: <20080622201841.669ff882@olorin>
 <20080623203107.GD6239@webber.adilger.int>
 <20080623133855.c00ddaa7.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: FD Cami <francois.cami@free.fr>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Kasper Sandberg <lkml@metanurb.dk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:41251 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbYFXGrL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jun 2008 02:47:11 -0400
In-reply-to: <20080623133855.c00ddaa7.randy.dunlap@oracle.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 23, 2008  13:38 -0700, Randy Dunlap wrote:
> On Mon, 23 Jun 2008 14:31:07 -0600 Andreas Dilger wrote:
> > >  	ext3_warning(sb, __func__,
> > > -		     "updating to rev %d because of new feature flag, "
> > > -		     "running e2fsck is recommended",
> > > -		     EXT3_DYNAMIC_REV);
> > > +			"updating to rev %d because of new feature flag, "
> > > +			"running e2fsck is recommended",
> > > +			EXT3_DYNAMIC_REV);
> > 
> > Please don't change all of the indenting.  The old indending is proper
> > linux coding style (aligned with previous '('), the new one is not.
> 
> Hi,
> I don't mind which way it's done, but I'm curious:  are you saying that
> aligning with '(' is codified (e.g., in CodingStyle) or just that it's
> dominant?

You're right - it isn't in the Linux CodingStyle...  It is the style
that we use for Lustre that explicitly requires aligning with '('.
The common stype definitely IS to align with the previous '(' if a line
is a continuation.

That said, it is IMHO bad form to go and change all of the indenting of
existing code with little reason to do so.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

