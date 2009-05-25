From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: zero out blocks of freed user data for operation a virtual
	machine environment
Date: Mon, 25 May 2009 12:50:36 +0200
Message-ID: <20090525105036.GA27604@cip.informatik.uni-erlangen.de>
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de> <200905250748.n4P7mbQS024844@tiffany.internal.tigress.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@thunk.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Ron Yorston <rmy@tigress.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:49835 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752816AbZEYKug (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 May 2009 06:50:36 -0400
Content-Disposition: inline
In-Reply-To: <200905250748.n4P7mbQS024844@tiffany.internal.tigress.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Ron,

* Ron Yorston <rmy@tigress.co.uk> [090525 09:49]:
> I've written a tool to zero freed blocks in ext2/ext3 filesystems, as well
> as a (half-baked) kernel patch.  Details here:

>    http://intgat.tigress.co.uk/rmy/uml/sparsify.html

nice work! While talking about sparse files: Do you know if there is an
option for qcow2 to reclaim zeroed out blocks (like a sparse in
userland)? I hope that this functionality hits upstream. It could also
used to provide a secure file deletion.

        Thomas
