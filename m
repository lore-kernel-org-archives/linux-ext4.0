From: Andreas Dilger <adilger@sun.com>
Subject: Re: Do we need dump for ext4?
Date: Thu, 28 Aug 2008 17:14:06 -0600
Message-ID: <20080828231406.GT3392@webber.adilger.int>
References: <48B6BD02.3080307@redhat.com> <20080828184804.GN26987@mit.edu>
 <48B6F69C.3090700@redhat.com> <20080828200448.GQ3392@webber.adilger.int>
 <20080828203553.GB10082@mit.edu> <20080828222348.GS3392@webber.adilger.int>
 <20080828223454.GD10082@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:50405 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbYH1XOZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 19:14:25 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7SNENp4021916
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 16:14:24 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K6C00A012GV2600@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 28 Aug 2008 16:14:23 -0700 (PDT)
In-reply-to: <20080828223454.GD10082@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 28, 2008  18:34 -0400, Theodore Ts'o wrote:
> It's fine, because according to POSIX it's undefined what happens to
> files that are created or deleted after the last opendir() or
> rewindir().  So basically, the b-tree is attached to the opendir, and
> we discard it and re-create it if we ever seek to the beginning of the
> directory.

... presumably only if the directory has been modified in the meantime?
It seems like this is missing from the ext3_dx_readdir() code, and could
be easily achieved by checking inode->i_version vs. filp->f_version or
similar.  It looks like this is checked later on, but by that time we've
already discarded everything.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

