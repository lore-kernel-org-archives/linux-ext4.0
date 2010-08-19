From: Ted Ts'o <tytso@mit.edu>
Subject: Re: buggy EOFBLOCKS_FL handling
Date: Thu, 19 Aug 2010 13:11:28 -0400
Message-ID: <20100819171128.GA3468@thunk.org>
References: <E1OlvNi-00063m-09@tytso-glaptop>
 <FB932B24-52F7-4C97-9BF6-58A78DFA5FBF@dilger.ca>
 <20100819144432.GA23345@thunk.org>
 <4C6D63D5.8030600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49452 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab0HSRLb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Aug 2010 13:11:31 -0400
Content-Disposition: inline
In-Reply-To: <4C6D63D5.8030600@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 19, 2010 at 12:03:17PM -0500, Eric Sandeen wrote:
> 
> Maybe e2fsck could tally these and after I dunno, 10 or 20 or so, ask
> whether it should keep flagging them or just go into "yes" mode for
> the rest of the inodes with that problem?

Maybe.  I'd need to do some testing to see what percentage of the
"takes hours longer" is caused by needing to fix truly vast numbers of
inodes, versus the fact that writing the e2fsck log file was taking a
huge amount of time.  I'm not sure, asking the user, "I've tried
fixing 100 of these inodes, and it looks like there are runs more,
want to skip checking for the rest" is all that great (i.e., a "go
into automatic 'no' mode for this question").

The other possibility is that I'd make it configurable by e2fsck.conf,
but change the default to be "ignore this fs error", and then 2-3
years later, change the default to "check for this fs error", without
actually requiring most users to have a knob in their e2fsck.conf
file.

							- Ted
