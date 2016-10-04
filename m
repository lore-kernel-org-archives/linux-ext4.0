From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Regression in next with ext4 oops
Date: Tue, 4 Oct 2016 10:02:31 -0400
Message-ID: <20161004140231.fyfrc6rs2lb6z63v@thunk.org>
References: <20161003233054.eltv3coiweht3ui4@atomide.com>
 <20161004090041.GE17515@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tony Lindgren <tony@atomide.com>,
        Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161004090041.GE17515@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 04, 2016 at 11:00:41AM +0200, Jan Kara wrote:
> Never seen this but I suspect it is a fallout from Al's directory locking
> changes. In particular ext4_htree_fill_tree() builds rb-tree of found
> directory entries in file->private_data (and generally modifies the
> structure stored there) but after Al's changes we don't have exclusive
> access to struct file if I'm right so if two processes end up calling
> getdents() for the same 'struct file' we are doomed.

I haven't seen it either, and I've been doing a lot of testing on the
ext4 test branch.  So I'm guessing Tony has the only reliable repro
for the problem at the moment.  That being said, it shouldn't be that
hard to create a test case for this and add it to xfstests.

I'm pretty sure Jan is right about this, though, but it would be great
to a get a quick confirmation from Tony if at all possible.

     	   	 	      	   	- Ted
