From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsprogs/debugfs/write: Input/output error when file size is
 zero
Date: Wed, 24 Jul 2013 10:00:04 -0500
Message-ID: <51EFEBF4.20701@redhat.com>
References: <51EF975E.2090700@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Darren Hart <dvhart@linux.intel.com>
To: Robert Yang <liezhi.yang@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab3GXPJV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Jul 2013 11:09:21 -0400
In-Reply-To: <51EF975E.2090700@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/24/13 3:59 AM, Robert Yang wrote:
> 
> Hello experts,
> 
> I met a "Input/output error" problem when used debugfs' command "write"
> to copy a zero size file to ext4 fs, here are the steps to reproduce the
> problem:
> 
> $ dd if=/dev/zero of=test.img count=1M bs=1k
> $ mkfs.ext4 -F test.img
> $ touch emptyfile
> $ debugfs -R "write emptyfile emptyfile" -w test.img
> $ mkdir mnt
> $ mount test.img mnt/
> $ ls mnt/emptyfile
> ls: cannot access mnt/emptyfile: Input/output error
> 
> The degbufs is from the up-to-date git repo, the ext2 and ext3 work well,
> I think that it is caused by the EXT4_EXTENTS_FL, it works well if we
> turn off the EXT4_EXTENTS_FL when the file size is zero, but this is not
> a correct fix, would you please give me some instructions so that I can
> fix it?

When reporting problems like this it's helpful to include which kernel version
you tested, all the error messages (including dmesg), etc.

But on upstream it persists, and when we do the ls, we get:

[40992.729130] EXT4-fs error (device loop0): ext4_ext_check_inode:464: inode #12: comm ls: bad header/extent: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)

so it seems that debugfs has created a corrupt inode in the image.

I'll send a patch.


