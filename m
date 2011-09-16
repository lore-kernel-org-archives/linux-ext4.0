From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/25] libext2: Fix EXT2_LIB_SOFTSUPP masking
Date: Fri, 16 Sep 2011 18:52:27 -0400
Message-ID: <20110916225227.GD16246@thunk.org>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
 <1316206180-6375-2-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47619 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265Ab1IPWw3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 18:52:29 -0400
Content-Disposition: inline
In-Reply-To: <1316206180-6375-2-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 03:49:16PM -0500, Eric Sandeen wrote:
> EXT2_LIB_SOFTSUPP_INCOMPAT_* are supposed to be bitmasks
> of features which can be opened even though they are
> under development.  The intent is that these are masked
> out of the features list, so that they will be ignored
> on open.
> 
> However, the code does a logical not vs. a bitwise not:
> 
> 	features &= !EXT2_LIB_SOFTSUPP_INCOMPAT;
> 
> which will not have the desired effect...
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

						- Ted
