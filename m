From: Tao Ma <tm@tao.ma>
Subject: Re: [ext4:dev 56/60] fs/ext4/xattr.h:422:12: error: two or more data
 types in declaration specifiers
Date: Mon, 03 Dec 2012 16:30:34 +0800
Message-ID: <50BC632A.1060108@tao.ma>
References: <50bc34a0.y/JP4a0udwG4qbxZ%fengguang.wu@intel.com> <50BC3AB0.1060708@tao.ma> <20121203061836.GA12998@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Tao Ma <boyu.mt@taobao.com>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>
To: Fengguang Wu <fengguang.wu@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:36409 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752973Ab2LCIai (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2012 03:30:38 -0500
In-Reply-To: <20121203061836.GA12998@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/03/2012 02:18 PM, Fengguang Wu wrote:
> Tao,
> 
> Perhaps you can create an incremental fix, which allows Ted to easily
> check how it's fixed, and have the freedom to either fold it to the
> bad commit, or to append to HEAD. 
yeah, I have create an incremental fix and sent it out. Anyway, thanks
again for your splendid test framework.

Ted, please consider merging it. Thanks

Tao
> 
> Thanks,
> Fengguang
> 
> On Mon, Dec 03, 2012 at 01:37:52PM +0800, Tao Ma wrote:
>> Great thanks, Fengguang.
>>
>> So Ted,
>> 	do you want me to send a new patch set? Or you just want me to generate
>> a patch for all these warnings Fengguang found?
>>
>> Thanks
>> Tao
>>
>>
>> On 12/03/2012 01:12 PM, kbuild test robot wrote:
>>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
>>> head:   e9f49e454264c1cdd793552bfeb44f337508201b
>>> commit: a7b0168d4a9bb78535827ddaf9c055963f5bd7aa [56/60] ext4: let fallocate handle inline data correctly
>>> config: i386-randconfig-m085 (attached as .config)
>>>
>>> All error/warnings:
>>>
>>> In file included from fs/ext4/dir.c:30:0:
>>> fs/ext4/xattr.h:422:12: error: two or more data types in declaration specifiers
>>> fs/ext4/xattr.h:422:16: warning: 'ext4_convert_inline_data' defined but not used [-Wunused-function]
>>> --
>>> In file included from fs/ext4/extents.c:45:0:
>>> fs/ext4/xattr.h:422:12: error: two or more data types in declaration specifiers
>>>
>>> vim +422 fs/ext4/xattr.h
>>>
>>> 18dfee69 Tao Ma 2012-12-02  416  static inline void ext4_inline_data_truncate(struct inode *inode,
>>> 18dfee69 Tao Ma 2012-12-02  417  					     int *has_inline)
>>> 18dfee69 Tao Ma 2012-12-02  418  {
>>> 18dfee69 Tao Ma 2012-12-02  419  	return;
>>> 18dfee69 Tao Ma 2012-12-02  420  }
>>> 18dfee69 Tao Ma 2012-12-02  421  
>>> a7b0168d Tao Ma 2012-12-02 @422  static int int ext4_convert_inline_data(struct inode *inode)
>>> a7b0168d Tao Ma 2012-12-02  423  {
>>> a7b0168d Tao Ma 2012-12-02  424  	return 0;
>>> a7b0168d Tao Ma 2012-12-02  425  }
>>>
>>> ---
>>> 0-DAY kernel build testing backend         Open Source Technology Center
>>> Fengguang Wu, Yuanhan Liu                              Intel Corporation
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

