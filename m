From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Sun, 4 Mar 2007 20:11:17 +0000
Message-ID: <0DA8B217-DDD4-4E05-B000-DEBE3BE55B94@cam.ac.uk>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <1172789056.11165.42.camel@kleikamp.austin.ibm.com> <20070301233819.GB31072@infradead.org> <200703032345.33137.arnd@arndb.de>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com,
	Ulrich Drepper <drepper@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <200703032345.33137.arnd@arndb.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 3 Mar 2007, at 22:45, Arnd Bergmann wrote:
> On Friday 02 March 2007 00:38:19 Christoph Hellwig wrote:
>>> Forgive me if I haven't put enough thought into it, but would it be
>>> useful to create a generic_fallocate() that writes zeroed pages  
>>> for any
>>> non-existent pages in the range?  I don't know how glibc currently
>>> implements posix_fallocate(), but maybe the kernel could do it more
>>> efficiently, even in generic code.  Maybe we don't care, since  
>>> the major
>>> file systems can probably do something better in their own code.
>>
>> I'd be more happy to have the write out zeroes loop in glibc.  And
>> glibc needs to have it anyway, for older kernels.
>
> A generic_fallocate makes sense to me iff we can do it in the kernel
> more significantly more efficiently than in glibc, e.g. by using only
> a single page in page cache instead of one for each page to be  
> preallocated.
>
> If  glibc is smart enough to do an optimal implementation, I fully  
> agree
> with you.

glibc cannot ever be smart enough because a file system driver will  
always know better and be able to do things in a much more optimized  
way.

For example on NTFS fallocate() only needs to involve the setting of  
a few bits in the volume block allocation bitmap (one bit for each  
logical block being allocated) and update the extent map in the on- 
disk inode to reflect that those blocks are now allocated to the  
inode.  Then it just needs to update the allocated size and  
optionally the data size (if fallocate wants to increase the file  
size rather than just the allocated size).  And that is it.  No  
zeroing needs to happen at all because we have not updated the  
initialized size of the inode!

glibc can only dream of an implementation like this.  (-;

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/


