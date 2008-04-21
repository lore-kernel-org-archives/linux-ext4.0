From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem checker)
Date: Mon, 21 Apr 2008 04:23:42 +0400
Message-ID: <f19298770804201723v12b78da6w187984debf8ef97c@mail.gmail.com>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com>
	 <20080419012952.GE25797@mit.edu>
	 <f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com>
	 <20080419185603.GA30449@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	"Rik van Riel" <riel@surriel.com>
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:31248 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbYDUAXm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Apr 2008 20:23:42 -0400
Received: by wa-out-1112.google.com with SMTP id m16so2691023waf.23
        for <linux-ext4@vger.kernel.org>; Sun, 20 Apr 2008 17:23:42 -0700 (PDT)
In-Reply-To: <20080419185603.GA30449@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 19, 2008 at 10:56 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Sat, Apr 19, 2008 at 01:44:51PM +0400, Alexey Zaytsev wrote:
>  > If it is a block containing a metadata object fsck has already read,
>  > than we already know what kind of object it is (there must be a way
>  > to quickly find all cached objects derived from a given block), and
>  > can update the cached version. And if fsck has not yet read the
>  > block, it can just be ignored, no matter what kind of data it
>  > contains. If it contains metadata and fsck is intrested in it, it
>  > will read it sooner or later anyway. If it contains file data, why
>  > should fsck even care?
>
>  The problem is that e2fsck makes calculations on the filesystem data
>  read out from the disk and stores that in a highly compressed format.
>  So it doesn't remember that block #12345 was an indirect block for
>  inode #123, and that it contained data block numbers 17, 42, and 45.
>  Instead it just marks blocks #12345, #17, #42, and #45 as in use, and
>  then moves on.
>
>  If you are going to store all of the cached objects then you will need
>  to effectively store *all* of the filesystem metatdata in memory at
>  the same time.  For a large filesystem, you won't have enough *room*
>  in memory store all of the cached objects.  That's one of the reasons
>  why e2fsck has a lot of very clever design so that summary information
>  can be stored in a very compressed form in memory so that things can
>  be fast (by avoid re-reading objects from disk) as well as not
>  requiring vast amounts of memory.
>

Yes, I agree on this problem. Do you have any estimates on how
much RAM the current e2fsck uses in some test cases? I hope
my approach will not add much to this. The only big thing I see
is the data needed to associate each inode/dir entry with the parent
block. Probably one radix tree to enumerate the blocks and a
pointer added to the ext2_inode and ext2_dir_entry structures
to form a linked list of objects belonging to the same block.
Still no idea how much RAM the whole thing would consume.

>  Even if you *do* store all of the cached objects, it still takes time
>  to examine all of the objects and in the mean time, more changes will
>  have come rolling in, and you will either need to add a huge amount of
>  dependency to figure out what internal data structures need to be
>  updated based on the changes in some of the cached objects --- or you
>  will end up restarting the e2fsck checking process from scratch.
>

Not really. In my application I propose some changes to the fsck pass
order to avoid the need to rerun it. And I don't get what dependency you
are talking about. The only one I see is between the directory entries and
the directory inode. Should not be hard to solve.
(Or do I miss something? Could you give more examples maybe?)

>  In either case, there is still the issue of knowing exactly whether a
>  particular read happened before or after some change in the
>  filesystem.  This race condition is a really hard one to deal with,
>  especially on a multiple CPU system and the filesystem checker is
>  running in userspace.

I don't see why should fsck care about this. The notification is always sent
after the write happened, so fsck should just re-read the data. No problem
if it already read the (half-)updated version just before the notification.

Btw, how about an even simplyer method: just watch the journal commits
(changes to jbd needed). This way we can get all actual metadata updates,
without being flooded by the file data updates.

>
>  > But you are probably right, this project may be not doable in just three
>  > months. The changes on the kernel side probably are, but there is a
>  > huge e2fsck work.
>
>  Yes, that is the concern.  And without implementing the user-space
>  side, you'll never besure whether you completely got the kernel side
>  changes right!
>
>  Regards,
>
>                                                 - Ted
>
