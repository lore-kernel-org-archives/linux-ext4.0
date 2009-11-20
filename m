From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext2: clear uptodate flag on super block I/O error
 (v2)
Date: Fri, 20 Nov 2009 10:23:24 +0100
Message-ID: <20091120092324.GA15422@duck.suse.cz>
References: <20091117174617.285298261@vyatta.com>
 <20091117174647.315080808@vyatta.com>
 <20091119151953.GA2943@atrey.karlin.mff.cuni.cz>
 <20091119101317.34791e83@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbZKTJXT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Nov 2009 04:23:19 -0500
Content-Disposition: inline
In-Reply-To: <20091119101317.34791e83@nehalam>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 19-11-09 10:13:17, Stephen Hemminger wrote:
> On Thu, 19 Nov 2009 16:19:53 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> > > +	if (buffer_write_io_error(sbh)) {
> > > +		/*
> > > +		 * This happens if USB or floppy device is yanked out.
> > > +		 * Maybe user put device back in so warn and update again.
> > > +		 */
> > > +		printk(KERN_ERR
> > > +		       "EXT2-fs: previous I/O error to superblock detected\n");
> > > +		clear_buffer_write_io_error(sbh);
> > > +		set_buffer_uptodate(sbh);  
> >   It's not much about puting the device back. It's really just about
> > avoiding the warning in mark_buffer_dirty(). So I'd just silently
> > set_buffer_uptodate and be done with it. For superblock we are darn sure
> > that in memory copy is the one that has the latest data :)
> 
> This code mirrors ext4_commit_super, why should ext2 be any different?
  OK, my remark was mostly about the comment which is different in ext4 ;).
I'll just fixup the comment and merge the patch. Thanks.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
