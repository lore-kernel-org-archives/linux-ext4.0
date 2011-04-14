From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: CONFIG_EXT4_USE_FOR_EXT23:  rootfs shows as ext2 instead of ext4
Date: Thu, 14 Apr 2011 08:47:16 -0400
Message-ID: <A3BD1EBC-DB1D-4BE2-9C1B-2CB7FBFFB82B@mit.edu>
References: <4DA48AF4.5080803@teksavvy.com> <20110413004938.GE3682@thunk.org> <4DA5AEBE.6060705@teksavvy.com> <5A35771F-49B6-491E-B012-DBE68907E382@mit.edu> <4DA64F1B.4070803@teksavvy.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Mark Lord <kernel@teksavvy.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:44891 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754540Ab1DNMrV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Apr 2011 08:47:21 -0400
In-Reply-To: <4DA64F1B.4070803@teksavvy.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Apr 13, 2011, at 9:34 PM, Mark Lord wrote:

> But far far less obvious is why the kernel reports
> having mounted my ext4 filesystem as "ext2",
> and what exactly it means by that.

Because the kernel reports the type that it successfully matched against when the mount succeeded, and in order for ext4 to take over ext2, it calls register_filesystem() as ext2.   Since the kernel (a) tries mounting the root file system as ext2 (it tries blindly until it succeeds), (b) when ext4 is taking care of ext2 mounts, an filesystem with ext4 features can be mounted by the ext4 file system driver, (c) the base VFS layer controls what types is listed, and since it succeeded when it tried mounting as ext2, it reports it as ext2.

In other words, what the kernel reports is not what file system driver is currently servicing your block device, but the name of the fs type first succeeded when the root file system mount did a brute-force search.  (BTW, some distributions may use an initrd that uses a more sophisticated userspace fs probing logic that will correctly determine that the file system is really an ext4 file system, and explicitly request an ext4 mount, and then the kernel will report that it was mounted with an ext4 fs type.)   The brute-force search nature of the kernel can potentially get you in trouble, since if a block device was originally formatted as a FAT file system, and then later reformatted as some other file system, such as btrfs, ext4, xfs, etc.,  in theory, depending on the order the kernel tri
 es its brute force search, it could conceivably get things wrong.  This is a long-known problem, and we mostly work around it by making the mkfs programs zero out enough data blocks that it's unlikely that a reused block device might get mistaken as something else.

I repeat; this is a cosmetic issue _only_.   I suspect most users won't be looking that closely at what the kernel outputs, but I agree it's something that we should fix.   OK?

-- Ted

