From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4 v2] ext4: Fix trimmed block count computing
Date: Wed, 21 Mar 2012 21:22:44 -0400
Message-ID: <20120322012244.GC11157@thunk.org>
References: <1330690318-22627-1-git-send-email-lczerner@redhat.com>
 <1330690318-22627-2-git-send-email-lczerner@redhat.com>
 <20120305123820.GE6643@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42817 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318Ab2CVBWr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Mar 2012 21:22:47 -0400
Content-Disposition: inline
In-Reply-To: <20120305123820.GE6643@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 05, 2012 at 01:38:20PM +0100, Jan Kara wrote:
> On Fri 02-03-12 13:11:56, Lukas Czerner wrote:
> > Currently when there is not enough free block in the block group to
> > discard (grp->bb_free < minlen) the 'trimmed' is bumped up anyway with
> > the number of discarded blocks from the previous iteration. Fix this
> > by bumping up 'trimmed' only if the ext4_trim_all_free() was actually
> > run.
>   Looks good. You can add:
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
