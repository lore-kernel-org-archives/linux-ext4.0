From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] vfs: don't let the dirty time inodes get more than a
 day stale
Date: Tue, 25 Nov 2014 12:53:32 +1100
Message-ID: <20141125015332.GE27262@dastard>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
 <1416599964-21892-4-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:13164 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791AbaKYBxe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Nov 2014 20:53:34 -0500
Content-Disposition: inline
In-Reply-To: <1416599964-21892-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 21, 2014 at 02:59:23PM -0500, Theodore Ts'o wrote:
> Guarantee that the on-disk timestamps will be no more than 24 hours
> stale.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

If we put these inodes on the dirty inode list with at writeback
time of 24 hours, this is completely unnecessary.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
