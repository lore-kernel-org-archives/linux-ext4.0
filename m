From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2image: Print a warning if running over a mounted
 filesystem
Date: Mon, 30 Sep 2013 16:19:48 -0400
Message-ID: <20130930201948.GD5845@thunk.org>
References: <1380229204-32526-1-git-send-email-cmaiolino@redhat.com>
 <20130926235658.GD6011@thunk.org>
 <5244D3C2.4090606@redhat.com>
 <20130927004832.GA15078@orion.maiolino.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40346 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab3I3UTx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Sep 2013 16:19:53 -0400
Content-Disposition: inline
In-Reply-To: <20130927004832.GA15078@orion.maiolino.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 26, 2013 at 09:48:33PM -0300, Carlos Maiolino wrote:
> 
> I'd suggest then to need a force when using -r or -q on a RW image. In case of a
> normal image, just a warning but continue.

(Sorry for not repsonding earlier; I was on vacation in at Yellowstone
/ Grand Teton National Park from Thursday through today.)

Yes, that's what I was suggesting.  Requiring force for the case of -r
or -q, but just a warning otherwise.

> Ted, as Eric said, I've got some useless images in the past too and just a
> warning won't really avoid the problem IMHO since, most of users don't even read
> what's being printed :-) so, request a force when getting at least a raw or
> QCOW2 image is very useful IMHO.

The useless images are primarily when we are trying to use -r or -q to
get the dynamic metadata (i.e., the directory blocks and extent tree
blocks).  That's what we generally need when are doing debugging, and
so yes, I'm fully in agreement with requiring force in the case of
e2image -r and e2image -q.

Regards,

					- Ted
