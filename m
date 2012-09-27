From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v2 07/10] vfs: fork one kthread to update data temperature
Date: Thu, 27 Sep 2012 14:54:22 +0800
Message-ID: <CAEH94LgMXNZ_6Cs-YbhWVocO6jWb+Xq8=xgooimCFGnFbuEw5Q@mail.gmail.com>
References: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
	<1348404995-14372-8-git-send-email-zwu.kernel@gmail.com>
	<20120927040357.GO15236@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	cmm@us.ibm.com, tytso@mit.edu, marco.stornelli@gmail.com,
	stroetmann@ontolinux.com, diegocg@gmail.com, chris@csamuel.org,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120927040357.GO15236@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 27, 2012 at 12:03 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Sep 23, 2012 at 08:56:32PM +0800, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>>   Fork and run one kernel kthread to calculate
>> that temperature based on some metrics kept
>> in custom frequency data structs, and store
>> the info in the hash table.
>
> No new kthreads, please. Use a per-superblock workqueue and a struct
> delayed_work to run periodic work on each superblock.
If no new kthread is created, which kthread will work on these
delayed_work tasks?

>
> That will also remove all the nasty, nasty
> !hot_track_temperature_update_kthread checks from the code, too.
>
> Also, I'd separate the work that the workqueue does from the patch
> that introduces the work queue. That way there is only one new thing
> to comment on in the patch. Further, I'd separate the aging code
> from the code that updates the temperature map into it's own patch
> as well..
>
> Finally, you're going to need a shrinker to control the amount of
> memory that is used in tracking hot regions - if we are throwing
> inodes out of memory due to memory pressure, we most definitely are
> going to need to reduce the amount of memory the tracking code is
> using, even if it means losing useful information (i.e. the shrinker
> accelerates the aging process).
Great, I agree with you.
>
> Given the above, and the other comments earlier in the series,
> there's not a lot of point in me spending time commenting on ethe
> code in detail here as it will change significantly as a result of
> all the earlier comments....
OK,  i will complete the code change based on all your earlier comments ASAP.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,

Zhi Yong Wu
