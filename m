From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: fsck performance.
Date: Wed, 23 Feb 2011 03:54:35 +0100
Message-ID: <20110223025435.GL21917@bitwizard.nl>
References: <20110220222013.GA2849@thunk.org> <20110220231514.GC21917@bitwizard.nl> <20110220234131.GC4001@thunk.org> <AANLkTikJs8mBHGvHkJAp-aC719aG6QSJaUH-uvwpx0JK@mail.gmail.com> <AANLkTinWOSBqkXhgOa4qdfK+iiLcJSP9LeZaYmUHH9KF@mail.gmail.com> <C5662C0F-10E3-4AC3-8ACA-4CBBF4F36D70@dilger.ca> <20110222102056.GH21917@bitwizard.nl> <20110222133652.GI21917@bitwizard.nl> <20110222135431.GK21917@bitwizard.nl> <386B23FA-CE6E-4D9C-9799-C121B2E8C3BB@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>,
	Pawe?? Brodacki <pawel.brodacki@googlemail.com>,
	Amir Goldstein <amir73il@gmail.com>, Ted Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.101.171.8]:16984 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751739Ab1BWCyh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Feb 2011 21:54:37 -0500
Content-Disposition: inline
In-Reply-To: <386B23FA-CE6E-4D9C-9799-C121B2E8C3BB@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 22, 2011 at 09:32:28AM -0700, Andreas Dilger wrote:
> Roger,

> Any idea what the hash size does to memory usage?  I wonder if we
> can scale this based on the directory count, or if the memory usage
> is minimal (only needed in case of tdb) then just make it the
> default. It definitely appears to have been a major performance
> boost.

First, that hash size is passed to the tdb module, so yes it only
matters when tdb is actually used.

Second, I expect tdb's memory use to be significantly impacted by the
hash size. However.... tdb's memory use is dwarfed by e2fsck's own
memory use....  I have not noticed any difference in memory use of
e2fsck. (by watching "top" output. I haven't done any scientific
measurements.)

> Another possible optuzatiom is to use the in-memory icount list
> (preferably with the patch to reduce realloc size) until the
> allocations fail and only then dump the list into tdb?  That would
> allow people to run with a swapfile configured by default, but only
> pay the cost of on-disk operations if really needed.

I don't think this is a good idea. When you expect the "big"
allocations to eventually fail (i.e. icount), you'll evenutally end up
with an allocation somewhere else that fails where you don't have
anything prepared for. A program like e2fsck will be handling
larger and different filesystems "in the field" from what you expected
at the outset. It should be robust. 

My fsck is currently walking the ridge.... 

It grew from about 1000M to over 2500 after pass 1. I was expecting it
to hit the 3G limit before the end. But luckily somehow some memory
got released, and now it seems stable at 2001Mb.

It is currently again in a CPU-bound task. I think it's doing
lots of tdb lookups. 

It has asked me: 

First entry 'DSCN11194.JPG' (inode=279188586) in directory inode 277579348 (...) should be '.'
Fix<y>? yes


Which is clearly wrong. IF we can find directory entries in that
directory (i.e. it acutally IS a directory), then it is likely that
the file DSCN11194.JPG still exists, and that it has inode
279188586. If it should've been '.', it would've been inode
277579348. So instead of overwriting this "first entry" of the
directory, the fix should've been:

Directory "." is missing in directory inode 277579348. Add?

If neccesary, place should be made inside the directory. 

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
