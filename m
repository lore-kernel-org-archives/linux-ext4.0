From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH 0/3] ext4 online defrag (ver 0.2)
Date: Tue, 16 Jan 2007 12:21:34 -0700
Message-ID: <20070116192134.GB5236@schatzie.adilger.int>
References: <20070116210346sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:47429 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbXAPTVh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Jan 2007 14:21:37 -0500
To: sho@tnes.nec.co.jp
Content-Disposition: inline
In-Reply-To: <20070116210346sho@rifu.tnes.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jan 16, 2007  21:03 +0900, sho@tnes.nec.co.jp wrote:
> 1. Add new ioctl(EXT4_IOC_DEFRAG) which returns the first physical
>    block number of the specified file.  With this ioctl, a command
>    gets the specified directory's.

Maybe I don't understand, but how is this different from the long-time
FIBMAP ioctl?

> 2. The new entry "goal" is added on ext4_ext_defrag_data structure
>    which is passed to existing ioctl(EXT4_IOC_DEFRAG)
>    as the argument.  The kernel starts searching the free blocks
>    from "goal".  The command passes the physical block number
>    gotten in the above step(1) to the ioctl.
> 
> struct ext4_ext_defrag_data {
>         loff_t start_offset; /* start offset to defrag in byte */
>         loff_t defrag_size;  /* size of defrag in bytes */
> 	ext4_fsblk_t goal;   /* block offset for allocation */
> };

Two things of note:
- presumably the start_offset and defrag_size should be multiples of the
  filesystem blocksize?  If they are not, is it an error or are they
  adjusted to cover whole blocks?
- in previous defrag discussions (i.e. XFS defrag), it was desirable to
  allow specifying different types of goals (e.g. hard, soft, kernel picks).
  We may as well have a structure that allows these to be specified, instead
  of having to change the interface afterward.
  
Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
