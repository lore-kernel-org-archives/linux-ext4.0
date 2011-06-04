From: Ted Ts'o <tytso@mit.edu>
Subject: Re: big allocation status
Date: Sat, 4 Jun 2011 15:11:35 -0400
Message-ID: <20110604191135.GC1001@thunk.org>
References: <4DE83F83.6070302@tao.ma>
 <20110604033805.GD2614@thunk.org>
 <4DE9EE01.6070406@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51144 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab1FDTLi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Jun 2011 15:11:38 -0400
Content-Disposition: inline
In-Reply-To: <4DE9EE01.6070406@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jun 04, 2011 at 04:34:09PM +0800, Tao Ma wrote:
> Cool, but do you have a mkfs.ext4 that we can let the kernel part work
> happily? Or we have to add the feature by hand by editing the disk
> format. ;)

Grab the bigalloc-hack branch on the e2fsprogs git tree on
git.kernel.org.  This will allow you to create bigalloc file systems
via "mke2fs -t ext4 -O bigalloc".  Don't base anything on this branch;
the code is incredibly hacky, and not how the final bigalloc
support will be done.

						- Ted
