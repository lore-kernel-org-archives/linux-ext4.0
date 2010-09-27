From: Brad Boyer <flar@allandria.com>
Subject: Re: [PATCH 2/6] [RFC] Create the .relink file_operation
Date: Mon, 27 Sep 2010 15:03:46 -0700
Message-ID: <20100927220346.GA30726@cynthia.pants.nu>
References: <6987185123220ec2034677299859c5a63eaf2aed.1285278339.git.matthltc@us.ibm.com> <d91e3660266d3a2956c4d1aebc9cb618081b21ef.1285278339.git.matthltc@us.ibm.com> <20100926190837.GA9308@cynthia.pants.nu> <20100927191628.GN23839@count0.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: containers@lists.linux-foundation.org,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
To: Matt Helsley <matthltc@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100927191628.GN23839@count0.beaverton.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Sep 27, 2010 at 12:16:28PM -0700, Matt Helsley wrote:
> On Sun, Sep 26, 2010 at 12:08:37PM -0700, Brad Boyer wrote:
> > On Thu, Sep 23, 2010 at 02:53:28PM -0700, Matt Helsley wrote:
> > > Not all filesystems will necessarily be able to support relinking an
> > > orphan inode back into the filesystem. Some offlist feedback suggested
> > > that instead of overloading .link that relinking should be a separate
> > > file operation for this reason.
> > > 
> > > Since .relink is a superset of .link make the VFS call .relink where
> > > possible and .link otherwise.
> > > 
> > > The next commit will change ext3/4 to enable this operation.
> > 
> > I may have missed something in one of these patches (patch 1 and any
> > original summary if there was one don't appear in my email), but
> > what is the point of the new operation? I didn't see any case that
> > treats one any different than the other. What is disallowed (and how)
> > for a driver which does not implement .relink but has .link?
> 
> Did you get patch 3? It shows how ext3/ext4 add the ability to take an
> inode that has been unlinked, placed onto the orphan list, and relink it.

Yes, I did get patch 3. I think you misunderstood my question. You point
both .link and .relink to the same function in ext3 and ext4. The common
code which calls them will call .relink if it is set and .link if it is
not set. If nothing acts any different based on .relink being NULL or
not-NULL, and the only implementation isn't any different from .link
what was the point of introducing a new operation?

What I expected to see was that some particular code path would check
if .relink was NULL and fail in that case. Unless there is a code path
that will only call .relink and not .link, it seems useless to me.

	Brad Boyer
	flar@allandria.com

