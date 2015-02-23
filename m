From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: add regression tests for ^extents punch hole
Date: Mon, 23 Feb 2015 17:43:32 -0600
Message-ID: <54EBBB24.3000802@redhat.com>
References: <4c557308eb4e62752dc8b513495cb6d46ca5775d.1424730653.git.osandov@osandov.com> <20150223224620.GL12722@dastard> <20150223231134.GA15327@mew.cs.washington.edu> <54EBB797.3080506@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>,
	Omar Sandoval <osandov@osandov.com>,
	Dave Chinner <david@fromorbit.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <54EBB797.3080506@sandeen.net>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2/23/15 5:28 PM, Eric Sandeen wrote:
> On 2/23/15 5:11 PM, Omar Sandoval wrote:
>> On Tue, Feb 24, 2015 at 09:46:20AM +1100, Dave Chinner wrote:
>>> On Mon, Feb 23, 2015 at 02:39:36PM -0800, Omar Sandoval wrote:
>>>> Linux commit 6f30b7e37a82 (ext4: fix indirect punch hole corruption)
>>>> fixes several bugs in the FALLOC_FL_PUNCH_HOLE implementation for an
>>>> ext4 filesystem with indirect blocks.
>>>>
>>>> Signed-off-by: Omar Sandoval <osandov@osandov.com>
>>>> ---
>>>>  tests/ext4/005     | 115 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>  tests/ext4/005.out |  29 ++++++++++++++
>>>>  tests/ext4/group   |   1 +
>>>>  3 files changed, 145 insertions(+)
>>>>  create mode 100755 tests/ext4/005
>>>>  create mode 100644 tests/ext4/005.out
>>>
>>> What's ext4 specific about this test apart from the mkfs parameter?
>>> Shouldn't it be generic and so test all the filesystems behave the
>>> same?  i.e. when someone then runs
>>>
>>> # MKFS_OPTIONS="-b size=1k -O ^extents" ./check -g auto
>>>
>>> That will exercise this specific regression fix, not to mention give
>>> much, much better test coverage of that configuration than just
>>> making a single test use that config...
>>>
>>> Cheers,
>>>
>>> Dave.
>>> -- 
>>> Dave Chinner
>>> david@fromorbit.com
>>
>> Hi, Dave,
>>
>> This test isn't completely generic bcause the output is dependent on the
>> block size. In particular, fpunch+fiemap will have different results
>> based on the block size:
>>
>> ----
>> # mkfs.ext3 -b1024 /dev/sdb1
>> # mount /dev/sdb1 /mnt/test
>> # xfs_io -f -c 'pwrite 0 8192' /mnt/test/a
>> # xfs_io -c 'fpunch 0 1024' /mnt/test/a
>> # xfs_io -c fiemap /mnt/test/a
>> /mnt/test/a:
>>         0: [0..1]: hole
>>         1: [2..15]: 1028..1041
>> # umount /mnt/test
>> # mkfs.ext3 -b4096 /dev/sdb1
>> # mount /dev/sdb1 /mnt/test
>> # xfs_io -f -c 'pwrite 0 8192' /mnt/test/a
>> # xfs_io -c 'fpunch 0 1024' /mnt/test/a
>> # xfs_io -c fiemap /mnt/test/a
>> /mnt/test/a:
>>         0: [0..15]: 8192..8207
>> ----
>>
>> I could either remove the fiemap output from the test case and rely on
>> the md5sum or round all of the punches to some larger block size so it
>> will behave the same up to, say, 8k. Do either of those options sound
>> better?
>>
>> Alternatively, is there a good way to have block size-dependent test
>> output? Then we could have the test adapt to different block sizes and
>> cover these regressions at any block size, not just 1k.
> 
> Can you scale every operational offset by block size?  I think there are
> other tests which do this sort of thing - look at _filter_bmap in test
> xfs/194 maybe?
> 
> i.e. above you would do 'fpunch 0 $blocksize' not 'fpunch 0 1024'
> (or blocksize/4, or whatever your intent is)

Or, I was talking to Dave about adding a fs-block-units output format
for fiemap... which might make life a lot simpler in cases like this,
though you'd still have to scale the tested offsets by fs blocks, but
that's not too hard.

-Eric

