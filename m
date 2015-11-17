From: Zhang AiHua <zhangaihua1@huawei.com>
Subject: Re: [PATCH] fix compile error while opening the macro DOUBLE_CHECK
Date: Tue, 17 Nov 2015 14:31:14 +0800
Message-ID: <564AC9B2.8040106@huawei.com>
References: <1447729443-14698-1-git-send-email-zhangaihua1@huawei.com>
 <20151117040305.GA10663@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <tytso@mit.edu>, <linux-ext4@vger.kernel.org>,
	<stable@vger.kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20151117040305.GA10663@kroah.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Hi,

     I want to submit the patch to mainline, I feel so ashamed for dist=
urbing you,
you can ignore it....  I have written wrong email.
     Later, when I need, I will read Documentation/stable_kernel_rules.=
txt first,
thank you anyway.

Regards, AiHua.


=E5=9C=A8 2015/11/17 12:03, Greg KH =E5=86=99=E9=81=93:
> On Tue, Nov 17, 2015 at 11:04:03AM +0800, zhangaihua1@huawei.com wrot=
e:
>> From: Aihua Zhang <zhangaihua1@huawei.com>
>>
>> the error is:
>>      fs/ext4/mballoc.c:475:43: error: 'struct ext4_group_info' has
>> no member named 'bb_bitmap'
>>      the definition of macro should before 'struct ext4_group_info'
>>
>> Signed-off-by: Aihua Zhang <zhangaihua1@huawei.com>
>> ---
>>   fs/ext4/ext4.h    |   12 ++++++++++++
>>   fs/ext4/mballoc.h |   12 ------------
>>   2 files changed, 12 insertions(+), 12 deletions(-)
>
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read Documentation/stable_kernel_rules.tx=
t
> for how to do this properly.
>
> </formletter>
>
> .
>
