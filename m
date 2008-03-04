From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 1/1] add a jbd option to force an unclean journal
	state
Date: Tue, 4 Mar 2008 20:01:09 +0100
Message-ID: <20080304190109.GD24335@duck.suse.cz>
References: <200803041339.42544.jbacik@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:52547 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752957AbYCDTBM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Mar 2008 14:01:12 -0500
Content-Disposition: inline
In-Reply-To: <200803041339.42544.jbacik@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Tue 04-03-08 13:39:41, Josef Bacik wrote:
> jbd and I want a way to verify that I'm not screwing anything up in the 
> process, and this is what I came up with.  Basically this option would only be 
> used in the case where someone mounts an ext3 image or fs, does a specific IO 
> operation (create 100 files, write data to a few files etc), unmounts the fs 
> and remounts so that jbd does its journal recovery and then check the status of 
> the fs to make sure its exactly the way its expected to be.  I'm not entirely 
> sure how usefull of an option like this would be (or if I did it right :) ), 
> but I thought I'd throw it out there in case anybody thinks it may be useful, 
> and in case there is some case that I'm missing so I can fix it and better make 
> sure I don't mess anything up while doing stuff.  Basically this patch keeps us 
> from resetting the journal's tail/transaction sequence when we destroy the 
> journal so when we mount the fs again it will look like we didn't unmount 
> properly and recovery will occur.  Any comments are much appreciated,
  Actually, there is a different way how we've done checking like this (and
I think also more useful), at least for ext3. Basically you mounted a
filesysteem with some timeout and after the timeout, device was forced
read-only. And then you've checked that the fs is consistent after journal
replay. I think Andrew had the patches somewhere...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
