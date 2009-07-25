From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ioctl32
Date: Sat, 25 Jul 2009 10:46:10 -0400
Message-ID: <20090725144610.GA9609@infradead.org>
References: <4A64E650.6020603@cox.net> <20090721020312.GL2416@mit.edu> <4A665E3F.7000109@cox.net> <4A666413.5030301@redhat.com> <20090722170152.GN4231@webber.adilger.int> <4A67EC3B.9060503@redhat.com> <87k51y11yn.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>,
	Ron Johnson <ron.l.johnson@cox.net>, linux-ext4@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48225 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbZGYOqb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Jul 2009 10:46:31 -0400
Content-Disposition: inline
In-Reply-To: <87k51y11yn.fsf@basil.nowhere.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 24, 2009 at 06:26:56PM +0200, Andi Kleen wrote:
> > /* pointer to compatible structure or no argument */
> > #define COMPATIBLE_IOCTL(cmd) \
> >         { (cmd), do_ioctl32_pointer },
> 
> 
> The modern way to do this is to use the ->compat_ioctl VFS
> method. COMPATIBLE_IOCTL etc are all obsolete.
> 
> > I think adding COMPATIBLE_IOCTL(FS_IOC_FIEMAP); to fs/compat_ioctl.c
> > should be enough, I'll try to get it tested tomorrow.
> 
> Nope, add a ->compat_ioctl 
> 
> When your ioctl is already a unlocked_ioctl you can just use
> the same function. If not convert to unlocked_ioctl first.

fiemap is handled in generic code and never enters ->whatever_ioctl.
Because of that there are only two ways to handle it:

  (1) add it to the static translation table in fs/compat_ioctl.c
  (2) add a special case to compat_sys_ioctl

Number one is the much simpler solution for a fully compatible ioctl.

