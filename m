From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: WARNING: at fs/ext4/inode.c:230 ext4_evict_inode+0x41b/0x510
Date: Tue, 9 Jul 2013 07:22:09 -0700
Message-ID: <20130709142209.GA29798@roeck-us.net>
References: <20130708183829.GA3205@roeck-us.net>
 <20130709033510.GE6000@thunk.org>
 <20130709040658.GA7763@roeck-us.net>
 <20130709083936.GB21060@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:32822 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab3GIOWL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Jul 2013 10:22:11 -0400
Received: by mail-pb0-f51.google.com with SMTP id um15so5594481pbc.10
        for <linux-ext4@vger.kernel.org>; Tue, 09 Jul 2013 07:22:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130709083936.GB21060@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 09, 2013 at 10:39:36AM +0200, Jan Kara wrote:
> On Mon 08-07-13 21:06:58, Guenter Roeck wrote:
> > On Mon, Jul 08, 2013 at 11:35:10PM -0400, Theodore Ts'o wrote:
> > > On Mon, Jul 08, 2013 at 11:38:29AM -0700, Guenter Roeck wrote:
> > > > Hi,
> > > > 
> > > > seen this morning with a brand new top-of-tree kernel (as of last night) plus a
> > > > couple of patches I am working on.
> > > > 
> > > > Due to my changes, there is a slight chance that the problem is not due to an
> > > > upstream bug, but I think that is quite unlikely (my changes are unrelated
> > > > to file system code).
> > > > 
> > > > If there is anything I can help to track this down, please let me know.
> > > > 
> > > > [13071.291013] ------------[ cut here ]------------
> > > > [13071.291021] WARNING: at fs/ext4/inode.c:230 ext4_evict_inode+0x41b/0x510()
> > > 
> > > Hmm, this warning was added by commit 5dc23bdd5: ext4: remove
> > > ext4_ioend_wait().
> > > 
> > > What sort of work load are you running on this machine?  Do you know
> > > what might have triggered it?
> > > 
> > My nightly kernel builds were running at the time. This is a sequence of git
> > clone/checkout operations followed by builds for several targets.
> > 
> > I have the same kernel running on three systems, but this only happened on the
> > build machine, and I have not seen it again during the day.
> > 
> > I'll let you know if it happens again tonight.
>   Thanks for report. I think I see what's going on. I think we completed
> bio directly in ext4_end_bio() (as it didn't need unwritten conversion) but
> io_end is released only a bit later which can race with ext4_evict_inode()
> as:
> 	CPU1					CPU2
> ext4_end_bio()				ext4_evict_inode()
>   ext4_finish_bio()
>     end_page_writeback();
> 					  truncate_inode_pages()
> 					    evict page
> 					WARN_ON(i_ioend_count > 0);
>   ext4_put_io_end_defer()			
>     ext4_release_io_end()
>       dec i_ioend_count
> 
> This seems harmless. I'll see if I can easily fix this to make the warning
> still useful. If not, I'll just rip out i_ioend_count completely as it's
> there only as a sanity check until the new code settles down...
> 
Good to hear that. It did not happen tonight, even though I ran builds on two
systems, so it must be quite rare.

It would be great if you can Cc: me on any patch. Also, if you have some
test software to trigger this condition, let me know and I'll give it a try.

Thanks,
Guenter
