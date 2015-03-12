From: Beata Michalska <b.michalska@samsung.com>
Subject: Re: [RFC] ext4: Add pollable sysfs entry for block threshold events
Date: Thu, 12 Mar 2015 10:06:29 +0100
Message-ID: <55015715.6000201@samsung.com>
References: <1426068993-1051-1-git-send-email-b.michalska@samsung.com>
 <1426068993-1051-2-git-send-email-b.michalska@samsung.com>
 <alpine.LFD.2.00.1503111314230.11156@localhost.localdomain>
 <55007140.6060700@samsung.com>
 <alpine.LFD.2.00.1503111802160.23678@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kyungmin.park@samsung.com
To: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <alpine.LFD.2.00.1503111802160.23678@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 03/11/2015 06:49 PM, Luk=C3=A1=C5=A1 Czerner wrote:
> On Wed, 11 Mar 2015, Beata Michalska wrote:
>
>> Date: Wed, 11 Mar 2015 17:45:52 +0100
>> From: Beata Michalska <b.michalska@samsung.com>
>> To: Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>
>> Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.=
org,
>>     linux-kernel@vger.kernel.org, kyungmin.park@samsung.com
>> Subject: Re: [RFC] ext4: Add pollable sysfs entry for block threshol=
d events
>>
>> Hi,
>>
>> On 03/11/2015 03:12 PM, Luk=C3=A1=C5=A1 Czerner wrote:
>>> On Wed, 11 Mar 2015, Beata Michalska wrote:
>>>
>>>> Date: Wed, 11 Mar 2015 11:16:33 +0100
>>>> From: Beata Michalska <b.michalska@samsung.com>
>>>> To: tytso@mit.edu, adilger.kernel@dilger.ca
>>>> Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
>>>>     kyungmin.park@samsung.com
>>>> Subject: [RFC] ext4: Add pollable sysfs entry for block threshold =
events
>>>>
>>>> Add support for pollable sysfs entry for logical blocks
>>>> threshold, allowing the userspace to wait for
>>>> the notification whenever the threshold is reached
>>>> instead of periodically calling the statfs.
>>>> This is supposed to work as a single-shot notifiaction
>>>> to reduce the number of triggered events.
>>> Hi,
>>>
>>> I though you were advocating for a solution independent on the file
>>> system. This is ext4 only solution, but I do not really have
>>> anything against this.
>>>
>> I definitely was/am, but again, that would be an ideal case.
>> Until we work out some sensible solution, possibly based on your ide=
a you
>> have mentioned in another thread, I guess we have to stick to
>> what we've got. The ext4 is within our interest, thus the changes pr=
oposed.
> I agree, this change seems to be simple enough to serve as
> workaround for ext4 at the moment.
>
> ...snip...
>
>>>> @@ -2967,7 +2962,6 @@ ext4_mb_mark_diskspace_used(struct ext4_allo=
cation_context *ac,
>>>>  	if (err)
>>>>  		goto out_err;
>>>>  	err =3D ext4_handle_dirty_metadata(handle, NULL, gdp_bh);
>>>> -
>>> No reason to change that.
>>>
>>>>  out_err:
>>>>  	brelse(bitmap_bh);
>>>>  	return err;
>>>> @@ -4525,8 +4519,8 @@ out:
>>>>  						reserv_clstrs);
>>>>  	}
>>>> =20
>>>> +	ext4_block_thres_notify(sbi);
>>> I wonder whether it would not be better to have this directly in
>>> ext4_claim_free_clusters() ? Or maybe even better in
>>> ext4_has_free_clusters() where we already have some of the counters
>>> you need ?
>>>
>>> This would avoid the overhead of calculating this again since espec=
ially
>>> the percpu_counter might get quite expensive.
>>>
>> The idea was to call the notify once all the necessary arithmetic
>> has been done, to get the most up-to date data. And to limit the
>> number of calls to notify. In both cases: ext4_claim_free_clusters
>> and ext4_has_free_clusters, smth might go wrong afterwards so the co=
unters
>> might get updated thus affecting the final outcome of ext4_block_thr=
es_notify.
> Right, we might get memory allocation, error quota enospc and
> possibly more. However before we do, the space is actually already
> reserved and with your approach someone might get ENOSPC (or at
> least cross the threshold) without the notification.
>
> And secondly, consider for example a delayed allocation which will
> never be allocated because if was freed before we manage to do
> that. Similar case, but possibly with a bigger window.
>
> None of it actually matters too much since this is a threshold
> notification and by the time you get the notification the reality
> will be slightly different anyway. However I think that there is a
> big benefit of having this in one place and avoiding gathering all
> the calculations multiple times.
>
>>>> --- a/fs/ext4/super.c
>>>> +++ b/fs/ext4/super.c
>>>> @@ -2558,10 +2558,56 @@ static ssize_t reserved_clusters_store(str=
uct ext4_attr *a,
>>>>  	if (parse_strtoull(buf, -1ULL, &val))
>>>>  		return -EINVAL;
>>>>  	ret =3D ext4_reserve_clusters(sbi, val);
>>>> -
>>>> +	ext4_block_thres_notify(sbi);
>>> I do not think you count in reserved clusters at the moment. But
>>> it's definitely something you should count in.
>>>
>> Well, this is the difference between the free and available blocks.
>> AFAIK, the reserved blocks just mark the difference between those tw=
o,
>> and they are not being counted in as far as used blocks are being co=
ncerned,
>> at least from the user-space perspective, though I might be missing =
smth here.
> See ext4_statfs(). From user-space perspective those are accounted
> towards used blocks. In the same way as blocks reserved for root.
>
> This value (s_resv_clusters) is also taken into account when
> calculating space available for allocation in
> ext4_has_free_clusters().
>
> It might be a bit confusing, but please read ext4 documentation to
> see what reserved_clusters is for.
>
>>>>  	return ret ? ret : count;
>>>>  }
>>>> =20
>>>> +void ext4_block_thres_notify(struct ext4_sb_info *sbi)
>>>> +{
>>>> +	struct ext4_super_block *es =3D sbi->s_es;
>>>> +	unsigned long long bcount, bfree;
>>>> +
>>>> +	if (!atomic64_read(&sbi->block_thres_event))
>>>> +		/* No limit set -> no notification needed */
>>>> +		return;
>>>> +	/* Verify the limit has not been reached. If so notify the watch=
ers */
>>>> +	bcount =3D ext4_blocks_count(es) - EXT4_C2B(sbi, sbi->s_overhead=
);
>>>> +	bfree =3D percpu_counter_sum_positive(&sbi->s_freeclusters_count=
er) -
>>>> +		percpu_counter_sum_positive(&sbi->s_dirtyclusters_counter);
>>>> +	bfree =3D EXT4_C2B(sbi, max_t(s64, bfree, 0));
>>> Hmm is it even possible to have s_dirtyclusters_counter higher than
>>> s_freeclusters_counter ? If so, we might have a big problem
>>> somewhere.
>>>
>> =20
>> Looking at the code I would agree that this should not happen, thoug=
h=20
>> this precaution is being used by ext4_statfs, so I assume it actuall=
y
>> did happen (?).
> Maybe, but that was possibly a bug. So if block_thres_event will
> only be writable by root I'd be tempted to put ext4_warning if we
> see this case.
>
>>>> +
>>>> +	if (bcount - bfree > atomic64_read(&sbi->block_thres_event)) {
>>>> +		sysfs_notify(&sbi->s_kobj, NULL, "block_thres_event");
>>>> +		/* Prevent flooding notifications */
>>>> +		atomic64_set(&sbi->block_thres_event, 0);
>>>> +	}
>>>> +}
>>>> +
>>>> +static ssize_t block_thres_event_show(struct ext4_attr *a,
>>>> +					struct ext4_sb_info *sbi, char *buf)
>>>> +{
>>>> +	return snprintf(buf, PAGE_SIZE, "%llu\n",
>>>> +		atomic64_read(&sbi->block_thres_event));
>>>> +
>>>> +}
>>>> +
>>>> +static ssize_t block_thres_event_store(struct ext4_attr *a,
>>>> +					struct ext4_sb_info *sbi,
>>>> +					const char *buf, size_t count)
>>>> +{
>>>> +	struct ext4_super_block *es =3D sbi->s_es;
>>>> +	unsigned long long bcount, val;
>>>> +
>>>> +	bcount =3D ext4_blocks_count(es) - EXT4_C2B(sbi, sbi->s_overhead=
);
>>> Hmm this might get confusing since user would not expect that they
>>> can not set the limit up to the number of block in the file system.
>>> But even if they set it to the value where EXT4_C2B(sbi,
>>> sbi->s_overhead) would come to the play, they would get the
>>> notification immediately right ? So is it really needed ?
>>>
>> Is there much sens to set the threshold on the total number of block=
s?
>> If there is an overhead - the used blocks will never hit such thresh=
old,
>> would they? The notification gets triggered whenever the number of u=
sed blocks
>> exceeds the one specified as threshold, so in order to get it fired
>> we have to be actually using at least that much, so I'm not sure we =
can get
>> the case when total =3D=3D used.
> That's not the point. s_overhead is number of block that's used by
> static filesystem structures. When it comes to file system block and
> free space calculations people might view this differently (see
> bsddf vs. minixdf) so I'd like to avoid it altogether.
>
> Maybe having the threshold to be in number of free blocks available
> will be a better approach.
>
> Also do you plat to count with number of blocks reserved for root as
> well ? It might be a good idea since regular users can not allocate
> from that pool. Take a look at ext4_has_free_clusters() to see how
> we figure out whether we have enough block for the allocation to
> proceed.
>
> I think you should use the same approach otherwise the notificaion
> might get out of sync with what the filesystem will allow users to
> allocate.
>
> Thanks!
> -Lukas
The first idea was to have the threshold based on the number of free (a=
vailable)
blocks, but then it seemed more reasonable to have it in a form of used
blocks instead, basically just to better reflect the overall idea and t=
o
reduce the calculations needed. I guess though that it is worth getting
back to it.

I'll prepare reworked version addressing your comments and I'll post
it as soon as possible.
Thanks for all the clarification and tips.

BR
Beata
