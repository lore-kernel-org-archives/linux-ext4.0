From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext2: show all mount options
Date: Mon, 23 Jul 2007 19:21:10 -0400
Message-ID: <20070723232110.GE30165@thunk.org>
References: <E1ID4H0-00065Q-00@dorka.pomaz.szeredi.hu> <20070723135642.9d87178a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51572 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755830AbXGWXVV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jul 2007 19:21:21 -0400
Content-Disposition: inline
In-Reply-To: <20070723135642.9d87178a.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 23, 2007 at 01:56:42PM -0700, Andrew Morton wrote:
> On Mon, 23 Jul 2007 22:12:54 +0200
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> 
> Could we have changelogs for these patches, please?
> 
> ie: what's wrong with the existing code, what change does this patch make?

The idea is to allow /proc/mounts to display all of the mount options
that were used to mount a particular filesystem.  This is useful if
you want /proc/mounts to replace /etc/mtab.

I keep thinking that this is really the wrong approach, though, since
it means adding a lot of coding to every single filesystem to
reconstruct the mount options, and in some cases it will still never
be enough to reconstruct exactly what was in /etc/mtab.  (For example,
the fully qualified domain named passed into some remote filesystem.)

It seems to me the right answer would be to enhance the mount(2)
system call with a new mount operation which would allow the user
space mount command can stash exactly the options used to mount the
filesystem.  That we the kernel can store the exact ascii string in
allocated memory and regurgitate it for the benefit of /proc/mounts,
instead of adding a lot of code into ext2, ext3, ext4, et. al in an
attempt partially reconstruct the mount options.  

						- Ted
