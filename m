From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH, RFC 0/3] *** SUBJECT HERE ***
Date: Tue, 3 Aug 2010 12:07:03 -0700
Message-ID: <20100803190703.GA15416@mail.oracle.com>
References: <1280851315-9167-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com, Keith Maanthey <kmannth@us.ibm.com>,
	John Stultz <johnstul@us.ibm.com>,
	Eric Whitney <eric.whitney@hp.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:33809 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174Ab0HCTID (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Aug 2010 15:08:03 -0400
Content-Disposition: inline
In-Reply-To: <1280851315-9167-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 03, 2010 at 12:01:52PM -0400, Theodore Ts'o wrote:
> The first patch in this patch series hasn't changed since when I had
> last posted it, but I'm including it again for the benefit of the folks
> on ocfs2-dev.

	Thanks!

> Thanks to some work done by Eric Whitney, when he accidentally ran the
> command "mkfs.ext4 -t xfs", and created a ext4 file system without a
> journal, it appears that main scalability bottleneck for ext4 is in the
> jbd2 layer.

	I'm certain, as you've surmised, that a lot of this affects
ocfs2 as well.  jbd2 improvements make both filesystems better.
	
> This patch series removes all exclusive spinlocks when starting and
> stopping jbd2 handles, which should improve things even more.  Since
> OCFS2 uses the jbd2 layer, and the second patch in this patch series
> touches ocfs2 a wee bit, I'd appreciate it if you could take a look and
> let me know what you think.  Hopefully, this should also improve OCFS2's
> scalability.

	The atomic changes make absolute sense.  Ack on them.  I had two
reactions to the rwlock: first, a lot of your rwlock changes are on
the write_lock() side.  You get journal start/stop parallelized, but
what about all the underlying access/dirty/commit paths?  Second,
rwlocks are known to behave worse than spinlocks when they ping the
cache line across CPUs.
	That said, I have a hunch that you've tested both of the above
concerns.  You mention 48 core systems, and clearly if cachelines were
going to be a problem, you would have noticed.  So if the rwlock changes
are faster on 48 core than the spinlocks, I say ack ack ack.
	From the ocfs2 perspective, the code is perfectly safe, and any
speedup you see on ext4 ought to be mirrored on ocfs2.

Joel

-- 

A good programming language should have features that make the
kind of people who use the phrase "software engineering" shake
their heads disapprovingly.
	- Paul Graham

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
