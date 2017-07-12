From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: Fast symlinks stored slow
Date: Wed, 12 Jul 2017 21:52:30 +0100
Message-ID: <20170712205230.GC19996@redhat.com>
References: <20170712170711.GA19996@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tahsin Erdogan <tahsin@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33566 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751862AbdGLUwc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 12 Jul 2017 16:52:32 -0400
Content-Disposition: inline
In-Reply-To: <20170712170711.GA19996@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 12, 2017 at 06:07:11PM +0100, Richard W.M. Jones wrote:
> To cut a long story short, we were using libext2fs to create
> filesystems where short symlinks (< 60 bytes) were stored the same way
> as long symlinks, ie. stored as an ordinary file instead of being
> stored in the inode.

As a further data point, e2fsck does not complain about these
filesystems.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-p2v converts physical machines to virtual machines.  Boot with a
live CD or over the network (PXE) and turn machines into KVM guests.
http://libguestfs.org/virt-v2v
