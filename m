From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: WARNING: at fs/inode.c:884 unlock_new_inode+0x34/0x59()
Date: Thu, 01 Dec 2011 16:33:37 -0600
Message-ID: <4ED800C1.4040303@redhat.com>
References: <4ED2994A.9080907@gmail.com> <4ED29C63.8070601@gmail.com> <20111127213432.GA22465@thunk.org> <4ED3CF24.2050702@gmail.com> <0F03D476-02D9-4C10-8A4D-7949E5B07CBB@mit.edu> <4ED3DC42.20504@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@MIT.EDU>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Alex <alex.vizor@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960Ab1LAWdm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Dec 2011 17:33:42 -0500
In-Reply-To: <4ED3DC42.20504@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/28/11 1:08 PM, Alex wrote:
> On 11/28/2011 09:28 PM, Theodore Tso wrote:
>> On Nov 28, 2011, at 1:12 PM, Alex wrote:
>>
>>> Hi Ted,
>>>
>>> This is full dmesg with suspend to disk. This time no fs errors happened. And unfortunately I don't remember what kind of errors were there last time.
>>>
>> OK, so you have a very large number of warnings, spanning over several seconds.   That sounds to me like a memory corruption problem, as opposed to some kind of race that only happens for a symlink creation happening right during the suspend/resume.
>>
>> I can fix the warning and arrange to print more debugging information so that if this happens again, we get more information, but if you can't reproduce it, I'm not sure there's much more I can do for now.
>>
>> Regards,
>>
>> -- Ted
>>
> Yes I can reproduce this, it happens after every s2disk.

And FYI a few other users are hitting it, see https://bugzilla.redhat.com/show_bug.cgi?id=744275

Several of the bugs dup'd to that bug are from distinct users.

-Eric
