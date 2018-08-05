From: zhong jiang <zhongjiang@huawei.com>
Subject: Re: [PATCH] ext4/mballoc: Remove unneeded variable "err"
Date: Sun, 5 Aug 2018 20:59:33 +0800
Message-ID: <5B66F4B5.8030908@huawei.com>
References: <1533380696-16325-1-git-send-email-zhongjiang@huawei.com> <20180804212426.GE4461@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
To: "Theodore Y. Ts'o" <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180804212426.GE4461@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2018/8/5 5:24, Theodore Y. Ts'o wrote:
> On Sat, Aug 04, 2018 at 07:04:56PM +0800, zhong jiang wrote:
>> The err is not used after initalization. So just remove the variable.
>>
>> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> I'll apply this patch, but how did you generate the diff?  The
> function name here is all wrong:
>
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index 8b24d3d..e29fce2 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -3801,7 +3801,6 @@ static int ext4_mb_new_preallocation(struct ext4_allocation_context *ac)
>                                    ^^^^^^^^^^^^^^^^^^^^^^^^^
>
> The lines in question are from ext4_mb_release_inode_pa(), *not*
> ext4_mb_new_preallocation().  So when I inspected the patch visually,
> my first reaction was, "there's no way this patch would apply".
>
> But then I looked at the C code changed by the patch, and I was
> surprised to see that it applied correctly in a completely different
> function, and when I regenerated the patch, the line numbers matched
> yours --- so the only thing "wrong" in your patch is the function name.
>
> So that raises the question --- how did you create the diff in this-rc
> patch?  What version of git?  And what version of the kernel?
>
> Regards,
>
> 					- Ted
>
> .
>
 I  create the diff in this patch again ,but get the same result .  the git version is git version 1.7.12.4
 but I create  the diff in git version 1.8.3.1. It shows the correct function name.

The kernel version is  4.18-rc7.   I will upgrade the git version.

Thanks,
zhong jiang
