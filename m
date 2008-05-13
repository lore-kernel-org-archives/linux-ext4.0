From: Tiger Yang <tiger.yang@oracle.com>
Subject: Re: [PATCH] ext3/4: fix uninitialized bs in ext3/4_xattr_set_handle()
Date: Tue, 13 May 2008 15:48:19 +0800
Message-ID: <482947C3.9040601@oracle.com>
References: <4827B878.50903@oracle.com> <4828DE73.2070001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4828DE73.2070001@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi, Eric,

I don't have tesecase about this bug. I did the test manually. I use 
khexedit to confirm the attributes whether in inody or block.
The problem about this bug is we want to replace an existing attribute 
in ibody with big size value which larger than free space in ibody.
Because we didn't do block_find(), so the struct bs have not been 
initialized. Then when we try to set attribute in block by block_set(), 
we find bs->base is empty, we need alloc a new block for attributes. The 
old block pointed by i_file_acl will lost with attributes in it.

Best regards,
tiger

Eric Sandeen wrote:
> Tiger Yang wrote:
>   
>> Hi,
>> I met a bug when I try to replace a xattr entry in ibody with a big size 
>> value. But in ibody there has no space for the new value. So it should 
>> set new xattr entry in block and remove the old xattr entry in ibody.
>>
>> Best regards,
>> tiger
>>
>>     
>
> Tiger, do you have a testcase handy to demonstrate this?
>
> Is the new, large out-of-inode xattr unique so that it does not match
> any existing attribute block, I assume?
>
> Thanks,
>
> -Eric
>   
