From: Theodore Tso <tytso@mit.edu>
Subject: Re: file allocation problem
Date: Thu, 16 Jul 2009 11:58:32 -0400
Message-ID: <20090716155832.GA6605@mit.edu>
References: <200907161331.17623.coolo@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Stephan Kulow <coolo@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40362 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932698AbZGPQWI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jul 2009 12:22:08 -0400
Content-Disposition: inline
In-Reply-To: <200907161331.17623.coolo@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 16, 2009 at 01:31:17PM +0200, Stephan Kulow wrote:
> Hi,
> 
> I played around with ext4 online defrag on 2.6.31-rc3 and noticed a problem. 
> The core is this:

Was your filesystem originally an ext3 filesystme which was converted
over to ext4?  What features are currently enabled (sending a copy of
the output of "dumpe2fs -h /dev/XXX" would be helpful.)

If it is the case that this was originally an ext3 filesystem,
e4defrag does have some definite limitations that will prevent it from
doing a great job in such a case.  I'm guessing that's what's going on
here.

> Now that I call fragmented! Calling e4defrag again gives me
> 34->28 and now it moved _parts_

I'm not sure what you mean by moving _parts_?

						- Ted
