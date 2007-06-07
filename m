From: "Mark Knibbs" <markk@clara.co.uk>
Subject: Re: Possible ext2 bug with large sparse files?
Date: Thu, 07 Jun 2007 22:40:22 +0100
Message-ID: <E1HwPiR-000ED6-0s@oceanus.uk.clara.net>
References: <E1HvvOu-000Ok2-Fh@oceanus.uk.clara.net>
            <20070607175154.GM5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: markk@clara.co.uk, Andreas Dilger <adilger@clusterfs.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oceanus.uk.clara.net ([80.168.70.150]:4755 "EHLO
	oceanus.uk.clara.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbXFGVkZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Jun 2007 17:40:25 -0400
In-Reply-To: <20070607175154.GM5181@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi, 

[Apologies if this reply doesn't thread correctly.] 

Andreas Dilger wrote:
> Could you please clarify what the particular defect is that you are
> looking at?  Presumably it is not just that there is an upper limit on the
> size of a file?

No. It seems there are some deficiencies in ext2/3's and/or e2fsck's 
handling of files which are the maximum length. Hopefully what follows is a 
little more concise than my previous messages. 


First problem
 -------------
On a partition with 1K or 2K blocks (maxfilesize depends on the block size, 
either 17247252480 or 275415851008), doing this:
 dd if=/dev/zero of=test.bin bs=1 count=1 seek=[maxfilesize]
gives a "File size limit exceeded" message, as it should (otherwise the 
resulting file would be maxfilesize+1 bytes long). However there are two 
things which shouldn't be happening: 

1) "EXT2-fs warning (device sdd): ext2_block_to_path: block > big" appears 
in dmesg output 

2) e2fsck finds a problem/inconsistency, saying something like
"Inode 123466, i_size is [maxfilesize], should be 0.  Fix<y>?"
(With ext3, e2fsck doesn't ask that but seems to silently fix it, since 
test.bin shows as 0 bytes long afterwards.) 

It's as if the write is not getting caught early enough in the filesystem 
code and partially completes, hence the warning from ext2_block_to_path 
(which probably shouldn't be called in this case) and e2fsck issue. 

(I didn't mention this one in my previous message.) Related to that, doing
 dd if=/dev/zero of=test.bin bs=1 count=0 seek=[maxfilesize]
appears to work correctly, as it should since the zero-byte write doesn't 
cause the file to be longer than the maximum. However the warning in dmesg 
output and e2fsck problem happen here as well. 


Second problem
 --------------
After doing the one-byte-write dd test above, test.bin shows as maxfilesize 
bytes long. I don't think it should, because the write didn't happen (it 
would have caused the file to be maxfilesize+1 bytes long). That also 
applies with 4K block size. The sequence is: open file, seek to offset 
maxfilesize, attempt a write there (which fails). 

I guess opinions here might differ, but I think the resulting file size 
should be 0. I say opinions might differ because using dd with a zero-length 
write does "fixate" the file length, e.g.
 dd if=/dev/zero of=test.bin bs=1 count=0 seek=12345678
creates a 12345678-byte long file. But at least there the notional 
zero-length write completes successfully. (I'm guessing that behaviour is 
filesystem-dependent; maybe other filesystems require an actual write to 
"fixate" the length?) 


Third problem
 -------------
There's a bug when creating a file of the maximum size. This should work 
fine:
 dd if=/dev/zero of=test.bin bs=1 count=1 seek=[maxfilesize-1]
It executes without error, but fscking the partition shows a problem which 
isn't corrected, something like:
"Inode 6073, i_size is [maxfilesize], should be [maxfilesize].  Fix<y>?"
over and over again even when you tell e2fsck to fix it. 

That "e2fsck looping" thing happens after any write that would take a file 
past the maximum size (i.e. it probably occurs with any maximum-length 
file). In the case of a partition with 2K blocks, the maximum size is 
275415851008 bytes. So for example, if you do
 dd if=/dev/urandom of=test.bin bs=1000 count=1 seek=275415851
then of course the write fails (with a warning in dmesg output), but the 
first 8 bytes do actually get written. (Is that a bug? Should a write be 
allowed to partly happen, even when the filesystem knows it cannot be 
completed?) 


Regards,
 -- Mark 
