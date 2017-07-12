From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Fast symlinks stored slow
Date: Wed, 12 Jul 2017 18:07:11 +0100
Message-ID: <20170712170711.GA19996@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tahsin Erdogan <tahsin@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55356 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753736AbdGLRHO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 12 Jul 2017 13:07:14 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


https://bugzilla.redhat.com/show_bug.cgi?id=1470157

To cut a long story short, we were using libext2fs to create
filesystems where short symlinks (< 60 bytes) were stored the same way
as long symlinks, ie. stored as an ordinary file instead of being
stored in the inode.

This actually worked fine until very recently when this change was
made to the upstream kernel:

  commit 407cd7fb83c0ebabb490190e673d8c71ee7df97e
  Author: Tahsin Erdogan <tahsin@google.com>
   Date:   Tue Jul 4 00:11:21 2017 -0400

    ext4: change fast symlink test to not rely on i_blocks

which broke these filesystems.

I think the reason we were creating filesystems wrongly in the first
place is because our code has been around since about 2008, and the
nice ext2fs_symlink function that deals properly with fast/slow
symlinks wasn't added until 2013.

It's not too much trouble for us to recreate the incorrect
filesystems.  Mostly we're creating one-off throwaway filesystems for
appliances anyway and they don't live for long.

But I suppose this might be a warning that other incorrect filesystems
exist which will break with Linux >= 4.13.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-p2v converts physical machines to virtual machines.  Boot with a
live CD or over the network (PXE) and turn machines into KVM guests.
http://libguestfs.org/virt-v2v
