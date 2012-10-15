From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v3 11/13] vfs: add 3 new ioctl interfaces
Date: Mon, 15 Oct 2012 15:57:22 +0800
Message-ID: <CAEH94LhtOXuiz7FqdiV3+9aoFmwvSbq0ybOyev0dY9veV9wcQg@mail.gmail.com>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
	<1349863655-29320-12-git-send-email-zwu.kernel@gmail.com>
	<20121015074811.GY2739@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	dave@jikos.cz, tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121015074811.GY2739@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 15, 2012 at 3:48 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Oct 10, 2012 at 06:07:33PM +0800, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>>   FS_IOC_GET_HEAT_INFO: return a struct containing the various
>> metrics collected in btrfs_freq_data structs, and also return a
>> calculated data temperature based on those metrics. Optionally, retrieve
>> the temperature from the hot data hash list instead of recalculating it.
>>
>>   FS_IOC_GET_HEAT_OPTS: return an integer representing the current
>> state of hot data tracking and migration:
>>
>> 0 = do nothing
>> 1 = track frequency of access
>>
>>   FS_IOC_SET_HEAT_OPTS: change the state of hot data tracking and
>> migration, as described above.
> .....
>> +struct hot_heat_info {
>> +     __u64 avg_delta_reads;
>> +     __u64 avg_delta_writes;
>> +     __u64 last_read_time;
>> +     __u64 last_write_time;
>> +     __u32 num_reads;
>> +     __u32 num_writes;
>> +     __u32 temperature;
>> +     __u8 live;
>> +     char filename[PATH_MAX];
>
> Don't put the filename in the ioctl and open the file in the kernel.
> Have userspace open the file directly and issue the ioctl on the fd
> that is returned.
OK, thanks. By the way, do you think that it is necessary to provide
another new ioctl interface to set the temperature value?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Regards,

Zhi Yong Wu
