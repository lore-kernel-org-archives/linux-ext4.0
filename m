From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: xfstests 252 failure
Date: Tue, 14 Jun 2011 12:37:25 -0700
Message-ID: <4DF7B875.7090700@linux.vnet.ibm.com>
References: <4DF78127.40505@linux.vnet.ibm.com> <4DF78716.4040605@redhat.com> <4DF7AB76.8030701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56104 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab1FNThu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Jun 2011 15:37:50 -0400
In-Reply-To: <4DF7AB76.8030701@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/14/2011 11:41 AM, Josef Bacik wrote:
> On 06/14/2011 12:06 PM, Eric Sandeen wrote:
>> On 6/14/11 10:41 AM, Allison Henderson wrote:
>>> Hi all,
>>>
>>> I just wanted to get some ideas moving on this question before too
>>> much time goes by. Ext4 is currently failing xfstest 252, test number
>>> 12. Currently test 12 is:
>>>
>>>      $XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
>>>          -c "$alloc_cmd 0 20k" \
>>>          -c "pwrite 8k 4k" -c "fsync" \
>>>          -c "$zero_cmd 4k 12k" \
>>>          -c "$map_cmd -v" $testfile | $filter_cmd
>>>      [ $? -ne 0 ]&&   die_now
>>
>> so the file should go through these steps:
>> (H=hole, P=prealloc, D=data)
>>
>> 0k                       20k
>> |  H |  H |  H |  H |  H | (truncate)
>> |  P |  P |  P |  P |  P | (alloc_cmd)
>> |  P |  P |  D |  P |  P | (pwrite)
>> <fsync>                     (fsync)
>> |  P |  H |  H |  H |  P | (punch)
>>
>>> and the output is:
>>>
>>>          12. unwritten ->  data ->  unwritten
>>> 0: [0..7]: unwritten
>>> 1: [8..31]: hole
>>> 2: [32..39]: unwritten
>>>
>>> Ext4 gets data extents here instead of unwritten extents.
>>
>> so it's like this?
>>
>> 0: [0..7]: data
>> 1: [8..31]: hole
>> 2: [32..39]: data
>>
>>> I did some
>>> investigating and it looks like the fsync command causes the extents
>>> to be written out before the punch hole operation starts. It looks
>>> like what happens is that when an unwritten extent gets written to,
>>> it doesnt always split the extent. If the extent is small enough,
>>> then it just zeros out the portions that are not written to, and the
>>> whole extent becomes a written extent. Im not sure if that is
>>> incorrect or if we need to change the test to not compare the extent
>>> types.
>>
>> Yes, it does do that IIRC.
>>
>> I probably need to look closer, but any test which expects exact
>> layouts from a filesystem after a series of operations is probably
>> expecting too much...
>>
>>  From a data integrity perspective, written zeros is as good as a hole is
>> as good as preallocated space, so I suppose those should all be acceptable,
>> though I guess "punch" should result in holes exactly as requested.
>>
>>> It looks to me that the code in ext4 that does this is supposed to be
>>> an optimization to help reduce fragmentation. We could change the
>>> filters to print just "extent" instead of "unwritten" or "data", but
>>> I realize that probably makes the test a lot less effective for xfs.
>>> If anyone can think of some more elegant fixes, please let me know.
>>> Thx!
>>
>> Josef, what do you think?  It's your test originally.  :)
>>
>
> Yes, a test that was really only meant to test the block based fiemap
> since they all act in a dumb and easy to verify way.  I think if we want
> to keep this test we should probably have it just recognize these little
> optimizations so it doesn't freak out.  Thanks,
>
> Josef

Alrighty then, so it sounds like we should adjust the filters to only 
recognize extents and holes, and then add a checksum to the punched 
files.  I think that seems pretty straight forward.  I already have a 
patch set out there that is adding more punch hole tests, so I can add 
these changes in with it if everyone is ok with that.  Thx!

Allison Henderson
