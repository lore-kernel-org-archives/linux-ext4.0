From: Ron Yorston <rmy@tigress.co.uk>
Subject: Re: zero out blocks of freed user data for operation a virtual
 machine environment
Date: Mon, 25 May 2009 08:48:37 +0100
Message-ID: <200905250748.n4P7mbQS024844@tiffany.internal.tigress.co.uk>
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: tytso@thunk.org, thomas@glanzmann.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.tigress.co.uk ([195.172.168.163]:35049 "EHLO
	intgat.tigress.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbZEYIFT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 May 2009 04:05:19 -0400
In-Reply-To: <20090524170045.GC24753@cip.informatik.uni-erlangen.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've written a tool to zero freed blocks in ext2/ext3 filesystems, as well
as a (half-baked) kernel patch.  Details here:

   http://intgat.tigress.co.uk/rmy/uml/sparsify.html

Ron
