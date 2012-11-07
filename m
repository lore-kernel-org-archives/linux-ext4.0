From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v4+ hot_track 16/19] btrfs: add hot tracking support
Date: Wed, 7 Nov 2012 16:03:55 +0800
Message-ID: <CAEH94LhVSXEuqSGgj+Hrce4FLa_Pr8CKabk1GYpfw9z-Cm8uhg@mail.gmail.com>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
	<1351485061-12297-17-git-send-email-zwu.kernel@gmail.com>
	<20121107000025.GY3102@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, zwu.kernel@gmail.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, tytso@mit.edu,
	cmm@us.ibm.com, wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49394 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab2KGID5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Nov 2012 03:03:57 -0500
In-Reply-To: <20121107000025.GY3102@twin.jikos.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 7, 2012 at 8:00 AM, David Sterba <dave@jikos.cz> wrote:
> On Mon, Oct 29, 2012 at 12:30:58PM +0800, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>>   Introduce one new mount option '-o hot_track',
>> and add its parsing support.
>>   Its usage looks like:
>>    mount -o hot_track
>>    mount -o nouser,hot_track
>>    mount -o nouser,hot_track,loop
>>    mount -o hot_track,nouser
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> Reviewed-by: David Sterba <dsterba@suse.cz>
thanks for your review.



-- 
Regards,

Zhi Yong Wu
