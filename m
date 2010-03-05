From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PULL REQUEST] Quota cleanups & fixes and ext3 fixes for
 2.6.34-rc1
Date: Fri, 5 Mar 2010 13:24:35 -0800 (PST)
Message-ID: <alpine.LFD.2.00.1003051314330.3906@localhost.localdomain>
References: <20100305003304.GE4887@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
	dushistov@mail.ru, joel.becker@oracle.com,
	shaggy@linux.vnet.ibm.com, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755131Ab0CEVZ6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Mar 2010 16:25:58 -0500
In-Reply-To: <20100305003304.GE4887@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Fri, 5 Mar 2010, Jan Kara wrote:
> 
>   could you please pull from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus
> 
>   You'll get lots of quota cleanups from Christoph which touch filesystems
> all over the place but it's just function renaming and moving quota calls
> from VFS into filesystems themselves.

Gaah. This interacted with the VFS stuff (the do_filp_open() cleanip in 
particular) I merged from Al earlier today. 

It really looked very trivial, so I fixed it up. Al had split up 
do_filp_open() into several helper functions, and one of your changes was 
to the old pre-split one. I felt confident enough about it that I just did 
the obvious merge resolution, but you guys should check it out to be sure.

			Linus
