From: =?windows-1252?Q?Luk=E1=9A_Czerner?= <czerner.lukas@gmail.com>
Subject: Re: [PATCH RFC 00/30] Ext4 snapshots - core patches
Date: Mon, 06 Jun 2011 21:58:45 +0200
Message-ID: <4DED3175.70806@gmail.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net> <alpine.LFD.2.00.1106061501460.3934@dhcp-27-109.brq.redhat.com> <BANLkTimjxkOnX6hvLvU+Xth20ie5FaXq1A@mail.gmail.com> <4DECF2D5.7050408@redhat.com> <77863E67-6DAF-491D-836D-09FCD379B81F@gmail.com> <4DED035B.9090107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <aedilger@gmail.com>,
	"Amir G." <amir73il@users.sourceforge.net>,
	Lukas Czerner <lczerner@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60203 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab1FFT6t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jun 2011 15:58:49 -0400
Received: by bwz15 with SMTP id 15so3599290bwz.19
        for <linux-ext4@vger.kernel.org>; Mon, 06 Jun 2011 12:58:48 -0700 (PDT)
In-Reply-To: <4DED035B.9090107@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dne 6.6.2011 18:42, Eric Sandeen napsal(a):
>>> Take for example dioread_nolock caveats:
>>>
>>>           "However this does not work with nobh
>>>            option and the mount will fail.
>> Does anyone actually use nobh? I recall it was a performance tweak
>> fir ext3, but i think it was eclipsed by other improvements in ext4.
>> If nobody is using it anymore, we might consider removing it
>> entirely, since it was only a mount-time option and did not affect
>> the on-disk format.
> As Lukas said, removing old cruft would help a fair bit, and this would
> seem reasonable to remove.
Nobh has been nooped already quite a long time ago with
206f7ab4f49a2021fcb8687f25395be77711ddee so we should remove it from 
documentation as well.

And what about other options ? Any idea what else we can remove ? Most 
of the options does not get any testing at all!

Thanks!
-Lukas
