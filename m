From: Zlatko Calusic <zcalusic@bitsync.net>
Subject: Re: e2fsck not fixing deleted inode referenced errors?
Date: Tue, 30 Sep 2014 23:34:00 +0200
Message-ID: <542B21C8.2000704@bitsync.net>
References: <542AEED4.5050303@bitsync.net> <20140930183012.GA9942@birch.djwong.org> <542AF9B8.2090800@bitsync.net> <20140930195408.GD17142@thunk.org> <542B1220.8020208@bitsync.net> <20140930203622.GC9942@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bitsync.net ([80.83.126.10]:41503 "EHLO bitsync.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbaI3VeD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Sep 2014 17:34:03 -0400
In-Reply-To: <20140930203622.GC9942@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 30.09.2014 22:36, Darrick J. Wong wrote:
>
> sysfs will tell you:
>
> $ ls /sys/block/sd*
> lrwxrwxrwx 1 root root 0 Sep 30 13:31 /sys/block/sda ->
> ../devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/block/sda/
>
>                                     ^^^^
>

Nice, thanks. The error came from /dev/sdb definitely.

>
> Both drives, individually.
>
> md should be fine with that, since you're only running the read test.
>

You're right, of course, what was I thinking. :)

OK, 2 x badblocks already running. Will report tomorrow how it ended.

> It would be fun to be able to poke around with an 'e2image /dev/md2' file, but
> given the 1TB volume that might be unmanageable.
>

Yeah. Together with the fact that fs has millions of files + not enough 
space on other disk, I'll have to pass on that one.

>> But, I'm pretty sure that it will come out clean. The md check I did
>> last night would surely detected bad blocks if there were any. Or
>> not?
>
> Let's hope so, unless it's some weird transient error...
>

The worst kind. :( Dunno. I guess tomorrow I'll try unlink from debugfs. 
Then e2fsck. First, we'll see if there are any bad blocks around.

Regards,
-- 
Zlatko

