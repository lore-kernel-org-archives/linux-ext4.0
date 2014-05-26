From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: don't run quota test if quota is not enabled
Date: Mon, 26 May 2014 11:46:12 -0400
Message-ID: <20140526154611.GF22284@thunk.org>
References: <537A6909.6060700@redhat.com>
 <537A82D0.8030702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33062 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbaEZPqP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 May 2014 11:46:15 -0400
Content-Disposition: inline
In-Reply-To: <537A82D0.8030702@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 19, 2014 at 05:16:48PM -0500, Eric Sandeen wrote:
> On 5/19/14, 3:26 PM, Eric Sandeen wrote:
> > The default configuration still has quota disabled, but
> > runs the f_quota test unconditionally, so we fail by
> > default.
> > 
> > Fix that...

Thanks, applied.

> related to this, should quota be on by default now, or not?

I think quota should be safe to enable in 1.42.10, but my plan was to
not enable it by default until 1.43 (at which point quota support will
always be enabled, and --enable-quota will be a no-op).

Cheers,

       	  	       		      	      - Ted
