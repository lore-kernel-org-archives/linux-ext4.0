From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 01/28] libext2fs: support modifying arbitrary extended
 attributes
Date: Wed, 4 Dec 2013 09:53:43 -0500
Message-ID: <20131204145343.GC17008@thunk.org>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
 <1386072715-9869-2-git-send-email-wenqing.lz@taobao.com>
 <20131203195457.GD9535@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36515 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254Ab3LDOxt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Dec 2013 09:53:49 -0500
Content-Disposition: inline
In-Reply-To: <20131203195457.GD9535@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 03, 2013 at 11:54:57AM -0800, Darrick J. Wong wrote:
> Ok, so inline_data implies ext_attr.  I think we should change the test to
> check for either feature flag, because with no test, we could accidentally
> read/write EAs on a FS with ^ext_attr,^inline_data.  Or maybe provide a helper
> predicate to hide those details.
> 
> Also, I'd ask you to send broken out changes to my patches... but I haven't
> posted my monster patchset recently. :)
> 
> (I think I might work up the courage to patchbomb the mailing list tonight.)

Zheng's patchset includes some of your patches.  Does it include all
of them?  If you are going to patchbomb the mailing list, do you have
any suggestions for the best way for me to figure out which patches
I should take from him and which from you?

Thanks,

					- Ted
