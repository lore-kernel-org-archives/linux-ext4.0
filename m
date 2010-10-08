From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Performance testing of various barrier reduction patches [was:
	Re: [RFC v4] ext4: Coordinate fsync requests]
Date: Fri, 8 Oct 2010 14:26:06 -0700
Message-ID: <20101008212606.GE25624@tux1.beaverton.ibm.com>
References: <20100805164504.GI2901@thunk.org> <20100806070424.GD2109@tux1.beaverton.ibm.com> <20100809195324.GG2109@tux1.beaverton.ibm.com> <4D5AEB7F-32E2-481A-A6C8-7E7E0BD3CE98@dilger.ca> <20100809233805.GH2109@tux1.beaverton.ibm.com> <20100819021441.GM2109@tux1.beaverton.ibm.com> <20100823183119.GA28105@tux1.beaverton.ibm.com> <20100923232527.GB25624@tux1.beaverton.ibm.com> <B0A8EB94-E2F7-4268-AE99-C4A7402E880D@dilger.ca> <20100927230111.GV25555@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>, Tejun Heo <tj@kernel.org>,
	hch@lst.de
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:44131 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065Ab0JHV0K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Oct 2010 17:26:10 -0400
Content-Disposition: inline
In-Reply-To: <20100927230111.GV25555@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 27, 2010 at 04:01:11PM -0700, Darrick J. Wong wrote:
> 
> Other than those regressions, the jbd2 fsync coordination is about as fast as
> sending the flush directly from ext4.  Unfortunately, where there _are_
> regressions they seem rather large, which makes this approach (as implemented,
> anyway) less attractive.  Perhaps there is a better way to do it?

Hmm, not much chatter for two weeks.  Either I've confused everyone with the
humongous spreadsheet, or ... something?

I've performed some more extensive performance and safety testing with the
fsync coordination patch.  The results have been merged into the spreadsheet
that I linked to in the last email, though in general the results have not
really changed much at all.

I see two trends happening here with regards to comparing the use of jbd2 to
coordinate the flushes vs. measuring and coodinating flushes directly in ext4.
The first is that for loads that most benefit from having any kind of fsync
coordination (i.e. storage with slow flushes), the jbd2 approach provides the
same or slightly better performance than the direct approach.  However, for
storage with fast flushes, the jbd2 approach seems to cause major slowdowns
even compared to not changing any code at all.  To me this would suggest that
ext4 needs to coordinate the fsyncs directly, even at a higher code maintenance
cost, because a huge performance regression isn't good.

Other people in my group have been running their own performance comparisons
between no-coordination, jbd2-coordination, and direct-coordination, and what
I'm hearing is tha the direct-coordination mode is slightly faster than jbd2
coordination, though either are better than no coordination at all.  Happily, I
haven't seen an increase in fsck complaints in my poweroff testing.

Given the nearness of the merge window, perhaps we ought to discuss this on
Monday's ext4 call?  In the meantime I'll clean up the fsync coordination patch
so that it doesn't have so many debugging knobs and whistles.

Thanks,

--D
