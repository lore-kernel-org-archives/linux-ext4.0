From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: skip project quota tests if the kernel does not
 support them
Date: Mon, 9 Oct 2017 08:42:12 +1100
Message-ID: <20171008214212.GV15067@dastard>
References: <20171008192746.20709-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:34217 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751510AbdJHVmR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 8 Oct 2017 17:42:17 -0400
Content-Disposition: inline
In-Reply-To: <20171008192746.20709-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 08, 2017 at 03:27:46PM -0400, Theodore Ts'o wrote:
> In _scratch_enable_pquota, use _notrun if the file system with project
> quotas enable can't be mounted, since that indicates the kernel
> doesn't support that feature.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Looks fine.

Acked-by: Dave Chinner <dchinner@redhat.com>

-Dave
-- 
Dave Chinner
david@fromorbit.com
