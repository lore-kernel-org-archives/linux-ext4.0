From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] statx: Add a system call to make enhanced file info
 available
Date: Thu, 5 May 2016 08:56:02 +1000
Message-ID: <20160504225601.GZ26977@dastard>
References: <20160429125736.23636.47874.stgit@warthog.procyon.org.uk>
 <20160429125743.23636.85219.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-afs@vger.kernel.org,
	linux-nfs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160429125743.23636.85219.stgit@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Apr 29, 2016 at 01:57:43PM +0100, David Howells wrote:
>  (4) File creation time (st_btime*), data version (st_version), inode
>      generation number (st_gen).
> 
>      These will be returned if available whether the caller asked for them or
>      not.  The corresponding bits in st_mask will be set or cleared as
>      appropriate to indicate a valid value.

IMO, exposing the inode generation number to anyone is a potential
security problem because they are used in file handles.

Most file handles provided by filesystems are simply an encoding of
the inode number + generation number, plus maybe the ino+gen of the
parent dir if the NFS server is configured to do this. This makes it
trivial for an attacker to guess what the likely generation numbers
are going to be for inode numbers surrounding any given inode, hence
greatly reducing the search space for guessing valid file handles.

We've known this to be a problem for a long time - file handles are
not cryptographically secure, so exposing information like this by
default make guessing handles successfully almost trivial for many
filesystems.

In the latest XFS filesystem format, we randomise the generation
value during every inode allocation to make it hard to guess the
handle of adjacent inodes from an existing ino+gen pair, or even
from life time to life time of the same inode. We don't use a secure
random number generator (prandom_u32()) so it's still possible to
guess with enough trial and observation. However, it makes it
several orders of magnitude harder to guess and requires knowledge
of inode allocation order to guess correctly once the random number
sequence has been deduced and so makes brute force the only real
option for guessing a valid handle for an inode.

However, this is definitely a problem for the older format where
each cluster of inodes was initialised with the same seed at cluster
allocation time and the generation number was simply incremented for
each life time. Most filesystems use a similar method for seeding
and incrementing generation numbers, so once the generation numbers
are exposed it makes handles trivial to calculate successfully.

>      If the caller didn't ask for them, then they may be approximated.  For
>      example, NFS won't waste any time updating them from the server, unless
>      as a byproduct of updating something requested.

I would suggest that exposing them from the NFS server is something
we most definitely don't want to do because they are the only thing
that keeps remote users from guessing filehandles with ease....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
