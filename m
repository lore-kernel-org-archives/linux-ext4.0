From: tytso@mit.edu
Subject: Re: [PATCH] ext4: initialize multi-block allocator before checking
 block descriptors
Date: Sat, 15 Mar 2014 22:38:41 -0400
Message-ID: <20140316023841.GA902@thunk.org>
References: <20140315214029.GA18873@thunk.org>
 <CAG5DWoj0pYD8O17qw_-MK+JX_hsFj04ReUPztShmKWzz45gRbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41950 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbaCPCiq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Mar 2014 22:38:46 -0400
Content-Disposition: inline
In-Reply-To: <CAG5DWoj0pYD8O17qw_-MK+JX_hsFj04ReUPztShmKWzz45gRbQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 16, 2014 at 03:54:34AM +0400, Azat Khuzhin wrote:
> 
> Thanks Ted, I'll take a look.
> Are you talking about xfs-tests failures?

Yes, the kernel is complaining that the file system looks corrupt.
The xfstest generic/001 is the easist one to trigger it:

generic/001 18s ...	[17:35:49][   26.793766] EXT4-fs error (device vde): ext4_mb_generate_buddy:756: group 1, 32763 clusters in bitmap, 32764 
in gd; block bitmap corrupt.
 [17:36:09] 20s
[   39.636943] EXT4-fs (vde): warning: mounting fs with errors, running e2fsck is recommended

I this was using a freshly generated file system using a 20 GiB test
partition, formatted using:

	   mke2fs -t ext4 -O bigalloc /dev/vde

Dropping the patch made the error go away.

Cheers,

					- Ted
