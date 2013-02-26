From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 xfstest regression due to ext4_es_lookup_extent
Date: Tue, 26 Feb 2013 15:06:59 -0500
Message-ID: <20130226200659.GA27235@thunk.org>
References: <87obfcs1x6.fsf@openvz.org>
 <20130224145837.GA3722@gmail.com>
 <87zjys3hza.fsf@openvz.org>
 <20130225095721.GA23984@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50096 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755909Ab3BZUHD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Feb 2013 15:07:03 -0500
Content-Disposition: inline
In-Reply-To: <20130225095721.GA23984@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 25, 2013 at 05:57:21PM +0800, Zheng Liu wrote:
> > I strongly believe in testing. Ext4 is production-grade filesystem
> > so we can not break it in the name of new features, unless we are sure
> > that features are safe and valuable, that's why investments in
> > self-testing infrastructure for ES should have very high priority.
> > But off course Theodore's decision whenever feature is looks stable
> > enough to get ready go upstream.
> 
> Yes, I agree with you that we shouldn't break a production-grade file
> system.  Certainly Ted has the final decision.

I agree that having better self-testing for sanity check features
would be a good thing to add, so that as we make changes in the
future, it's much more likely that we will find potential problems
sooner rather than later.

Given that amount of testing that we've done looking for regressions,
I'm feeling pretty good about the stability of the ext4 tree, so I'm
ready to send a pull request to Linus with the extent status tree. 

Yes, we do have the problem with the defrag ioctl, but I trust that
Zheng will have a fix for us before v3.9 releases.  Worst case, we can
just flush the extent status tree entirely which should
(inefficiently) solve the defrag bug.

Cheers,

					- Ted
