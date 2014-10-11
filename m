From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: misc: fix build without magic.h
Date: Sat, 11 Oct 2014 19:32:31 -0400
Message-ID: <20141011233231.GA24257@thunk.org>
References: <CABz95_A18aY0VkamhuoZ-ziAVf2mzs6vsCmxbUyVVxDet49++A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Steven Honeyman <stevenhoneyman@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48021 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbaJKXcg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Oct 2014 19:32:36 -0400
Content-Disposition: inline
In-Reply-To: <CABz95_A18aY0VkamhuoZ-ziAVf2mzs6vsCmxbUyVVxDet49++A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 09, 2014 at 10:39:22PM +0100, Steven Honeyman wrote:
> This prevents a failed build if magic.h doesn't exist, because type
> magic_t will be unknown.
> 
> Fixes: d2e3c0dc60cd ("misc: if dlopen() is available, use it to load
> the libmagic library")
> Signed-off-by: Steven Honeyman <stevenhoneyman@gmail.com>

Apologies, this was fixed in my tree earlier, but I had failed to push
this out to the public git tree.  Fixed now.

							- Ted
