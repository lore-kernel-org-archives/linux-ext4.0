From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: Re: [PATCH] ext4: remove readpage() check up for mmap file
Date: Thu, 3 Jul 2014 09:37:12 +0800
Message-ID: <53B4B3C8.9000102@huawei.com>
References: <1404273488-4612-1-git-send-email-zhenzhang.zhang@huawei.com>  <53B38434.7030500@huawei.com> <1404314153.24795.4.camel@rzwisler-mobl1.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"jack@suse.cz" <jack@suse.cz>, "tytso@mit.edu" <tytso@mit.edu>,
	<wangnan0@huawei.com>
To: "Zwisler, Ross" <ross.zwisler@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:13067 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaGCBhe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jul 2014 21:37:34 -0400
In-Reply-To: <1404314153.24795.4.camel@rzwisler-mobl1.amr.corp.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2014/7/2 23:15, Zwisler, Ross wrote:
> On Wed, 2014-07-02 at 12:01 +0800, Zhang Zhen wrote:
>> There is no kind of file does not supply page reading function.
>>
>> Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
>> ---
>>  fs/ext4/file.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
>> index 8695f70..f5c0a17 100644
>> --- a/fs/ext4/file.c
>> +++ b/fs/ext4/file.c
>> @@ -202,8 +202,6 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
>>  {
>>  	struct address_space *mapping = file->f_mapping;
> 
> Assuming this change is correct, the 'mapping' variable is now unused and can
> also be deleted.
> 
Hi,

Thank you for your correction, sorry for my mistake.
I will send a new patch.
>>
>> -	if (!mapping->a_ops->readpage)
>> -		return -ENOEXEC;
>>  	file_accessed(file);
>>  	vma->vm_ops = &ext4_file_vm_ops;
>>  	return 0;
> 


