From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH] fstests: generic: Check if cycle mount and sleep can
 affect fiemap result
Date: Mon, 10 Apr 2017 10:07:54 +0800
Message-ID: <e1d76075-1244-f671-b5e7-1e8851d4f0c1@cn.fujitsu.com>
References: <20170403070923.18518-1-quwenruo@cn.fujitsu.com>
 <20170405023526.GS22845@eguan.usersys.redhat.com>
 <20170406162616.zsnbgx6vy2fgugmq@thunk.org>
 <36663e81-9520-0c52-5e72-1d54ddbfb0b7@sandeen.net>
 <20170407050258.GO22845@eguan.usersys.redhat.com>
 <20170407154225.GG10881@birch.djwong.org>
 <d6e81d34-fda4-d242-01bd-270436177771@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, <linux-btrfs@vger.kernel.org>,
        <fstests@vger.kernel.org>, <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eryu Guan <eguan@redhat.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <d6e81d34-fda4-d242-01bd-270436177771@sandeen.net>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



At 04/07/2017 11:48 PM, Eric Sandeen wrote:
> On 4/7/17 10:42 AM, Darrick J. Wong wrote:
>> On Fri, Apr 07, 2017 at 01:02:58PM +0800, Eryu Guan wrote:
>>> On Thu, Apr 06, 2017 at 11:28:01AM -0500, Eric Sandeen wrote:
>>>> On 4/6/17 11:26 AM, Theodore Ts'o wrote:
>>>>> On Wed, Apr 05, 2017 at 10:35:26AM +0800, Eryu Guan wrote:
>>>>>>
>>>>>> Test fails with ext3/2 when driving with ext4 driver, fiemap changed
>>>>>> after umount/mount cycle, then changed back to original result after
>>>>>> sleeping some time. An ext4 bug? (cc'ed linux-ext4 list.)
>>>>>
>>>>> I haven't had time to look at this, but I'm not sure this test is a
>>>>> reasonable one on the face of it.
>>>>>
>>>>> A file system may choose to optimize a file's extent tree for whatever
>>>>> reason it wants, whenever it wants, including on an unmount --- and
>>>>> that would not be an invalid thing to do.  So to have an xfstests that
>>>>> causes a test failure if a file system were to, say, do some cleanup
>>>>> at mount or unmount time, or when the file is next opened, to merge
>>>>> adjacent extents together (and hence change what is returned by
>>>>> FIEMAP) might be strange, or even weird --- but is this any of user
>>>>> space's business?  Or anything we want to enforce as wrong wrong wrong
>>>>> by xfstests?
>>>
>>> So I was asking for a review from ext4 side instead of queuing it for
>>> next xfstests update :)
>>
>> In general FIEMAP can return pretty much whatever it wants, which
>> usually means that it won't report extents larger than the underlying
>> block mapping extents, though as we've seen it can split a single
>> on-disk extent into multiple FIEMAP records for the purpose of reporting
>> sharedness.
>>
>> For ext3 I'm wondering if it's the case that the first time we FIEMAP an
>> indirect map file we see a possibly-merged version of whatever's in the
>> particular leaf node we land in; then that information gets cached &
>> merged with other records in the extent status tree, such that
>> subsequent FIEMAP calls see longer extents than the first time around.
>>
>>>> I had the same question.  If the exact behavior isn't defined anywhere,
>>>> I don't know what we can be testing, TBH.
>>>
>>> Agreed, I was about to ask for the expected behavior today if there was
>>> no new review comments on this patch.
>>
>> I think the expected behavior is that any behavior is expected. :(
>
> I suppose that if any particular filesystem wants to enforce stricter
> rules for its own fiemap interface, that could be done in a
> filesystem-specific test...

Well, then some test cases need to be moved from generic to filesystem 
specified test, and some filsystems will have similar test cases.
I think it's a hell for maintainer to keep all these test cases consistent.

This is not the first time Btrfs failed to pass reflink and fiemap test 
designed for xfs though.
Btrfs does skip some generic test case originally designed for xfs, like 
generic/372.

But most of the time, xfs and btrfs can get consistent result.

And for btrfs side, we already have such fix now:
https://patchwork.kernel.org/patch/9668721/

It's OK that any fs can have either own fiemap behavior, but if it's a 
not big fix and the behavior itself is somewhat wired, why not joining 
the common behavior?

Thanks,
Qu

>
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
