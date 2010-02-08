From: tytso@mit.edu
Subject: Re: e2fsprogs segfaults during make check
Date: Mon, 8 Feb 2010 07:16:19 -0500
Message-ID: <20100208121619.GF4494@thunk.org>
References: <1265614286.3882.16.camel@metis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 <linux-ext4@vger.kernel.org>, adilger@Sun.COM
To: Girish Shilamkar <Girish.Shilamkar@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33638 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab0BHMQX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Feb 2010 07:16:23 -0500
Content-Disposition: inline
In-Reply-To: <1265614286.3882.16.camel@metis>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 08, 2010 at 01:01:26PM +0530, Girish Shilamkar wrote:
> Hello,
>      I found a problem while creating e2fsprogs rpms. Few of the tests
> fail with segfault during make check. The tests are d_loaddump, f_dup4,
> f_imagic_fs and r_resize_inode. This failure is only seen on rhel5,
> x86_64. 
>       On further searching I found that this error can reproduced when
> e2fsprogs is configured with shared elf libraries. For example,
> configure --enable-elf-shlibs, make; make check 
> And this problem is seen from 1.41.7 version onwards.
> 
> Any ideas/comments ?

Well, I run "make check" all the time during the course of my
development, so it must be something unique with RHEL5.

#1) Does it show up if you just unpack a source tree, and do a
 "configure; make; make check" run in RHEL 5?

#2)  In the build directory, cd to tests, and then run the command:

   (. $(srcdir)/tests/test_config; debugfs)

.. and see if you get a core dump.  (Replace $(srcdir) with the top
level source tree directory.  If you are building in the source tree,
you can just do "(. test_config ; debugfs)"; if you are building with
the build directory located in a "build" subdirectory under the source
tree, you could do "(. ../tests/test_config ; debugfs)", etc.

If you do get a core dump, run it under gdb and get a stack trace,
and/or see if anything is showing up in stderr that might be help
explain what's going on.

#3) Try downloading:

    http://master.kernel.org/~tytso/e2fsprogs_1.41.10-rc1.tar.gz

... and see if you can see the problem there.

Thanks,

					- Ted
