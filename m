From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4_fallocate
Date: Tue, 26 Jun 2012 14:57:21 -0400
Message-ID: <20120626185721.GA26669@thunk.org>
References: <4FE8086F.4070506@zoho.com>
 <20120625085159.GA18931@gmail.com>
 <20120625191744.GB9688@thunk.org>
 <4FE9B57F.4030704@redhat.com>
 <20120626173050.GA6745@thunk.org>
 <4FE9FDA4.60509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Fredrick <fjohnber@zoho.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@dilger.ca>, wenqing.lz@taobao.com
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52850 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756375Ab2FZS51 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jun 2012 14:57:27 -0400
Content-Disposition: inline
In-Reply-To: <4FE9FDA4.60509@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 26, 2012 at 02:21:24PM -0400, Ric Wheeler wrote:
> 
> It would be interesting to see if simply not doing the preallocation
> would be easier and safer. Better yet, figure out how to leverage
> trim commands to safely allow us to preallocate and not expose other
> users' data (and not have to mark the extents as allocated but not
> written).

TRIM is applicable to SSD's and enterprise storage arrays.  It's not
applicable HDD's.

> This is not a theory guy worry. I would not use any server/web
> service that knowingly enabled this hack in a multi-user machine and
> would not enable it for any enterprise customers.

Sure, but for single-user or for dedicated cluster file system server,
it makes sense; it's not not going to be useful for all customers,
sure, but for some customers it will make sense.

> We should be very, very careful not to strip away the usefulness of
> file system just to cater to some users. 

A mount option or a superblock flag does not "strip away the
usefulness of the file system".  It makes it more useful for some use
cases.

Your alternate proposals (preinitializing the space with zeros, using
trim, writing larger chunks) will work for some use cases, certainly.
But it's not going to be sufficient for at least some use cases, or
they will simply not work.

Fundamentally it sounds to me the biggest problem is that you don't
trust your customers, and so you're afraid people will use the
no-hide-stale feature if it becomes available, even if it's not needed
or if it's needed but you're afraid that they don't understand the
security tradeoffs.

					- Ted
