From: Waiman Long <waiman.long@hpe.com>
Subject: Re: [PATCH v3 1/2] ext4: Pass in DIO_SKIP_DIO_COUNT flag if inode_dio_begin()
 called
Date: Wed, 20 Apr 2016 11:59:36 -0400
Message-ID: <5717A768.3090903@hpe.com>
References: <1460484775-33359-1-git-send-email-Waiman.Long@hpe.com> <1460484775-33359-2-git-send-email-Waiman.Long@hpe.com> <20160414031634.GJ10643@dastard> <570FC379.7000107@hpe.com> <20160415081757.GK10643@dastard> <57112235.1090201@hpe.com> <20160415221918.GA21184@destitution> <571539A6.5070401@hpe.com> <20160419230129.GD18517@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	<linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160419230129.GD18517@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 04/19/2016 07:01 PM, Dave Chinner wrote:
> On Mon, Apr 18, 2016 at 03:46:46PM -0400, Waiman Long wrote:
>> On 04/15/2016 06:19 PM, Dave Chinner wrote:
>>> On Fri, Apr 15, 2016 at 01:17:41PM -0400, Waiman Long wrote:
>>>> On 04/15/2016 04:17 AM, Dave Chinner wrote:
>>>>> On Thu, Apr 14, 2016 at 12:21:13PM -0400, Waiman Long wrote:
>>>>>> What the patch does is to eliminate the innermost
>>>>>> inode_dio_begin/end pair.
>>>>> Yes, and with that change inode_dio_wait() no longer waits for
>>>>> AIO+DIO writes on ext4, hence breaking truncate IO barrier
>>>>> requirements of inode_dio_wait().
>>>>>
>>>>> Cheers,
>>>>>
>>>>> Dave.
>>>> You are right and thank for pointing this out to me. I think I focus too
>>>> much on the dax_do_io() internal and didn't realize that inode_dio_end() can
>>>> be deferred in __blockdev_direct_IO(). I will update my patch to eliminate
>>>> the extra inode_dio_begin/end pair only for dax_do_io().
>>> Even there there is the risk that a future change will break ext4.
>>> the ext4 code needs fixing first, then you can look at skipping the
>>> DIO based counting everywhere.
>>>
>>> i.e. fix the root cause of the problem, don't hack around it or
>>> throw band-aids over it.
>> I agree that the ext4 code needs fixing w.r.t. the problem that you
>> found. That will take more time and testing. In the mean time, I
>> think it is OK to pick the low-hanging fruits that are handled by my
>> patch.
> IOWs, you're saying that you won't fix the problem, because all you
> care about is scalability results. This is how we end up with code
> that breaks randomly in future because if it doesn't get fixed now,
> nobody will fix the underlying problem. So, fix it now, fix it
> properly and you still get your scalability improvement without
> leaving a landmine that will explode on someone else in future.
>
> Fix it now, fix it properly.

I am not saying that I will not fix it. I am just saying that I need 
more time to fully understand what code changes need to be done. I am 
not that well versed in the filesystem internal, though it will be a 
good learning experience for me.

Cheers,
Longman
