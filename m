From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Severe slowdown caused by jbd2 process
Date: Fri, 21 Jan 2011 20:34:15 -0500
Message-ID: <20110122013415.GN3043@thunk.org>
References: <1295568782.2459.29.camel@tybalt>
 <20110121013140.GA8949@dhcp231-156.rdu.redhat.com>
 <1295601083.5799.3.camel@tybalt>
 <20110121125922.GB8949@dhcp231-156.rdu.redhat.com>
 <20110121140306.GA11313@dhcp231-156.rdu.redhat.com>
 <1295620109.22802.1.camel@tybalt>
 <20110121143145.GB11313@dhcp231-156.rdu.redhat.com>
 <20110121235641.GM3043@thunk.org>
 <4D3A2EC6.3020700@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	Jon Leighton <j@jonathanleighton.com>,
	linux-ext4@vger.kernel.org
To: torn5 <torn5@shiftmail.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48433 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab1AVBeT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jan 2011 20:34:19 -0500
Content-Disposition: inline
In-Reply-To: <4D3A2EC6.3020700@shiftmail.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 22, 2011 at 02:11:34AM +0100, torn5 wrote:
> I think that currently the fsyncs have a double meaning: they are
> used to make a filesystem operation happen before another filesystem
> operation, and to make a filesystem operation happen before a
> network operation. I don't think the second case can be speeded up
> (there can be a distributed transaction involved) 

It all depends on the application.  If you have many simultanous
transactions with different peers (say, SMTP for example), you could
just simply have the server batch multiple commits for multiple
incoming mail messages into the database before sending allowing
sending 200 acknowledgement which means, "yes I have this mail
message" to the various MTA's.  In other cases, if you are sending a
huge number of transactions from one server to another, maybe you
change things so that you transactions get acknowledged batches.  So
that might require an application protocol change, but it could be
done (if you have control of both the ends of the connection).

At the end of the day, though, if the application protocol design is
stupid, there's not much you can do.  That's like the difference
between XMODEM (for those who are old enough to remember it), and
ZMODEM (which had a sliding window acknowledgement system).

> Do you think nobarrier + data=journal would provide the same
> guarantees of barrier and almost the same performances of nobarrier
> (for random I/O)?

No.  Fundamentally barriers are bout making sure the data actually
hits the disk platters.  If you don't use a barrier operation, the
hard drive could potential delay writing disk sectors for seconds,
perhaps even minutes, in order to try to optimize disk head movements.
So if you have a sudden power drop, without barriers, even though you
*think* you had sent the commit to disk, and had told your network
partner, "I have it, and commit not to lose it", if you drop power at
precisely the wrong time, data could be lost.  Using data=journal
doesn't change this fact.

> But then there should be a mount option (barriersonlyjournal?) so
> that barriers are only generated every so many seconds and only for
> committing a big transaction to the journal, while applications'
> fsyncs would be made with nobarriers.

In general, an fsync() has to force a journal commit.  There are a few
cases where an fdatasync() could avoid needing a journal commit, but
usually when application uses fdatasync(), they really want to assure
that their data writes are really pushed out to the disk platter, and
a barriersonlyjournal command would defeat that need for a database
which is trying to provide ACID semantics.

      	 					- Ted

