From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Resubmit][Patch 0/2] Persistent preallocation in ext4
Date: Sun, 25 Feb 2007 02:23:26 -0800
Message-ID: <20070225022326.137b4875.akpm@linux-foundation.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58988 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933690AbXBYKZF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 Feb 2007 05:25:05 -0500
In-Reply-To: <20070117094658.GA17390@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Wed, 17 Jan 2007 15:16:58 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
> (1) The final interface is yet to be decided. We have the option of
> chosing from one of these:
> 	a> modifying posix_fallocate() in glibc
> 	b> using fcntl
> 	c> using ftruncate, or
> 	d> using the ioctl interface.

I'd suggest we add a new syscall, which implements the posix_fallocate()
API as per the relevant specs.  We can work the final details out with Ulrich
and I'm sure that glibc's posix_fallocate() will start using the syscall if it
is available.

Actually, we should implement

 asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len);

note: loff_t, not off_t.

This probably means that we'll need to implement file_operations.fallocate().

It wouldn't surprise me if XFS was able to implement fallocate() too.
