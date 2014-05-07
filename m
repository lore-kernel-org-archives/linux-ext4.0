From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: add a make variable for the pkgconfig install
 dir
Date: Tue, 6 May 2014 23:06:00 -0400
Message-ID: <20140507030600.GC6461@thunk.org>
References: <87tx9ajl7o.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: David Michael <fedora.dm0@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53398 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbaEGDGC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 May 2014 23:06:02 -0400
Content-Disposition: inline
In-Reply-To: <87tx9ajl7o.fsf@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 30, 2014 at 10:18:03PM -0400, David Michael wrote:
> Adding the pkgconfigdir variable allows specifying an installation
> location for pkg-config files independent of libdir.
> 
> Signed-off-by: David Michael <fedora.dm0@gmail.com>

Thanks, applied.

					- Ted
