From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5] ext2: Preparation to remove BKL
Date: Tue, 13 Apr 2010 22:12:49 +0200
Message-ID: <20100413201246.GB5602@nowhere>
References: <1271104905-8804-1-git-send-email-jblunck@suse.de> <20100412210127.GE8285@nowhere> <201004131131.54650.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Blunck <jblunck@suse.de>, Jan Kara <jack@suse.cz>,
	tytso@mit.edu,
	Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:57070 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab0DMUM5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Apr 2010 16:12:57 -0400
Content-Disposition: inline
In-Reply-To: <201004131131.54650.arnd@arndb.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 13, 2010 at 11:31:54AM +0200, Arnd Bergmann wrote:
> On Monday 12 April 2010, Frederic Weisbecker wrote:
> > It looks like this is all about .35 material.
> > 
> > This is going to be hard to have a separate tree to pushdown/remove
> > the bkl in the mount path if it depends on the ext2 tree.
> 
> The pushdown can be in a separate tree that can be merged independently,
> just the final patch removing it in do_new_mount needs to wait
> for everything else to get merged first.


Right.



> We have some other patches,
> in particular the one that makes CONFIG_BKL modular that have to
> wait for other patches and should probably just be applied separately
> rather than merged from a bisectable git tree.
> 
> 	Arnd


Ok, no problem then.

Thanks.

