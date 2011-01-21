From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Severe slowdown caused by jbd2 process
Date: Fri, 21 Jan 2011 18:56:41 -0500
Message-ID: <20110121235641.GM3043@thunk.org>
References: <1295568782.2459.29.camel@tybalt>
 <20110121013140.GA8949@dhcp231-156.rdu.redhat.com>
 <1295601083.5799.3.camel@tybalt>
 <20110121125922.GB8949@dhcp231-156.rdu.redhat.com>
 <20110121140306.GA11313@dhcp231-156.rdu.redhat.com>
 <1295620109.22802.1.camel@tybalt>
 <20110121143145.GB11313@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jon Leighton <j@jonathanleighton.com>, linux-ext4@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56564 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816Ab1AUX4o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jan 2011 18:56:44 -0500
Content-Disposition: inline
In-Reply-To: <20110121143145.GB11313@dhcp231-156.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 21, 2011 at 09:31:45AM -0500, Josef Bacik wrote:
> 
> Yup, whatever you are doing in your webapp is making your database do lots of
> fsyncs, which is going to suck.  If you are on a battery backed system or just
> don't care if you lose your database and rather it be faster you can mount your
> ext4 fs with -o nobarrier.  Thanks,

Note that if you don't use -o barrier on ext3, or use -o nobarrier on
ext4, the chance of significant file system damage if you have a power
failure, since without the barrier, the file system doesn't wait for
disk to acknowledge that the data has hit the barrier.  The problem is
that if you are using a barrier operation, you're not going to be able
to get more than about 30-50 non-trivial[1] fsync's per second on a
standard HDD; barriers are inherently slow.

[1] Where there was some kind of data write between the two fsync's.
You may be able to get faster back-to-back fsync() with no intervening
data writes, but that's not terribly interesting.  :-)

A UPS should protect you against most of the dangers of not using
barriers.  The other choice is to be more intelligent with your coding
(and/or with your database choice) to avoid needing a huge number of
fsync's, as they are going to be costly.  If you can batch multiple
database operations under a single commit, for example, you should be
able to eliminate the need for so many fsync's.

		        	       	       - Ted


