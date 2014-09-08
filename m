From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: speed up _require_ext4_bigalloc and
 _require_ext4_mkfs_bigalloc
Date: Mon, 8 Sep 2014 08:02:13 -0400
Message-ID: <20140908120213.GF1066@thunk.org>
References: <20140907192110.GC1066@thunk.org>
 <1410141968-17551-1-git-send-email-tytso@mit.edu>
 <1410141968-17551-2-git-send-email-tytso@mit.edu>
 <20140908095000.GD30012@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, hch@infradead.org,
	linux-ext4@vger.kernel.org, wangxg.fnst@cn.fujitsu.com,
	eguan@redhat.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43424 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbaIHMCr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Sep 2014 08:02:47 -0400
Content-Disposition: inline
In-Reply-To: <20140908095000.GD30012@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2014 at 07:50:00PM +1000, Dave Chinner wrote:
> On Sun, Sep 07, 2014 at 10:06:08PM -0400, Theodore Ts'o wrote:
> > We don't need to make a full-sized file system in order to test
> > whether "mkfs.ext4 -O bigalloc" works.
> 
> Why wouldn't you just use the "-n" option? If bigalloc is not
> supported, that should still fail, right?

Good point.  We still need to make the file system for
_require_ext4_bigalloc, but there's no need to create one for
_require_ext4_mkfs_bigalloc.

					- Ted
