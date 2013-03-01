From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: optimize ext4_es_shrink()
Date: Fri, 1 Mar 2013 11:26:51 -0500
Message-ID: <20130301162651.GB16485@thunk.org>
References: <CA+55aFwWA1jPEEQNx_5oJ6Ze=3yFb6=E9nraBfX-Ve=WjRkQMw@mail.gmail.com>
 <20130227184912.GA19624@thunk.org>
 <20130227185625.GA224@x4>
 <20130227191923.GA1121@redhat.com>
 <20130227192907.GB14253@thunk.org>
 <20130227201217.GD14253@thunk.org>
 <20130301033005.GA7081@redhat.com>
 <20130301040039.GA4452@thunk.org>
 <20130301050029.GB4452@thunk.org>
 <20130301161130.GA24367@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "gnehzuil.liu" <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Dave Jones <davej@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50808 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab3CAQ05 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Mar 2013 11:26:57 -0500
Content-Disposition: inline
In-Reply-To: <20130301161130.GA24367@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 01, 2013 at 11:11:30AM -0500, Dave Jones wrote:
> On Fri, Mar 01, 2013 at 12:00:29AM -0500, Theodore Ts'o wrote:
>  > When the system is under memory pressure, ext4_es_srhink() will get
>  > called very often.  So optimize returning the number of items in the
>  > file system's extent status cache by keeping a per-filesystem count,
>  > instead of calculating it each time by scanning all of the inodes in
>  > the extent status cache.
>  > 
>  > Also rename the slab used for the extent status cache to be
>  > "ext4_extent_status" so it's obviousl the slab in question is created
>  > by ext4.
> 
> Seems to work with no ill effects afaics.

Thanks for reporting the problem and testing the fix!

I'll add a Reported-by: and Tested-by: Dave Jones <davej@redhat.com>
to the commit.  (Unless of course you have an objection, in which case
let me know.)

					- Ted
