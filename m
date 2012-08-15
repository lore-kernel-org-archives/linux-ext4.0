From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: ext4fs error "ext4_mb_generate_buddy:741:group 16, 8160 clusters
 in bitmap, 4064 in gd" (with repro)
Date: Wed, 15 Aug 2012 11:17:57 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1208151116530.4904@dhcp-1-248.brq.redhat.com>
References: <50238A29.3060808@redhat.com> <20120809170640.GA6607@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Linux Kernel Mailinlinux-ext4@vger.kernel.orgg List"
	<linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463Ab2HOJS5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Aug 2012 05:18:57 -0400
In-Reply-To: <20120809170640.GA6607@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 9 Aug 2012, Theodore Ts'o wrote:

> Date: Thu, 9 Aug 2012 13:06:40 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>,
>     "Linux Kernel Mailinlinux-ext4@vger.kernel.orgg List"
>     <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
> Subject: Re: ext4fs error
>     "ext4_mb_generate_buddy:741:group 16, 8160 clusters in bitmap, 4064 in gd"
>      (with repro)
> 
> On Thu, Aug 09, 2012 at 12:00:09PM +0200, Paolo Bonzini wrote:
> > Here is how to reproduce it.  It happens during fstrim.  I found other
> > occurrences of the error in the mailing list, but they were not related
> > to trim so they may be something different.
> > 
> > modprobe scsi_debug dev_size_mb=256 lbpws=1
> > dd if=/dev/zero of=/dev/sdb bs=1M      
> > fdisk /dev/sdb
> >  >> create a new partition accepting all defaults
> > fdisk -lu /dev/sdb|tail -1
> >  >> should show: /dev/sdb1     57      524285      262114+  83  Linux
> > 
> > mkfs.ext4 /dev/sdb1
> > mkdir test
> > mount /dev/sdb1 test
> > fstrim ./test
> 
> I can confirm that this accurately reproduces file system corruption
> using a 3.5 kernel.  It looks like some block allocation bitmap blocks
> is getting trimmed when it shouldn't have been.  Lukas, can you take a
> look at this?
> 
> 					- Ted

Hi Ted,

sorry for the delay, I've just got back from my vacation. I'll take
a look at it.

Thanks!
-Lukas
