Return-Path: <SRS0=RWfY=OV=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52825 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbeLLNtm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 12 Dec 2018 08:49:42 -0500
Subject: Re: [PATCH 00/10] fix coding style for ext2 filesystem
To: Jan Kara <jack@suse.cz>
Cc: jack@suse.com, linux-ext4@vger.kernel.org
References: <20181113000448.16023-1-cgxu519@gmx.com>
 <20181212131518.GE10902@quack2.suse.cz>
From: cgxu519 <cgxu519@gmx.com>
Message-ID: <de145a89-8788-f896-3019-9fd461bc0df1@gmx.com>
Date: Wed, 12 Dec 2018 21:49:26 +0800
MIME-Version: 1.0
In-Reply-To: <20181212131518.GE10902@quack2.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/12/18 9:15 PM, Jan Kara wrote:
> On Tue 13-11-18 08:04:38, Chengguang Xu wrote:
>> This patch set fixes some coding style warnings which are from
>> checkpatch.pl.
>>
>> Detail warning/error messages are below:
>>
>> WARNING: function definition argument 'struct inode *' should
>> also have an identifier name
>>
>> WARNING: space prohibited between function name and open
>> parenthesis '('
>>
>> WARNING: line over 80 characters
>>
>> ERROR: "foo * bar" should be "foo *bar"
> Thanks for the series! I had a look into the patches but I don't think
> these whitespace fixes are really worth the churn. Sorry.

Hi Jan

Thanks for the check. The motivation of that series is just for avoiding 
annoying checkpatch complains.
However, we can also fix the coding style problem when we actually 
touch  the particular code,  that will be fine.

Thanks,
Chengguang
