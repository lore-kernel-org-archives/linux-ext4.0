From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 scaling limits ?
Date: Wed, 22 Mar 2017 23:35:10 -0400
Message-ID: <20170323033510.tx62b4y5ap3jkrnt@thunk.org>
References: <CAE0An6fc6tX6ACQYdTYdP+CwN=RDKuv_oaW0xeNrBLY_1AvOtw@mail.gmail.com>
 <32A4A230-566F-4476-A516-2C6C4BA5C1C6@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Manish Katiyar <mkatiyar@gmail.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40594 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751503AbdCWDfN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 22 Mar 2017 23:35:13 -0400
Content-Disposition: inline
In-Reply-To: <32A4A230-566F-4476-A516-2C6C4BA5C1C6@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 21, 2017 at 05:48:11PM -0400, Andreas Dilger wrote:
> While it is true that e2fsck does not free memory during operation, in
> practice this is not a problem. Even for large filesystems (say 32-48TB)
> it will only use around 8-12GB of RAM so that is very reasonable for a
> server today.

E2fsck does free memory during operation; see the comments in front of
pass 2 and pass 3 for example:

 * Pass 2 also collects the following information:
 * 	- The inode numbers of the subdirectories for each directory.
 *
 * Pass 2 relies on the following information from previous passes:
 * 	- The directory information collected in pass 1.
 * 	- The inode_used_map bitmap
 * 	- The inode_bad_map bitmap
 * 	- The inode_dir_map bitmap
 *
 * Pass 2 frees the following data structures
 * 	- The inode_bad_map bitmap
 * 	- The inode_reg_map bitmap

 * Pass 3 frees the following data structures:
 *     	- The dirinfo directory information cache.

It's not a *lot* of memory, especially given that bitmaps are stored
in a much more compact, extent-mapped format, but it does free some
memory.

It is fair to say that e2fsck is optimized to run as quickly as
possible, and to cache information so that we are not rereading file
system metadata from disk.  This was done using some of the
suggestions from the 1989 Usenix ATC paper:

Bina. E. J., and P. A. Emrath (1989): "A faster fsck for BSD UNIX,"
Proceedings of the Winter 1989 USENIX Technical Conference, 173-185.


On Tue, 21 Mar 2017 22:59:18 +0100 Reindl Harald <h.reindl@thelounge.net> said:
>Am 21.03.2017 um 22:48 schrieb Andreas Dilger:
>> While it is true that e2fsck does not free memory during operation, in
>> practice this is not a problem. Even for large filesystems (say 32-48TB)
>> it will only use around 8-12GB of RAM so that is very reasonable for a
>> server today.
>
>no it's not reasonable even today that your whole physical machine exposes
>it's total RAM to the one of many single virtual machines running just a samba
>server for a 50 TB "datagrave" with a handful of users
>
>in reality it should not be a problem to attach even a 100 TB storage to a VM
>with 1-2 GB

Reindl, sorry, but today, if you have an out-of-balance server with a
huge amoutn of storage, and a tiny amount of disk, it *will* be a
problem.

If you are desperate, you *may* be able to use the scratch files
feature documented in e2fsck.conf.  This was mainly implemented for
users of desktop NAS boxes which tried to connect a huge disk to a
tiny arm server, and the manufacturers of said NAS boxes didn't bother
to check to see if they had provisioned enough memory so they could
repair a broken file system.  (I know they didn't because the
developers didn't reach out to me; their users did.)  The scratch
files is way to use on-disk databases to replace the in-memory data
structure, but it is S-L-O-W.  But hey, you get what you pay for, and
if you are too cheapskate to provision a system with enough memory,
you (or your paying customers) will suffer the consequences.

If you don't like this answer, feel free to write your own e2fsck
which is 5-6 times slower because it is constantly rereading metadata
from disk.

Or submit patches, but if it slows down the fsck times on a reasonably
configured servers, I reserve the right to reject such patches as
inflicting pain existing users of ext4 who correctly sized their
servers.

						- Ted
