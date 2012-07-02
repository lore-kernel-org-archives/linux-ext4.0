From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 blocks up
Date: Mon, 2 Jul 2012 13:43:42 -0400
Message-ID: <20120702174342.GA5795@thunk.org>
References: <1341231316.2979.11.camel@sauron.fi.intel.com>
 <20120702144444.GA18074@thunk.org>
 <1341240862.2979.23.camel@sauron.fi.intel.com>
 <20120702151442.GB18074@thunk.org>
 <20120702164548.GD18074@thunk.org>
 <4FF1D22D.2070804@redhat.com>
 <20120702173104.GK6679@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54007 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899Ab2GBRnr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jul 2012 13:43:47 -0400
Content-Disposition: inline
In-Reply-To: <20120702173104.GK6679@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 02, 2012 at 07:31:04PM +0200, Jan Kara wrote:
>   Yes, I can hang the kernel on this test with basically any filesystem
> when running long enough. My freezing patches should fix that - currently
> waiting for Al to merge them...

So this is different from your suspend/resume patches, then?

Can you send me a pointer to your patches?  Is this something that Al
will hopefully merge before 3.5 is released?

    	     	  	     	  - Ted
