From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Add a norecovery option to ext3/4?
Date: Tue, 10 Apr 2007 18:04:55 -0400
Message-ID: <461C0A07.6080604@cfl.rr.com>
References: <20070409000556.GA13980@implementation> <461A5F13.7040705@cfl.rr.com> <461A760B.1040103@redhat.com> <461BDD48.2000904@cfl.rr.com> <461BE2FB.5090101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	joern@lazybastard.org, tytso@mit.edu
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753957AbXDJWE1@vger.kernel.org>
In-Reply-To: <461BE2FB.5090101@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:
> except in the case of a journaling filesystem, where the journal in
> theory obviates the need for a fsck.  (yes, I know... fsck still has a
> place...)  But, fsck is largely meaningless until the journal has been
> recovered anyway (fs can only be consistent if it includes uncommited
> transactions in the journal), so isn't this new territory?

In a way, yes, this is new territory, but not entirely.  It is merely an 
extension of the existing system, and in the existing system the ro flag 
clearly meant do not write to the disk.  You don't extend an existing 
system by breaking old expectations.

> I'm admittedly playing devil's advocate here :)  but what, in the
> historical non-journalled filesystem case, would be writing to the
> device anyway, if all IO from the vfs were stopped?  Without the
> journal, isn't vfs-ro the same as bdev-ro, largely?

Yes, they were the same, and that is my point: users got used to using 
ro to indicate they did not want the block device written to, and were 
doing this long before there was a read only flag on the block device 
itself.  Excepting journal playback from this breaks user expectation 
and leads to data loss.

> As a counter example, if you had a filesystem which saves it's last
> mount time in the superblock; should a ro mount not update that time?
> (perhaps not, depending on how that timestamp was intended to be used.)

This is another good example arguing against writing to the disk.  Ext2 
would write to the super block to mark the volume as dirty and update 
the mount count used to decide when it was time for a fsck.  It did not 
do this if mounted read only because it understood that the meaning of 
the ro flag was not to write to the disk.  Likewise, it did not update 
file's atime.  If ro just meant "don't let me write to files" then the 
atime would be updated even when mounted read only.

> You might not damage the underlying filesystem, but you could sure go
> off in the weeds trying to read it, if you stumbled upon some
> half-updated metadata... so while it may be safe for the filesystem, I'm
> not convinced that it's safe for the host reading the filesystem.

And this is exactly what you get without journals.  You mount a damaged 
filesystem read only, you take what you can get.  You might get bad 
data, or fail to open or read certain files or parts of files, but you 
knew for sure that you wouldn't cause any more damage to the data on 
disk, and you could run a fsck or defrag or partimage or anything else 
to read and/or modify the disk.

> but it's already changed, and has been in linux since ext3 came on the
> scene.  mount -o ro -does- replay the journal.  Surely readonly does not
> imply that we want a corrupted filesystem if it was not cleanly shut
> down.  I suppose there is a place for the argument that a readonly mount
> of a journaled filesystem -should- present a recovered filesystem to the
> user, without actually recovering the log to disk.  I guess to me, it
> hardly seems worth the effort, as the precedent is long set for doing
> recovery on a read-only mount.

Just because a bug has been around for a long time does not mean it is 
not a bug.  In the pre-journal world, if you mounted a dirty filesystem 
read only you expected the possibility of errors reading it.  Why should 
that expectation not hold true with journals?  It might be nice to do 
the journal playback in ram or otherwise without writing to the disk, 
but as far as the user setting the ro flag cares, they just want you not 
to update the disk and if there are inconsistencies that cause errors, 
then you need to fsck or mount rw.
