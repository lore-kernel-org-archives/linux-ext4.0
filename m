From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] blkid: recognize ext3 with test_fs set as ext3
Date: Sat, 18 Oct 2008 17:20:13 -0400
Message-ID: <20081018212013.GA2116@mit.edu>
References: <48F4D673.8020202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:45767 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750923AbYJRVUQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Oct 2008 17:20:16 -0400
Content-Disposition: inline
In-Reply-To: <48F4D673.8020202@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 14, 2008 at 12:27:15PM -0500, Eric Sandeen wrote:
> It seems that if we have the test_filesystem flag set on an ext3
> filesystem(!) on a system which provides ext4, blkid gets confused.

Thanks, applied.

						- Ted
