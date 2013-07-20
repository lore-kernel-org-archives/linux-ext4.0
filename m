From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: fix a bug when we try to open a file with
 O_TMPFILE flag
Date: Sun, 21 Jul 2013 00:37:37 +0800
Message-ID: <20130720163737.GA8870@gmail.com>
References: <20130717161944.GA19405@redhat.com>
 <20130719121405.GA3856@gmail.com>
 <20130719233613.GH4165@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130719233613.GH4165@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Al,

On Sat, Jul 20, 2013 at 12:36:13AM +0100, Al Viro wrote:
> On Fri, Jul 19, 2013 at 08:14:05PM +0800, Zheng Liu wrote:
> > Hi Dave,
> > 
> > After applied this patch, the problem has been fixed in my own sand box.
> > But that would be great if you could give it a try.  I want to make sure
> > that this patch can fix the problem.  It looks like there has the same
> > problem in ext3.  So if this patch is fine, I will generate a patch for
> > ext3 file system.
> 
> Nice catch, and you have my ACK.  Which tree do you prefer that to go
> through?  vfs and ext4 are the obvious candidates...

Now ext4 tree has not yet rebased against 3.11-rcX.  So it seems that
vfs tree is better if we want to fix this bug in mainline kernel as soon
as possible.  This patch is against mainline kernel.  I think it should
be applied into vfs tree cleanly.  Please let me know if I need to rebase
it against vfs tree.  BTW, the patch for ext3 file system will be sent
out soon.  Please pick it up.

Thanks,
                                                - Zheng
