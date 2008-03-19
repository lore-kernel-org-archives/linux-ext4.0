From: Andreas Dilger <adilger@Sun.COM>
Subject: Re: [E2FSPROGS, RFC] New mke2fs types parsing
Date: Wed, 19 Mar 2008 11:36:55 +0800
Message-ID: <20080319033655.GG2971@webber.adilger.int>
References: <E1JRpaN-0000Bs-4N@closure.thunk.org> <47BC76A9.307@redhat.com>
 <20080220222019.GG30305@mit.edu> <47DEE2AE.1050105@redhat.com>
 <20080318022053.GL8368@mit.edu> <47DF35CC.7020604@redhat.com>
 <20080318042339.GO8368@mit.edu> <47DF5045.1000108@redhat.com>
 <20080318110145.GQ8368@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:52846 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbYCSTYz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Mar 2008 15:24:55 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2J3bDip010388
	for <linux-ext4@vger.kernel.org>; Tue, 18 Mar 2008 20:37:13 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JXY00K01KNNR500@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 18 Mar 2008 20:37:13 -0700 (PDT)
In-reply-to: <20080318110145.GQ8368@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 18, 2008  07:01 -0400, Theodore Ts'o wrote:
> If this is too confusing, one of the things which we *could* do is
> decouple the filesystem size from everything else.  "mke2fs -t" is a
> deprecated alias for "mke2fs -c".  We could make "/sbin/mkfs.ext4"
> equivalent to "mke2fs -t ext4".  Then we don't have to explain how
> the filesystem type handling prepends onto the -T arguments.

Note that "-t" is not listed in the mke2fs man page, but it is
still listed in the mke2fs -h usage line:

Usage: mke2fs [-c|-t|-l filename] [-b block-size] [-f fragment-size]
        [-i bytes-per-inode] [-I inode-size] [-j] [-J journal-options]
        [-N number-of-inodes] [-m reserved-blocks-percentage] [-o creator-os]
        [-g blocks-per-group] [-L volume-label] [-M last-mounted-directory]
        [-O feature[,...]] [-r fs-revision] [-E extended-option[,...]] [-qvSV]
        device [blocks-count]

> I rejected this approach originally because it would mean reusing the
> -t option right away.  But maybe this would be easier for users to
> understand, and easier to document in the man pages, and maybe that's
> an overriding consideration.

How long ago was it deprecated, and are there major distros that still
document/use this feature?  I suppose if the old code would fail with
any textual input (as used by new types), and the new code either
fails when no argument is given then it should be fairly clear if the
user has a conflicting usage.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

