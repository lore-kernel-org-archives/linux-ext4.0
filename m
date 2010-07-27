From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH][BUG] ext4: fix returning with 0 from write system call
 on ext4 with noextent
Date: Tue, 27 Jul 2010 09:53:12 -0400
Message-ID: <20100727135312.GE18966@thunk.org>
References: <20100726111636.72264f8c.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@sun.com, linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:60279 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018Ab0G0NxN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jul 2010 09:53:13 -0400
Content-Disposition: inline
In-Reply-To: <20100726111636.72264f8c.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, I've applied this patch, although I edited patch description
to make it be a bit more succint.

				- Ted
