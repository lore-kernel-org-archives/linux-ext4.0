From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RESEND PATCH 2/2] ext4: ext4_inode_is_fast_symlink should use cluster size
Date: Mon, 6 Jan 2014 10:47:03 -0700
Message-ID: <E2CB8B2A-38FD-4509-BCEF-DDF23ABA01AC@dilger.ca>
References: <1387515880-10185-1-git-send-email-yangyongqiang01@baidu.com> <1387515880-10185-2-git-send-email-yangyongqiang01@baidu.com> <CAGBYx2Zx7jnK-DmM7=RCCVwz4N0FfE_-=eETO8OkLt5McCXttg@mail.gmail.com> <20140106145145.GC13648@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43453 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbaAFRrG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jan 2014 12:47:06 -0500
Received: by mail-pa0-f46.google.com with SMTP id kp14so16787627pab.5
        for <linux-ext4@vger.kernel.org>; Mon, 06 Jan 2014 09:47:05 -0800 (PST)
In-Reply-To: <20140106145145.GC13648@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted, 
What about the idea to stop using the blocks count for doing the fast/slow symlink check, and instead use i_size?  IMHO this is far more robust than using the blocks count, since we've repeatedly seen bugs when the number of blocks allocated to an inode changes for done reason (e.g. xattrs, bigalloc, multi-block xattrs in the future).

AFAIK the kernel and e2fsprogs have always been consistent with symlinks <= 60 bytes being stored in the inode. 

Cheers, Andreas

> On Jan 6, 2014, at 7:51, Theodore Ts'o <tytso@mit.edu> wrote:
> 
>> On Fri, Dec 20, 2013 at 01:13:33PM +0800, Yongqiang Yang wrote:
>> From: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> 
>> can be reproduced by xfstests 62 with  bigalloc and 128bit size inode.
>> 
>> Signed-off-by: Yongqiang Yang <yangyongqiang01@baidu.com>
> 
> Thanks, applied.
> 
>                        - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
