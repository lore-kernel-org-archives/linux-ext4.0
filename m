From: supersud501 <supersud501@yahoo.de>
Subject: Re: e2fsck (git) on ext4: unsupported feature(s): huge_file
Date: Tue, 08 Apr 2008 21:45:08 +0200
Message-ID: <47FBCB44.1050500@yahoo.de>
References: <47FBB24D.90807@yahoo.de> <47FBBB13.7060501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from n43.bullet.mail.ukl.yahoo.com ([87.248.110.176]:29398 "HELO
	n43.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752298AbYDHUhZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Apr 2008 16:37:25 -0400
In-Reply-To: <47FBBB13.7060501@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> supersud501 wrote:
>> i get this when trying to run e2fsck on my ext4dev filesystem (kernel 
>> 2.6.25-rc8), extents enabled:
>>
>> e2fsck 1.40.8 (13-Mar-2008)
>> /dev/loop2 has unsupported feature(s): huge_file
>> e2fsck: Get a newer version of e2fsck!
>>
>> just updated to the git-version of e2fsprogs, same error. i know e2fsck 
>> worked once with the drive (~2 months ago).
>>
>> what can i do?
> 
> Do you in fact have any very large files on the disk?
> 

yeah, i have (> 5.5gb).

i know it worked a few months (1-2) ago, even with extents enabled. at 
this time there where those large files too.

