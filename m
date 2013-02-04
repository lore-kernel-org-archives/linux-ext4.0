From: qixuan wu <wuqixuan@gmail.com>
Subject: Re: Help to know the stable ver of ext4 for commercial app.
Date: Tue, 5 Feb 2013 01:52:38 +0800
Message-ID: <CAEjEV8A90nYC74yPg+0n+KimWV2BPEVdOHtwbrkGuSDQpCGjFQ@mail.gmail.com>
References: <BB7C62C2B0732E4DA93834A501E8464544E6181A@SZXEML519-MBS.china.huawei.com>
	<20130202032307.GA16364@thunk.org>
	<BB7C62C2B0732E4DA93834A501E8464544E62844@SZXEML519-MBS.china.huawei.com>
	<9FEF1A06-2C24-4D37-A896-3C63D7AB29FE@dilger.ca>
	<BB7C62C2B0732E4DA93834A501E8464544E628B1@SZXEML519-MBS.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>, tm@tao.ma,
	xiaoqiangnk@gmail.com, Li Zefan <lizefan@huawei.com>,
	wuqixuan <wuqixuan@huawei.com>
To: adilger@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ia0-f170.google.com ([209.85.210.170]:38211 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab3BDRwk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Feb 2013 12:52:40 -0500
Received: by mail-ia0-f170.google.com with SMTP id k20so8435236iak.15
        for <linux-ext4@vger.kernel.org>; Mon, 04 Feb 2013 09:52:40 -0800 (PST)
In-Reply-To: <BB7C62C2B0732E4DA93834A501E8464544E628B1@SZXEML519-MBS.china.huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 3, 2013 at 8:43 PM, Wuqixuan <wuqixuan@huawei.com> wrote:

> On 2013-02-02, at 0:20, Wuqixuan <wuqixuan@huawei.com> wrote:
>>
>> Thanks a lot for your information. Has some doubt below.
>>
>>> On Sat, Feb 02, 2013 at 02:30:11AM +0000, Wuqixuan wrote:
>>>>
>>>>   Currently we are choocing ssd/sata file system using for stream media application. We are using 2.6.34.10 (can be upgraded to 2.6.34.14). We are consider of ext3 or ext4.  Even in wikipedia, it mentions ext4 is stable from 2.6.28, I still have some doubts:
>>>>
>>>>    1. Whether 2.6.34.10 of ext4 is stable enough for commercial use or not.
>>>>    2. Are there many mature commercial application on ext4 on 2.6.34.10 or before? Can tell some famous company or app name ?
>>
>>> Well, it's _possible_ to use 2.6.34 as a base for a production server.
>>> Red Hat's RHEL 5 was based on kernel of approximately that vintage
>>> (with many, many patches).  Google announced it was upgrading its data
>>> centers to use ext4 just about the time I was hired at Google[1], in
>>> January 2010, and 2.6.34 dates from May 2010.
>
> If you are looking at stability for a commercial application, I think you would be best off to choose something like RHEL6 2.6.32 which has back ported all of these patches for ext4 already and will continue to get fixes for years to come.
>
> Next best would be to pick something like FC18 3.8(?), which also has the needed patches, but will not be supported for as long a time.  This is definitely still better than picking the vanilla kernel of the same version.
>
> That way, you can focus on your application, and not on becoming a kernel maintainer...

Thanks andreas, will check the RHEL6 2.6.32 ext4 and compare with
Windriver 4.3 (2.6.34.10) which we are ready to use. Do you have any
idea of ext4 of Windriver 4.3 (2.6.34.10) ?

Best Regards.
Wood.
