From: Andreas Dilger <adilger@sun.com>
Subject: Re: Reading inode..
Date: Thu, 18 Sep 2008 15:36:16 -0600
Message-ID: <20080918213616.GD10950@webber.adilger.int>
References: <2d08ef090809170707x1564f440k7f69c92eac04b9e7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ext4 <linux-ext4@vger.kernel.org>,
	Kernelnewbies <kernelnewbies@nl.linux.org>
To: Rohit Sharma <imreckless@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:44113 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbYIRVgv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Sep 2008 17:36:51 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8ILaUdX000391
	for <linux-ext4@vger.kernel.org>; Thu, 18 Sep 2008 14:36:40 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K7E00E01UM4SQ00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 18 Sep 2008 14:36:30 -0700 (PDT)
In-reply-to: <2d08ef090809170707x1564f440k7f69c92eac04b9e7@mail.gmail.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 17, 2008  19:37 +0530, Rohit Sharma wrote:
> I want to read ext2 inode.
> 
> Its just like i have a inode no. say 1900..
> so from the block group we can read the group descriptor and from there we
> can identify the first block no. of the inode table.
> So we can read the required inode no.i.e. 1900 from this inode table.
> I found that there are 8176 inodes per block group using tune2fs utility,

That is true for your filesystem, it might be different for each ext*
filesystems, depending on many parameters.

> so if i am interested in reading 8177th inode then i have to move on
> to next block groups inode table.

Right, for this particular filesystem.

Note also that there is libext2fs for performing operations like this on
the filesystem in userspace.

If you are reading the inode from within the kernel you can just use
ext2_read_inode().

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

