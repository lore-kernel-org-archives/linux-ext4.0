From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v2] overlay: stress test changes to top and bottom
 layers simultaneously
Date: Wed, 11 Jan 2017 22:54:00 -0500
Message-ID: <20170112035400.zwq5sypdhv66llwy@thunk.org>
References: <20170112034938.5934-1-tytso@mit.edu>
 <20170112034938.5934-3-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux@sciencehorizons.net
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37376 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752423AbdALDyC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 11 Jan 2017 22:54:02 -0500
Content-Disposition: inline
In-Reply-To: <20170112034938.5934-3-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 11, 2017 at 10:49:35PM -0500, Theodore Ts'o wrote:
> Introduce a test which runs fsstress on the top and bottom overlayfs
> directories simultaneously to find potential races that plagued wrapfs
> derived file systems.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

sigh, please ignore this patch.  I had some trash left over in the
directory I use to send out pathces.

				- Ted
