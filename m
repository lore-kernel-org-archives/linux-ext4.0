From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Date: Wed, 11 Jul 2007 16:04:30 -0400
Message-ID: <20070711200430.GF4138@fieldses.org>
References: <1183275424.4010.126.camel@localhost.localdomain>
	<20070710163038.ceb2ae94.akpm@linux-foundation.org>
	<1184105380.3759.65.camel@localhost.localdomain>
	<20070710182237.e2f88bf3.akpm@linux-foundation.org>
	<18068.19667.942363.686858@notabene.brown>
	<18068.25879.745638.343290@notabene.brown>
	<1184164086.12154.15.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org, cmm@us.ibm.com,
	linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <nfsv4-bounces@linux-nfs.org>
Content-Disposition: inline
In-Reply-To: <1184164086.12154.15.camel@kleikamp.austin.ibm.com>
List-Unsubscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=unsubscribe>
List-Archive: <http://linux-nfs.org/pipermail/nfsv4>
List-Post: <mailto:nfsv4@linux-nfs.org>
List-Help: <mailto:nfsv4-request@linux-nfs.org?subject=help>
List-Subscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=subscribe>
Sender: nfsv4-bounces@linux-nfs.org
Errors-To: nfsv4-bounces@linux-nfs.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 11, 2007 at 09:28:06AM -0500, Dave Kleikamp wrote:
> On Wed, 2007-07-11 at 15:05 +1000, Neil Brown wrote:
> > It just occurred to me:
> > 
> >  If i_version is 64bit, then knfsd would need to be careful when
> >  reading it on a 32bit host.  What are the locking rules?
> 
> How does knfsd use i_version?  I would think that if all it was doing
> was to compare (i_version == previous_version)

That's correct.  (Though it's the client that's doing the comparison,
actually--the server is just reporting the value.)

> then locking wouldn't really matter.  Well, theoretically,
> previous_version could be 0x100000000, and i_version could be
> 0x1ffffffff, knfsd checks the high word, then ext4 updates i_version
> to 0x200000000, then knfsd checks the low word, detecting no change.
> How likely is this?

The choice of upper word in your example is arbitrary, but other than
that I believe your example is essentially the only one.  So this would
only happen when *both*

	- the read of the new value of the low word happens precisely
	  2^32 i_version updates after the word was read on the client's
	  previous cache revalidation, and
	- the value of i_version itself is close enough to a 32-bit
	  boundary that wraparound can happen between the reads of the
	  high and low words.

> (I don't understand why i_version even needs to be 64 bits in the
> first place.)

A 32-bit i_version could in theory wrap pretty quickly, couldn't it?
That's not a problem in itself--the problem would only arise if two
subsequent client queries of the change attribute happened a multiple of
2^32 i_version increments apart.

This is more likely than the previous scenario, but still very unlikely.
I would have guessed that even in situations with a very high rate of
updates and a low rate of client revalidations, the chance of two
revalidations happening exactly 2^32 updates apart would still be no
more than 1 in 2^32.  (Could odd characteristics of the workloads (like
updates that tend to happen in power-of-2 groups?) make it any more
likely?)

I'd be happier if ext4 at least allowed the possibility of 64 bits in
the future.  And there's always the chance someone would find a use for
an i_version that was nondecreasing, even if nfs didn't care.

> >  Presumably it is only updated under i_mutex protection, but having to
> >  get i_mutex to read it would seem a little heavy handed.
> 
> How does knfsd protect itself from the inode changing after i_version is
> checked?  Is any locking being done otherwise?

If the client always requests the change attribute before reading, and
the i_version is always updated after data is modified, I think we're
OK.  Admittedly this is a little subtle.

--b.
