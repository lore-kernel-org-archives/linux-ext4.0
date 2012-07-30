From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] Make Multi Mount Protection (MMP) optional at
 configure time.
Date: Mon, 30 Jul 2012 15:40:55 -0400
Message-ID: <20120730194055.GB10343@thunk.org>
References: <1340674935-1503-1-git-send-email-tony@bakeyournoodle.com>
 <1340674935-1503-2-git-send-email-tony@bakeyournoodle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>
To: Tony Breeds <tony@bakeyournoodle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42090 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089Ab2G3Tk5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jul 2012 15:40:57 -0400
Content-Disposition: inline
In-Reply-To: <1340674935-1503-2-git-send-email-tony@bakeyournoodle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 26, 2012 at 11:42:15AM +1000, Tony Breeds wrote:
> Add --{en,dis}able-mmp options for configure, default to enabled.
> Also make tools fail gracefully in the event of encoutering a filesystem
> with MMP enabled when the tools were compiled with --disable-mmp
> 
> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>

Added to the next branch of e2fsprogs.

					- Ted
