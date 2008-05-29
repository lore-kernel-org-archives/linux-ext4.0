From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: fdatasync/barriers (was : [Bug 421482] Firefox 3 uses fsync excessively)
Date: Thu, 29 May 2008 10:08:44 -0700
Message-ID: <OF96824E74.387F8AD7-ON88257458.005D1BC3-88257458.005E2EC4@us.ibm.com>
References: <20080526202210.GA29046@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Cc: Andrew Morton <akpm@linux-foundation.org>,
	=?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Theodore Tso <tytso@MIT.EDU>
To: Jamie Lokier <jamie@shareable.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56068 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbYE2RIw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 May 2008 13:08:52 -0400
In-Reply-To: <20080526202210.GA29046@shareable.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Here's a thought for someone implementing fdatasync().  If a database
> uses O_DIRECT writes (typically with aio), then wants data which it's
> written to be committed to the hard disk platter, and the filesystem
> is mounted "barrier=1" - should it call fdatasync()?  Should that emit
> the barrier?  If another application uses normal (not O_DIRECT)
> writes, and then _is delayed_ so long that kernel writeback occurs and
> all cache is clean, and then calls fdatasync(), should that call emit
> a barrier in that case?  (Answers imho: yes and yes).

I don't get it.  What would be the value of emitting the barrier?

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems

