From: Jan Kara <jack@suse.cz>
Subject: Re: RT/ext4/jbd2 circular dependency
Date: Thu, 13 Nov 2014 20:06:44 +0100
Message-ID: <20141113190644.GA12075@quack.suse.cz>
References: <CANGgnMbQmsdMDJUx7Bop9Xs=jQMmAJgWRjhXVFUGx-DwF=inYw@mail.gmail.com>
 <544940EF.7090907@windriver.com>
 <alpine.DEB.2.11.1410261516020.5308@nanos>
 <544E7144.4080809@windriver.com>
 <alpine.DEB.2.11.1410291854090.5308@nanos>
 <54513BDA.1050804@windriver.com>
 <alpine.DEB.2.11.1410292013510.5308@nanos>
 <20141029231916.GD5000@thunk.org>
 <alpine.DEB.2.11.1410302204570.5308@nanos>
 <20141030232437.GF31927@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Chris Friesen <chris.friesen@windriver.com>,
	Austin Schuh <austin@peloton-tech.com>, pavel@pavlinux.ru,
	"J. Bruce Fields" <bfields@fieldses.org>,
	linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
	rt-users <linux-rt-users@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-rt-users-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141030232437.GF31927@thunk.org>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 30-10-14 19:24:37, Ted Tso wrote:
> On Thu, Oct 30, 2014 at 10:11:26PM +0100, Thomas Gleixner wrote:
> > 
> > That's a way better explanation than what I saw in the commit logs and
> > it actually maps to the observed traces and stackdumps.
> 
> I can't speak for Jan, but I suspect he didn't realize that there was
> a problem.  The commit description in b34090e5e2 makes it clear that
> the intent was a performance improvement, and not an attempt to fix a
> potential deadlock bug.
  Yeah, correct. When I wrote b34090e5e2 I did that because I have realized
that journal reservations would create similar deadlock opportunity as
Chris has observed. I hadn't realized the problem is already in the code :)

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
