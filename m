From: Alex <alex.vizor@gmail.com>
Subject: Re: WARNING: at fs/inode.c:884 unlock_new_inode+0x34/0x59()
Date: Mon, 28 Nov 2011 22:08:50 +0300
Message-ID: <4ED3DC42.20504@gmail.com>
References: <4ED2994A.9080907@gmail.com> <4ED29C63.8070601@gmail.com> <20111127213432.GA22465@thunk.org> <4ED3CF24.2050702@gmail.com> <0F03D476-02D9-4C10-8A4D-7949E5B07CBB@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48216 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab1K1TIz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Nov 2011 14:08:55 -0500
Received: by bke11 with SMTP id 11so8913854bke.19
        for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 11:08:54 -0800 (PST)
In-Reply-To: <0F03D476-02D9-4C10-8A4D-7949E5B07CBB@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/28/2011 09:28 PM, Theodore Tso wrote:
> On Nov 28, 2011, at 1:12 PM, Alex wrote:
>
>> Hi Ted,
>>
>> This is full dmesg with suspend to disk. This time no fs errors happened. And unfortunately I don't remember what kind of errors were there last time.
>>
> OK, so you have a very large number of warnings, spanning over several seconds.   That sounds to me like a memory corruption problem, as opposed to some kind of race that only happens for a symlink creation happening right during the suspend/resume.
>
> I can fix the warning and arrange to print more debugging information so that if this happens again, we get more information, but if you can't reproduce it, I'm not sure there's much more I can do for now.
>
> Regards,
>
> -- Ted
>
Yes I can reproduce this, it happens after every s2disk.

Tanks,
Alex
