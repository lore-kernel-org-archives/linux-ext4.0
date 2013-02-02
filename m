From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Help to know the stable ver of ext4 for commercial app.
Date: Sat, 2 Feb 2013 11:08:35 -0700
Message-ID: <9FEF1A06-2C24-4D37-A896-3C63D7AB29FE@dilger.ca>
References: <BB7C62C2B0732E4DA93834A501E8464544E6181A@SZXEML519-MBS.china.huawei.com> <20130202032307.GA16364@thunk.org> <BB7C62C2B0732E4DA93834A501E8464544E62844@SZXEML519-MBS.china.huawei.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>, "adilger@sun.com" <adilger@sun.com>,
	"tm@tao.ma" <tm@tao.ma>,
	"xiaoqiangnk@gmail.com" <xiaoqiangnk@gmail.com>,
	Lizefan <lizefan@huawei.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Wuqixuan <wuqixuan@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f50.google.com ([209.85.210.50]:39561 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab3BBSIg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Feb 2013 13:08:36 -0500
Received: by mail-da0-f50.google.com with SMTP id h15so2136259dan.9
        for <linux-ext4@vger.kernel.org>; Sat, 02 Feb 2013 10:08:35 -0800 (PST)
In-Reply-To: <BB7C62C2B0732E4DA93834A501E8464544E62844@SZXEML519-MBS.china.huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-02-02, at 0:20, Wuqixuan <wuqixuan@huawei.com> wrote:
> 
> Thanks a lot for your information. Has some doubt below. 
> 
>> On Sat, Feb 02, 2013 at 02:30:11AM +0000, Wuqixuan wrote:
>>> 
>>>   Currently we are choocing ssd/sata file system using for stream media application. We are using 2.6.34.10 (can be upgraded to 2.6.34.14). We are consider of ext3 or ext4.  Even in wikipedia, it mentions ext4 is stable from 2.6.28, I still have some doubts:
>>> 
>>>    1. Whether 2.6.34.10 of ext4 is stable enough for commercial use or not.
>>>    2. Are there many mature commercial application on ext4 on 2.6.34.10 or before? Can tell some famous company or app name ?
> 
>> Well, it's _possible_ to use 2.6.34 as a base for a production server.
>> Red Hat's RHEL 5 was based on kernel of approximately that vintage
>> (with many, many patches).  Google announced it was upgrading its data
>> centers to use ext4 just about the time I was hired at Google[1], in
>> January 2010, and 2.6.34 dates from May 2010.

If you are looking at stability for a commercial application, I think you would be best off to choose something like RHEL6 2.6.32 which has back ported all of these patches for ext4 already and will continue to get fixes for years to come. 

Next best would be to pick something like FC18 3.8(?), which also has the needed patches, but will not be supported for as long a time.  This is definitely still better than picking the vanilla kernel of the same version. 

That way, you can focus on your application, and not on becoming a kernel maintainer...

Cheers, Andreas