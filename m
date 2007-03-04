From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Sun, 4 Mar 2007 23:22:06 +0000
Message-ID: <8A8B28AA-3481-4CFF-AEAA-0CB4CCDFF9F9@cam.ac.uk>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <1172789056.11165.42.camel@kleikamp.austin.ibm.com> <20070301233819.GB31072@infradead.org> <200703032345.33137.arnd@arndb.de> <0DA8B217-DDD4-4E05-B000-DEBE3BE55B94@cam.ac.uk> <45EB4A55.3060908@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Arnd Bergmann <arnd@arndb.de>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com
To: Ulrich Drepper <drepper@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <45EB4A55.3060908@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

On 4 Mar 2007, at 22:38, Ulrich Drepper wrote:
> Anton Altaparmakov wrote:
>> And that is it.  No zeroing needs to happen at all because we
>> have not updated the initialized size of the inode!
>
> When you do it like this, who can the kernel/filesystem *guarantee*  
> that
> when the data is written there actually is room on the harddrive?

The blocks are allocated so of course it is guaranteed.  Subsequent  
writes to this file will not generate any allocations thus  
allocations cannot fail.  (-:

> What you described seems like using truncate/ftruncate to increase the
> file's size.  That is not at all what posix_fallocate is for.
> posix_fallocate must make sure that the requested blocks on the  
> disk are
> reserved (allocated) for the file's use and that at no point in the
> future will, say, a msync() fail because a mmap(MAP_SHARED) page has
> been written to.

No that is different.  I described performing the allocations in the  
volume bitmap, i.e. for each allocated block the corresponding "in  
use" bit is set in the bitmap (NTFS uses a linear bitmap where byte  
0, bit 0 == physical block 0 of volume, byte 0, bit 1 == physical  
block 1 of volume, ... byte 1, bit 0 == block 8 of volume, ...).

Also I described updating the extent map of the inode such that it  
describes the physical blocks as belonging to the file, thus you  
would have "logical file block X corresponds to physical block Y on  
volume" entries entered into the extent map of the inode and they  
would describe the just allocated blocks.

Finally I described updating the allocated size in the inode which  
basically says "there are that many bytes worth of blocks allocated  
to this inode".

And optionally I described updating the data size in the inode which  
basically says "this file has size Z bytes".

And I specifically did NOT update the initialized size in the inode  
thus it will remain at its old value thus all new allocated blocks  
will be considered as present but not initialized thus a read will  
always return zero whilst a write will do the right thing and pad  
with zeroes as necessary (if the write is smaller than the block  
size, etc).

Note that you are right that this is like truncate in NTFS for non- 
sparse enabled inodes/volumes.

But for sparse ones, instead of doing any allocations in the bitmap  
and entering them in the extent map, you would simply add a single  
entry to the extent map that says "X blocks allocated starting at  
logical block Y corresponding to no physical blocks, i.e. they are  
sparse".  You would then also update the allocated size and data size  
as above and now you can even (but do not have to) update the  
initialized size to be equal to the data size as the file can be  
considered fully initialized because it is sparse.  As an  
implementation detail this truncate operation would not modify the  
compressed size of the inode (i.e. the really used on-disk space,  
i.e. what you get from running "du" as that does not change when you  
add sparse blocks) whilst the fallocate described above would update  
the compressed size (if the file is sparse or compressed - there is  
no compressed size in the inode if the inode is not sparse/ 
compressed) because the file now occupies more blocks on disk even if  
they are actually not initialized.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/


