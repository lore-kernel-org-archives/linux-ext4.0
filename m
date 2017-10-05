From: Xiao Yang <yangx.jy@cn.fujitsu.com>
Subject: Re: [RFC][PATCH] fstest: regression test for ext4 crash consistency
 bug
Date: Thu, 5 Oct 2017 15:27:28 +0800
Message-ID: <59D5DEE0.6080506@cn.fujitsu.com>
References: <1503830683-21455-1-git-send-email-amir73il@gmail.com> <59C8D147.1060608@cn.fujitsu.com> <CAOQ4uxgnK3mGKG+owRUNGyDVOCeicArwaufGgwXaSVxC26+peQ@mail.gmail.com> <CAFk8rvYvrGo6SjA6e0yj0XL_BARMmZoofB5kESM4EY4S2n-==w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Amir Goldstein <amir73il@gmail.com>, Theodore Ts'o <tytso@mit.edu>,
        Eryu Guan <eguan@redhat.com>, Josef Bacik <jbacik@fb.com>,
        fstests <fstests@vger.kernel.org>,
        Ext4 <linux-ext4@vger.kernel.org>,
        Vijay Chidambaram <vvijay03@gmail.com>
To: Ashlie Martinez <ashmrtn@utexas.edu>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <CAFk8rvYvrGo6SjA6e0yj0XL_BARMmZoofB5kESM4EY4S2n-==w@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2017/09/30 22:15, Ashlie Martinez wrote:
> Hi Xiao,
>
> I am a student at the University of Texas at Austin. Some researchers
> in the computer science department at UT, myself included, have
> recently been working to develop a file system crash consistency test
> harness called CrashMonkey [1][2]. I have been working on the
> CrashMonkey project since it was started late last year. With
> CrashMonkey we have also been able to reproduce the incorrect i_size
> error you noted but we have not been able to reproduce the other
> output that Amir found. CrashMonkey works by logging and replaying
> operations for a workload, so it should not be sensitive to
> differences in timing that could be caused by things like KVM+virtio.
> I also did a few experiments with Amir's new xfstests test 456 (both
> with and without KVM and virtio) and I was unable to reproduce the
> output noted in the xfstest. I have not spent a lot of time looking
> into the cause of the bug that Amir found and it is rather unfortunate
> that I was unable to reproduce it with either xfstests or CrashMonkey.
Hi Ashlie,

Thanks for your detailed comments.

1) Do you think the output that Amir noted in xfstests is a false positive?

2) About the output that both i and you reproduced,  did you look into 
it and find its root cause?

Thanks,
Xiao Yang
> At any rate, CrashMonkey is still under development, so it does have
> some caveats. First, we are running with a fixed random seed in our
> default RandomPermuter (used to generate crash states) to aid
> development. Second, the branch with the reproduction of this ext4
> regression bug in CrashMonkey [3] will yield a few false positives due
> to the way CrashMonkey works and how fsx runs. These false positives
> are due to CrashMonkey generating crash states where the directories
> for files used for the test have not be fsync-ed in the file system.
> The top of the README in the CrashMonkey branch with this bug
> reproduction outlines how we determined these were false positives
>
> [1] https://github.com/utsaslab/crashmonkey
> [2] https://www.usenix.org/conference/hotstorage17/program/presentation/martinez
> [3] https://github.com/utsaslab/crashmonkey/tree/ext4_regression_bug
>
>
> On Mon, Sep 25, 2017 at 5:53 AM, Amir Goldstein<amir73il@gmail.com>  wrote:
>> On Mon, Sep 25, 2017 at 12:49 PM, Xiao Yang<yangx.jy@cn.fujitsu.com>  wrote:
>>> On 2017/08/27 18:44, Amir Goldstein wrote:
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
>>>> The following fsck error is reliably reproduced by replaying some fsx ops
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
>>>>    _check_generic_filesystem: filesystem on /dev/mapper/ssd-scratch is inconsistent
>>>>    *** fsck.ext4 output ***
>>>>    fsck from util-linux 2.27.1
>>>>    e2fsck 1.42.13 (17-May-2015)
>>>>    Pass 1: Checking inodes, blocks, and sizes
>>>>    Inode 12, end of extent exceeds allowed value
>>>>            (logical block 33, physical block 33441, len 7)
>>>>    Clear? no
>>>>    Inode 12, i_blocks is 184, should be 128.  Fix? no
>>> Hi Amir,
>>>
>>> I always get the following output when running your xfstests test case 501.
>> Now merged as test generic/456
>>
>>> ---------------------------------------------------------------------------
>>> e2fsck 1.42.9 (28-Dec-2013)
>>> Pass 1: Checking inodes, blocks, and sizes
>>> Inode 12, i_size is 147456, should be 163840. Fix? no
>>> ---------------------------------------------------------------------------
>>>
>>> Could you tell me how to get the expected output as you reported?
>> I can't say I am doing anything special, but I can say that I get the
>> same output as you did when running the test inside kvm-xfstests.
>> Actually, I could not reproduce ANY of the the crash consistency bugs
>> inside kvm-xfstests. Must be something to do with different timing of
>> IO with KVM+virtio disks??
>>
>> When running on my laptop (Ubuntu 16.04 with latest kernel)
>> on a 10G SSD volume, I always get the error reported above.
>> I just re-verified with latest stable e2fsprogs (1.43.6).
>>
>> Amir.
>
> .
>
