From: Daniel Phillips <phillips@phunq.net>
Subject: [RFC] A better solution to the HTree telldir problem
Date: Mon, 21 Jul 2008 14:11:51 -0700
Message-ID: <200807211411.52007.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org, ext2-devel@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755561AbYGUVMO@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

After all these years, I may have finally noticed a better approach to
the NFS directory cookie problem in HTree.

Let me summarize the issue for those not privy to its horrors:

 * The Single Unix Specification defines semantics for directory
   traversal whereby it is permitted to create and delete directory
   entries simultaneously with a process that reads the directory
   entries and does something with them.

 * SUS specifies that a sequence of all the files in a directory will
   be returned by the readdir call, and though it leaves unspecified
   whether a simultaneously deleted or created directory entry will
   appear in the sequence, it does seem to require that no entry appear
   more than once and that no entry that existed before the during the
   entire directory traversal be omitted.  (This is not directly stated,
   but can be inferred from the definition of directory stream.)
   http://www.opengroup.org/onlinepubs/009695399/functions/readdir.html

The implied requirement that no pre-existing directory entry be returned 
multiple times or be omitted poses problems for modern btree directory 
indexing schemes, which like to move batches of entries around on disk 
as new entries are created or old ones deleted.  Whatever the indexing 
scheme, it is necessary to come up with some stable enumeration of 
directory entries that satisfies the (implied) SUS requirement.  Enter 
NFS with a monumental design blunder that makes this exceptionally 
difficult to achieve for any modern directory indexing scheme.  You
summarize the issues authoritavely here:

   http://lkml.org/lkml/2007/4/7/159

One nit: NFS v2 provides 31 bits worth of telldir cookie, not 32.  (But
you knew that)

I see that you have been busy explaining the gory details to Chris, as
you once explained them to me:

   http://oss.oracle.com/pipermail/btrfs-devel/2008-January/000460.html

The code to deal with the telldir cookie problem in HTree was written by 
one Theodore Y Ts'o in 2002, and consists of some hundreds of lines of 
clever RB tree hacking that miraculously works so reliably that none of 
the tens of millions of Ext3 users has had any complaint for years.  Now 
six years after the fact, I think there is a nicer way.

This is something of a duh: if HTree refrains from splitting leaves 
while a directory traversal is in progress then a simple linear 
traversal can be used in classic Ext2/UFS fashion, with the logical 
file address of each directory entry serving as the telldir cookie.

The idea is to disable leaf splitting during directory traversal and use 
an alternate leaf overflow mechanism in its place.  To handle a create 
into a full leaf when splitting is disabled, a new leaf block is 
created having the same hash index as the current one and inserted 
before the full leaf in the hash tree to hold the new entry and any 
subsequent creates into the same hash bucket.  The lookup probe has to 
be modified slightly to traverse all leaves with the same hash index.
Or maybe this already works.

HTree could opportunistically re-distribute the entries later when no 
directory listing is in progress, or it could just leave things as they 
are.  The fallback is quite unlikely to occur in practice, and the 
alternative storage format is only very slightly less efficient to 
process on lookup, and does not consume any extra space.

A possible heuristic for disabling node splitting: disable on each 
opendir until a matching number of closedirs are received, unless there 
was a telldir in which case it stays disabled until a following readdir
returns NULL, followed by matching closedirs.

A new feature bit would be needed should the new overflow code path ever 
be hit for a given directory (unlikely...) in which case an older 
HTree-enabled ext3 would fall back to linear scan if somebody manages 
to write a volume under an ungraded kernel then reboot to an older 
kernel.  There would also be a flag in the HTree index root block that
does not affect the volume as a whole.  I think that the way we did it,
any unknown HTRee flag just causes a fallback to linear scan.  (If so,
this would be a nice example of forward compatibility gone right.)

Now the sticky bit where the brain damaged NFS semantics really get to
take their best kick at us.  This mechanism has to work across NFS server
reboots.  We can notice from the flag in the Htree index root block that 
a particular directory went into an "NFS mode" that was never properly
completed.  But how can we know when to take the directory out of NFS
mode and get on with a slightly more efficient version of life?  Well.

There are two kinds of NFS servers available on Linux: 1) kernel and
2) userspace.  The kernel version is... part of the kernel, and so we
can always know when it has mounted our volume.  We could give it a
minute or two to reconnect to the client that was doing the readdir,
then assume the readdir will never resume.  Otherwise, if the readdir
does resume in that time, the client will get exactly the SUS semantics
and things will work properly even if the server reboots again.

The user space server is another story.  I have no idea how to detect
its presence, and I doubt we need to care, because it already suffers
from fatal flaws such as:

  "some awkwardnesses in the semantics (for instance, moving a file
  to a different directory will render its file handle invalid)"
  http://packages.debian.org/sid/nfs-user-server

Nobody should use this server, and if they do, they simply risk
dropouts and repeated filenames in a directory listing if they go out
of their way to abuse it.  What you would have to do to break the above
heuristic for the user space NFS server:

  * NFS client starts a directory listing
  * Server reboots after retrieving some dirents
  * NFS client creates some new files in the directory, splitting a
    btree block
  * Client side ls omits or repeats a few names.  Sob.
  * Moral of the story is: use knfsd if you want your NFS server to
    respect reboot semantics properly, or to operate properly at all.

If the new semantics are acceptable, the payoff for adopting this simpler
method is:

  * Can use a more efficient HTree hash because we do not need to be so
    paranoid about bucket levelling to avoid rare cases that might break
    the RB tree approach.

  * We get to use the nice shiny alternative hash mechanism that we put
    considerable effort into building but so far have never used.

  * Considerably more efficient directory traversal.

  * Delete will now happen in physical create order and therefore not
    thrash the inode table, which is a problem that HTree can currently
    hit with large directories ant tight cache.

  * Several hundred lines of special purpose code removed.  (Replaced by
    maybe 50 different lines of special purpose code.)

Drawbacks:

  * Adds a new feature to knfsd to force it to advertise its presence
    to filesystems.  On the other hand, this might be seen as a feature
    useful to other filesystems (btrfs and jfs come to mind).

  * Breaks the user space NFS server worse than it already is.  But it
    is already fatally broken, so do we care?

Regards,

Daniel
