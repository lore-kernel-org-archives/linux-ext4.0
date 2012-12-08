From: Forrest Liu <forrestl@synology.com>
Subject: Re: [PATCH] ext4: fix extent tree corruption that incurred by hole punch
Date: Sun, 9 Dec 2012 02:56:54 +0800
Message-ID: <CAJSVwFOwC=Za2WnpmbepO4gpRk4by8jM1Dj92y0=_nzjCJcqGQ@mail.gmail.com>
References: <1354623069-8124-1-git-send-email-forrestl@synology.com>
	<CAJSVwFMGZrOncF1s8xwZdDDVfYwtz_OBsKhHMGhMNZ98pQM06Q@mail.gmail.com>
	<50C37955.9090407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:47110 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965498Ab2LHS44 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Dec 2012 13:56:56 -0500
Received: by mail-ie0-f173.google.com with SMTP id e13so6102540iej.18
        for <linux-ext4@vger.kernel.org>; Sat, 08 Dec 2012 10:56:56 -0800 (PST)
In-Reply-To: <50C37955.9090407@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/12/9 Eric Sandeen <sandeen@redhat.com>:
> On 12/4/12 6:29 AM, forrest wrote:
>> This problem is easily to reproduce
>>
>> Create a file with size larger than 1GB.
>>
>> dd if=/dev/zero of=/test_file bs=1M count=1024
>>
>> Punch every even block in test_file, and then use debugfs to dump
>> extents,  followings is dumped result
>>
>>  2/ 2 339/340 231197 - 231197   3917597 -   3917597      1
>>  2/ 2 340/340 231199 - 231199   3917599 -   3917599      1
>>  0/ 2   2/  2 231201 - 262143   3901486              30943
>>  1/ 2   1/ 46 231201 - 231880   3901488                680
>>  2/ 2   1/340 231201 - 231201   3917601 -   3917601      1
>>  2/ 2   2/340 231203 - 231203   3917603 -   3917603      1
>>
>> Punch blocks #231779 ~#231201 ,
>
> Can you explain what you mean by the above?  Which blocks get punched?

Hi Eric,

At first, i found blowing code may have some problem

ext4_ext_rm_leaf ()
{
        ...
       /////when eh->eh_entries equals to zero, logical start value
will not be update;
       //// If parent is first index in block, this cause problem.
        if (correct_index && eh->eh_entries)
                err = ext4_ext_correct_indexes(handle, inode, path);
}

To prove that, I tried to trigger this case (eh->eh_entries = 0)

1) create a file which size greater than 1GB

2) punch all even blocks 0, 2, 4, 6, 8, .......  (blocks depends on
file size) one by one to make extent tree with depth equals to 2

3) use debugfs to find an extent index entry at level1 (assume leaf at
level2) witch logical start value is equals to is't parent node.

In example, founded entry is
1/ 2   1/ 46 231201 - 231880   3901488                680

4 ) punch blocks covered by extent index found by step3 one by one.
In example,
231879, 231877, ..., 231201..

5 ) Then, we can use debugfs to  check if logical start value is correct or not

In example, 231201 is not equals to 231881.

0/ 2   2/  2 231201 - 262143   3901486              30943
1/ 2   1/ 45 231881 - 232560   3901490                680

Thanks,
-Forrest

>
> -Eric
>
>> to remove extent index, and then use
>> debugfs to dump extents,  followings is dumped result
>
>
