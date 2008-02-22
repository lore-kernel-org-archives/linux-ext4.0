From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: e2fsck dies with error "this should never happen!!!"
Date: Fri, 22 Feb 2008 07:38:52 -0500
Message-ID: <20080222123852.GI20118@mit.edu>
References: <47BEBAF1.4090505@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Bas van Schaik <bas@tuxes.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:57161 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754612AbYBVMj7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Feb 2008 07:39:59 -0500
Content-Disposition: inline
In-Reply-To: <47BEBAF1.4090505@tuxes.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 22, 2008 at 01:07:13PM +0100, Bas van Schaik wrote:
> Hi all,
> 
> Currently, I have a big problem: e2fsck refuses to fix my currupted
> filesystem...

The things that I would suggest first of all is upgrading to the
latest version of e2fsprogs.  If that doesn't fix it, I'm going to
need either a compressed e2image file (see the e2image man page) or
login access to see what is up.

							- Ted
