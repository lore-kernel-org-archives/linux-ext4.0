From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fslibs: fix llseek on i386
Date: Thu, 24 Jan 2013 21:16:05 -0500
Message-ID: <20130125021604.GB28908@thunk.org>
References: <1359044517-18243-1-git-send-email-psusi@ubuntu.com>
 <20130124195158.GC9477@thunk.org>
 <5101980D.30904@ubuntu.com>
 <20130124203230.GA20776@thunk.org>
 <20130125022514.GA10883@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phillip Susi <psusi@ubuntu.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45372 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629Ab3AYCQI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jan 2013 21:16:08 -0500
Content-Disposition: inline
In-Reply-To: <20130125022514.GA10883@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 25, 2013 at 10:25:14AM +0800, Zheng Liu wrote:
> 
> This patch makes me consider my patches that dump a sparse file in
> debugfs.  In my patch [1] llseek64(2) is called to seek to the next
> data in target file.  So I believe ext2fs_llseek() is a better choice.
> I am happy to send a newer patch to fix it.  What do you think?
> 
> 1. http://www.spinics.net/lists/linux-ext4/msg36134.html

You're right, we should use ext2fs_llseek() for better portability.
Thanks,

					- Ted
