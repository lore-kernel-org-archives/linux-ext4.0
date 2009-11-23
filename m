From: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: i_version, NFSv4 change attribute
Date: Mon, 23 Nov 2009 13:37:44 -0500
Message-ID: <1259001464.8700.36.camel@localhost>
References: <20091122222047.GB21944@fieldses.org>
	 <20091123114831.GA2532@thunk.org> <20091123164445.GB3292@fieldses.org>
	 <1258999879.8700.17.camel@localhost>  <20091123181951.GB5583@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20091123181951.GB5583@fieldses.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2009-11-23 at 13:19 -0500, J. Bruce Fields wrote: 
> On Mon, Nov 23, 2009 at 01:11:19PM -0500, Trond Myklebust wrote:
> > On Mon, 2009-11-23 at 11:44 -0500, J. Bruce Fields wrote: 
> > > If the side we want to optimize is the modifications, I wonder if we
> > > could do all the i_version increments on *read* of i_version?:
> > > 
> > > 	- writes (and other inode modifications) set an "i_version_dirty"
> > > 	  flag.
> > > 	- reads of i_version clear the i_version_dirty flag, increment
> > > 	  i_version, and return the result.
> > > 
> > > As long as the reader sees i_version_flag set only after it sees the
> > > write that caused it, I think it all works?
> > 
> > That probably won't make much of a difference to performance. Most NFSv4
> > clients will have every WRITE followed by a GETATTR operation in the
> > same compound, so your i_version_dirty flag will always immediately get
> > cleared.
> 
> I was only thinking about non-NFS performance.

I would think that running a high performance database _and_ NFS server
on the same machine would tend to be very much of a corner case anyway.
In most setups I'm aware of, the database and NFS server tend to be
completely separate machines.

> > The question is, though, why does the jbd2 machinery need to be engaged
> > on _every_ write?
> 
> Is it?

See Ted's email. As I read it, his concern was that if they allow people
to reduce the a/m/c/time resolution, then the i_version would still
force them to dirty the inode on every write...

Trond

