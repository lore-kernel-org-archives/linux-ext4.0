From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4/fsync.c: functions should not be declared extern
Date: Tue, 11 Oct 2011 23:09:50 -0400
Message-ID: <20111012030950.GE11548@thunk.org>
References: <201109231514.02174.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
To: H Hartley Sweeten <hartleys@visionengravers.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60004 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab1JLDJw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Oct 2011 23:09:52 -0400
Content-Disposition: inline
In-Reply-To: <201109231514.02174.hartleys@visionengravers.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 23, 2011 at 03:14:01PM -0700, H Hartley Sweeten wrote:
> The function declaration in ext4.h is already marked extern.  The function
> definition should not have the tag.
> 
> This quiets the sparse noise:
> 
> warning: function 'ext4_flush_completed_IO' with external linkage has definition
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>

Thanks, applied.

						- Ted
