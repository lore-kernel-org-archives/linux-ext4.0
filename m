From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH 1/2] ext2: clear uptodate flag on super block I/O error
 (v2)
Date: Thu, 19 Nov 2009 10:13:17 -0800
Message-ID: <20091119101317.34791e83@nehalam>
References: <20091117174617.285298261@vyatta.com>
	<20091117174647.315080808@vyatta.com>
	<20091119151953.GA2943@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:42169 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbZKSSNR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Nov 2009 13:13:17 -0500
In-Reply-To: <20091119151953.GA2943@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 19 Nov 2009 16:19:53 +0100
Jan Kara <jack@suse.cz> wrote:

> > +	if (buffer_write_io_error(sbh)) {
> > +		/*
> > +		 * This happens if USB or floppy device is yanked out.
> > +		 * Maybe user put device back in so warn and update again.
> > +		 */
> > +		printk(KERN_ERR
> > +		       "EXT2-fs: previous I/O error to superblock detected\n");
> > +		clear_buffer_write_io_error(sbh);
> > +		set_buffer_uptodate(sbh);  
>   It's not much about puting the device back. It's really just about
> avoiding the warning in mark_buffer_dirty(). So I'd just silently
> set_buffer_uptodate and be done with it. For superblock we are darn sure
> that in memory copy is the one that has the latest data :)

This code mirrors ext4_commit_super, why should ext2 be any different?
