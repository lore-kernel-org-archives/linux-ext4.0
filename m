From: Tao Ma <tm@tao.ma>
Subject: Re: [URGENT PATCH] ext4: fix potential deadlock in ext4_evict_inode()
Date: Fri, 26 Aug 2011 17:10:35 +0800
Message-ID: <4E57630B.7000202@tao.ma>
References: <E1QwnAu-00087H-8X@tytso-glaptop.cam.corp.google.com> <20110826073507.GZ3162@dastard> <20110826084403.GA3162@dastard> <20110826085057.GA13311@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>,
	Jiaying Zhang <jiayingz@google.com>, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:54125 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754566Ab1HZJKk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Aug 2011 05:10:40 -0400
In-Reply-To: <20110826085057.GA13311@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Christoph,
On 08/26/2011 04:50 PM, Christoph Hellwig wrote:
> On Fri, Aug 26, 2011 at 06:44:03PM +1000, Dave Chinner wrote:
>> While the lockdep report is false positive, I agree that your
>> change is the right fix to make - the IO completions are already
>> queued on the workqueue, so they don't need to be flushed to get
>> them to complete. All that needs to be done is call
>> ext4_ioend_wait() for them to complete, and that gets rid of the
>> i_mutex altogether. (*)
> 
> The really correct fix is to stop using the ioend wait like I did
> in my pending series for XFS.  The only thing preventing ext4 from
> doing that is that it marks pages uptodate from irq context,
> before finishing the ioends.  This has a lot of nasty implications
> as the the page might be marked uptodate without actually having
> that state on disk.
yeah, the DIO read on a buffer write file issue is also another side
effect of it.[1]
So could you please talk a little more about how xfs handle it now?

[1] http://www.spinics.net/lists/linux-ext4/msg27139.html

Thanks
Tao
