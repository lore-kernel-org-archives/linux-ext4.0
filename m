From: Jan Kara <jack@suse.cz>
Subject: Re: freeze_bdev hangs
Date: Tue, 9 Oct 2012 23:49:15 +0200
Message-ID: <20121009214915.GD27882@quack.suse.cz>
References: <CAD6i1f+fzh-z+Xr6V2gHBzq4kmJzPcfre91g=q6fJ7P_5nY0Zw@mail.gmail.com>
 <506F19E6.8030005@redhat.com>
 <CAD6i1fJbfiBnTu1ttisMr96PzaTWCLAsvmTjx7OevfPcAGd7-A@mail.gmail.com>
 <20121008161926.GH9243@quack.suse.cz>
 <CAD6i1fKpWZVbL4gS1ui7GvF81S+SAduckXeWoApwH=KgKuiU9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org
To: Prashant Shah <pshah.mumbai@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35533 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757050Ab2JIVtR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Oct 2012 17:49:17 -0400
Content-Disposition: inline
In-Reply-To: <CAD6i1fKpWZVbL4gS1ui7GvF81S+SAduckXeWoApwH=KgKuiU9g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 08-10-12 22:05:38, Prashant Shah wrote:
> Hi,
> 
> On Mon, Oct 8, 2012 at 9:49 PM, Jan Kara <jack@suse.cz> wrote:
> >   And what tool are you using for monitoring?
> 
> I am using printk(). A custom module that changes the make_request_fn
> of the block device to a custom callback. In the callback I am
> printing the request bio details and passing the bio back to the
> original make_request_fn.
  OK. There are several ways how I could imagine you hit ino == 0. Either
someone is using direct IO or inode is a block device inode...

								Honza
