From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: fsck performance.
Date: Wed, 23 Feb 2011 21:53:09 +0100
Message-ID: <20110223205309.GA16661@bitwizard.nl>
References: <AANLkTikJs8mBHGvHkJAp-aC719aG6QSJaUH-uvwpx0JK@mail.gmail.com> <AANLkTinWOSBqkXhgOa4qdfK+iiLcJSP9LeZaYmUHH9KF@mail.gmail.com> <C5662C0F-10E3-4AC3-8ACA-4CBBF4F36D70@dilger.ca> <20110222102056.GH21917@bitwizard.nl> <20110222133652.GI21917@bitwizard.nl> <20110222135431.GK21917@bitwizard.nl> <386B23FA-CE6E-4D9C-9799-C121B2E8C3BB@dilger.ca> <20110222221304.GH2924@thunk.org> <20110223044427.GM21917@bitwizard.nl> <DC8EC4D5-BB64-4908-985B-C6D3EDA955E3@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rogier Wolff <R.E.Wolff@bitwizard.nl>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.101.171.8]:40321 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752537Ab1BWUxM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Feb 2011 15:53:12 -0500
Content-Disposition: inline
In-Reply-To: <DC8EC4D5-BB64-4908-985B-C6D3EDA955E3@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 23, 2011 at 06:32:17AM -0500, Theodore Tso wrote:
> 
> On Feb 22, 2011, at 11:44 PM, Rogier Wolff wrote:
> 
> > 
> > I'll shoot off an Email to the TDB guys as well. 
 
> I'm pretty sure this won't come as a surprise to them.  I'm using
> the last version of TDB which was licensed under the GPLv2, and they
> relicensed to GPLv3 quite a while ago.  I remember hearing they had
> added a new hash algorithm to TDB since the relicensing, but those
> newer versions aren't available to e2fsprogs....

Well then.... 

You're free to use my "new" hash function, provided it is kept under
GPLv2 and not under GPLv3.

My implementation has been a "cleanroom" implementation in that I've
only looked at the specifications and implemented it from
there. Although no external attestation is available that I have been
completely shielded from the newer GPLv3 version... 

On a slightly different note: 

A pretty good estimate of the number of inodes is available in the
superblock (tot inodes - free inodes). A good hash size would be: "a
rough estimate of the number of inodes." Two or three times more or
less doesn't matter much. CPU is cheap. I'm not sure what the
estimate for the "dircount" tdb should be.

The amount of disk space that the tdb will use is at least: 
  overhead + hash_size * 4 + numrecords * (keysize + datasize +
                                                 perrecordoverhead)

There must also be some overhead to store the size of the keys and
data as both can be variable length. By implementing the "database"
ourselves we could optimize that out. I don't think it's worth the
trouble. 

With keysize equal 4, datasize also 4 and hash_size equal to numinodes
or numrecords, we would get

 overhead + numinodes * (12 + perrecordoverhead). 

In fact, my icount database grew to about 750Mb, with only 23M inodes,
so that means that apparently the perrecordoverhead is about 20 bytes.
This is the price you pay for using a much more versatile database
than what you really need. Disk is cheap (except when checking a root
filesystem!)

So... 

-- I suggest that for the icount tdb we move to using the superblock
info as the hash size.

-- I suggest that we use our own hash function. tdb allows us to
specify our own hash function. Instead of modifying the bad tdb, we'll
just keep it intact, and pass a better (local) hash function.


Does anybody know what the "dircount" tdb database holds, and what is
an estimate for the number of elements eventually in the database?  (I
could find out myself: I have the source. But I'm lazy. I'm a
programmer you know...).


On a separate note, my filesystem finished the fsck (33 hours (*)),
and I started the backups again... :-)

	Roger. 

*) that might include an estimated 1-5 hours of "Fix <y>?" waiting.

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
