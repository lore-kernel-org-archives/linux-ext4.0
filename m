From: Ashlie Martinez <ashmrtn@utexas.edu>
Subject: Re: [RFC][PATCH] fstest: regression test for ext4 crash consistency bug
Date: Thu, 5 Oct 2017 19:34:10 -0500
Message-ID: <CAFk8rvYtyraezVEP1e3LFEE+9t5YoRH2YwjKxex8hgSY74Lw7A@mail.gmail.com>
References: <1503830683-21455-1-git-send-email-amir73il@gmail.com>
 <59C8D147.1060608@cn.fujitsu.com> <CAOQ4uxgnK3mGKG+owRUNGyDVOCeicArwaufGgwXaSVxC26+peQ@mail.gmail.com>
 <CAFk8rvYvrGo6SjA6e0yj0XL_BARMmZoofB5kESM4EY4S2n-==w@mail.gmail.com>
 <59D5DEE0.6080506@cn.fujitsu.com> <CAFk8rvbi3MHbRBtaZVTJKDcORaDTtMpwy2X2ZdXTZt=LE5smZw@mail.gmail.com>
 <CAOQ4uxgc77_P472KEyHfAXSOE6DD7c=2VrJWBJT6ahiSYb=iJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Xiao Yang <yangx.jy@cn.fujitsu.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Eryu Guan <eguan@redhat.com>,
        Josef Bacik <jbacik@fb.com>, fstests <fstests@vger.kernel.org>,
        Ext4 <linux-ext4@vger.kernel.org>,
        Vijay Chidambaram <vvijay03@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:55755 "EHLO
        mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751980AbdJFAeN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Oct 2017 20:34:13 -0400
Received: by mail-vk0-f51.google.com with SMTP id i1so8913376vke.12
        for <linux-ext4@vger.kernel.org>; Thu, 05 Oct 2017 17:34:12 -0700 (PDT)
In-Reply-To: <CAOQ4uxgc77_P472KEyHfAXSOE6DD7c=2VrJWBJT6ahiSYb=iJQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 5, 2017 at 2:10 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, Oct 5, 2017 at 6:04 PM, Ashlie Martinez <ashmrtn@utexas.edu> wrote:
>> On Thu, Oct 5, 2017 at 2:27 AM, Xiao Yang <yangx.jy@cn.fujitsu.com> wrote:
>>> On 2017/09/30 22:15, Ashlie Martinez wrote:
>>>>
>>>> Hi Xiao,
>>>>
>>>> I am a student at the University of Texas at Austin. Some researchers
>>>> in the computer science department at UT, myself included, have
>>>> recently been working to develop a file system crash consistency test
>>>> harness called CrashMonkey [1][2]. I have been working on the
>>>> CrashMonkey project since it was started late last year. With
>>>> CrashMonkey we have also been able to reproduce the incorrect i_size
>>>> error you noted but we have not been able to reproduce the other
>>>> output that Amir found. CrashMonkey works by logging and replaying
>>>> operations for a workload, so it should not be sensitive to
>>>> differences in timing that could be caused by things like KVM+virtio.
>>>> I also did a few experiments with Amir's new xfstests test 456 (both
>>>> with and without KVM and virtio) and I was unable to reproduce the
>>>> output noted in the xfstest. I have not spent a lot of time looking
>>>> into the cause of the bug that Amir found and it is rather unfortunate
>>>> that I was unable to reproduce it with either xfstests or CrashMonkey.
>>>
>>> Hi Ashlie,
>>>
>>> Thanks for your detailed comments.
>>>
>>> 1) Do you think the output that Amir noted in xfstests is a false positive?
>>
>> It almost seems that way, though to be honest, I don't think I know
>> enough about 1. the setup used by Amir and 2. all the internal working
>> of KVM+virtio to say for sure.
>
> I believe you misread my email.
> The problem was NOT reproduced on KVM+virtio.
> The problem *is* reproduced on a 10G LVM volume over SSD on
> Ubuntu 16.04 with latest kernel and latest e2fsprogs.

I have also tried running generic/456 on non-KVM, non-virtio machines
and I was unable to reproduce it. Without information on test setups
individuals are using, it is very hard to tell where I, or other
people, are going wrong in testing other than maybe using a virtual
machine.

As an aside, it does not appear to be simply a timing issue due to
KVM+virtio. I would hope that CrashMonkey would still be able to find
the extent error you saw, even on a KVM VM since it is not dependent
on timing.

>
> There is no use in speculating why the problem doesn't happen on your
> systems. If the issue reproduces on A system (2 systems actually that I tested)
> that it is a problem.
>
> Attached is an e2image dump of the inconsistent file system following test
> generic/456 on my system.  I would have attached the image sooner,
> but since on my system problem reproduces 100% on the time, I did not think
> that was a need. Without an ext4 developer looking into this image, I don't
> really see the point in further discussion.
>
> I would be interesting to get more test samples from people running the test
> on other systems. If only some people see the error
> "end of extent exceeds allowed value"
> it would be interesting to find the commonality between those setups.
>

I agree it would be interesting to see why this error appears only for
some people.


>> One thing I have identified as being a
>> potential source of false positives is code in the kernel to remap the
>> block number sent to device drives to something relative to the start
>> of a block device, not the start of a partition. I'm thinking this
>> could cause trouble if 1. a partition higher than the first partition
>> is monitored by dm-log-writes, 2. the block numbers are recorded
>> verbatim in dm-log-writes, and 3. the dm-log-writes log is replayed on
>> a different device with different partitions (or possibly the same
>> device, but a different partition).
>
> You do realize that the test generic/456 is not using dm-log-writes at all.
> I intentionally took it out of the equation and used the even dumber dm-flakey
> target to demonstrate the crash inconsistency.

Oh, yes, I recall that now. The past few weeks have been very busy for
me with all of my other school work, so getting all of my i's dotted
and t's crossed has been a challenge. At any rate, I don't think it is
a real minus to mention the potential remapping of blocks in the cited
function. If people are going to use any sort of block device module
(be dm-log-writes or otherwise) then I think it would be good for
developers to be aware of.

>
>> I know some other undergrad
>> students at UT on the CrashMonkey team are looking into this right
>> now, but I have not had time to test this myself. The offending code
>> in the kernel is in the completely misnamed
>> `generic_make_request_checks` function which has given the CrashMonkey
>> team trouble in the past. Links to that function and the remapping
>> function it calls are below.
>>
>> http://elixir.free-electrons.com/linux/latest/source/block/blk-core.c#L2041
>> http://elixir.free-electrons.com/linux/latest/source/block/blk-core.c#L1902
>>
>>>
>>> 2) About the output that both i and you reproduced,  did you look into it
>>> and find its root cause?
>>
>> I have not looked to find the root cause of the issue that we both
>> reliably reproduce.
>>
>
> Now you have a broken file system image and the exact set of operations
> that led to it. That's should be a pretty big lead for investigation.
>
> Amir.
