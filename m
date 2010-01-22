From: tytso@mit.edu
Subject: Re: [PATCH] default max mount count to unused
Date: Thu, 21 Jan 2010 20:29:29 -0500
Message-ID: <20100122012929.GA21263@thunk.org>
References: <4B5785A5.2010505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Bill Nottingham <notting@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:40014 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709Ab0AVB3j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jan 2010 20:29:39 -0500
Content-Disposition: inline
In-Reply-To: <4B5785A5.2010505@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 20, 2010 at 04:37:25PM -0600, Eric Sandeen wrote:
> From: Bill Nottingham <notting@redhat.com>
> 
> Anaconda has been setting the max mount count on the root fs
> to -1 (unused) for ages.
> 
> I (Eric) tend to agree that using mount count as a proxy for potential
> for corruption seems odd.  And waiting for fsck on a reboot just because
> it's number 20 (or so) is painful.  Can we just turn it off by default?
> 
> I wouldn't mind killing the periodic check as well, but consider
> this a trial balloon.  :)

I think it would be better to make this be something tunable via
mke2fs.conf.  And as a profile option, maybe we would want this to be
something where we periodically force a full fsck check and then send
TRIM commands down to the SSD.  Given the size and speed of SSD's,
doing periodic TRIM's every N mounts mike actually be a good thing.
(It's dangerous to do a TRIM without doing a full fsck since if the
block allocation bitmap isn't quite right, the user could lose data.)

      		 	      	    	       - Ted
