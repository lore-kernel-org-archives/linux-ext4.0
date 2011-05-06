From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [BUG] fatal hang untarring 90GB file, possibly writeback
 related.
Date: Fri, 06 May 2011 14:14:37 -0500
Message-ID: <1304709277.12427.29.camel@mulgrave.site>
References: <20110428171826.GZ4658@suse.de>
	 <1304015436.2598.19.camel@mulgrave.site> <20110428192104.GA4658@suse.de>
	 <1304020767.2598.21.camel@mulgrave.site>
	 <1304025145.2598.24.camel@mulgrave.site>
	 <1304030629.2598.42.camel@mulgrave.site> <20110503091320.GA4542@novell.com>
	 <1304431982.2576.5.camel@mulgrave.site>
	 <1304432553.2576.10.camel@mulgrave.site> <20110506074224.GB6591@suse.de>
	 <20110506154444.GG6591@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Mel Gorman <mgorman@novell.com>, Jan Kara <jack@suse.cz>,
	colin.king@canonical.com, Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Mel Gorman <mgorman@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:43587 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab1EFTOn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 May 2011 15:14:43 -0400
In-Reply-To: <20110506154444.GG6591@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2011-05-06 at 16:44 +0100, Mel Gorman wrote:
> Colin and James: Did you happen to switch from SLAB to SLUB between
> 2.6.37 and 2.6.38? My own tests were against SLAB which might be why I
> didn't see the problem. Am restarting the tests with SLUB.

Aargh ... I'm an idiot.  I should have thought of SLUB immediately ...
it's been causing oopses since debian switched to it.

So I recompiled the 2.6.38.4 stable kernel with SLAB instead of SLUB and
the problem goes away ... at least from three untar runs on a loaded
box ... of course it could manifest a few ms after I send this email ...

There are material differences, as well: SLAB isn't taking my system
down to very low memory on the untar ... it's keeping about 0.5Gb listed
as free.  SLUB took that to under 100kb, so it could just be that SLAB
isn't wandering as close to the cliff edge?

James


