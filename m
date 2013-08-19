From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Which features should I implement in my ext4 reader?
Date: Mon, 19 Aug 2013 10:03:21 -0400
Message-ID: <20130819140321.GA21453@thunk.org>
References: <CACyNnZNJssSL+UWOXYmWk9xy07WRT_z+Fk9Kjwfws9JRfWoNEQ@mail.gmail.com>
 <CACyNnZManY_k3SB1-p4mQ8Z1+9B=VAdfXU7bWsFVHDsHV6KyUQ@mail.gmail.com>
 <20130817130204.GA30769@thunk.org>
 <CACyNnZONOUy0+OeDriZaSt4OQrR6LzpyJz4Sj8XvMHvxr2u_Xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45692 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033Ab3HSODY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Aug 2013 10:03:24 -0400
Content-Disposition: inline
In-Reply-To: <CACyNnZONOUy0+OeDriZaSt4OQrR6LzpyJz4Sj8XvMHvxr2u_Xg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 18, 2013 at 08:04:20AM +0200, Felipe Monteiro de Carvalho wrote:
> > These features aren't quite fully supported yet.  The inline data
> > feature is probably closest to be being fully supported, when we
> > release an the next major version of e2fsprogs.
> 
> Just for completeness, which version number will that by?

When we release 1.43.x.  We are currently releasing maintenance
releases on 1.42.x, tracked on the maint branch.  What will eventually
become e2fsprogs 1.43.x is on the master branch in the git tree.  (As
well as the next and pu -- proposed updates -- branches, which are
supersets of the master branch.)

> So, I understand that currently mkfs.ext4 cannot generate ext4 file
> systems with this feature, correct?

Well, if you are building with the e2fsprogs with the pu branch, it
will work.  This is a rewinding branch, so for example, when I process
Zheng's latest set of changes, the pu branch will get rewound and the
new patches applied.

BTW, for any new ABI's exported via libext2fs, there is no guarantee
of stability until 1.43.x gets released.  If we find ABI
incompatibilities for old interfaces in between 1.43.x and 1.42.x on
the master branch, that is a bug that we will fix.

> Is there any other way to generate a file system with this feature
> with a 3.8 kernel which will work?
> 
> Just wondering if I can already start work on this or if I need to wait.

It should be sufficient to use debugfs to manually set the inline_data
feature.  However, you won't be able to run e2fsck on the file system
after you do that.  So using the pu branch is probably your best bet.

The git tree can be found here:

    git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git

Regards,

						- Ted
