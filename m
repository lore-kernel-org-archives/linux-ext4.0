From: Dolev Raviv <draviv@codeaurora.org>
Subject: Re: Quadrant write performance degradation - kernel3.10 vs kernel3.4
Date: Tue, 01 Jul 2014 10:07:18 +0300
Message-ID: <53B25E26.6040201@codeaurora.org>
References: <539E8860.3010602@codeaurora.org> <20140616192009.GD9743@birch.djwong.org> <alpine.LFD.2.00.1406170949020.2148@localhost.localdomain> <20140620023615.GA21301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Tanya Brokhman <tlinder@codeaurora.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	kdorfman@codeaurora.org, merez@codeaurora.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140620023615.GA21301@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


On 06/20/2014 05:36 AM, Zheng Liu wrote:
> On Tue, Jun 17, 2014 at 09:52:46AM +0200, Luk=C3=A1=C5=A1 Czerner wro=
te:
>> On Mon, 16 Jun 2014, Darrick J. Wong wrote:
>>
>>> Date: Mon, 16 Jun 2014 12:20:09 -0700
>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>> To: Tanya Brokhman <tlinder@codeaurora.org>
>>> Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
>>>      kdorfman@codeaurora.org, merez@codeaurora.org,
>>>      Dolev Raviv <draviv@codeaurora.org>
>>> Subject: Re: Quadrant write performance degradation - kernel3.10 vs=
 kernel3.4
>>>
>>> On Mon, Jun 16, 2014 at 09:02:08AM +0300, Tanya Brokhman wrote:
>>>> Hello,
>>>> Recently we encountered a performance degradation on 3.10kernel
>>>> based build, compared to 3.4 based one, when running the fs_write
>>>> Quadrant benchmark.
>>>> We profiled the test and came to the conclusion that the root caus=
e
>>>> of the degradation is in the vfs_write call stack (overhead of
>>>> 2611.2us is observed in 3.10 kernel compared to 3.4):
>>>>
>>>> ret_fast_syscall
>>>> SyS_write
>>>> vfs_write (total time spent: 3.10kernel-21295us, 3.4kernel-18683.7=
9us)
>>>> do_sync_write
>>>> ext4_file_write
>>>> generic_file_aio_write (total time spent: 3.10kernel-19124.4us,
>>>> 3.4kernel-16815us)
>>>> __generic_file_aio_write
>>>> generic_file_buffered_write
>>>> ext4_da_write_begin (total time spent: 3.10kernel-10935.2us,
>>>> 3.4kernel-8444.6us)
>>>> __block_write_begin
>>>> ext4_da_get_block_prep (total time spent: 3.10kernel-5402.6us,
>>>> 3.4kernel-3576.8us)
>>>> ext4_es_lookup_extent  (total time spent: 3.10kernel-2219.7us,
>>>> 3.4kernel-0us)
> [snip]
>>>> 2) Extents status tracking: https://git.kernel.org/cgit/linux/kern=
el/git/stable/linux-stable.git/tree/fs/ext4/extents_status.c?id=3Drefs/=
tags/v3.10.42#n20
>>>> =E2=80=9CThere is a cache extent for write access, so if writes ar=
e not very
>>>> random, adding space operations are in O(1) time.=E2=80=9D
>>> I'm no expert on the extent status cache, but this seems like a pos=
sible cause.
>> Exactly, there has been some fixes since the introduction of extent
>> status tree, however I've noticed some performance going down as
>> well and I believe that extent status tree is to blame.
>>
>> AFAIK you can not turn it off in any way, but there might be some
>> way to test it's overhead. Zheng, do you have any suggestions ?
> Sigh, sorry for the delay reply.
>
> Lukas, Could you please share your test with me?  From the calltrace =
it
> seems that the latency is in ext4_da_get_block_prep.  It is not easy =
to
> disable ext4_es_lookup_extent() because we need to lookup delayed ext=
ent
> from extent status tree and determine whether or not we need to reser=
ve
> some disk spaces.
>
> Tanya, I really appreciate if you can disable delalloc and re-run you=
r
> test.  You can use the following command to turn off the delalloc
> feature.
>
>   $ sudo mount -t ext4 -o remount,nodelalloc ${DEV} ${MNT}
>
> Thanks,
>                                                  - Zheng
Thanks Zheng, Lukas and all for your help.
Zheng, we have tested with the delalloc feature turned off. We didn't=20
notice any Improvement.

Any other suggestions :) , or other thought regarding this?
>> Thanks!
>> -Lukas
>>
>>> --D
>>>> We tried pick up several performance-enhancement patches from the
>>>> community, released between 3.10 and 3.14 kernel versions. The
>>>> performance was almost the same.
>>>>
>>>> I was wondering what performance tests were performed on these
>>>> features? Has anyone encountered same issue?
>>>>
>>>> Best Regards
>>>> Tanya Brokhman
>>>> --=20
>>>> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is =
a member
>>>> of Code Aurora Forum, hosted by The Linux Foundation
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ex=
t4" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
