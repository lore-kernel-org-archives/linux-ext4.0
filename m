From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Add a norecovery option to ext3/4?
Date: Sun, 08 Apr 2007 22:24:50 -0500
Message-ID: <4619B202.3050601@redhat.com>
References: <20070409000556.GA13980@implementation>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbXDIDYy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Apr 2007 23:24:54 -0400
In-Reply-To: <20070409000556.GA13980@implementation>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Samuel Thibault wrote:
> Hi,
> 
> Distribution installers usually try to probe OSes for building a suited
> grub menu.  Unfortunately, mounting an ext3 partition, even in read-only
> mode, does perform some operations on the filesystem (log recovery).
> This is not a good idea since it may silently garbage data.  

Can you elaborate?  Under what circumstances is log replay going to harm 
data?  Do you mean that the installer mounts partitions, looking for 
what OS is installed?  How is that harmful?

Ohhh... this is http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=417407 
isn't it?

Hm, so the root cause there seems that the installer found 2 legs of a 
mirror and mounted them independently, recovering them independently... 
But why did that cause problems?

> XFS has a
> norecovery option that allows to disable that, I'd say ext3/4 should
> have it too.

The xfs mount option is useful on a purely read-only device, or if the 
log is corrupted to the point where it can't be replayed... It was put 
in place 9+ years ago.  :)  I'd have to ask the sgi guys to dig & see 
what the original use for...

It'd be easy enough to add to ext3/4, I suppose.  Other options you may 
have in the installer, though, is to check for md superblocks before 
mounting bare partitions, or maybe use the BLKROSET ioctl to set the 
block device to read-only prior to mount, for added insurance...

-Eric
