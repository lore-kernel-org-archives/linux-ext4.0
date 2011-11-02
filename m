From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH V1 02/17] ext4: Add the basic function for inline data support.
Date: Wed, 2 Nov 2011 15:16:14 -0600
Message-ID: <4209A71E-F65C-4335-BD80-ACCABDB6E7D2@whamcloud.com>
References: <4EA7B788.3040503@tao.ma> <1319614468-11227-1-git-send-email-tm@tao.ma> <1319614468-11227-2-git-send-email-tm@tao.ma> <E38E92E9-2937-47BA-A9F4-B1F75C9FDE4A@dilger.ca> <4EA81B50.1060802@tao.ma> <DACDC44B-F60E-493E-9C15-67EDFCDFD34D@dilger.ca> <4EA8AB25.4030506@tao.ma> <42CED85D-7936-4D51-B405-787F65F0C10A@whamcloud.com> <4EA97075.4050307@tao.ma>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42226 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab1KBVPy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Nov 2011 17:15:54 -0400
In-Reply-To: <4EA97075.4050307@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-10-27, at 8:53 AM, Tao Ma wrote:
> On 10/27/2011 05:57 PM, Andreas Dilger wrote:
>> if ANY other xattr exists it will be pushed to an external block, and
>> then if this data xattr grows (much more likely than the other xattr
>> changing) it won't fit into the inode, and now performance is
>> permanently worse than before.
> 
> OK, since it seems that lustre uses xattr heavily, I will try my best to
> avoid the performance regression for xattr operations.

I don't even think it is very much a Lustre problem, since it always
stores file data in a separate filesystem from the metadata, and
60-byte files are going to have terrible performance either way.

My main concern is for SELinux (enabled by default on most systems
today).  If the "small file" data is stored in the xattr space, and
this pushes the SELinux xattr to an external block, we have added
code complexity and a gratuitous format change (data in inode and
metadata in block, instead of metadata in inode and data in block)
with no real benefit at all.

>> In our environment we use at least 512-byte inodes on the metadata server, but I still don't want half if that space wasted on this xattr if so much is not needed.
> 
> btw, I have another idea about using the not-used extent space for
> storing inline data like what we do for a symlink. So I will still use a
> xattr entry to indicate whether the inode will have inline data or not.
> If yes, the initialized xattr value len will be zero while the extent
> space(60 bytes) will be used to store the inline data. And if the file
> size is larger than 60, it will begin to insert xattr values. In such
> case, we supports inline data and don't use too much space after the
> i_extra_isize. What do you think of it?

I think this is an interesting idea.  Since only the "data" xattr could
use this space, it gives us an extra 60 bytes of space to be used in
the inode and does not consume the xattr space.  The main drawback is
that this would add special case handling based on the xattr name, but
I think it is worthwhile to investigate how complex that code is and
what kind of performance improvement it gives.

Looking at my FC13 installation, it seems like a large number of
files could benefit from just 60 bytes of inline storage.  So more
than 10% of all of the files on the filesystem would fit in i_blocks.
This filesystem includes a lot of source and build files, but I also
think this is pretty typical of normal Linux usage.

# find / -xdev -type f -size -61c | wc -l
35661
# find / -xdev -type f | wc -l
335515

The "fsstats" tool is useful for collecting interesting data like this:
(http://www.pdsi-scidac.org/fsstats/files/fsstats-1.4.5.tar.gz)
and it shows the same is true for directories as well:


directory size (entries): Range of entries, count of directories in range,
 number of dirs in range as a % of total num of dirs, number of dirs in
 this range or smaller as a % total number of dirs, total entries in range,
 number of entries in range as a % of total number of entries, number of
 entries in this range or smaller as a % of total number of entries.

  count=33476 avg=11.38 ents
  min=0.00 ents max=3848.00 ents
  [   0-   1 ents]: 11257 (33.63%) ( 33.63%)   9968.00 ents ( 2.62%) (  2.62%)
  [   2-   3 ents]:  7080 (21.15%) ( 54.78%)  16608.00 ents ( 4.36%) (  6.97%)
  [   4-   7 ents]:  5793 (17.30%) ( 72.08%)  30674.00 ents ( 8.05%) ( 15.02%)
  [   8-  15 ents]:  3971 (11.86%) ( 83.94%)  43315.00 ents (11.37%) ( 26.39%)
  [  16-  31 ents]:  2731 ( 8.16%) ( 92.10%)  59612.00 ents (15.64%) ( 42.04%)
  [  32-  63 ents]:  1610 ( 4.81%) ( 96.91%)  69326.00 ents (18.19%) ( 60.23%)
  [  64- 127 ents]:   705 ( 2.11%) ( 99.02%)  61633.00 ents (16.17%) ( 76.40%)
  [ 128- 255 ents]:   236 ( 0.70%) ( 99.72%)  40005.00 ents (10.50%) ( 86.90%)
  [ 256- 511 ents]:    66 ( 0.20%) ( 99.92%)  21923.00 ents ( 5.75%) ( 92.66%)
  [ 512-1023 ents]:    19 ( 0.06%) ( 99.98%)  14249.00 ents ( 3.74%) ( 96.40%)
  [1024-2047 ents]:     6 ( 0.02%) ( 99.99%)   7756.00 ents ( 2.04%) ( 98.43%)
  [2048-4095 ents]:     2 ( 0.01%) (100.00%)   5979.00 ents ( 1.57%) (100.00%)

A simple test of the performance gains might be running "file" on
everything in /etc and /usr, and measuring this with blktrace to
see what kind of seek reduction is seen from not doing seeks to
read the small files from an external block.



I think it is still useful to try to store the data in the large inode
xattr space if it is larger than i_blocks, especially for larger inodes,
but if there is not enough space for all the xattrs to fit into the
inode, I think "data" should be the first one to be pushed out of the
inode since that changes the format back to a normal ext* file.


We might also consider a reiserfs-like approach where multiple small
files could be packed into the same shared xattr block, but then the
xattr name would need to change from "data" to e.g. "inode.generation"
so that it can be located within the block shared between inodes.

Tail packing is more complex, so such a change would only make sense
if real-world testing showed a benefit.  There is already the concept
of shared external xattr blocks, so maybe it isn't too bad.  Together
with bigalloc, it might make sense to be able to pack many small files
into one cluster if there is a binomial distribution of file sizes?

Cheers, Andreas
--
Andreas Dilger 
Principal Engineer
Whamcloud, Inc.



