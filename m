From: supersud501 <supersud501@yahoo.de>
Subject: Re: e2fsck (git) on ext4: unsupported feature(s): huge_file
Date: Wed, 09 Apr 2008 16:52:24 +0200
Message-ID: <47FCD828.9020204@yahoo.de>
References: <47FBB24D.90807@yahoo.de>  <47FBBB13.7060501@redhat.com> <1207752320.30215.1.camel@zem>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Calvin Walton <calvin.walton@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from n7a.bullet.ukl.yahoo.com ([217.146.183.155]:21913 "HELO
	n7a.bullet.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752597AbYDIO6O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2008 10:58:14 -0400
In-Reply-To: <1207752320.30215.1.camel@zem>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Calvin Walton wrote:
> On Tue, 2008-04-08 at 13:36 -0500, Eric Sandeen wrote:
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
> 
> I'm just curious - if I know for sure that I don't have any huge files
> on my disk, would I be able to do something like use debugfs to simply
> clear the flag?
> 

interests mee, too. and how are "huge files" defined? thought they are 
 >4gb files?

