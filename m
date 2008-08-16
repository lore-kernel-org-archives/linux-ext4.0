From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs : Fix memory leaks in ext2fs_extent_open()
Date: Sat, 16 Aug 2008 10:52:47 -0400
Message-ID: <20080816145247.GA12978@mit.edu>
References: <ea11fea30808151356g49cc399fna2457d8902926e97@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:52036 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751660AbYHPPDW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Aug 2008 11:03:22 -0400
Content-Disposition: inline
In-Reply-To: <ea11fea30808151356g49cc399fna2457d8902926e97@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 16, 2008 at 02:26:43AM +0530, Manish Katiyar wrote:
> Memory allocated for the ext2_extent_handle is not getting freed from
> all the return paths in case of error. Below patch fixes it.
> 
> Signed-off-by: "Manish Katiyar" <mkatiyar@gmail.com>

Thanks, applied.

					- Ted
