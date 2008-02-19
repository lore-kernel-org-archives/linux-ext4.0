From: t-sato@yk.jp.nec.com
Subject: Re: [RFC] ext3 freeze feature
Date: Tue, 19 Feb 2008 20:27:06 +0900
Message-ID: <20080219202706t-sato@mail.jp.nec.com>
References: <47B5A088.6050801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, Theodore Tso <tytso@MIT.EDU>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:61226 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761762AbYBSL2U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2008 06:28:20 -0500
In-reply-to: <47B5A088.6050801@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi,

>#define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
>#define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
>
>as generic vfs ioctls.  These ioctls started out as
>EXT2_IOC_SETFLAGS/EXT2_IOC_GETFLAGS but they were generically useful,
>other filesystems picked them up, and they were "elevated" to the vfs.

Thank you for good information.
I will elevate XFS_IOC_FREEZE and XFS_IOC_THAW to the VFS.

>> And xfs_freeze calls XFS_IOC_FREEZE with a magic number 1, but what is 1?
>
>Looks like it's called "level" but it's probably a holdover, it doesn't
>look like it's used.

I see.

>> Instead, I'd like the sec to timeout on freeze API in order to thaw
>> the filesystem automatically.  It can prevent a filesystem from staying
>> frozen forever.
>> (Because a freezer may cause a deadlock by accessing the frozen filesystem.)
>
>I'm still not very comfortable with the timeout; if you un-freeze on a
>timer, how do you know that the work for which you needed the fileystem
>frozen is complete?  How would you know if your snapshot was good if
>there's a possibility that the fs unfroze while it was being taken?

My following freeze ioctl never perform the timeout when 0 is specified
as timeval.  So, existent applications which don't expect the timeout
can stay frozen with 0.
 int ioctl(int fd, int FIFREEZE, long *timeval);
    fd:file descriptor of mountpoint
    FIFREEZE:request cord for freeze
    timeval:timeout period (second)

And how about adding the new ioctl to reset the timeval like below?
(Dmitri proposed this idea before.)
 int ioctl(int fd, int FIFREEZE_RESET_TIMEOUT, long *timeval);
    fd:file descriptor of mountpoint
    FIFREEZE_RESET_TIMEOUT:request cord for reset of timeout period 
    timeval:new timeout period
This is useful for the application to set the timeval more accurately.
For example, the freezer resets the timeval to 10 seconds every 5
seconds.  In this approach, even if the freezer causes a deadlock
by accessing the frozen filesystem, it will be solved by the timeout
in 10 seconds and the freezer can recognize that at the next reset
of timeval.

Any comments are very welcome.

Cheers, Takashi
