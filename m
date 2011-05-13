From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Regression with ext4 in kernel 2.6.39-rc7? (Was: testing ext4
 master branch)
Date: Fri, 13 May 2011 10:25:18 -0500
Message-ID: <4DCD4D5E.6050307@redhat.com>
References: <BANLkTikW57S9emEFG9w9RXvq5O7v_MrsYw@mail.gmail.com> <20110513145608.GA21165@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Amir Goldstein <amir73il@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab1EMPZZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 May 2011 11:25:25 -0400
In-Reply-To: <20110513145608.GA21165@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/13/11 9:56 AM, Ted Ts'o wrote:
> On Fri, May 13, 2011 at 12:17:03PM +0300, Amir Goldstein wrote:
>>
>> Can anyone try to reproduce the error with xfstest 005 and the crash
>> with xfstest 232?
> 
> Xfstest #5 broke because of a change in the VFS, which now allows up
> to 40 nested symlinks.  So that's a matter of your xfstests being too
> old.
> 
> The version of xfstests I've been using on my KVM box is too old to
> have test 232, so I haven't been able to test it.  I've been trying to
> use a newer version of xfstests, but xfstests doesn't build on either
> Ubuntu 10.04 (LTS), Debian stable, or Debian unstable, due to the use
> of newer XFS ioctl's and xfsctl's that aren't defined in the system
> header files.  The fact that it doesn't work on Ubuntu LTS and Stable
> is not that surprising, I suppose, but I was a bit disappointed that
> it doesn't work on Debian unstable.

I missed that bug report :)  If you can send me the details of the
failures we can probably add configure tests for any new ioctls
that are causing build failures.

> Since I don't have a Fedora system handy --- which header file are
> things like "struct xfs_flock64" supposed to be defined these days?

Hm, well, on my Fedora system, /usr/include/xfs/xfs_fs.h, from xfsprogs-devel.

I don't think that has changed in a very long time...

I also package an xfsprogs-qa-devel which has some additional pieces in
it to support xfstests.  Debian could do the same ... "make install-qa"
in xfsprogs puts those bits into the root.

-Eric

>        	    	    		 	     - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

