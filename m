From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4 problems with external RAID array via SAS connection
Date: Mon, 7 Feb 2011 17:54:36 -0500
Message-ID: <20110207225436.GG3457@thunk.org>
References: <OFFAEBAC93.6731CA9F-ON85257830.0067BABF-85257830.0067C1CB@dart.biz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bryan.coleman@dart.biz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38922 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238Ab1BGWyj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Feb 2011 17:54:39 -0500
Content-Disposition: inline
In-Reply-To: <OFFAEBAC93.6731CA9F-ON85257830.0067BABF-85257830.0067C1CB@dart.biz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 07, 2011 at 01:53:18PM -0500, bryan.coleman@dart.biz wrote:
> I am experiencing problems with an ext4 file system.
> 
> At first, the drive seemed to work fine.  I was primarily copying things 
> to the drive migrating data from another server.  After many GBs of data, 
> that seemingly successfully were done being transferred, I started seeing 
> ext4 errors in /var/log/messages.  I then unmounted the drive and ran fsck 
> on it (which took multiple hours to run).  I then ls'ed around and one of 
> the areas caused the system to again throw ext4 errors.

Did fsck report any errors?  Do you have a copy of your fsck
transcript?

The errors you've reported do make me suspicious that there's
something unstable with your hardware...

					- Ted
