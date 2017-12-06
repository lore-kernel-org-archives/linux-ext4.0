From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2p: fix getflags for link file
Date: Tue, 5 Dec 2017 21:44:00 -0500
Message-ID: <20171206024400.u5umqlwknjow4zuy@thunk.org>
References: <1512395795-10022-1-git-send-email-wshilong1991@gmail.com>
 <20171205161010.2q2owkepbk6zg2hp@thunk.org>
 <CAP9B-Q=ady2ni+YRaQwFQuWtmJBmN0FKj7wSpv0-5vzTZEthkw@mail.gmail.com>
 <CAP9B-Qnu=SrKx60q7B1Wyzd_a_Po-vX3Ah_avTnFudZO2PsAyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Shuichi Ihara <sihara@ddn.com>, Wang Shilong <wshilong@ddn.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39150 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754516AbdLFCoD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 5 Dec 2017 21:44:03 -0500
Content-Disposition: inline
In-Reply-To: <CAP9B-Qnu=SrKx60q7B1Wyzd_a_Po-vX3Ah_avTnFudZO2PsAyw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 06, 2017 at 09:19:26AM +0800, Wang Shilong wrote:
> > But this is one of our customers feedback, this is not good that
> > lsattr/chattr did not support symlink, we might need make it
> > clear, for example, we support symlink, but it always follow
> > original files, that is even better than output errors.

What is the basis of the customer's complaint?  I could imagine
printing a more explanatory message.  So instead of:

lsattr: Operation not supported While reading flags on /foo/bar/baz

maybe:

/foo/bar/baz: file attributes not supported for symlinks

It's not clear to me at all that following symlinks is the right
thing.

> >
> > In this way, we need fix chattr too.
> 
> Just to think more, there is a problem to follow symlink for chattr:
> consider following case that users want to use directory quota:
> 
> dir1/dir1.1         --->project ID is 1
> dir2/dir2.link.1.1 ----->dir2's Project ID is 2, link file to dir1.1
> 
> Considering if users do something like:
> #chattr -p 1 -R dir1
> #chattr -p 2 -R dir2/
> 
> This will break some users expected behavior, since dir1.1
> will be set to project ID 2 which expected as 1.
> 
> So i supposed we should disallow follow symlink for chattr?

... and this is why I don't think we should change the behavior for
lsattr *or* chattr.

I could imagine adding an option which causes lsattr and chattr to
follow symlinks (but in the absense of the option, lsattr and chattr
will do what it does today, which is not follow symlinks, possibly
with a friendly error message), or maybe which causes lsattr to print
something like this:

--------------e---- /usr/bin/emacsclient.emacs24
   <symlink>        /usr/bin/emacs -> /etc/alternatives/emacs

... but honestly, is it really worth it?

					- Ted
