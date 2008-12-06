From: Andreas Dilger <adilger@sun.com>
Subject: Re: RFC, 32-bit compat handlers for EXT4_IOC_GROUP_ADD
Date: Fri, 05 Dec 2008 18:02:04 -0700
Message-ID: <20081206010204.GY3186@webber.adilger.int>
References: <49385BC5.2070703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:44090 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbYLFBCJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Dec 2008 20:02:09 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mB6128O5026372
	for <linux-ext4@vger.kernel.org>; Fri, 5 Dec 2008 17:02:09 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KBF00001JZ7HS00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 05 Dec 2008 17:02:08 -0800 (PST)
In-reply-to: <49385BC5.2070703@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 04, 2008  16:37 -0600, Eric Sandeen wrote:
> It's too bad this wasn't caught sooner, but I wonder if maybe it's still
> not too late; can we change the structure in the kernel and have newer
> e2fsprogs try both the old & new?  The new interface would add 32 bits
> of padding to the structure; this would leave it unchanged on 64-bit
> boxes so everything would continue to work.  Newer e2fsprogs would try
> both, so still work on older kernels.  32-bit compat would have a simple
> handler, *but* this *would* break resize of ext4 on native 32-bit
> machines with older e2fsprogs (the kernel would have a padded struct;
> older userspace would not, and the ioctl would fail).
> 
> How far out of "dev" are we?  I'm leaning towards saying "oh well, would
> have been nicer the other way" but going ahead and just putting the
> compat handler into the kernel.

I would be OK with changing to the "proper" struct layout.  Not being able
to resize with an older e2fsprogs + newer kernel isn't going to cause any
serious problems (unlike e.g. not being able to mount or e2fsck "/").

If we are seriously worried about compatibility, we could add the compat
handler for 32-bit kernels (should have a different IOC number anyways
because of the struct size) and add some arbitrary check like:

#ifdef LINUX_KERNEL_VERSION > KERNEL_VERSION(2,6,40)
#warning remove this old compat code
#endif

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

