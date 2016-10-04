From: Tony Lindgren <tony@atomide.com>
Subject: Re: Regression in next with ext4 oops
Date: Tue, 4 Oct 2016 12:19:48 -0700
Message-ID: <20161004191947.keu6tyqlxq7qlc6a@atomide.com>
References: <20161003233054.eltv3coiweht3ui4@atomide.com>
 <20161004090041.GE17515@quack2.suse.cz>
 <20161004140231.fyfrc6rs2lb6z63v@thunk.org>
 <20161004145915.GZ19539@ZenIV.linux.org.uk>
 <20161004190717.yzisypxpuh5nufsc@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@ZenIV.linux.org.uk>,
        Jan Kara <jack@suse.cz>, Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161004190717.yzisypxpuh5nufsc@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

* Theodore Ts'o <tytso@mit.edu> [161004 12:08]:
> On Tue, Oct 04, 2016 at 03:59:15PM +0100, Al Viro wrote:
> > Jan is wrong - we do have per-struct-file serialization for getdents()
> > et.al.  It might be a race between getdents() on *different* struct
> > file for the same directory, but ->private_data is not a problem.
> 
> So the rb_insert_color() OOPS seems to indicate that the rbtree has
> gotten corrupted, and it hangs off of private_data.

Yes so it seems..

> And I've just checked the ext4.git tree and I can't see any changes in
> the dev branch (which I was just about to push to Linus) that would
> impact the readdir path for non-encrypted directories.  So if it's a
> race on ->private_data I'm not sure what else might be going wrong.
> 
> Hmm... Tony, what version was the last good version where it wouldn't
> reproduce for you?  v4.7?   Does it reproduce for you on v4.8?

Well I just found it's caused by my commit d776fc86b82f ("wlcore:
sdio: Populate config firmware data") and has nothing to do with
ext4, see the mail I just posted.

> Also, would you mind seeing if you can reproduce it on the dev
> branch of the ext4 git tree?
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev

Seems like there's nothing wrong with ext4, this is probably some
memory corruption issue.

Thanks everybody for help and sorry for the false ext4 alert.

Regards,

Tony
