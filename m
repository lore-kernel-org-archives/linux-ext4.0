From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC 0/3] Introduce new O_HOT and O_COLD flags
Date: Thu, 19 Apr 2012 22:45:11 -0400
Message-ID: <20120420024511.GB24486@thunk.org>
References: <1334863211-19504-1-git-send-email-tytso@mit.edu>
 <4F90AD29.9030501@dreamhost.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Alex Elder <elder@dreamhost.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F90AD29.9030501@dreamhost.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 19, 2012 at 07:26:17PM -0500, Alex Elder wrote:
> 
> The scenario I'm thinking about is that users could easily request
> hot files repeatedly, and could thereby quickly exhaust all available
> speedy-quick media designated to serve this purpose--and that will
> be especially bad for those filesystems which base initial allocation
> decisions on this.

Sure, there will need to be some controls about this.  In the sample
implementation, it required CAP_SYS_RESOURCE or the uid or guid had to
match the res_uid/res_gid stored in the ext 2/3/4 superblock (this was
there already to allow certain users or groups access to the reserved
free space on the file system).  I could imagine other implementations
using a full-fleged quota system.

> I would prefer to see something like this communicated via fcntl().
> It already passes information down to the underlying filesystem in
> some cases so you avoid touching all these create interfaces.

Well, programs could also set or clear these flags via fcntl's
SETFL/GETFL.  The reason why I'm interested in having this flexibility
is so that it's possible for applications to pass in these flags at
open time or via fcntl.

> The second problem is that "hot/cold" is a lot like "performance."
> What is meant by "hot" really depends on what you want.  I think it
> most closely aligns with frequent access, but someone might want
> it to mean "very write-y" or "needing exceptionally low latency"
> or "hammering on it from lots of concurrent threads" or "notably
> good looking."  In any case, there are lots of possible hints
> that a filesystem could benefit from, but if we're going to start
> down that path I suggest "hot/cold" is not the right kind of
> naming scheme we ought to be using.

There are two ways we could go with this.  One is to try to define
what the semantics of the performance flags that the application
program might want to request, very precisely.  Going down that path
leads to something like what the T10 folks have done, with multiple
4-bit slider specifying write-frequency, read-frequency, retention
levels, etc. in great exhaustive detail.

The other approach is to leave things roughly undefined, and accept
the fact that applications which use this will probably be specialized
applications that are very much aware of what file system they are
using, and just need to pass minimal hints to the application in a
general way, and that's the approach I went with in this O_HOT/O_COLD proposal.

I suspect that HOT/COLD is enough to go quite far even for tiered
storage; maybe at some point we will want some other, more
fine-grained interface where an application program can very precisely
dial in their requirements in a T10-like fashion.  Perhaps.  But I
don't think having a simple O_HOT/O_COLD interface precludes the
other, or vice versa.  In fact, one advantage with sticking with
HOT/COLD is that there's much less chance of bike-shedding, with
people arguing over what a more fine-grained interface might look like.

So why not start with this, and if we need to use something more
complex later, we can cross that bridge if and when we get to it?  In
the meantime, I think there are valid uses of this simple, minimal
interface in the case of a local disk file system supporting a cluster
file system such as Hadoopfs or TFS.  One of the useful things that
came out of the ext4 workshop where we got to talk to developers from
Taobao was finding out how much their interests matched with some of
the things we've talked about doing at Google to support our internal
customers.

	       	      	    	 	   - Ted
