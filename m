From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH 1/2] ext4: Return proper offset for '..' if inline_data
 enabled.
Date: Fri, 29 Mar 2013 09:34:58 +0800
Message-ID: <5154EFC2.4010800@tao.ma>
References: <1364466899-5599-1-git-send-email-tm@tao.ma> <20130328183332.GE16651@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Zach Brown <zab@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:48567 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753234Ab3C2BfG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Mar 2013 21:35:06 -0400
In-Reply-To: <20130328183332.GE16651@lenny.home.zabbo.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/29/2013 02:33 AM, Zach Brown wrote:
> On Thu, Mar 28, 2013 at 06:34:58PM +0800, Tao Ma wrote:
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> Zach reported a problem that if inline data is enabled, we don't
>> tell the difference between the offset of '.' and '..'. And a
>> getdents will fail if the user only want to get '.'.
>>
>> This patch adds a new offset EXT4_INLINE_DOTDOT_OFFSET which
>> indicates the offset of inline "..", and now 0 is for the "."
>> and EXT4_INLINE_DOTDOT_OFFSET is for "..".
> 
> Yeah, this fixes the problem.  I confirmed that my little test that got
> a single dirent from getdents() now properly sees . and .. and exits
> rather than spinning.
> 
> Tested-by: Zach Brown <zab@redhat.com>
> 
>>  
>> +			if (filp->f_pos == EXT4_INLINE_DOTDOT_OFFSET) {
>>  				error = filldir(dirent, "..", 2, 0, parent_ino,
>>  						DT_DIR);
>>  				if (error)
>> -- 
>> 1.7.0.4
> 
> Though I think you should change the fourth argument (offset) of the
> second flildir() from 0 to EXT4_INLINE_DOTDOT_OFFSET.
My fault, will change it in the next version.

Thanks,
Tao
