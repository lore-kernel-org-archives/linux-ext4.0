From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3] ext4: Don't set PageUptodate in ext4_end_bio()
Date: Tue, 10 May 2011 15:17:47 -0400
Message-ID: <20110510191747.GB6933@thunk.org>
References: <1303762999-20541-1-git-send-email-curtw@google.com>
 <alpine.LSU.2.00.1105101037440.1243@sister.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jim Meyering <jim@meyering.net>,
	Mingming Cao <cmm@us.ibm.com>,
	Curt Wohlgemuth <curtw@google.com>
To: Hugh Dickins <hughd@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41751 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab1EJTRw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 May 2011 15:17:52 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1105101037440.1243@sister.anvils>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 10, 2011 at 10:41:56AM -0700, Hugh Dickins wrote:
> 
> I'm concerned that we've reached -rc7, with Linus planning on 2.6.39
> release next week, but Curt's fix above to the mblk_io corruption bug
> seems to have fallen through the cracks.

It's in the ext4 master branch so it's queued to be pushed during the
next merge window, and then it would go into the 2.6.39.x stable
series.  So it didn't fall through the cracks; it was just a question
of whether to push late in the rc series, or waiting until the merge
window and then backporting to 2.6.39 stable.  Basically I got the
patch in -rc5, and at that point, given that the vast majority of the
file systems are 4k blocksize on x86, and most Power and Itanic users
are using distribution kernels (and that's a very small number
anyway), I decided not to push it to Linus at that point.

It's a judgement call; and I could have gone the other way; it was
very much a 49/51 sort of decision.

					- Ted
