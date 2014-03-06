From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/8] xfstests: Create single function for testing
 xfs_io commands
Date: Thu, 6 Mar 2014 09:44:20 -0800
Message-ID: <20140306174420.GA28297@infradead.org>
References: <1394034699-21187-1-git-send-email-lczerner@redhat.com>
 <1394034699-21187-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36946 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaCFRoU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Mar 2014 12:44:20 -0500
Content-Disposition: inline
In-Reply-To: <1394034699-21187-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 05, 2014 at 04:51:32PM +0100, Lukas Czerner wrote:
> Currently there are several function testing various xfs_io commands.
> This commit creates _require_xfs_io_command() to test any xfs_command.

Looks good.  Do you plan to keep the wrappers around
_require_xfs_io_command in the long run or just for a transitional
period?

Reviewed-by: Christoph Hellwig <hch@lst.de>
