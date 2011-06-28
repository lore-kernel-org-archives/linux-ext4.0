From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/3 v2] XFS TESTS: Fix 252 Failure: Update 252 Golden
 Output
Date: Tue, 28 Jun 2011 08:29:25 -0500
Message-ID: <4E09D735.5060000@redhat.com>
References: <1309235247-32650-1-git-send-email-achender@linux.vnet.ibm.com> <1309235247-32650-3-git-send-email-achender@linux.vnet.ibm.com> <20110628050900.GL32466@dastard> <4E09660B.7050706@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4E09660B.7050706@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 6/28/11 12:26 AM, Allison Henderson wrote:
> On 06/27/2011 10:09 PM, Dave Chinner wrote:
>> On Mon, Jun 27, 2011 at 09:27:26PM -0700, Allison Henderson wrote:
>>> New filtered golden output for test 252
>>>
>>> Signed-off-by: Allison Henderson<achender@linux.vnet.ibm.com>
>>> ---
>>> :100644 100644 930c924... fcfd121... M    252.out
>>>   252.out |  272 +++++++++++++++++++++++++++++++++++++++------------------------
>>>   1 files changed, 170 insertions(+), 102 deletions(-)
>>>
>>> diff --git a/252.out b/252.out
>>> index 930c924..fcfd121 100644
>>> --- a/252.out
>>> +++ b/252.out
>>> @@ -1,239 +1,307 @@
>>>   QA output created by 252
>>>       1. into a hole
>>> +daa100df6e6711906b61c9ab5aa16032
>>>       2. into allocated space
>>> -0: [0..7]: data
>>> +0: [0..7]: extent
>>>   1: [8..23]: hole
>>> -2: [24..39]: data
>>> +2: [24..39]: extent
>>> +cc58a7417c2d7763adc45b6fcd3fa024
>>
>> I don't really like the way this weakens the test for XFS. With this
>> change, the test no longer is checking that unwritten extent
>> behaviour is correct.
>>
>> Rather than weakening the test, perhaps it would be better to
>> execute 252 for XFS only (with the md5sums added), and then
>> duplicate it to a new test for all filesystems to run with the
>> weaker result checking that using the new filter function gives us.
>> With the amount of common code the two tests share, it should be
>> trivial to do this....
>>
> 
> Alrighty, that sounds pretty straight forward, as long as every one
> is in agreement. I think that would help retain the tests
> effectiveness. Eric, Josef, what are your thoughts?

Yeah, I agree, I share Dave's concerns and that sounds like a good
way to go.

Thanks,
-Eric

> Allison Henderson
> 
>> Cheers,
>>
>> Dave.
> 

