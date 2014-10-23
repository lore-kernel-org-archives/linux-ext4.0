From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] xfstests-bld: Split system images in two parts
Date: Thu, 23 Oct 2014 10:06:46 -0400
Message-ID: <20141023140646.GA14868@thunk.org>
References: <1413990417-18285-1-git-send-email-dmonakhov@openvz.org>
 <20141022212535.GC6295@thunk.org>
 <20141023004812.GA7841@thunk.org>
 <87d29j10zx.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39233 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756045AbaJWOGu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Oct 2014 10:06:50 -0400
Content-Disposition: inline
In-Reply-To: <87d29j10zx.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 23, 2014 at 03:25:38PM +0400, Dmitry Monakhov wrote:
> Theodore Ts'o <tytso@mit.edu> writes:
> 
> > On Wed, Oct 22, 2014 at 05:25:35PM -0400, Theodore Ts'o wrote:
> >> So what I suggest instead is that we have a new script, update-image,
> >> which takes an existing root_fs.img, and installs the updated
> >> xfstests, the configuration files, and startup files, leaving the
> >> existing debian base image intact.
> >
> > Here's an enhancement to the gen-image script which adds a new
> > --update option.
> Yes. This one looke much than mine, than you.

Great, I've pushed it out to git.kernel.org.

							- Ted
