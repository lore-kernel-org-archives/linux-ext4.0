From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Add a norecovery option to ext3/4?
Date: Mon, 9 Apr 2007 04:14:40 -0600
Message-ID: <20070409101440.GM5967@schatzie.adilger.int>
References: <20070409000556.GA13980@implementation> <4619B202.3050601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:54997 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097AbXDIKOm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Apr 2007 06:14:42 -0400
Content-Disposition: inline
In-Reply-To: <4619B202.3050601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Apr 08, 2007  22:24 -0500, Eric Sandeen wrote:
> Samuel Thibault wrote:
> >Distribution installers usually try to probe OSes for building a suited
> >grub menu.  Unfortunately, mounting an ext3 partition, even in read-only
> >mode, does perform some operations on the filesystem (log recovery).
> >This is not a good idea since it may silently garbage data.  
> 
> Can you elaborate?  Under what circumstances is log replay going to harm 
> data?  Do you mean that the installer mounts partitions, looking for 
> what OS is installed?  How is that harmful?

If that disk was actually in use on another system but just exported
via a SAN to this node you've potentially corrupted the filesystem.

It's a bad idea to just go ahead and mount filesystems that you aren't
told to mount.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
