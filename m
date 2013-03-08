From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: restore verbose message for BLKDISCARD
Date: Fri, 8 Mar 2013 14:00:19 -0500
Message-ID: <20130308190019.GB12008@thunk.org>
References: <1362515118-30344-1-git-send-email-swarren@wwwdotorg.org>
 <alpine.LFD.2.00.1303060753500.24359@localhost>
 <5138EEBD.5000705@wwwdotorg.org>
 <alpine.LFD.2.00.1303080818510.24359@localhost>
 <513A1D56.1010402@wwwdotorg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Chris Ball <cjb@laptop.org>, linux-ext4@vger.kernel.org,
	Stephen Warren <swarren@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52018 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab3CHTA0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Mar 2013 14:00:26 -0500
Content-Disposition: inline
In-Reply-To: <513A1D56.1010402@wwwdotorg.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I hate to suggest this, but there's so many crappy devices out there
that I'm wondering if we need to figure out some way of maintaining a
black list of devices that don't handle discard properly.  For
example, the Sandisk U100 advertises a max discard granularity of 512
bytes, but I've been advised that if you don't use a discard
granularity of 256k, aligned on 256k, you'll be very, very, sorry.

It sounds like Stephen's device is probably an example of Yet Another
Busted Trim implementation.  The problem is that manufacturers will be
releasing more broken products faster than we can update a blacklist
in the kernel.  So any blacklist would have to be maintained online on
the web, and dynamically updated by distro installers.   :-(

    	     		 	    	   		 - Ted
