From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v2] ext4: speed up _require_ext4_bigalloc and
 _require_ext4_mkfs_bigalloc
Date: Mon, 8 Sep 2014 08:39:41 -0400
Message-ID: <20140908123941.GH1066@thunk.org>
References: <20140908120213.GF1066@thunk.org>
 <1410178541-15192-1-git-send-email-tytso@mit.edu>
 <20140908123602.GL30012@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43502 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675AbaIHMjp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Sep 2014 08:39:45 -0400
Content-Disposition: inline
In-Reply-To: <20140908123602.GL30012@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2014 at 10:36:02PM +1000, Dave Chinner wrote:
> On Mon, Sep 08, 2014 at 08:15:41AM -0400, Theodore Ts'o wrote:
> > We don't need to make a full-sized file system in order to test
> > whether "mkfs.ext4 -O bigalloc" works.
> > 
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> Got it - thanks for the quick turnaround.

You're not going to apply this one until I send out the rebased
version of the 1/2 version of this patch series, right?  Because this
one depends on MKFS_EXT4_PROG...

					- Ted
