From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: A proposal for making ext4's journal more SMR (and flash)
 friendly
Date: Wed, 8 Jan 2014 12:43:35 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1401081212370.2257@localhost.localdomain>
References: <nsxfvozavl2.fsf@lambda.thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbaAHLnk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jan 2014 06:43:40 -0500
In-Reply-To: <nsxfvozavl2.fsf@lambda.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 8 Jan 2014, Theodore Ts'o wrote:

> Date: Wed, 08 Jan 2014 00:31:05 -0500
> From: Theodore Ts'o <tytso@mit.edu>
> To: linux-ext4@vger.kernel.org
> Subject: A proposal for making ext4's journal more SMR (and flash) friendly
> 
> 
> This is something I've discussed on our weekly conference calls, but I
> think it's time that try to get it written down.

Hi Ted,

thanks a lot for sharing this. It really looks interesting and I
have couple of questions/comments bellow.

> 
>                      SMR-Friendly Journal for Ext4
>                               Version 0.10
>                             January 8, 2014
> 

--snip--

> 
> Design
> ======
> 
> The key insight in making the ext4's metadata updates more friendly is
> that the writes to the journal are ideal from the perspective of writes
> to a shingled disk --- or for a flash device with a simplistic FTL, such
> as those found on many eMMC devices found in mobile handsets.  It is
> after the journal commit, when the updates to the allocation bitmaps,
> the inode table, directory blocks, which are random writes that are less
> optimal from the perspective of a Flash Translation Layer or the SMR
> drive's management layer.  So we apply the Smith and Dale technique[4]:
> 
>         Patient: Doctor, it hurts when I do _this_.
>         Doctor Kronkheit: Don't _do_ that.
> 
> [4] Doctor Kronkheit and His Only Living Patient, Joe Smith and
> Charlie Dale, 1920's American vaudeville comedy team.
> 
> 
> The simplest implementation of this design does not require making any
> on-disk format changes.  We simply suppress the writeback of the dirty
> metadata block to the file system.  Instead we keep a journal map in
> memory, which maps metadata block numbers (or data block numbers if data
> journalling is enabled) to a block number in the journal.

So it means that we would have to have bigger journal which is
multiple zones (or bands) of size long, right ? However I assume that
the optimal journal size in this case will be very much dependent
on the workload used - for example small file workload or other metadata
heavy workloads would need bigger journal. Could we possibly make journal
size variable ?

> 
> The journal is not truncated when the file system is unmounted, and so
> there is no difference between mounting a file system which has been
> cleanly unmounted or after a system crash.

I would maybe argue that clean unmount might be the right time for
checkpoint and resetting journal head back to the beginning because
I do not see it as a performance sensitive operation. This would in
turn help us on subsequent mount and run.

> In both case, the ext4 file
> system will scan the journal, and create an in-memory data structure
> which maps metadata block locations to their location in the journal.
> When a metadata block (or a data block, if data journalling is enabled)
> needs to be read, if the block number is found in the journal map, the
> block is read from the journal instead of from its "real" location on
> disk.

While this helps a lot to avoid random writes it could possibly
result in much higher seek rates especially with bigger journals.
We're trying hard to keep data and associated metadata close
together and this would very much break that. This might be
especially bad with SMR devices because those are designed to be much
bigger in size. But of course this is a trade-off which makes it
very important to have good benchmark.

> 
> Eventually, we will run out of room in the journal, and so we will need
> to retire commits from the head of the journal.  For each block
> referenced in the commit at the head of the journal, if it is has since
> been updated in a newer commit, then no action will be needed.

I assume that the information about the newest commits for
particular metadata blocks would be kept in memory ? Otherwise it
would be quite expensive operation. But it seems unavoidable on
mount time, so it might really be better to clear the journal at
unmount when we should have all this information already in memory ?

Overall this design seems like a good idea to me and I agree that
this should help not only on SMR devices but should be generally
useful if we can determine the best heuristics to balance
trade-offs.

Thanks!
-Lukas

> For a
> block that has not been updated in a newer commit, there are two
> choices.   The checkpoint operation could either copy the block to the
> tail of the journal, or write the block back to its final / "permanent"
> location on disk.   The latter is preferable if it is unlikely that the
> block will needed again, or if space is needed in the journal for other
> metadata blocks.   On the other hand, writing the block to the final
> location on disk will entail a random write, which will be especially
> expensive on SMR disks.  Some experimentation may be needed to determine
> the best hueristics to use.
> 
> 
> Avoiding Updating the Journal Superblock
> ----------------------------------------
> 
> The basic scheme described above has does not require any format
> changes.   However, while it eliminates most of the random writes
> associated with the file system metadata, the journal superblock must be
> updated each time the journal layer performs a "checkpoint" operation to
> retire the oldest commits from the head of the journal, so that the
> starting point of the journal can be identified.
> 
> This can be avoided by modifying the commit block to include the head of
> the journal at the time of the commit, and then by requiring that first
> block of each zone must be a jbd2 control block.  Since each control
> block contains the sequence number, the mount operation simply needs to
> scan the first block in each zone to find the control block with the
> highest commit ID, and then parse the journal until the last valid
> commit block is found.  Once the tail of the journal has been
> identified, the last commit block will contain a pointer to the head of
> the journal.
> 
> Applicability to other storage technologies
> ===========================================
> 
> This design was originally designed to improve ext4's performance on SMR
> devices.  However, it it may be helpful for flash based devices, since
> it reduces the write load caused by metadata blocks, since very often
> the a particular metadata block will be updated in multiple commits.
> Even on a hard drive, the reduction in writes and seek traffic may be
> worthwhile.
> 
> Although we will need to benchmark this new scheme, this modified
> journalling scheme should be at least as efficient as the current
> mechanism used in the ext4/jbd2 implementation.  If this is true, it may
> make sense to this be the default.
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
