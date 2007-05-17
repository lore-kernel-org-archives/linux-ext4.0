From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5][TAKE3] fallocate() implementation on i86, x86_64
	and powerpc
Date: Thu, 17 May 2007 07:10:44 -0500
Message-ID: <1179403844.13965.2.camel@kleikamp.austin.ibm.com>
References: <20070418130600.GW5967@schatzie.adilger.int>
	 <20070420135146.GA21352@amitarora.in.ibm.com>
	 <20070420145918.GY355@devserv.devel.redhat.com>
	 <20070424121632.GA10136@amitarora.in.ibm.com>
	 <20070426175056.GA25321@amitarora.in.ibm.com>
	 <20070515193722.GA3487@amitarora.in.ibm.com>
	 <20070515195421.GA2948@amitarora.in.ibm.com>
	 <20070515200359.GA5834@amitarora.in.ibm.com>
	 <20070516031626.GM85884050@sgi.com>
	 <1179318076.10313.6.camel@kleikamp.austin.ibm.com>
	 <20070516234036.GQ85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@osdl.org,
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
To: David Chinner <dgc@sgi.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070516234036.GQ85884050@sgi.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-05-17 at 09:40 +1000, David Chinner wrote:
> On Wed, May 16, 2007 at 07:21:16AM -0500, Dave Kleikamp wrote:
> > On Wed, 2007-05-16 at 13:16 +1000, David Chinner wrote:

> > > Please don't make this always happen. c/mtime updates should be dependent
> > > on the mode being used and whether there is visible change to the file. If no
> > > userspace visible changes to the file occurred, then timestamps should not
> > > be changed.
> > 
> > i_blocks will be updated, so it seems reasonable to update ctime.  mtime
> > shouldn't be changed, though, since the contents of the file will be
> > unchanged.
> 
> That's assuming blocks were actually allocated - if the prealloc range already
> has underlying blocks there is no change and so we should not be changing
> mtime either. Only the filesystem will know if it has changed the file, so I
> think that timestamp updates need to be driven down to that level, not done
> blindy at the highest layer....

Yes, I agree.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

