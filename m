From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -V2] vfs: Enable FS_IOC_FIEMAP and FIGETBSZ for all
	filetypes
Date: Wed, 13 May 2009 18:42:39 -0400
Message-ID: <20090513224239.GB10003@mit.edu>
References: <20090503203037.GA17044@mit.edu> <1241427742-13049-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45464 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbZEMWmn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 May 2009 18:42:43 -0400
Content-Disposition: inline
In-Reply-To: <1241427742-13049-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 04, 2009 at 02:32:22PM +0530, Aneesh Kumar K.V wrote:
> fiemap and get_blk_size ioctl should be enabled even for directories.
> So move it outisde file_ioctl. Enabling file_ioctl for both
> directories and files cause udev to hang when using FIONREAD. I guess
> some of the user space may depend on these ioctls cmd failing on
> directories.

I've added this patch to the ext4 patch queue.

						- Ted
