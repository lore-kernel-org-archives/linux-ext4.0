From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] ext4: speed up _require_ext4_bigalloc and
 _require_ext4_mkfs_bigalloc
Date: Mon, 8 Sep 2014 19:50:00 +1000
Message-ID: <20140908095000.GD30012@dastard>
References: <20140907192110.GC1066@thunk.org>
 <1410141968-17551-1-git-send-email-tytso@mit.edu>
 <1410141968-17551-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, hch@infradead.org,
	linux-ext4@vger.kernel.org, wangxg.fnst@cn.fujitsu.com,
	eguan@redhat.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:32339 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752981AbaIHJuP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2014 05:50:15 -0400
Content-Disposition: inline
In-Reply-To: <1410141968-17551-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 07, 2014 at 10:06:08PM -0400, Theodore Ts'o wrote:
> We don't need to make a full-sized file system in order to test
> whether "mkfs.ext4 -O bigalloc" works.

Why wouldn't you just use the "-n" option? If bigalloc is not
supported, that should still fail, right?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
