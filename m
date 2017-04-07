From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH] fstests: generic: Check if cycle mount and sleep can
 affect fiemap result
Date: Fri, 7 Apr 2017 08:48:20 +0800
Message-ID: <519beb0e-f82c-91dc-4eae-7c61e9ee69fa@cn.fujitsu.com>
References: <20170403070923.18518-1-quwenruo@cn.fujitsu.com>
 <20170405023526.GS22845@eguan.usersys.redhat.com>
 <20170406162616.zsnbgx6vy2fgugmq@thunk.org>
 <36663e81-9520-0c52-5e72-1d54ddbfb0b7@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>, Theodore Ts'o <tytso@mit.edu>,
        Eryu Guan <eguan@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <36663e81-9520-0c52-5e72-1d54ddbfb0b7@sandeen.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



At 04/07/2017 12:28 AM, Eric Sandeen wrote:
> On 4/6/17 11:26 AM, Theodore Ts'o wrote:
>> On Wed, Apr 05, 2017 at 10:35:26AM +0800, Eryu Guan wrote:
>>>
>>> Test fails with ext3/2 when driving with ext4 driver, fiemap changed
>>> after umount/mount cycle, then changed back to original result after
>>> sleeping some time. An ext4 bug? (cc'ed linux-ext4 list.)
>>
>> I haven't had time to look at this, but I'm not sure this test is a
>> reasonable one on the face of it.
>>
>> A file system may choose to optimize a file's extent tree for whatever
>> reason it wants, whenever it wants, including on an unmount --- and
>> that would not be an invalid thing to do.  So to have an xfstests that
>> causes a test failure if a file system were to, say, do some cleanup
>> at mount or unmount time, or when the file is next opened, to merge
>> adjacent extents together (and hence change what is returned by
>> FIEMAP) might be strange, or even weird --- but is this any of user
>> space's business?  Or anything we want to enforce as wrong wrong wrong
>> by xfstests?
>
> I had the same question.  If the exact behavior isn't defined anywhere,
> I don't know what we can be testing, TBH.

For unmount cleanup, it's acceptable.

But if we're getting different result even we didn't modify the fs 
during the same mount duration, fiemap still changes, then it's at least 
anti-instinct.

And unfortunately, btrfs and ext3 shares the same problem here:

=== Fiemap after cycle mount ===
/mnt/scratch/file:
  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
    0: [0..95]:         139264..139359      96 0x1000
    1: [96..127]:       139360..139391      32 0x1000
    2: [128..511]:      138112..138495     384 0x1000
    3: [512..1023]:     138752..139263     512 0x1000
    4: [1024..2047]:    143360..144383    1024 0x1000
    5: [2048..4095]:    145408..147455    2048 0x1001
=== Fiemap after cycle mount and sleep ===
/mnt/scratch/file:
  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
    0: [0..127]:        139264..139391     128 0x1000
    1: [128..511]:      138112..138495     384 0x1000
    2: [512..1023]:     138752..139263     512 0x1000
    3: [1024..2047]:    143360..144383    1024 0x1000
    4: [2048..4095]:    145408..147455    2048 0x1001

I was using the same excuse just as you guys, until I found btrfs is 
merging extent maps at read time, which causes the problem.
That's why the 2nd fiemap in btrfs returns merged result.

We fix btrfs by caching fiemap extent result before calling 
fiemap_fill_next_extent(), and try to merge with cached result.
Which fixes the problem quite easy.

Thanks,
Qu
>
> -Eric
>
>> 		       		   	   - Ted
>
>


