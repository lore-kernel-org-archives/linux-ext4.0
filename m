From: Tony Lindgren <tony@atomide.com>
Subject: Re: Regression in next with ext4 oops
Date: Tue, 4 Oct 2016 12:16:34 -0700
Message-ID: <20161004191633.muirbg7mvb3ylhhl@atomide.com>
References: <20161003233054.eltv3coiweht3ui4@atomide.com>
 <20161004090041.GE17515@quack2.suse.cz>
 <20161004140231.fyfrc6rs2lb6z63v@thunk.org>
 <20161004145915.GZ19539@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:43736 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752591AbcJDTQi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 4 Oct 2016 15:16:38 -0400
Content-Disposition: inline
In-Reply-To: <20161004145915.GZ19539@ZenIV.linux.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

* Al Viro <viro@ZenIV.linux.org.uk> [161004 08:00]:
> On Tue, Oct 04, 2016 at 10:02:31AM -0400, Theodore Ts'o wrote:
> > On Tue, Oct 04, 2016 at 11:00:41AM +0200, Jan Kara wrote:
> > > Never seen this but I suspect it is a fallout from Al's directory locking
> > > changes. In particular ext4_htree_fill_tree() builds rb-tree of found
> > > directory entries in file->private_data (and generally modifies the
> > > structure stored there) but after Al's changes we don't have exclusive
> > > access to struct file if I'm right so if two processes end up calling
> > > getdents() for the same 'struct file' we are doomed.
> > 
> > I haven't seen it either, and I've been doing a lot of testing on the
> > ext4 test branch.  So I'm guessing Tony has the only reliable repro
> > for the problem at the moment.  That being said, it shouldn't be that
> > hard to create a test case for this and add it to xfstests.
> > 
> > I'm pretty sure Jan is right about this, though, but it would be great
> > to a get a quick confirmation from Tony if at all possible.
> 
> Jan is wrong - we do have per-struct-file serialization for getdents()
> et.al.  It might be a race between getdents() on *different* struct
> file for the same directory, but ->private_data is not a problem.

OK found the guilty person after git bisect and that's me.

Git bisect points to commit d776fc86b82f ("wlcore: sdio: Populate config
firmware data"), so adding Kalle to Cc.

Looks like update-initramfs does rmmod of wlcore_sdio and that triggers
some issue with the wlcore driver or with SDIO/MMC. Or maybe it's a memory
corruption issue. I don't know yet exactly what's going on here yet but
I plan to find out after some lunch.

Regards,

Tony
