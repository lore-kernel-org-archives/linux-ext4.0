From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v1 0/9] do not use s_dirt in ext4
Date: Thu, 22 Mar 2012 11:06:02 -0400
Message-ID: <20120322150602.GD25897@thunk.org>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
 <20120322133521.GA25897@thunk.org>
 <1332424585.18717.34.camel@sauron.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1332424585.18717.34.camel@sauron.fi.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Mar 22, 2012 at 03:56:25PM +0200, Artem Bityutskiy wrote:
> 
> But I wonder, since this is cross-FS story, where I need to first do
> small VFS change (export the variable), then change all file-systems,
> and then remove whole 's_dirt'/'write_supers()' stuff from VFS, how this
> would be handled?

What I'm thinking about doing is pulling the first five patches into
my tree, which includes the VFS change to export the
dirty_writeback_interval variable.  Those patches should be very low
risk, and acceptable at this point (although I'm still going to test
them really hard).

Assuming there are no objections with this, then you'd be able to send
the rest of the patches for each file system to get rid of the super
writeback thread separately; those really should go via each file
system maintainer's separate trees, though.  Ext2 and ext3 changes I'm
willing to carry in the ext4 tree (although Jan does have his own ext3
tree).  However, it would really be inappropriate for me to carry
patches against jfs, xfs, or other non-ext 2/3/4 file systems in my
tree.  It will go much faster if you negotiate with each of the file
system maintainers/development teams directly, instead of trying to
use my tree and me as a middleman.

The one thing that will require some coordination is the patch to
completely remove the super writeback thread altogether, which
obviously can't be applied until we know all of the file systems have
removed their dependency on s_dirt.  That's a pretty trivial patch
that could go in late in the next merge window, or even in -rc2 (with
prior warning given to Linus), once you're sure all of the file
systems have gotten their s_dirt removal patches merged in.

Does that seem reasonable to you?

Best regards,

					- Ted
