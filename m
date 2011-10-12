From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4/extents.c: quiet sparse noise about plain integer
 as NULL pointer
Date: Tue, 11 Oct 2011 23:11:20 -0400
Message-ID: <20111012031120.GH11548@thunk.org>
References: <201109231532.44363.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
To: H Hartley Sweeten <hartleys@visionengravers.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60016 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab1JLDLW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Oct 2011 23:11:22 -0400
Content-Disposition: inline
In-Reply-To: <201109231532.44363.hartleys@visionengravers.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 23, 2011 at 03:32:44PM -0700, H Hartley Sweeten wrote:
> The third parameter to ext4_free_blocks is a struct buffer_head *.  This
> parameter should be NULL not 0.
> 
> This quiets the sparse noise:
> 
> warning: Using plain integer as NULL pointer
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>

Thanks, applied.

					- Ted
