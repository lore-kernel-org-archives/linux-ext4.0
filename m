From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Add a norecovery option to ext3/4?
Date: Tue, 10 Apr 2007 14:18:19 -0500
Message-ID: <461BE2FB.5090101@redhat.com>
References: <20070409000556.GA13980@implementation> <461A5F13.7040705@cfl.rr.com> <461A760B.1040103@redhat.com> <461BDD48.2000904@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	joern@lazybastard.org, tytso@mit.edu
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196AbXDJTVa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Apr 2007 15:21:30 -0400
In-Reply-To: <461BDD48.2000904@cfl.rr.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Phillip Susi wrote:
> Eric Sandeen wrote:
>> It means the filesystem should not be writeable when it is mounted.
>> This is not the same as saying that the filesystem itself should do no
>> IO in the course of making that read-only mount available.
> 
> I disagree.
> 
>> I respectfully disagree, see above.
> 
> Based on what?  I argue that historically the primary use of the read 
> only mount flag was to prevent the underlying filesystem from being 
> modified and possibly damaged further before it can be fsck'ed.  It 
> became common practice to mount the root filesystem read only and run a 
> fsck on it, then either reboot or remount read-write depending on if 
> fsck had to make changes.

except in the case of a journaling filesystem, where the journal in
theory obviates the need for a fsck.  (yes, I know... fsck still has a
place...)  But, fsck is largely meaningless until the journal has been
recovered anyway (fs can only be consistent if it includes uncommited
transactions in the journal), so isn't this new territory?

I guess looking to the man page for clarification of intent is no help...

              ro  Mount the file system read-only.


> In this context, the meaning of the read only mount flag was clear: do 
> not write to the disk.  If you wish to redefine it as "do not allow me 
> write access to any files" then you fly in the face of convention, and 
> the onus is on you to provide a compelling argument to make such a change.

I'm admittedly playing devil's advocate here :)  but what, in the
historical non-journalled filesystem case, would be writing to the
device anyway, if all IO from the vfs were stopped?  Without the
journal, isn't vfs-ro the same as bdev-ro, largely?

As a counter example, if you had a filesystem which saves it's last
mount time in the superblock; should a ro mount not update that time?
(perhaps not, depending on how that timestamp was intended to be used.)

>> In that case you are mounting the same filesystem uner 2 different
>> operating systems simultaneously, which is, and always has been, a
>> recipe for disaster.  Flagging the fs as "mounted already" would
>> probably be a better solution, though it's harder than it sounds at
>> first glance.
> 
> No, it has not been.  Prior to poorly behaved journal playback, it was 
> perfectly safe to mount a filesystem read only even if it was mounted 
> read-write by another system ( possibly fsck or defrag ).  You might not 
> read the correct data from it, but you would not damage the underlying 
> data simply by mounting it read-only.

You might not damage the underlying filesystem, but you could sure go
off in the weeds trying to read it, if you stumbled upon some
half-updated metadata... so while it may be safe for the filesystem, I'm
not convinced that it's safe for the host reading the filesystem.

>> Under all conditions it should be safe to mount a read-only block
>> device, but that is not the same as mounting a filesystem read-only.
> 
> Historically it was the same thing.  I see no reason to change that 
> behavior, do you?

but it's already changed, and has been in linux since ext3 came on the
scene.  mount -o ro -does- replay the journal.  Surely readonly does not
imply that we want a corrupted filesystem if it was not cleanly shut
down.  I suppose there is a place for the argument that a readonly mount
of a journaled filesystem -should- present a recovered filesystem to the
user, without actually recovering the log to disk.  I guess to me, it
hardly seems worth the effort, as the precedent is long set for doing
recovery on a read-only mount.

-Eric
