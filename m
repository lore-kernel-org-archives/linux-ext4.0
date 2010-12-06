From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] ext4: Set barrier=0 when block device does not
	advertise flush support
Date: Mon, 6 Dec 2010 10:09:42 -0800
Message-ID: <20101206180942.GL18195@tux1.beaverton.ibm.com>
References: <20101203001659.GI18195@tux1.beaverton.ibm.com> <20101203070950.GA19071@infradead.org> <20101203091445.GK18195@tux1.beaverton.ibm.com> <20101206133924.GB9235@infradead.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56155 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab0LFSJo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Dec 2010 13:09:44 -0500
Content-Disposition: inline
In-Reply-To: <20101206133924.GB9235@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 06, 2010 at 08:39:24AM -0500, Christoph Hellwig wrote:
> barrier=0 really means losemydata=1.  The plan I discussed with Jens was
> to allow to disable the flush and fua semantics in the block layer, so
> we'll have one new tunable for that, which is documented to causes these
> issues.  

Oh.  I wasn't aware that anyone was planning to put in a tuning knob for
flush/fua, red warning light or otherwise.  What is the name of the tunable,
and when will it appear?  Or has it already?

> > picks the safe option by default.  However, I'd prefer /proc/mounts not
> > misrepresent the status of flush support, to the best of ext4's knowledge.
> 
> That's bullshit.  The barrier option has traditionally meant that we

Well then, let's remove the barrier= mount flag altogether.  No need for strong
language over a minor issue. :)  When I see some patches I will push this
through my testing setup and report back what data I collect.

--D

> sent barrier requests, and now means thatwe send flush+fua requests.
> There's no reason for a warning and option mislabling just because you
> got the most efficient implementation of it.
