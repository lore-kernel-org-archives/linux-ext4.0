From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsck (git) on ext4: unsupported feature(s): huge_file
Date: Wed, 09 Apr 2008 07:54:12 -0500
Message-ID: <47FCBC74.7000500@redhat.com>
References: <47FBB24D.90807@yahoo.de> <47FBBB13.7060501@redhat.com> <47FBCB44.1050500@yahoo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: supersud501 <supersud501@yahoo.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbYDIMyO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Apr 2008 08:54:14 -0400
In-Reply-To: <47FBCB44.1050500@yahoo.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

supersud501 wrote:
> Eric Sandeen wrote:
>> supersud501 wrote:
>>> i get this when trying to run e2fsck on my ext4dev filesystem (kernel 
>>> 2.6.25-rc8), extents enabled:
>>>
>>> e2fsck 1.40.8 (13-Mar-2008)
>>> /dev/loop2 has unsupported feature(s): huge_file
>>> e2fsck: Get a newer version of e2fsck!
>>>
>>> just updated to the git-version of e2fsprogs, same error. i know e2fsck 
>>> worked once with the drive (~2 months ago).
>>>
>>> what can i do?
>> Do you in fact have any very large files on the disk?
>>
> 
> yeah, i have (> 5.5gb).
> 
> i know it worked a few months (1-2) ago, even with extents enabled. at 
> this time there where those large files too.

For what it's worth, I don't think 5.5gb should have tripped the
huge_file flag.  So I wonder how this got set on your fs.

-Eric
