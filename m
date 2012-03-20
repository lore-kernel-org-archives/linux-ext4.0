From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: umode_t breakage in exported kernel headers
Date: Tue, 20 Mar 2012 10:05:10 +0000
Message-ID: <20120320100510.GK6589@ZenIV.linux.org.uk>
References: <201203191601.55668.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Duane Griffin <duaneg@dghda.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:59511 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab2CTKFM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Mar 2012 06:05:12 -0400
Content-Disposition: inline
In-Reply-To: <201203191601.55668.vapier@gentoo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 19, 2012 at 04:01:53PM -0400, Mike Frysinger wrote:
> commit 0583fcc96bb117763c0fa74c123573c0112dec65 moved umode_t out of the 
> exported headers space (via the arches' asm/types.h) and into __KERNEL__ 
> specific linux/types.h.  this breaks the exported linux/ext2_fs.h 
> ext2_mask_flags function which uses that type.  that func appears to be the 
> only one exported that utilizes umode_t.
> 
> should ext2_mask_flags be updated to take a __kernel_mode_t as its first arg ?
> -mike

ITYM "unsigned short".  __kernel_mode_t is wrong kernel-side and pointless
everywhere.  It should *only* be used in layout of structs shared with
userland and misdefined back then.  Anything new should use explicitly-sized
types (and u16 is enough for mode).

It's nearly entirely about ncp_mount_data - ipc_perm, ipc64_perm and in
several cases st_mode of stat* are arch-dependent anyway and could bloody
well use explicitly-sized types.
