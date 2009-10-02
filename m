From: Neil Brown <neilb@suse.de>
Subject: Re: [patch 4/4] [ext3] Add journal guided resync (data=declared mode)
Date: Fri, 2 Oct 2009 11:51:59 +1000
Message-ID: <19141.23743.35576.466246@notabene.brown>
References: <20091001223929.120106893@sun.com>
	<20091001224021.757201872@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andreas Dilger <adilger@sun.com>
To: scjody@sun.com
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from scjody@sun.com on Thursday October 1
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thursday October 1, scjody@sun.com wrote:
> We introduce a new data write mode known as declared mode.  This is based on
> ordered mode except that a list of blocks to be written during the current
> transaction is added to the journal before the blocks themselves are written to
> the disk.  Then, if the system crashes, we can resync only those blocks during
> journal replay and skip the rest of the resync of the RAID array.
> 
> TODO: Add support to e2fsck.
> 
> TODO: The following sequence of events could cause resync to be skipped
> incorrectly:
>  - An MD array that supports RESYNC_RANGE is undergoing resync.
>  - A filesystem on that array is mounted with data=declared.
>  - The machine crashes before the resync completes.
>  - The array is restarted and the filesystem is remounted.
>  - Recovery resyncs only the blocks that were undergoing writes during
>    the crash and skips the rest.
> Addressing this requires even more communication between MD and ext and
> I need to think more about how to do this.

I have thought about this sort of thing from time to time and I have a
very different idea for how the necessary communication between the
filesystem and MD would happen.  I think my approach would completely
address this problem, and doesn't need to add any ioctls (which I am not
keen on).

I would add two new BIO_RW_ flags to be used with WRITE requests.
The first flag would mean "don't worry about a crash in the middle of
this write,  I will validate it after a crash before I rely on the
data."
The second would mean "last time I wrote data near here there might
have been a failure, be extra careful".

So the first flag would be used during normal filesystem writes for
every block that gets recorded in the journal, and for every write
to the journal.

The second flag is used after a crash to re-write every block that
could have been in-flight during the crash.  Some of those blocks will
be read from the journal and written to their proper home, other will
be read from wherever they are and written back there.

The first flag would be interpreted by MD as "don't set the bitmap
bit".  The second flag would be interpreted as "don't trust the
parity block, but do a reconstruct-write".

With this scheme you would still need a write-intent-bitmap on the MD
array, but no bits would ever be set if the filesystem were using the
new flags, so no performance impact.  You probably could run without a
bitmap, in which case the flag would me "don't mark the array as
active".

I'm not entirely sure about the second flag.  Maybe it would be better
to make it a flag for READ and have it mean "validate and correct any
redundancy information (duplicates or parity) for this block before
returning it.  Then we could have just one flag, which meant different
things for READ and WRITE.

What do you think?

NeilBrown
