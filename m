From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] ext3 freeze feature
Date: Fri, 08 Feb 2008 08:26:57 -0500
Message-ID: <20080208132657.GE3120@webber.adilger.int>
References: <20080125195938t-sato@mail.jp.nec.com>
 <20080125121851.GA3361@dmon-lap.sw.ru> <20080125133329.GB8184@mit.edu>
 <01cd01c86a40$21d49410$41a8400a@bsd.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@MIT.EDU>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:61386 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbYBHN1M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Feb 2008 08:27:12 -0500
In-reply-to: <01cd01c86a40$21d49410$41a8400a@bsd.tnes.nec.co.jp>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 08, 2008  19:48 +0900, Takashi Sato wrote:
> OK I would like to implement the freeze feature on VFS
> as the filesystem independent ioctl so that it can be
> available on filesystems that have already had write_super_lockfs()
> and unlockfs().
> The usage for the freeze ioctl is the following.
>  int ioctl(int fd, int FIFREEZE, long *timeval);
>    fd:file descriptor of mountpoint
>    FIFREEZE:request cord for freeze
>    timeval:timeout period (second)
>
> And the unfreeze ioctl is the following.
>  int ioctl(int fd, int FITHAW, NULL);
>    fd:file descriptor of mountpoint
>    FITHAW:Request cord for unfreeze

You may as well make the common ioctl the same as the XFS version,
both by number and parameters, so that applications which already
understand the XFS ioctl will work on other filesystems.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
