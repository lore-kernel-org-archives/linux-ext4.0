From: Michal Novotny <minovotn@redhat.com>
Subject: Re: [PATCH] extend e2fsprogs functionality to add EXT2_FLAG_DIRECT
 option
Date: Tue, 12 Jan 2010 11:54:20 +0100
Message-ID: <4B4C54DC.4040006@redhat.com>
References: <4B46FCB2.1090308@redhat.com> <4B4B84E2.1050508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951Ab0ALKym (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jan 2010 05:54:42 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0CAsghJ026154
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 12 Jan 2010 05:54:42 -0500
In-Reply-To: <4B4B84E2.1050508@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/11/2010 09:06 PM, Ric Wheeler wrote:
> On 01/08/2010 04:36 AM, Michal Novotny wrote:
>> This patch extends functionality of e{2|4}fsprogs to add 
>> EXT2_FLAG_DIRECT flag to be passed to ext2fs_open2() function. This 
>> internally calls open() function with O_DIRECT and handles the memory 
>> alignment for both read and write operations.
>> In some cases direct access to devices is necessary and that was the 
>> main reason for this patch to be done.
>>
>> The main reason why this was done is that pygrub (used by xen 
>> virtualization user-space package, it's a python version of grub for 
>> paravirtualized guests) sometimes uses outdated version of grub.conf 
>> file. Modifications to xen package were *not* enough because 
>> e2fsprogs doesn't open the files directly. That's why I added 
>> EXT2_FLAG_DIRECT support to make read/write operations work directly 
>> when passed. It's been tested with pygrub like mentioned above for 
>> read operation and it's working fine.
>>
>> Signed-off-by: Michal Novotny <minovotn@redhat.com>
>
> Can you add to this some kind of data flow overview?  Seems like a 
> really odd way to update this file system...
>
> ric
>
What do you mean by adding some kind of data flow overview? I am not 
working on file systems but I needed option  open files directly to be 
added to e2fsprogs to make pygrub working right with not using 
cached/outdated data so this was the first patch I did for file system 
so I don't realy know what do you mean by data flow overview ...

Thanks,
Michal
