From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: next: ext4 build failure
Date: Tue, 4 Dec 2012 08:27:01 -0500
Message-ID: <20121204132701.GA29083@thunk.org>
References: <50BDC25C.5020509@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: boyu.mt@taobao.com, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Jiri Slaby <jslaby@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36654 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab2LDN1J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Dec 2012 08:27:09 -0500
Content-Disposition: inline
In-Reply-To: <50BDC25C.5020509@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 04, 2012 at 10:29:00AM +0100, Jiri Slaby wrote:
> Hi,
> 
> commit a7b0168d4a9bb78535827ddaf9c055963f5bd7aa
> Author: Tao Ma <boyu.mt@taobao.com>
> Date:   Sun Dec 2 20:30:52 2012 -0500
> 
>     ext4: let fallocate handle inline data correctly
> 
> added
> 
> static int int ext4_convert_inline_data(struct inode *inode)
> 
>        ^^^^^^^
> 
> when EXT4_FS_XATTR is unset.
> 
> Care to fix that?

Oops.  Thanks for catching this!!!

						- Ted
