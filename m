From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [stable] [PATCH] ext3/4: fix uninitialized bs in
 ext3/4_xattr_set_handle()
Date: Wed, 14 May 2008 10:28:09 -0700
Message-ID: <20080514102809.3fc190f0.akpm@linux-foundation.org>
References: <4827B878.50903@oracle.com>
	<20080512170254.f79fe869.akpm@linux-foundation.org>
	<4828FD68.40608@oracle.com>
	<200805141256.43272.agruen@suse.de>
	<20080514160035.GD28594@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andreas Gruenbacher <agruen@suse.de>,
	Tiger Yang <tiger.yang@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@kernel.org
To: Greg KH <greg@kroah.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080514160035.GD28594@kroah.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 14 May 2008 09:00:36 -0700 Greg KH <greg@kroah.com> wrote:

> On Wed, May 14, 2008 at 12:56:42PM +0200, Andreas Gruenbacher wrote:
> > On Tuesday 13 May 2008 04:31:04 Tiger Yang wrote:
> > > Hi, Andrew
> > >
> > > This situation only happens we format ext3/4 with inode size more than
> > > 128 and we have put xattr entries both in ibody and block.
> > > The consequences about this bug is we will lost the xattr block which
> > > pointed by i_file_acl with all xattr entires in it. We will alloc a new
> > > xattr block and put that large value entry in it. The old xattr block
> > > will become orphan block.
> > 
> > The patch looks good, and it obviously fixes the described problem. Thanks!
> > 
> > Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
> > 
> > 
> > Could it please be added to -stable?
> 
> Can someone actually _send_ the patch to stable@kernel.org?  I haven't
> seen it yet :)
> 
> And is it in Linus's tree?  We need to wait until it is there before we
> can add it to -stable.

It's in -mm and I just added the "Cc:stable" tag to it.
