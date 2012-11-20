From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v1 0/9] fs: fix up AIO+DIO+O_SYNC to actually do the sync part
Date: Tue, 20 Nov 2012 14:05:40 -0500
Message-ID: <x494nkkjdrv.fsf@segfault.boston.devel.redhat.com>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
	<x49pq38jquh.fsf@segfault.boston.devel.redhat.com>
	<20121120185700.GD8740@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, tytso@mit.edu, david@fromorbit.com, bpm@sgi.com,
	viro@zeniv.linux.org.uk, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, hch@infradead.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab2KTTFy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Nov 2012 14:05:54 -0500
In-Reply-To: <20121120185700.GD8740@blackbox.djwong.org> (Darrick J. Wong's
	message of "Tue, 20 Nov 2012 10:57:00 -0800")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Darrick J. Wong" <darrick.wong@oracle.com> writes:

>> Would you like to push the set in, or should I post the patches I've
>> got?  Doesn't matter to me, just let me know.
>
> Since you're the original author of most of the patches in my set anyway, would
> you mind simply picking up my blockdev patch for your next submission?  It
> sounds like you're a little further along in the testing than I am anyway.

Not at all.  I'll address the comments so far and get another version
out tomorrow.

Cheers,
Jeff
