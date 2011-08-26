From: Tao Ma <tm@tao.ma>
Subject: Re: [URGENT PATCH] ext4: fix potential deadlock in ext4_evict_inode()
Date: Fri, 26 Aug 2011 17:03:14 +0800
Message-ID: <4E576152.9060405@tao.ma>
References: <E1QwnAu-00087H-8X@tytso-glaptop.cam.corp.google.com> <20110826073507.GZ3162@dastard> <20110826084403.GA3162@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, Jiaying Zhang <jiayingz@google.com>,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:58752 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753592Ab1HZJDW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Aug 2011 05:03:22 -0400
In-Reply-To: <20110826084403.GA3162@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/26/2011 04:44 PM, Dave Chinner wrote:
> On Fri, Aug 26, 2011 at 05:35:07PM +1000, Dave Chinner wrote:
>> On Thu, Aug 25, 2011 at 11:33:44PM -0400, Theodore Ts'o wrote:
>>>
>>> Note: this will probably need to be sent to Linus as an emergency
>>> bugfix ASAP, since it was introduced in 3.1-rc1, so it represents a
>>> regression.
>>
>> It doesn't appear to be a bug. All of the new ext4 lockdep reports
>> in 3.1 I've seen (except for the mmap_sem/i_mutex one) are false
>> positives....
> 
> While the lockdep report is false positive, I agree that your
> change is the right fix to make - the IO completions are already
> queued on the workqueue, so they don't need to be flushed to get
> them to complete. All that needs to be done is call
> ext4_ioend_wait() for them to complete, and that gets rid of the
> i_mutex altogether. (*)
ext4_ioend_wait can't work here for a nasty bug. Please see the commit
log of 2581fdc8.

Thanks
Tao
