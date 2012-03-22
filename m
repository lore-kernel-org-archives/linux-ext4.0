From: Jan Kara <jack@suse.cz>
Subject: Re: Required help for understanding ext4 block allocation
Date: Thu, 22 Mar 2012 15:11:55 +0100
Message-ID: <20120322141155.GB19587@quack.suse.cz>
References: <CA+tw96DSaJH50o1F4sW9XMnmPD8dFO9VCyvK4tbsLFqfgK9CWQ@mail.gmail.com>
 <20120316091810.GB24821@quack.suse.cz>
 <CA+tw96C9kRHYhiQoyRRH8U_gPtcXZimJL0=kHBX4m7dLrXwaPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4 <linux-ext4@vger.kernel.org>
To: Akshay Nehe <akshaynehe785@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39403 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786Ab2CVOMR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Mar 2012 10:12:17 -0400
Content-Disposition: inline
In-Reply-To: <CA+tw96C9kRHYhiQoyRRH8U_gPtcXZimJL0=kHBX4m7dLrXwaPg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Thu 22-03-12 18:54:26, Akshay Nehe wrote:
> Yes, i got extents as you have suggested, but one thing i found that
> each time modification occurs on any file from ext4 file system then
> kernel deallocates all current blocks and allocate new blocks and
> write modified data on newly allocated blocks.
  That is not true. Why do you think it is? Maybe you are modifying the
file with something like a text editor? That certainly truncates the old
file and writes a new one. But generally ext4 supports overwriting.

> So by tracing kernel code i got some useful functions, for
> deallocation: ext4_free_blocks, for allocation: ext4_map_blocks, but
> found difficult to analyse each of them. Can anyone suggest correct
> functions which actually dose allocation and deallocation?
  Ext4 uses multiblock allocator which is in fs/ext4/mballoc.c. In
particular function allocating blocks in ext4_mb_new_blocks(), function
freeing blocks is ext4_free_blocks(). But you will need to understand most
of mballoc.c to understand how mballoc works. You can read comments in the
beginning of the file to understand some basics about mballoc. You can
also read some basics from by presentation about ext4 at Linux Kongress in
2009 (http://www.linux-kongress.org/2009/slides/ext4+btrfs_jan_kara.pdf).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
