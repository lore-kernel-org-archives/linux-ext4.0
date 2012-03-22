From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4 v2] ext4: Always set then trimmed blocks count into
 len
Date: Wed, 21 Mar 2012 21:23:01 -0400
Message-ID: <20120322012301.GD11157@thunk.org>
References: <1330690318-22627-1-git-send-email-lczerner@redhat.com>
 <1330690318-22627-3-git-send-email-lczerner@redhat.com>
 <20120305123839.GF6643@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39420 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318Ab2CVBXE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Mar 2012 21:23:04 -0400
Content-Disposition: inline
In-Reply-To: <20120305123839.GF6643@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 05, 2012 at 01:38:39PM +0100, Jan Kara wrote:
> On Fri 02-03-12 13:11:57, Lukas Czerner wrote:
> > Currently if the range to trim is too small, for example on 1K fs
> > the request to trim the first block, then the 'range->len' is not set
> > reporting wrong number of discarded block to the caller.
> > 
> > Fix this by always setting the 'range->len' before we return. Note that
> > when there is a failure (-EINVAL) caller can not depend on 'range->len'
> > being set properly.
>   Looks good. You can add:
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
