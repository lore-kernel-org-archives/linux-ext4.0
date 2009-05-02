From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix for fiemap last-block test
Date: Sat, 2 May 2009 19:08:13 -0400
Message-ID: <20090502230813.GC22191@mit.edu>
References: <49F727A6.8010302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Carl Henrik Lunde <chlunde@ping.uio.no>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34269 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbZEBXIQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 May 2009 19:08:16 -0400
Content-Disposition: inline
In-Reply-To: <49F727A6.8010302@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, I've pulled this into the ext4 patch queue.  While I was
testing this, I found an additional bug in ext4's fiemap handling.
I'll post that fix as a reply to this message.

						- Ted
