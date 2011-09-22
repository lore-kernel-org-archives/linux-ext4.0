From: Alex Elder <aelder@sgi.com>
Subject: Re: [PATCH] xfstests: Assume yes when test device is not
 partitioned
Date: Thu, 22 Sep 2011 16:14:44 -0500
Message-ID: <1316726084.2009.85.camel@doink>
References: <1315038799-2150-1-git-send-email-prasadjoshi.linux@gmail.com>
Reply-To: <aelder@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>,
	Chaitanya Kulkarni <chaitanyakulkarni15@gmail.com>,
	<xfs@oss.sgi.com>
To: Prasad Joshi <prasadjoshi.linux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:46882 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753863Ab1IVVOt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Sep 2011 17:14:49 -0400
In-Reply-To: <1315038799-2150-1-git-send-email-prasadjoshi.linux@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2011-09-03 at 14:03 +0530, Prasad Joshi wrote:
> If an entire device used for file system creation, the mkfs.ext2/3/4
> asks for confirmation before proceeding. Since the device is
> configured for testing it is safe to assume positive response
> during mkfs.
> 
> The patch also replaces hard coded mkfs path with MKFS_PROG variable.
> 
> Signed-off-by: Chaitanya Kulkarni <chaitanyakulkarni15@gmail.com>
> Signed-off-by: Prasad Joshi <prasadjoshi.linux@gmail.com>

Thanks for submitting a patch, Prasad (and Chaitanya).

Can you please re-submit this?  Based on feedback what
we're looking for would be:
[PATCH 0/2] description e-mail
[PATCH 1/2] patch that substitutes /sbin/mkfs with ${MKFS_PROG}
[PATCH 2/2] patch that adds a '-f' flag to ${MKFS_PROG}.${FSTYP}
            for all ext* filesystem types.

Thanks.

					-Alex


