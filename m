From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: remove bashism in lib/blkid/test_probe.in
Date: Sun, 25 May 2008 20:27:23 -0400
Message-ID: <20080526002723.GH5970@mit.edu>
References: <alpine.DEB.1.10.0805251750250.4890@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:34666 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751562AbYEZA1l (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 May 2008 20:27:41 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0805251750250.4890@sheep.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 25, 2008 at 06:00:06PM +0200, Christian Kujau wrote:
> while running "make check" on a current e2fsprogs.pu git tree fails with:
>
> [: 1: ==: unexpected operator
> + [ cramfs == swap1 ]

Thanks, fixed.  I've updated the git repository to deal with the
problems you reported.

						- Ted
