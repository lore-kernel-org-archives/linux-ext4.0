From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] ext3: fix trim length underflow with small trim length.
Date: Wed, 19 Jan 2011 21:50:41 +0800
Message-ID: <4D36EC31.30708@tao.ma>
References: <1295430550-8978-1-git-send-email-tm@tao.ma> <alpine.LFD.2.00.1101191125120.2686@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:37664 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754506Ab1ASNuw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Jan 2011 08:50:52 -0500
In-Reply-To: <alpine.LFD.2.00.1101191125120.2686@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/19/2011 06:42 PM, Lukas Czerner wrote:
> On Wed, 19 Jan 2011, Tao Ma wrote:
>
>> From: Tao Ma<boyu.mt@taobao.com>
>>
>> We adjust 'len' with s_first_data_block - start in case of start is less
>> than s_first_data_block, but it could underflow in case blocksize=1K, while
>> fstrim_range.len=512 and fstrim_range.start = 0. In this case len happens
>> to be underflow and in the end, although we are safe that last_group check
>> will limit the trim to the whole volume, I am afraid that isn't what the user
>> really want.
>>
>> So this patch fix it. It also adds a new variable s_first_data_block so that
>> the 4 le32_to_cpu can be replaced with 1.
> Well, I just realized that what are we doing is not exactly what will
> user expect. User does not really care where the first data block is.
> What the user will expect is, to trim let's say first one gigabyte
> of his filesystem, not gigabyte - first data block.
It is hard to tell, anyway, it is just 1kb(in case bs=1k and 
first_data_block != 0), so I guess either is ok. ;)
> So what I suggest is to always add first_data_block to
> fstrim_range.start and do all the necessary checks for overflow. If no
> one has any objections I'll put it to the patch.
I am fine with it. And it should make the code more clear and easy to 
read I guess.

Regards,
Tao
