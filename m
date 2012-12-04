From: Tao Ma <tm@tao.ma>
Subject: Re: next: ext4 build failure
Date: Tue, 04 Dec 2012 21:40:16 +0800
Message-ID: <50BDFD40.1020202@tao.ma>
References: <50BDC25C.5020509@suse.cz> <20121204132701.GA29083@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, Jiri Slaby <jslaby@suse.cz>,
	boyu.mt@taobao.com, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:57934 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751875Ab2LDNkX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2012 08:40:23 -0500
In-Reply-To: <20121204132701.GA29083@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
On 12/04/2012 09:27 PM, Theodore Ts'o wrote:
> On Tue, Dec 04, 2012 at 10:29:00AM +0100, Jiri Slaby wrote:
>> Hi,
>>
>> commit a7b0168d4a9bb78535827ddaf9c055963f5bd7aa
>> Author: Tao Ma <boyu.mt@taobao.com>
>> Date:   Sun Dec 2 20:30:52 2012 -0500
>>
>>     ext4: let fallocate handle inline data correctly
>>
>> added
>>
>> static int int ext4_convert_inline_data(struct inode *inode)
>>
>>        ^^^^^^^
>>
>> when EXT4_FS_XATTR is unset.
>>
>> Care to fix that?
> 
> Oops.  Thanks for catching this!!!
Please push the patch with the subject "[PATCH] ext4: Fix inline data
build warning found by kernel build testing." and these error should go
away. And also Dan's smatch has found another issue and I have sent out
the patch with subject "[PATCH] ext4: Fix inline data build warning
found by kernel build testing.".

Thanks
Tao
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

