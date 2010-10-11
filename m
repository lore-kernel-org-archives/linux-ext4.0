From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Performance testing of various barrier reduction patches [was:
 Re: [RFC v4] ext4: Coordinate fsync requests]
Date: Mon, 11 Oct 2010 10:33:17 -0400
Message-ID: <20101011143317.GA3860@thunk.org>
References: <20100806070424.GD2109@tux1.beaverton.ibm.com>
 <20100809195324.GG2109@tux1.beaverton.ibm.com>
 <4D5AEB7F-32E2-481A-A6C8-7E7E0BD3CE98@dilger.ca>
 <20100809233805.GH2109@tux1.beaverton.ibm.com>
 <20100819021441.GM2109@tux1.beaverton.ibm.com>
 <20100823183119.GA28105@tux1.beaverton.ibm.com>
 <20100923232527.GB25624@tux1.beaverton.ibm.com>
 <B0A8EB94-E2F7-4268-AE99-C4A7402E880D@dilger.ca>
 <20100927230111.GV25555@tux1.beaverton.ibm.com>
 <20101008212606.GE25624@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Mingming Cao <cmm@us.ibm.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>, Tejun Heo <tj@kernel.org>,
	hch@lst.de
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58018 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622Ab0JKOdZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Oct 2010 10:33:25 -0400
Content-Disposition: inline
In-Reply-To: <20101008212606.GE25624@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 08, 2010 at 02:26:06PM -0700, Darrick J. Wong wrote:
> Given the nearness of the merge window, perhaps we ought to discuss
> this on Monday's ext4 call?  In the meantime I'll clean up the fsync
> coordination patch so that it doesn't have so many debugging knobs
> and whistles.

Yes, we should definitely talk about this on today's call.

One of the things that concern me is that if I'm reading the
spreadsheet correctly, there are some colums (for example,
elm3c44_sas, comparing I3, which is what will be in 2.6.36 --- jan's
patch, but not yours, and the currently existing behaviour --- with
I10 which is as I understand it, what you are recommending, I see an
FFSB regression from 1,916.54 to 1,690.33).  

That's something like a 15% regression.  I know that for other
hardware, there are improvements, but the fact that at least for some
hardware we're seeing such a big regression makes me worried that
we're missing something --- or maybe it's just me who is missing
something about your spreadsheet?

						- Ted
