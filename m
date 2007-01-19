From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH 0/3] ext4 online defrag (ver 0.2)
Date: Fri, 19 Jan 2007 04:33:51 -0700
Message-ID: <20070119113351.GM5236@schatzie.adilger.int>
References: <20070116210346sho@rifu.tnes.nec.co.jp> <20070116192134.GB5236@schatzie.adilger.int> <02bb01c73a29$eb846120$4168010a@bsd.tnes.nec.co.jp> <015201c73b89$70f521e0$4168010a@bsd.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Joel Becker <Joel.Becker@oracle.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:55862 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965069AbXASLdw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Jan 2007 06:33:52 -0500
To: Takashi Sato <sho@tnes.nec.co.jp>
Content-Disposition: inline
In-Reply-To: <015201c73b89$70f521e0$4168010a@bsd.tnes.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jan 19, 2007  14:19 +0900, Takashi Sato wrote:
> >>On Jan 16, 2007  21:03 +0900, sho@tnes.nec.co.jp wrote:
> >>>1. Add new ioctl(EXT4_IOC_DEFRAG) which returns the first physical
> >>>   block number of the specified file.  With this ioctl, a command
> >>>   gets the specified directory's.
> >>
> >>Maybe I don't understand, but how is this different from the long-time
> >>FIBMAP ioctl?
> >
> >I can use FIBMAP instead of my new ioctl.
> >You are right.  I should have used FIBMAP ioctl...
> 
> I have to get the physical block number of the specified directory.
> But FIBMAP is available only for a regular file, not for a directory.
> So I will use my new ioctl.

Though it might make sense to implement FIBMAP for a directory, to keep
it consistent and allow user-space tools like "filefrag" to work on
directories also.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
