From: supersud501 <supersud501@yahoo.de>
Subject: Re: e2fsck (git) on ext4: unsupported feature(s): huge_file
Date: Wed, 09 Apr 2008 11:15:24 +0200
Message-ID: <47FC892C.5080000@yahoo.de>
References: <47FBB24D.90807@yahoo.de> <47FBBB13.7060501@redhat.com> <47FBCB44.1050500@yahoo.de> <20080408210048.GA16108@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from n5.bullet.ukl.yahoo.com ([217.146.182.182]:30261 "HELO
	n5.bullet.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750989AbYDIJUz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2008 05:20:55 -0400
In-Reply-To: <20080408210048.GA16108@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Tue, Apr 08, 2008 at 09:45:08PM +0200, supersud501 wrote:
>> Eric Sandeen wrote:
>>> supersud501 wrote:
>>>> i get this when trying to run e2fsck on my ext4dev filesystem (kernel 
>>>> 2.6.25-rc8), extents enabled:
>>>>
>>>> e2fsck 1.40.8 (13-Mar-2008)
>>>> /dev/loop2 has unsupported feature(s): huge_file
>>>> e2fsck: Get a newer version of e2fsck!
>>>>
>>>> just updated to the git-version of e2fsprogs, same error. i know e2fsck 
>>>> worked once with the drive (~2 months ago).
>>>>
>>>> what can i do?
>>> Do you in fact have any very large files on the disk?
>> yeah, i have (> 5.5gb).
>>
>> i know it worked a few months (1-2) ago, even with extents enabled. at this 
>> time there where those large files too.
> 
> The old 1.39-interim-tyt3 e2fsprogs patch claimed it supported huge
> files, but it didn't, actually.  It lied.  :-(
> 
> (So if you needed to repair a filesystem, e2fsck would screw up the
> i_blocks field.)
> 
> I'm working on fixing that.
> 

ah ok, so i know what's up - seems i've to wait until fixing it. just 
wanted to do it, because syslog said "maximum mount time reached, 
running is recommended". so no need to hurry ;)

regards.

