From: Girish Shilamkar <Girish.Shilamkar@Sun.COM>
Subject: Re: e2fsprogs segfaults during make check
Date: Mon, 08 Feb 2010 19:50:17 +0530
Message-ID: <1265638817.3882.31.camel@metis>
References: <1265614286.3882.16.camel@metis> <20100208121619.GF4494@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: Ext4 <linux-ext4@vger.kernel.org>, adilger@Sun.COM
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-1.sun.com ([192.18.19.6]:62729 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab0BHOTq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Feb 2010 09:19:46 -0500
Received: from fe-apac-06.sun.com (fe-apac-06.sun.com [192.18.19.177] (may be forged))
	by sineb-mail-1.sun.com (8.13.6+Sun/8.12.9) with ESMTP id o18EJS9u029216
	for <linux-ext4@vger.kernel.org>; Mon, 8 Feb 2010 14:19:41 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KXJ00H0011MP000@mail-apac.sun.com> for linux-ext4@vger.kernel.org; Mon,
 08 Feb 2010 22:19:28 +0800 (SGT)
In-reply-to: <20100208121619.GF4494@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2010-02-08 at 07:16 -0500, tytso@mit.edu wrote:
> Well, I run "make check" all the time during the course of my
> development, so it must be something unique with RHEL5.
That is the surprising part, no other distros had problem. Even
rhel5/i686 passes all the tests.

> #1) Does it show up if you just unpack a source tree, and do a
>  "configure; make; make check" run in RHEL 5?
No, it doesn't show up. Problem appears when it is configured with 
--enable-elf-shlibs !!

> #2)  In the build directory, cd to tests, and then run the command:
> 
>    (. $(srcdir)/tests/test_config; debugfs)
> 
> .. and see if you get a core dump.  (Replace $(srcdir) with the top
> level source tree directory.  If you are building in the source tree,
> you can just do "(. test_config ; debugfs)"; if you are building with
> the build directory located in a "build" subdirectory under the source
> tree, you could do "(. ../tests/test_config ; debugfs)", etc.
> 
> If you do get a core dump, run it under gdb and get a stack trace,
> and/or see if anything is showing up in stderr that might be help
> explain what's going on.
Tried that before but there were no segfaults seen.

> #3) Try downloading:
> 
>     http://master.kernel.org/~tytso/e2fsprogs_1.41.10-rc1.tar.gz
> 
> ... and see if you can see the problem there.
The problem is not seen for this version. Any tentative dates for 1.41.10 release ?

Thanks,
Girish


