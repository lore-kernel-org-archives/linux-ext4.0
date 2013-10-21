From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: add ratelimiting to ext4 messages
Date: Mon, 21 Oct 2013 17:43:46 +0800
Message-ID: <20131021094345.GA2313@gmail.com>
References: <1382059728-29483-1-git-send-email-tytso@mit.edu>
 <526140E8.7000002@redhat.com>
 <20131018185955.GA7557@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:33827 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab3JUJlm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Oct 2013 05:41:42 -0400
Received: by mail-pb0-f43.google.com with SMTP id md4so6736874pbc.16
        for <linux-ext4@vger.kernel.org>; Mon, 21 Oct 2013 02:41:42 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20131018185955.GA7557@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Fri, Oct 18, 2013 at 02:59:55PM -0400, Theodore Ts'o wrote:
> On Fri, Oct 18, 2013 at 09:08:40AM -0500, Eric Sandeen wrote:
> > On 10/17/13 8:28 PM, Theodore Ts'o wrote:
> > > In the case of a storage device that suddenly disappears, or in the
> > > case of significant file system corruption, this can result in a huge
> > > flood of messages being sent to the console.  This can overflow the
> > > file system containing /var/log/messages, or if a serial console is
> > > configured, this can slow down the system so much that a hardware
> > > watchdog can end up triggering forcing a system reboot.
> > 
> > Just out of curiosity, after the fs shuts down, is there still a flood
> > of messages?  Shouldn't that clamp down on the errors?
> 
> Not if we are running with errors=continue.  There are some ugly
> patches in our tree which pipes error notifications to a netlink
> socket, which allows userspace to do something intelligent with
> errors, and because there are some errors where it's safe to continue
> (especially if you are willing to shut down block allocations to the
> block group where you don't trust the allocation bitmap), we tend to
> run with errors=continue.
> 
> I think I mentioned the errors->netlink feature a while back, but
> there wasn't a whole lot of excitement about it, and the patches
> definitely need a lot of cleanup before they would be ready for
> upstream merging.  If people are curious, I can look into getting the
> patches sent out, since we just finished rebasing them to 3.11.

That would be great if you could sent it out.  We are happy to review
and let it go into mainline kernel if it is also useful for others.

Thanks,
                                                - Zheng
