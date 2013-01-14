From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] Ext3: return ENOMEM rather than EIO if sb_getblk
 fails
Date: Sun, 13 Jan 2013 22:45:38 -0500
Message-ID: <20130114034538.GB29329@thunk.org>
References: <1294915634-3413-1-git-send-email-wangshilong1991@gmail.com>
 <20130113044342.GA11738@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wang shilong <wangshilong1991@gmail.com>, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Wang Shilong <wangsl-fnst@cn.fujitsu.com>
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43173 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295Ab3ANDpq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Jan 2013 22:45:46 -0500
Content-Disposition: inline
In-Reply-To: <20130113044342.GA11738@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 12, 2013 at 08:43:42PM -0800, Greg KH wrote:
> On Thu, Jan 13, 2011 at 06:47:14PM +0800, Wang shilong wrote:
> > From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> > 
> > It will be better to have ENOMEM return rather than EIO,because
> > the only reason that sb_getblk fails is allocation fails.
> > 
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> for how to do this properly.
> 
> </formletter>

Did Wang Shilong bcc stable@vger.kernel.org?  He didn't need to send
this to linux-fsdevel@vger.kernel.org (the linux-ext4 list is
sufficient), but I didn't see anything which indicated he was trying
to submit this for inclusion in the stable kernel tree.

My personal opinion is this isn't an important enough patch to warrant
going into stable@vger.kernel.org, although I don't think it would do
any harm or is really dangerous, so I wouldn't object strongly if it did.

I did mark a similar change for ext4 as going to stable, but not
because of the error code change; but rather because I also fixed a
problem where an out-of-memory failure might result in the file system
getting marked as containing errors (and thus might cause an unneeded
fsck).

Cheers,

						- Ted
