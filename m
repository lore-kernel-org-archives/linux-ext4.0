From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH resend] mke2fs: Make lost+found always have at least 2
	blocks
Date: Mon, 14 Jan 2008 10:49:47 -0500
Message-ID: <20080114154947.GB25813@mit.edu>
References: <20080109195947.GE2215@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:49831 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751035AbYANPwL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jan 2008 10:52:11 -0500
Content-Disposition: inline
In-Reply-To: <20080109195947.GE2215@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 09, 2008 at 08:59:47PM +0100, Jan Kara wrote:
>   Hi,
> 
>   this is a resend of Andreas' patch I've sent in the beginning of
> December. The patch modifies mke2fs to always create lost+found with at
> least two directory blocks. I think this could make sence not only for
> testing but as a sanity check that 64KB support works for general e2fsprogs
> if someone decides to use it...

Thanks, applied.

						- Ted
