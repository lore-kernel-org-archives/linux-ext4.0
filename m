From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] ext4: fix a bug when we try to open a file with
 O_TMPFILE flag
Date: Sat, 20 Jul 2013 00:36:13 +0100
Message-ID: <20130719233613.GH4165@ZenIV.linux.org.uk>
References: <20130717161944.GA19405@redhat.com>
 <20130719121405.GA3856@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:55520 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab3GSXgQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Jul 2013 19:36:16 -0400
Content-Disposition: inline
In-Reply-To: <20130719121405.GA3856@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 19, 2013 at 08:14:05PM +0800, Zheng Liu wrote:
> Hi Dave,
> 
> After applied this patch, the problem has been fixed in my own sand box.
> But that would be great if you could give it a try.  I want to make sure
> that this patch can fix the problem.  It looks like there has the same
> problem in ext3.  So if this patch is fine, I will generate a patch for
> ext3 file system.

Nice catch, and you have my ACK.  Which tree do you prefer that to go
through?  vfs and ext4 are the obvious candidates...
