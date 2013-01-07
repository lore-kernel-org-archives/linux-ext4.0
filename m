From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: remove duplicate assignment in
 ext4_init_new_dir()
Date: Sun, 6 Jan 2013 23:37:20 -0500
Message-ID: <20130107043720.GC4956@thunk.org>
References: <1357371781-18194-1-git-send-email-yan@linux.vnet.ibm.com>
 <1357371781-18194-3-git-send-email-yan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Tao Ma <boyu.mt@taobao.com>
To: Guo Chao <yan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42097 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524Ab3AGEhX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Jan 2013 23:37:23 -0500
Content-Disposition: inline
In-Reply-To: <1357371781-18194-3-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 05, 2013 at 03:43:01PM +0800, Guo Chao wrote:
> It should be a typo unless I miss something.
> 
> Cc: Tao Ma <boyu.mt@taobao.com>
> Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>

Thanks, applied.  Note that this fixes a buffer cache leak when
creating a directory using the mkdir system call.

	   	     	       	     - Ted
