From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: fiemap is broken for sparse file in ext4?
Date: Thu, 10 Jun 2010 23:08:56 -0500
Message-ID: <4C11B6D8.8070909@redhat.com>
References: <4C119C2E.2090801@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	linux-kernel@vger.kernel.org
To: Tao Ma <tao.ma@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C119C2E.2090801@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Tao Ma wrote:
> Hi Ted and other ext4 gurus,
>     I found fiemap may be broken for sparse files in ext4. Here is a
> simple example.
> 
> dd if=/dev/zero of=testfile1 bs=1M count=1
> using fiemap shows that it has a delalloc extent.
> Logical: 0 Ext length: 1048576    Physical: 0    flags: 7
> 
> flags 7 means FIEMAP_EXTENT_LAST, FIEMAP_EXTENT_UNKNOWN and
> FIEMAP_EXTENT_DELALLOC,
> 
> while if we create a sparse file, fiemap will not show the delalloc extent.
> dd if=/dev/zero of=testfile1 bs=1M count=1 seek=1
> using fiemap shows that it has no extent for the file. while we should
> have some output like:
> Logical: 1048576 Ext length: 1048576    Physical: 0    flags: 7
> 
> So we have different output with sparse and non-sparse file. Is it a bug
> for ext4?

What are you using to call fiemap?  Here it seems to be working:

# dd if=/dev/zero of=testfile1 bs=1M count=1 seek=1;

# filefrag -v testfile1
Filesystem type is: ef53
Filesystem cylinder groups is approximately 119
File size of testfile1 is 2097152 (512 blocks, blocksize 4096)
 ext logical physical expected length flags
   0     256   151946               1 merged
   1     257   151951   151946      2 merged
   2     259   152434   151952    253 merged,eof
testfile1: 4 extents found

And with my homegrown fiemap tester:

# ./fiemap-test testfile1
ext:   0 logical: [     256..     256] phys:   151946..  151946 flags: 0x1000 tot: 1
ext:   1 logical: [     257..     258] phys:   151951..  151952 flags: 0x1000 tot: 2
ext:   2 logical: [     259..     511] phys:   152434..  152686 flags: 0x1001 tot: 253

... seems ok here, aside from the fragmentation :) ...

-Eric
