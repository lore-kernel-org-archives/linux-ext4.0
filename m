From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4fs error "ext4_mb_generate_buddy:741:group 16, 8160 clusters
 in bitmap, 4064 in gd" (with repro)
Date: Thu, 9 Aug 2012 13:06:40 -0400
Message-ID: <20120809170640.GA6607@thunk.org>
References: <50238A29.3060808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	"Linux Kernel Mailinlinux-ext4@vger.kernel.orgg List"
	<linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43843 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756Ab2HIRGn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Aug 2012 13:06:43 -0400
Content-Disposition: inline
In-Reply-To: <50238A29.3060808@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 09, 2012 at 12:00:09PM +0200, Paolo Bonzini wrote:
> Here is how to reproduce it.  It happens during fstrim.  I found other
> occurrences of the error in the mailing list, but they were not related
> to trim so they may be something different.
> 
> modprobe scsi_debug dev_size_mb=256 lbpws=1
> dd if=/dev/zero of=/dev/sdb bs=1M      
> fdisk /dev/sdb
>  >> create a new partition accepting all defaults
> fdisk -lu /dev/sdb|tail -1
>  >> should show: /dev/sdb1     57      524285      262114+  83  Linux
> 
> mkfs.ext4 /dev/sdb1
> mkdir test
> mount /dev/sdb1 test
> fstrim ./test

I can confirm that this accurately reproduces file system corruption
using a 3.5 kernel.  It looks like some block allocation bitmap blocks
is getting trimmed when it shouldn't have been.  Lukas, can you take a
look at this?

					- Ted
