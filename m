From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Reproducible block structure
Date: Tue, 10 Dec 2013 08:42:55 -0500
Message-ID: <20131210134255.GA31214@thunk.org>
References: <CAO_9QQcOSgUA84ewb=PANikU+MzeTmmeHnPeLd2SHQ_46sUi8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jitesh Shah <jitesh.1337@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38593 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab3LJNnB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Dec 2013 08:43:01 -0500
Content-Disposition: inline
In-Reply-To: <CAO_9QQcOSgUA84ewb=PANikU+MzeTmmeHnPeLd2SHQ_46sUi8Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 09, 2013 at 09:03:23PM -0800, Jitesh Shah wrote:
> 
> Now, if the script is ran in the SAME way for all 5 HDDs, is it
> guaranteed that these HDDs will be same at the block level too? (i.e.
> block allocation/deallocation will follow the same pattern). Assume
> single-core system with only one process modifying the HDD in
> predetermined order.

Nope, there's no way to guarantee this.  There are a few places where
the algorithms are non-deterministic by design.  It would be possible
to make some changes to guarantee this, but I'm not sure it's really
worth it --- in real life, assuming a single core system with a single
process which is also single threaded is generally not a realisstic
scenario.

> Why do I ask -> I am tinkering with the idea of block level
> verification of images. If the above guarantees can be provided, I can
> easily hash the raw HDD for verification purposes.

If you want to do a block level verification of the image, why not
also do block level update of the image as well?

Regards,

						- Ted
