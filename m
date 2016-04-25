From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: f.s. corruption ext3, kernel 4.4.8
Date: Mon, 25 Apr 2016 11:51:31 -0500
Message-ID: <571E4B13.4040103@redhat.com>
References: <CABWT5yh98_f5=Y0k7_ELHM=fn35s0Eb5D5kmDCSsFMikgmscnQ@mail.gmail.com>
 <20160425021413.GM20980@thunk.org>
 <CABWT5yi0SF1HhtWPfM36ibRja-fhaeGFfVgZz5_8Q-NX9fkkCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Barry Kauler <bkauler@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932686AbcDYQvd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Apr 2016 12:51:33 -0400
In-Reply-To: <CABWT5yi0SF1HhtWPfM36ibRja-fhaeGFfVgZz5_8Q-NX9fkkCg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/24/16 9:33 PM, Barry Kauler wrote:
> On 4/25/16, Theodore Ts'o <tytso@mit.edu> wrote:
>> On Mon, Apr 25, 2016 at 09:46:19AM +0800, Barry Kauler wrote:
>>> I sent this direct to Greg KH yesterday morning. 24 hours later got an
>>> automated reply to send my email to one of the lists.
>>>
>>> I'm a user, not a kernel developer, gotta post this somewhere.
>>>
>>> I reckon this is urgent.
>>> I have rolled back from 4.4.8 to 4.4.7, have used heavily for 24 hours
>>> since then,
>>> no problem. So, it's the kernel, not my laptop.
>>
>> No one else has reported any problems to date, and there are only two
>> changes in ext4 code between v4.4.7 and v4.4.8, neither of which seem
>> at all likely to cause file system corruption.
>>
>> ee8516a ext4: ignore quota mount options if the quota feature is enabled
>> 321299a ext4: add lockdep annotations for i_data_sem
>>
>> If you can send us the "EXT4-fs error" message that would have been
>> logged before the file system went read-only, or the output from
>> e2fsck, that might be helpful in matching up your report from any
>> others, or to have some insight into what might have happened.
>>
>> Unfortunately, without any more information there's not much we can do
>> with your report other than to keep an ear out in case anyone else
>> complains.
>>
> 
> Thanks for the response.
> 
> My kernel is still not using EXT4_USE_FOR_EXT23
> 
> My config is:
> 
> CONFIG_EXT2_FS=y
> CONFIG_EXT2_FS_XATTR=y
> CONFIG_EXT2_FS_POSIX_ACL=y
> # CONFIG_EXT2_FS_SECURITY is not set
> CONFIG_EXT3_FS=y
> CONFIG_EXT3_FS_POSIX_ACL=y
> # CONFIG_EXT3_FS_SECURITY is not set
> CONFIG_EXT4_FS=y
> CONFIG_EXT4_FS_POSIX_ACL=y
> # CONFIG_EXT4_FS_SECURITY is not set
> CONFIG_EXT4_ENCRYPTION=y
> CONFIG_EXT4_FS_ENCRYPTION=y
> # CONFIG_EXT4_DEBUG is not set
> 
> ...is this deprecated?
> 
> Just asking, as if everyone else is using EXT4_USE_FOR_EXT23, then
> perhaps they won't hit my problem.

Ted asked for the actual error messages; without that, there's really
nothing to go on here.  It's hard to debug from narrative.  ;)

As for ext3 - that was removed in v4.3, so it's unlikely that you are
using the ext3 driver at this point; in 4.4 you can only be using
the ext4 driver for an ext3 filesystem.

Again, actual copies of the error messages might tell us something.  

Thanks,
-Eric

