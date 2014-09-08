From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH -v2] ext4: speed up _require_ext4_bigalloc and
 _require_ext4_mkfs_bigalloc
Date: Mon, 8 Sep 2014 22:36:02 +1000
Message-ID: <20140908123602.GL30012@dastard>
References: <20140908120213.GF1066@thunk.org>
 <1410178541-15192-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:6359 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781AbaIHMgQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2014 08:36:16 -0400
Content-Disposition: inline
In-Reply-To: <1410178541-15192-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2014 at 08:15:41AM -0400, Theodore Ts'o wrote:
> We don't need to make a full-sized file system in order to test
> whether "mkfs.ext4 -O bigalloc" works.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Got it - thanks for the quick turnaround.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
