From: Wuqixuan <wuqixuan@huawei.com>
Subject: Re: Help to know the stable ver of ext4 for commercial app.
Date: Sat, 2 Feb 2013 07:20:32 +0000
Message-ID: <BB7C62C2B0732E4DA93834A501E8464544E62844@SZXEML519-MBS.china.huawei.com>
References: <BB7C62C2B0732E4DA93834A501E8464544E6181A@SZXEML519-MBS.china.huawei.com>,<20130202032307.GA16364@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "adilger@sun.com" <adilger@sun.com>, "tm@tao.ma" <tm@tao.ma>,
	"xiaoqiangnk@gmail.com" <xiaoqiangnk@gmail.com>,
	Lizefan <lizefan@huawei.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:4985 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3BBHUs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Feb 2013 02:20:48 -0500
In-Reply-To: <20130202032307.GA16364@thunk.org>
Content-Language: zh-CN
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted, 

 Thanks a lot for your information. Has some doubt below. 

> On Sat, Feb 02, 2013 at 02:30:11AM +0000, Wuqixuan wrote:
>>
>>    Currently we are choocing ssd/sata file system using for stream media application. We are using 2.6.34.10 (can be upgraded to 2.6.34.14). We are consider of ext3 or ext4.  Even in wikipedia, it mentions ext4 is stable from 2.6.28, I still have some doubts:
>>
>>     1. Whether 2.6.34.10 of ext4 is stable enough for commercial use or not.
>>     2. Are there many mature commercial application on ext4 on 2.6.34.10 or before? Can tell some famous company or app name ?

>  Well, it's _possible_ to use 2.6.34 as a base for a production server.
>  Red Hat's RHEL 5 was based on kernel of approximately that vintage
>  (with many, many patches).  Google announced it was upgrading its data
>  centers to use ext4 just about the time I was hired at Google[1], in
>  January 2010, and 2.6.34 dates from May 2010.

>  [1] http://lists.openwall.net/linux-ext4/2010/01/04/8

>  The team at Taobao was using a similar vintage kernel if I recall
>  correctly, at least at one point in time.  I'm not sure if they have
>  since upgraded to a newer kernel.

>  However, at Google, we used a huge number of patches to fix and
>  stablize ext4.  The patches were pushed upstream over a 18 months or
>  so, but not all of them were backported into 2.6.34.x kernels.  I
>  believe you will find the same story at Red Hat and at Tao Bao.

>  Part of that is because the stable kernel maintainers will generally
>  just drop a patch if it doesn't apply cleanly.  In order to determine
>  which patches are applicable, and to adopt and backport patches, you
>  really will need one or more ext4 developers on staff, such as Eric
>  Sandeen and his colleagues for Red Hat, or me and my colleages for
>  Google, or Tao Ma and his team at Taobao.

   From these two paragraphs, my understanding is, during the 18 months 
about the huge number of patches, all the patches which impact 2.6.34.x 
had been backported into old stable version like 2.6.34.x. If not merge, 
just because those patches is not applicable to or impat that version. I am 
not sure whether I am wrong. 

   Another doubt is that currently if a new patch is merged in upstream, who is to be obligated to 
do backport. The maintainter of ext4 (you) or the stable branch maintiner (like 
maintiner of 2.6.34.x, i think he is from windriver) ? I saw even in 2013-01-16, 
still one checkin (commit: 25772970966c268c16ec5c0f9d02449f401663c1) 
in 2.6.34.14. Does it mean that if one patch is merged in upstream, somebody 
generally will be obligated to do backport to old stable branches within some period.

   So for a conclusion, can I think, no valuable patch( or not many patch) is missing to be 
backport from upstream high version currently ? 

>  Whether or not it's good enough for your streaming media application
>  is a different question.  That's a very restricted use case, and it
>  might be good enough.   You should test it and see for yourself.

Regards,

                                                - Ted