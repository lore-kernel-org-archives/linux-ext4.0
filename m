From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4 v2] ext4: fix start and len arguments handling in
 ext4_trim_fs()
Date: Wed, 21 Mar 2012 21:22:34 -0400
Message-ID: <20120322012234.GB11157@thunk.org>
References: <1330690318-22627-1-git-send-email-lczerner@redhat.com>
 <20120305123757.GD6643@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42813 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab2CVBWj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Mar 2012 21:22:39 -0400
Content-Disposition: inline
In-Reply-To: <20120305123757.GD6643@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 05, 2012 at 01:37:57PM +0100, Jan Kara wrote:
> On Fri 02-03-12 13:11:55, Lukas Czerner wrote:
> > The overflow can happen when we are calling get_group_no_and_offset()
> > which stores the group number in the ext4_grpblk_t type which is
> > actually int. However when the blocknr is big enough the group number
> > might be bigger than ext4_grpblk_t resulting in overflow. This will
> > most likely happen with FITRIM default argument len = ULLONG_MAX.
> > 
> > Fix this by using "end" variable instead of "start+len" as it is easier
> > to get right and specifically check that the end is not beyond the end
> > of the file system, so we are sure that the result of
> > get_group_no_and_offset() will not overflow. Otherwise truncate it to
> > the size of the file system.
>   Looks good. You can add:
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
