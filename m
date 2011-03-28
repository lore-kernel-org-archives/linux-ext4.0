From: Ted Ts'o <tytso@mit.edu>
Subject: Re: fsck.ext4 taking months
Date: Mon, 28 Mar 2011 11:47:30 -0400
Message-ID: <20110328154730.GD21075@thunk.org>
References: <4D8F1F75.8010201@psi5.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christian Brandt <brandtc@psi5.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55413 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab1C1Prf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Mar 2011 11:47:35 -0400
Content-Disposition: inline
In-Reply-To: <4D8F1F75.8010201@psi5.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 27, 2011 at 01:28:53PM +0200, Christian Brandt wrote:
> Situation: External 500GB drive holds lots of snapshots using lots of
> hard links made by rsync --link-dest. The controller went bad and
> destroyed superblock and directory structures. The drive contains
> roughly a million files and four complete directory-tree-snapshots with
> each roughly a million hardlinks.

As Ric said, this is a configuration that can take a long time to
fsck, mainly due to swapping (it's fairly memory intensive).  But
500GB isn't *that* big.  The larger problem is that a lot more than
just superblock and directory structures got destroyed:

> File ??? (Inode #123456, modify time Wed Jul 22 16:20:23 2009)
>   block Nr. 6144 double block(s), used with four file(s):
>     <filesystem metadata>
>     ??? (Inode #123457, mod time Wed Jul 22 16:20:23 2009)
>     ??? (Inode #123458, mod time Wed Jul 22 16:20:23 2009)
>     ...
> multiply claimed block map? Yes

This means that you have very badly damaged inode tables.  You either
have garbage written into the inode table, or inode table blocks
written to the wrong location on disk, or both.  (I'd guess most
likely both).

> Is there an adhoc method of getting my data back faster?

What's your high level goal?  If this is a backup device, how badly do
you need the old snapshots?   

> Is the slow performance with lots of hard links a known issue?

Lots of hard links will cause a large memory usage requirement.  This
is a problem primarily on 32-bit systems, particularly (ahem) "value"
NAS systems that don't have a lot of physical memory to begin with.
On 64-bit systems, you can either install enough physical memory that
this won't be a problem, or you can enable swap, in which case you
might end up swapping a lot (which will cause things to be slow) but
it should finish.

We do have a workaround for people who just can't add the physical
memory, which inolves adding a [scratch_files] section in e2fsck, and
that does cause slow performance.  There has been some work on
improving that lately, by tuning the use of the tdb library we are
using.  But if you haven't specifically enabled this workaround, it's
prboably not an issue.

I think what you're running into is the a problem caused by very badly
corrupted inode tables, and the work to keep track of the
double-allocated blocks is slowing things down.  We've improved things
a lot in this area, so we're O(n log n) in number of multiply claimed
blocks, instead of O(n^2), but if N is sufficiently large, this can
still be problematic.

There are patches that I've never had time to vet and merge that will
try to use hueristics to determine if an inode table block is hopeless
garbage, and if so, to skip the inode table block entirely.  This will
speed up e2fsck's performance in these situations, and the risk of
perhaps skipping some valid data that could have otherwise been
recovered.

So where are you at this point?  Have you completed running the fsck,
and simply wanted to let us know?  Do you need assistance in trying to
recover this disk?

							- Ted
