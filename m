From: Hugh Dickins <hughd@google.com>
Subject: Re: Bug with "fix partial page writes"
Date: Mon, 21 Nov 2011 14:04:18 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1111211331120.1879@sister.anvils>
References: <CAO81RMa4uRsOsaK4G78EDvOenJpEdTp4y+rtkiDxaK9cASbMtA@mail.gmail.com> <alpine.LSU.2.00.1111201121120.1264@sister.anvils> <20111121165626.GD14568@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Curt Wohlgemuth <curtw@google.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40771 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab1KUWEf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Nov 2011 17:04:35 -0500
Received: by ggnr5 with SMTP id r5so2852535ggn.19
        for <linux-ext4@vger.kernel.org>; Mon, 21 Nov 2011 14:04:35 -0800 (PST)
In-Reply-To: <20111121165626.GD14568@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 21 Nov 2011, Ted Ts'o wrote:
> On Sun, Nov 20, 2011 at 12:59:10PM -0800, Hugh Dickins wrote:
> 
> > I did not reproduce either problem above with that.  Instead I found
> > that backing out 02fac1297eb3 made fsx on 3.2-rc1 fail in a few minutes.
> > But leaving 02fac1297eb3 in, fsx still failed in 20 minutes or an hour.
> > On 3.1, fsx failed in a few minutes.  On 3.0, fsx failed in half an hour.
> > On 2.6.39, fsx failed in a few minutes.  I had to go back to 2.6.38 for
> > fsx to run successfully under memory pressure for more than two hours.
> > 
> > It looks as if ext4 testing has not been running fsx under memory
> > pressure recently.  And although I didn't reproduce my main problems
> > that way, it could well be that getting fsx to run reliably again
> > under memory pressure will be the way to fix those problems.
> 
> Yes, I think we've been relying mostly on xfstests, and not
> necessarily under extreme memory pressures.  Out of curiosity, what
> sort of configuration were you using when you did the above tests?
> (memory, swap, fs bock size, etc.)  Was it the same as you did with
> your make -j20 kernel stress test?  And where you using any special
> fsx options?

Thanks for your rapid replies.

x86_64 kernel booted with "mem=700M cgroup_disable=memory" (latter to
rule out any memcg effects), swap was 1.5G, ext2 block size was 1024,

CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set

fsx options as below, no fallocation or holepunching:

fsx foo -q -c 100 -l 100000000 &
while :
do	# memory hog mmaps and touches each page of 800MB private area
	swapout 800
done

You might well wonder about the provenance of my fsx, and I'm not
certain where it came from originally (perhaps akpm's toolbox about
nine years ago).  So I got an xfstests.git tree

HEAD e219e1cb59660b010ae8c1e22d41d319bb1e10c7
Date:   Tue Nov 8 11:41:45 2011 +0800

built the latest version of fsx there, and ran the script with that,
on 3.2-rc2+ kernel pulled yesterday.

This time I used a disk partition, to rule out any loop or tmpfs
effects; but sized the partition to 460800 blocks to match what
I'd been using with loop and tmpfs (after growing impatient when
the first run on the whole 1.5G partition ran for half an hour -
but in retrospect perhaps it was about to blow when I stopped it).

It ran for 28 minutes before fsx failed with
READ BAD DATA: offset = 0x97f50, size = 0xe1bf, fname = foo
OFFSET	GOOD	BAD	RANGE
0xa6000	0x537e	0x0000	0x    0
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
...
0xa600f	0x4453	0x0000	0x    f
operation# (mod 256) for the bad data unknown, check HOLE and EXTEND ops
LOG DUMP (433525 total operations):
followed by the usual trace of operations leading up to this point.

Hugh
