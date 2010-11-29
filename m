From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: convert from ext3 versus fresh format
Date: Sun, 28 Nov 2010 22:51:22 -0700
Message-ID: <F4A59BB4-367A-4F65-AC38-299ADCAF19FB@dilger.ca>
References: <1290978963.16103.1407558601@webmail.messagingengine.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: linux_ext4@proinbox.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:33322 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab0K2FvX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 00:51:23 -0500
In-Reply-To: <1290978963.16103.1407558601@webmail.messagingengine.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-11-28, at 14:16, linux_ext4@proinbox.com wrote:
> I have a production system installed on an SSD, whose installer formats
> the target drive as ext3 automatically. I've since learned that ext4 is
> more suited for use on SSDs and am considering an upgrade to ext4.
> 
> I see the procedure on how to convert from ext3 to ext4 on the wiki, and
> before I proceed would like to know whether there's an advantage to
> formatting as ext4 from the start as opposed to converting after an ext3
> format.

It is possible to use the ext4 filesystem code on ext3-formatted filesystems without any conversion being done.  Enabling extents will improve performance, and uninit_bg will improve e2fsck performance.

You wouldn't be able to take advantage of flex_bg without reformatting (or some significant surgery to resize2fs).

If the inodes are "large" (256 bytes) then mounting the filesystem with ext4 will allow the inodes to use nanosecond timestamps.

> In the case that there is a difference, what exactly is sacrificed in
> choosing one over the other?

Reformatting and reinstalling and/or restoring from backup into an ext4-formatted filesystem will allow using a few of the features lay out the files with extents, and reduce the metadata overhead.  There will be some performance benefits, but I don't think it will necessarily be dramatic.

Cheers, Andreas





