From: Alex Elder <aelder@sgi.com>
Subject: Re: [PATCH] xfstests: Assume yes when test device is not
 partitioned
Date: Thu, 22 Sep 2011 17:02:49 -0500
Message-ID: <1316728969.2009.95.camel@doink>
References: <1315038799-2150-1-git-send-email-prasadjoshi.linux@gmail.com>
	 <1316726084.2009.85.camel@doink>
Reply-To: <aelder@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>,
	Chaitanya Kulkarni <chaitanyakulkarni15@gmail.com>,
	<xfs@oss.sgi.com>
To: Prasad Joshi <prasadjoshi.linux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:40917 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753955Ab1IVWCy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Sep 2011 18:02:54 -0400
In-Reply-To: <1316726084.2009.85.camel@doink>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2011-09-22 at 16:14 -0500, Alex Elder wrote:
> On Sat, 2011-09-03 at 14:03 +0530, Prasad Joshi wrote:
> > If an entire device used for file system creation, the mkfs.ext2/3/4
> > asks for confirmation before proceeding. Since the device is
> > configured for testing it is safe to assume positive response
> > during mkfs.
> > 
> > The patch also replaces hard coded mkfs path with MKFS_PROG variable.
> > 
> > Signed-off-by: Chaitanya Kulkarni <chaitanyakulkarni15@gmail.com>
> > Signed-off-by: Prasad Joshi <prasadjoshi.linux@gmail.com>
> 
> Thanks for submitting a patch, Prasad (and Chaitanya).
> 
> Can you please re-submit this?  Based on feedback what
> we're looking for would be:
> [PATCH 0/2] description e-mail
> [PATCH 1/2] patch that substitutes /sbin/mkfs with ${MKFS_PROG}
> [PATCH 2/2] patch that adds a '-f' flag to ${MKFS_PROG}.${FSTYP}
>             for all ext* filesystem types.


Oh, and while I'm thinking about it...

/sbin/mkfs.${FSTYP} and ${MKFS_PROG}.${FSTYP} are most likely
incorrect.  The switch to MKFS_PROG at least finds where the
mkfs executable lies, but in theory anyway there is no guarantee
that, for example, the mkfs.xfs program lies in the same directory.
The mkfs executable uses the PATH (via execvp()) to find the
filesystem-specific mkfs program to use, and I expect we should
work the same way.

					-Alex



