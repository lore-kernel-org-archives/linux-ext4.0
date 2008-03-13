From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH RESEND] e2fsprogs: reprot minimal resize size when
	given size is too small
Date: Thu, 13 Mar 2008 17:56:24 -0400
Message-ID: <20080313215624.GF28728@mit.edu>
References: <20080313174610.GF21187@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:52698 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753264AbYCMV4g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Mar 2008 17:56:36 -0400
Content-Disposition: inline
In-Reply-To: <20080313174610.GF21187@unused.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 13, 2008 at 01:46:10PM -0400, Josef Bacik wrote:
> Hello,
> 
> This is a resend of a patch I sent a few months ago that hasn't
> gotten picked up yet.  This will spit out the correctly calculated
> minimal number of blocks the given fs can be resized to if the given
> resize size is too small.  This is useful for creating images, you
> can do the install and then resize the image to the smallest
> possible size.  Thank you,

Can you resend one with a Signed-off-by, please?  (Or give me
permission to add a "Signed-off-by: Josef Bacik <jbacik@redhat.com>" line.)

Thanks!!

						- Ted
