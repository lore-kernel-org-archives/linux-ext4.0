From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH] fstest: regression test for ext4 crash consistency bug
Date: Tue, 26 Sep 2017 14:48:27 +0300
Message-ID: <CAOQ4uxispZ9WYDOt+dgYNs7rcFDopc6u0VHQvyAmw9y+D3UOmg@mail.gmail.com>
References: <1503830683-21455-1-git-send-email-amir73il@gmail.com>
 <59C8D147.1060608@cn.fujitsu.com> <CAOQ4uxgnK3mGKG+owRUNGyDVOCeicArwaufGgwXaSVxC26+peQ@mail.gmail.com>
 <59CA2FDF.5020806@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Ts'o" <tytso@mit.edu>, Eryu Guan <eguan@redhat.com>,
        Josef Bacik <jbacik@fb.com>, fstests <fstests@vger.kernel.org>,
        Ext4 <linux-ext4@vger.kernel.org>
To: Xiao Yang <yangx.jy@cn.fujitsu.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <59CA2FDF.5020806@cn.fujitsu.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 26, 2017 at 1:45 PM, Xiao Yang <yangx.jy@cn.fujitsu.com> wrote:
> On 2017/09/25 18:53, Amir Goldstein wrote:
>>
>> On Mon, Sep 25, 2017 at 12:49 PM, Xiao Yang<yangx.jy@cn.fujitsu.com>
>> wrote:
>>>
>>> On 2017/08/27 18:44, Amir Goldstein wrote:
>>>>
>>>> This test is motivated by a bug found in ext4 during random crash
>>>> consistency tests.
>>>>
>>>> This test uses device mapper flakey target to demonstrate the bug
>>>> found using device mapper log-writes target.
>>>>
>>>> Signed-off-by: Amir Goldstein<amir73il@gmail.com>
>>>> ---
>>>>
>>>> Ted,
>>>>
>>>> While working on crash consistency xfstests [1], I stubmled on what
>>>> appeared to be an ext4 crash consistency bug.
>>>>
>>>> The tests I used rely on the log-writes dm target code written
>>>> by Josef Bacik, which had little exposure to the wide community
>>>> as far as I know.  I wanted to prove to myself that the found
>>>> inconsistency was not due to a test bug, so I bisected the failed
>>>> test to the minimal operations that trigger the failure and wrote
>>>> a small independent test to reproduce the issue using dm flakey target.
>>>>
>>>> The following fsck error is reliably reproduced by replaying some fsx
>>>> ops
>>>> on overlapping file regions, then emulating a crash, followed by mount,
>>>> umount and fsck -nf:
>>>>
>>>>    ./ltp/fsx -d --replay-ops /tmp/8995.fsxops /mnt/scratch/testfile
>>>>    1 write 0x137dd thru    0x21445 (0xdc69 bytes)
>>>>    2 falloc        from 0xb531 to 0x16ade (0xb5ad bytes)
>>>>    3 collapse      from 0x1c000 to 0x20000, (0x4000 bytes)
>>>>    4 write 0x3e5ec thru    0x3ffff (0x1a14 bytes)
>>>>    5 zero  from 0x20fac to 0x27d48, (0x6d9c bytes)
>>>>    6 mapwrite      0x216ad thru    0x23dfb (0x274f bytes)
>>>>    All 7 operations completed A-OK!
>>>>    _check_generic_filesystem: filesystem on /dev/mapper/ssd-scratch is
>>>> inconsistent
>>>>    *** fsck.ext4 output ***
>>>>    fsck from util-linux 2.27.1
>>>>    e2fsck 1.42.13 (17-May-2015)
>>>>    Pass 1: Checking inodes, blocks, and sizes
>>>>    Inode 12, end of extent exceeds allowed value
>>>>            (logical block 33, physical block 33441, len 7)
>>>>    Clear? no
>>>>    Inode 12, i_blocks is 184, should be 128.  Fix? no
>>>
>>> Hi Amir,
>>>
>>> I always get the following output when running your xfstests test case
>>> 501.
>>
>> Now merged as test generic/456
>>
>>>
>>> ---------------------------------------------------------------------------
>>> e2fsck 1.42.9 (28-Dec-2013)
>>> Pass 1: Checking inodes, blocks, and sizes
>>> Inode 12, i_size is 147456, should be 163840. Fix? no
>>>
>>> ---------------------------------------------------------------------------
>>>
>>> Could you tell me how to get the expected output as you reported?
>>
>> I can't say I am doing anything special, but I can say that I get the
>> same output as you did when running the test inside kvm-xfstests.
>> Actually, I could not reproduce ANY of the the crash consistency bugs
>> inside kvm-xfstests. Must be something to do with different timing of
>> IO with KVM+virtio disks??
>>
>> When running on my laptop (Ubuntu 16.04 with latest kernel)
>> on a 10G SSD volume, I always get the error reported above.
>> I just re-verified with latest stable e2fsprogs (1.43.6).
>
> Hi Amir,
>
> I tested generic/456 with KVM+virtio disks and SATA volumes on some kernels

I don't understand. Did you also test without KVM?
Otherwise I suggest that you test without KVM/virtio.

> (including
> v3.10.0, the latest kernel), but i still got the same output as i reported.
>
> Could you determine whether the two different outputs are caused by the same
> bug
> or not ?

No idea if those are 2 symptoms of the same bug or 2 different bugs
I did not investigate the root cause.

Amir.
