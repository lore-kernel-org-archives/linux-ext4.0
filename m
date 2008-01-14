From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH resend] Fix reading of bitmaps from filesystem image
Date: Mon, 14 Jan 2008 10:57:18 -0500
Message-ID: <20080114155718.GC25813@mit.edu>
References: <20080109195435.GD2215@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:51676 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754489AbYANQAJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jan 2008 11:00:09 -0500
Content-Disposition: inline
In-Reply-To: <20080109195435.GD2215@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 09, 2008 at 08:54:35PM +0100, Jan Kara wrote:
> 
> Reading of bitmaps from image file could never work with more than one
> group in a filesystem... Fix the loops so that we read appropriate number
> of blocks.

OK, so I'm probably being dense, but.... what's the problem?

You changed the loop from counting in bytes to inodes, but either
method should work.

						- Ted
