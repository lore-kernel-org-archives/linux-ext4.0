From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Ext4 tail merging?
Date: Tue, 23 Dec 2014 15:13:18 -0700
Message-ID: <C129E0A8-6B8F-45AF-8EC5-33ABEC979C15@dilger.ca>
References: <5499DFE5.60508@ubuntu.com>
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:60434 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaLWWNV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Dec 2014 17:13:21 -0500
Received: by mail-pa0-f54.google.com with SMTP id fb1so8761767pad.13
        for <linux-ext4@vger.kernel.org>; Tue, 23 Dec 2014 14:13:21 -0800 (PST)
In-Reply-To: <5499DFE5.60508@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 23, 2014, at 2:34 PM, Phillip Susi <psusi@ubuntu.com> wrote:
> 
> Ext4 still does not support tail merging right?  I had a user post
> this filefrag output and was surprised to see that it says the merged
> flag is set.  How can this be?
> 
> $ filefrag -v /boot/grub/grubenv
> Filesystem type is: ef53
> Filesystem cylinder groups approximately 19
> File size of /boot/grub/grubenv is 1024 (1 block of 4096 bytes)
> ext: logical_offset: physical_offset: length: expected: flags:
>   0: 0.. 0: 494592.. 494592: 1: merged,eof
> /boot/grub/grubenv: 1 extent found, perfection would be -1 extent

"merged" in this context doesn't mean "tail merging" in the sense of Reiserfs.  This just means that the reported "extent" is actually merged
from a series of contiguous blocks in an ext3 block-mapped file (as
opposed to an extent-mapped file).

Note that there is an experimental ext4 feature similar to "tail merging"
that is being added.  That is "inline data", which stores the data of
small files or directories directly in the inode as an xattr.

Cheers, Andreas





