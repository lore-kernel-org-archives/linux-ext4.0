From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ext4: fix suboptimal seek_{data,hole} extents
 traversial
Date: Wed, 17 Dec 2014 21:39:18 -0500
Message-ID: <20141218023918.GC17575@thunk.org>
References: <1417518054-21733-1-git-send-email-dmonakhov@openvz.org>
 <1417518054-21733-4-git-send-email-dmonakhov@openvz.org>
 <20141211200540.GE31008@thunk.org>
 <878uidgshe.fsf@openvz.org>
 <20141217035713.GW17575@thunk.org>
 <87y4q6joy4.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33541 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbaLRCjW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Dec 2014 21:39:22 -0500
Content-Disposition: inline
In-Reply-To: <87y4q6joy4.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 17, 2014 at 06:06:27PM +0300, Dmitry Monakhov wrote:
> FYI: Currently test failed only on EXT4 w/o extents but w/ -odelalloc enabled.
> This configuration is absent in xfstest-bld where conf/ext3 is EXT4 w/o
> extents and w/ nodelalloc. That is why we oversee this from very beginning.

Hmm..  I definitely found this because it was failing with the
conf/ext3 configuration for me....

						- Ted
