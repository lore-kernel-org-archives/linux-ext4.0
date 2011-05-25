From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext3: Convert ext3 to new truncate calling
 convention
Date: Wed, 25 May 2011 17:42:10 -0400
Message-ID: <20110525214210.GC9520@thunk.org>
References: <1306320216-19368-1-git-send-email-jack@suse.cz>
 <20110525214110.GB9520@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54668 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114Ab1EYVm2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 May 2011 17:42:28 -0400
Content-Disposition: inline
In-Reply-To: <20110525214110.GB9520@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 25, 2011 at 05:41:10PM -0400, Ted Ts'o wrote:
> On Wed, May 25, 2011 at 12:43:36PM +0200, Jan Kara wrote:
> > Mostly trivial conversion. We fix a bug that IS_IMMUTABLE and IS_APPEND
> > files could not be truncated during failed writes as we change the code.
> > In fact we remove the test altogether because do_sys_[f]truncate() and
> > may_open() do necessary checks anyway.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Thanks, added to the ext4 tree.

Oops, replied to the wrong message.  I pulled in the ext4 v2 version
of your patch, obviously...

					- Ted
