From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/9] vfs: Handle O_SYNC AIO DIO in generic code properly
Date: Wed, 21 Nov 2012 13:29:01 -0500
Message-ID: <20121121182901.GA4519@infradead.org>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
 <20121120074123.24645.41965.stgit@blackbox.djwong.org>
 <20121121100809.GE23339@infradead.org>
 <x497gpevqoy.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <darrick.wong@oracle.com>, axboe@kernel.dk,
	tytso@mit.edu, david@fromorbit.com, bpm@sgi.com,
	viro@zeniv.linux.org.uk, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:57451
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755509Ab2KUS3R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Nov 2012 13:29:17 -0500
Content-Disposition: inline
In-Reply-To: <x497gpevqoy.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 21, 2012 at 11:58:05AM -0500, Jeff Moyer wrote:
> > I'd like to use this as a vehicle to revisit how dio completions work.
> 
> I don't like the sound of that.  ;-)  It sounds like this bugfix may get
> further delayed by the desire for unrelated code cleanup.

I've got a prototype that isn't much more invasive than the current
series.  I'll finish it up and run it through QA and will post it
tomorrow.

