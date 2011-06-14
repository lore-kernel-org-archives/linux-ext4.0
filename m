From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: recovering from backup superblock with uninit_bg
Date: Tue, 14 Jun 2011 09:42:39 -0600
Message-ID: <CADCB32D-556C-415D-BA3B-29F632753D4D@dilger.ca>
References: <BANLkTi=Xy0hKvBe2VvO7L6cPvT94A2g+nw@mail.gmail.com> <E51F9800-231C-45E0-A013-9DC1749AA00C@dilger.ca> <BANLkTimHDG7p1P4yykQW2ywHG4J3Dfs3qQ@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:24504 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab1FNPmm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jun 2011 11:42:42 -0400
In-Reply-To: <BANLkTimHDG7p1P4yykQW2ywHG4J3Dfs3qQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-14, at 2:53 AM, Amir Goldstein wrote:
> On Tue, Jun 14, 2011 at 11:35 AM, Andreas Dilger <adilger@dilger.ca> wrote:
>> On 2011-06-14, at 2:15 AM, Amir Goldstein wrote:
>>> Can you help me figure this one out.
>>> 
>>> When I run the test:
>>> # mkfs.ext4 /dev/sda5
>>> # fsck.ext4 -nf -b 32768 /dev/sda5
>>> 
>>> The results are a total chaos.
>>> 
>>> Apparently, when opening an fs from a backup superblock,
>>> all _UNINIT flags are cleared:
>>> 
>>> First fsck rightfully complains that the group desc checksums are wrong.
>>> Then, is complains about many errors in phantom inodes, because the inode
>>> bitmap and tables are treated as initialized, but they aren't (see snip below)
>>> 
>>> Any idea what was the purpose of clearing the _UNINIT flags?
>>> Or how and if this should be fixed?
>> 
>> The reason that the _UNINIT flags are cleared is that they cannot possibly
>> be correct in the backup superblocks, and it is far more reliable to check
>> all of the inode table blocks for inodes, as old e2fsck used to do.
> 
> Right, so in this case do the checksums need to be wrong by design?
> 
>> However, you shouldn't have garbage data in your inode table in the first
>> place.  mke2fs will normally do the inode table zeroing, unless it detects
>> that the kernel supports the "lazyinit zeroing thread".  At that point, it
>> expects the kernel to proceed to zero all of the unused blocks in the
>> filesystem at mount time.  If this isn't happening, it is a bug.
> 
> The test was: mkfs; fsck.  There was no mount in between.
> I am testing a 16TB fs on a loop device, so I am mounting with -o noinit_itable,
> so my image file won't grow.

Hmm, a loop device should only return zeroes for reads of sparse areas, so
it shouldn't be causing errors when checking the inode table, unless you
are doing something strange.

If you are directly mapping the backing device, this is definitely going to
show errors due to stale inodes remaining on disk from the old filesystem.
Until we get inode generations and/or checksums, we won't be able to
distinguish between old inodes and other forms of corruption.

Two things that could be done:
- instead of always writing zeroes to disk in ext4_init_inode_table() is to
 first start by reading the itable blocks from disk and checking for zeroes,
 and only switch to writing zeroes if non-zero data is read.  That will
 prevent the lazyinit thread from filling in sparse files if they already
 read back as zero
- e2fsck should probably be changed to read the backup group descriptor blocks
 first, and then change the flags, so that there are not spurious error
 messages for an expected (self caused) failure case

> I may as well pick up your patch to skip zeroing of the journal,
> as that is mainly what my image file contains now.

It's in git master already.

Cheers, Andreas





