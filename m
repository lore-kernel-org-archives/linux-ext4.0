From: Ike Panhc <ike.pan@canonical.com>
Subject: Re: [Bisect] ext4_validate_inode_bitmap:98: comm stress-ng: Corrupt
 inode bitmap
Date: Wed, 11 Jul 2018 16:57:16 +0800
Message-ID: <b39169ad-2237-0a4f-e3d1-afc51ac10fa5@canonical.com>
References: <20180706174324.GA3049@xps13.dannf>
 <20180707041018.GB3546@thunk.org> <20180710165143.GA20459@xps13.dannf>
 <20180710204329.GB20459@xps13.dannf>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: dann frazier <dann.frazier@canonical.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, yanaijie@huawei.com,
        colin.king@canonical.com, kamal.mostafa@canonical.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180710204329.GB20459@xps13.dannf>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 07/11/2018 04:43 AM, dann frazier wrote:
> On Tue, Jul 10, 2018 at 10:51:43AM -0600, dann frazier wrote:
>> On Sat, Jul 07, 2018 at 12:10:18AM -0400, Theodore Y. Ts'o wrote:
>>> On Fri, Jul 06, 2018 at 11:43:24AM -0600, dann frazier wrote:
>>>> Hi,
>>>>   We're seeing a regression triggered by the stress-ng[*] "chdir" test
>>>> that I've bisected to:
>>>>
>>>> 044e6e3d74a3 ext4: don't update checksum of new initialized bitmaps
>>>>
>>>> So far we've only seen failures on servers based on HiSilicon's family
>>>> of ARM64 SoCs (D05/Hi1616 SoC, D06/Hi1620 SoC). On these systems it is
>>>> very reproducible.
>>>
>>> Thanks for the report.  Can you verify whether or not this patch fixes
>>> things for you?
>>
>> hey Ted,
>>   Sorry for the delayed response - was afk for a long weekend.
>> Your patch does seem to fix the issue for me - after applying the
>> patch, I was able to survive 20 iterations (and counting), where
>> previously it would always fail the first time.
>>
>> However, I've received a conflicting report from a colleague who
>> appears to still be seeing errors. I'll get back to you ASAP once I am
>> able to (in-?)validate that observation.
> 
> OK - I believe I found an explanation for my colleague's continued
> test failures after applying the patch. The filesystem being used may
> have already been corrupted from a previous run, and the test w/ your
> patch just tripped over it. Details are here starting in comment #9 if
> you'd like to look them over:
> 
>   https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1780137
> 
>   -dann
> 

Review console log and on each run I have filesystem rebuild. The problem
is that mke2fs I am using is 1.44.3-rc2. I am now reseting the environment
and re-test.

-- Ike
