From: "Yan, Zheng" <ukernel@gmail.com>
Subject: Re: [PATCH] ext4: fix delayed pages writback regression.
Date: Tue, 10 Sep 2013 10:02:33 +0800
Message-ID: <CAAM7YA=tU7+FbeKovPua2K=eeViJm1MidXPfHUUX=gHSv2pmqw@mail.gmail.com>
References: <1378697117-5894-1-git-send-email-zheng.z.yan@intel.com>
	<20130909135221.GC1612@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, lkp@linux.intel.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:57827 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab3IJCCf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Sep 2013 22:02:35 -0400
Received: by mail-lb0-f170.google.com with SMTP id w7so5776833lbi.29
        for <linux-ext4@vger.kernel.org>; Mon, 09 Sep 2013 19:02:34 -0700 (PDT)
In-Reply-To: <20130909135221.GC1612@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 9, 2013 at 9:52 PM, Jan Kara <jack@suse.cz> wrote:
>   Hello,
>
>   Thanks for testing and the report.
>
> On Mon 09-09-13 11:25:17, Yan, Zheng wrote:
>> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>>
>> Our Linux Kernel Performance project found that commit 4e7ea81db5
>> (ext4: restructure writeback path) indroduced a read performance
>> regression. After the commit, ext4 does not merge adjacent delayed
>   Really "read performance regression"? Do you mean that the file was more
> fragmented and therefore reading got slower? Or how exactly did a change in
> writeback path cause read perfomance regression?
>
> Also what benchmark and HW configuration do you use for testing? And how
> big regression do you see exactly? I can try to reproduce the results...

It's fio benchmark, about 50% regression. job file is attached below.

---
[global]
direct=0
ioengine=mmap
size=1500M
bs=4k
pre_read=1
numjobs=1
overwrite=1
loops=5
runtime=300
group_reporting
invalidate=0
directory=/mnt/stp/fiodata
file_service_type=random:36
file_service_type=random:36

[job_sdb1_sub0]
startdelay=0
rw=randrw
filename=data0/f1:data0/f2

[job_sdb1_sub1]
startdelay=0
rw=randrw
filename=data0/f2:data0/f1

[job_sdb1_sub2]
startdelay=0
rw=randrw
filename=data0/f1:data0/f2

[job_sdb1_sub3]
startdelay=0
rw=randrw
filename=data0/f2:data0/f1

[job_sdb1_sub4]
startdelay=0
rw=randrw
filename=data0/f1:data0/f2

[job_sdb1_sub5]
startdelay=0
rw=randrw
filename=data0/f2:data0/f1

[job_sdb1_sub6]
startdelay=0
rw=randrw
filename=data0/f1:data0/f2

[job_sdb1_sub7]
startdelay=0
rw=randrw
filename=data0/f2:data0/f1

[job_sdc1_sub0]
startdelay=0
rw=randrw
filename=data1/f1:data1/f2

[job_sdc1_sub1]
startdelay=0
rw=randrw
filename=data1/f2:data1/f1

[job_sdc1_sub2]
startdelay=0
rw=randrw
filename=data1/f1:data1/f2

[job_sdc1_sub3]
startdelay=0
rw=randrw
filename=data1/f2:data1/f1

[job_sdc1_sub4]
startdelay=0
rw=randrw
filename=data1/f1:data1/f2

[job_sdc1_sub5]
startdelay=0
rw=randrw
filename=data1/f2:data1/f1

[job_sdc1_sub6]
startdelay=0
rw=randrw
filename=data1/f1:data1/f2

[job_sdc1_sub7]
startdelay=0
rw=randrw
filename=data1/f2:data1/f1

[job_sdd1_sub0]
startdelay=0
rw=randrw
filename=data2/f1:data2/f2

[job_sdd1_sub1]
startdelay=0
rw=randrw
filename=data2/f2:data2/f1

[job_sdd1_sub2]
startdelay=0
rw=randrw
filename=data2/f1:data2/f2

[job_sdd1_sub3]
startdelay=0
rw=randrw
filename=data2/f2:data2/f1

[job_sdd1_sub4]
startdelay=0
rw=randrw
filename=data2/f1:data2/f2

[job_sdd1_sub5]
startdelay=0
rw=randrw
filename=data2/f2:data2/f1

[job_sdd1_sub6]
startdelay=0
rw=randrw
filename=data2/f1:data2/f2

[job_sdd1_sub7]
startdelay=0
rw=randrw
filename=data2/f2:data2/f1

[job_sde1_sub0]
startdelay=0
rw=randrw
filename=data3/f1:data3/f2

[job_sde1_sub1]
startdelay=0
rw=randrw
filename=data3/f2:data3/f1

[job_sde1_sub2]
startdelay=0
rw=randrw
filename=data3/f1:data3/f2

[job_sde1_sub3]
startdelay=0
rw=randrw
filename=data3/f2:data3/f1

[job_sde1_sub4]
startdelay=0
rw=randrw
filename=data3/f1:data3/f2

[job_sde1_sub5]
startdelay=0
rw=randrw
filename=data3/f2:data3/f1

[job_sde1_sub6]
startdelay=0
rw=randrw
filename=data3/f1:data3/f2

[job_sde1_sub7]
startdelay=0
rw=randrw
filename=data3/f2:data3/f1


>
>> pages during writeback. The regression is caused by the "buffer
>> mapped" check in mpage_add_bh_to_extent(), delayed dirty pages are
>> not mapped.
>   This shouldn't happen. As a comment before ext4_da_get_block_prep()
> describes, delayed allocated buffers should be marked with BH_Mapped |
> BH_New | BH_Delay. So if you can see BH_Delay buffers without BH_Mapped set
> that's a bug we should find.

Sorry, I re-ran the test and found it's the "(!buffer_delay(bh) &&
!buffer_unwritten(bh))"
check that prevents the merging. I will send a new patch soon

Regards
Yan, Zheng


>
>                                                                 Honza
>>
>> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
>> ---
>>  fs/ext4/inode.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index c79fd7d..f2034cb 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -1944,8 +1944,9 @@ static bool mpage_add_bh_to_extent(struct mpage_da_data *mpd, ext4_lblk_t lblk,
>>       struct ext4_map_blocks *map = &mpd->map;
>>
>>       /* Buffer that doesn't need mapping for writeback? */
>> -     if (!buffer_dirty(bh) || !buffer_mapped(bh) ||
>> -         (!buffer_delay(bh) && !buffer_unwritten(bh))) {
>> +     if (!buffer_dirty(bh) ||
>> +         (!buffer_mapped(bh) &&
>> +          !buffer_delay(bh) && !buffer_unwritten(bh))) {
>>               /* So far no extent to map => we write the buffer right away */
>>               if (map->m_len == 0)
>>                       return true;
>> --
>> 1.8.1.4
>>
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
