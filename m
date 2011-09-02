From: Ted Ts'o <tytso@mit.edu>
Subject: Re: e2fsck sigcatcher breaks valgrind
Date: Fri, 2 Sep 2011 14:28:58 -0400
Message-ID: <20110902182858.GE4110@thunk.org>
References: <A1043F1C-DAAD-4FAB-B8F4-82AB00E21DEF@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>,
	linux-ext4 List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43932 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571Ab1IBS3C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Sep 2011 14:29:02 -0400
Content-Disposition: inline
In-Reply-To: <A1043F1C-DAAD-4FAB-B8F4-82AB00E21DEF@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 02, 2011 at 11:38:09AM -0600, Andreas Dilger wrote:
> I was reading Eric's recent commit message in "next" about how he used
> e2fsprogs "./test_script --valgrind" to find the uninitialized memory and
> thought I would try it myself.  To my dismay it was failing on my system with:
> 
> ==2806==    at 0x3566A0F5BE: __libc_sigaction (in /lib64/libpthread-2.12.2.so)
> ==2806==    by 0x4321A3: sigcatcher_setup (sigcatcher.c:224)
> ==2806==    by 0x40F4DE: main (unix.c:1027)
> ==2806==  Address 0x7fefffe18 is on thread 1's stack
> ==2806==
> ==2806== Syscall param rt_sigaction(act->sa_mask) points to uninitialised byte(s)
> 
> After a bunch of testing as to why this system was not working correctly,
> it turns out that the problem is in the later commit 9b3018a82e843d.
> Reverting that commit fixes the problem and allows --valgrind tests to pass.

Oops, thanks for the bug report, I'll fix it.

For context, the reason why I added this was I had a nearly impossible
to debug crash in e2fsck that happened extremely rarely, and only in
my virtualized xfstests environment.  I found the bug and fixed it in
commit a4aff9ca5.

> 
> I also noticed (for Lukas), "./test_script --valgrind i_e2image" fails with:
> 
> i_e2image: Create/convert raw and qcow2 disk images: ./i_e2image/script: line 2: test: too many arguments
> 
> That is due to:
> 
>    if test -x $E2IMAGE; then
> 
> expanding to:
> 
>    if test -x valgrind -q --sim-hints=lax-ioctls ../misc/e2image; then

Thanks, I'll look at fixing this as well.

	     	     	    	 - Ted
