From: Killian De Volder <killian.de.volder@scarlet.be>
Subject: Re: Recovery after mkfs.ext4 on a ext4
Date: Mon, 23 Jun 2014 18:37:20 +0200
Message-ID: <53A857C0.3060401@scarlet.be>
References: <539D555E.3050707@scarlet.be> <20140615132026.GC2180@thunk.org> <539E019C.6060600@scarlet.be> <20140615214403.GA1420@thunk.org> <53A7C4A1.4000603@scarlet.be> <20140623123758.GA14887@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:34360 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbaFWQhZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jun 2014 12:37:25 -0400
In-Reply-To: <20140623123758.GA14887@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 23-06-14 14:37, Theodore Ts'o wrote:
> On Mon, Jun 23, 2014 at 08:09:37AM +0200, Killian De Volder wrote:
>> It's still checking due to the high amount of ram it's using.
>> However if I start a parallel check with -nf if find other errors the one with the high memory usage hasn't found yet ?
> No, definitely not that!  Running two e2fsck's in parallel will do far
> more harm than good.
In parallel is a big word: the check repair is SOOO slow, it might as well been killed when the second (read-only) test is done.
I once has a OOM because of tomuch ZRAM allocated, after I restarted e2fsck, it found more error before going into massive ram-usage.
So I was wonder what would happen if I restarted it.
>
>> Should I start a new one, or is this not advised ?
>> As sometimes I think it's bad inodes causing artificial usage of memory.
> What part of the e2fsck run are you in?  If you are in passes
> 1b/1c/1d, then one of the things you can do is to analyze the log
Pass 1: Checking inodes, blocks, and sizes
Notthing else below this except things like:

Too many illegal blocks in inode 488.
Clear inode<y>? yes

But no mention of any next pass.

This is the stack it's "stuck" on: (should compile one with debugging data)
#4  0x00007f1b0f1a0edb in block_iterate_dind ()
   from /lib64/libext2fs.so.2
#5  0x00007f1b0f1a1950 in ext2fs_block_iterate3 ()
   from /lib64/libext2fs.so.2
#6  0x00000000004118c3 in check_blocks ()
#7  0x0000000000412921 in process_inodes.part.6 ()
#8  0x0000000000413923 in e2fsck_pass1 ()
#9  0x000000000040e2cf in e2fsck_run ()
#10 0x000000000040a8e5 in main ()

So this is passA correct ?

> output to date, and individually investigate the inodes that were
> reported as bad using debugfs.  You could then backup what was worth
> backuping up out of those inodes, and then use the debugfs "clri"
> command to zap the bad inode.  I have done that to reduce the number
> of bad inodes to make e2fsck pass 1b, 1c, and 1d run faster.  But I've
> never done it on a really huge file system, and it may not be worth
> the effort.
>
> What I'd probably do instead is to edit e2fsck to skip pass 1b, 1c,
> and 1d, and then hope for the best.  The file system will still be
> corrupted, and there is the chance that you will do some damage in the
> later passes because you skipped passes 1b/c/d, but if the goal is to
> get the file system in a state where you can safely mount it
> read-only, that would probably be your best bet.
>
> 						- Ted
>
Regards,
Killian
