From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] Add ZFS detection to libblkid
Date: Mon, 2 Jun 2008 21:11:36 -0400
Message-ID: <20080603011135.GH23119@mit.edu>
References: <1212171647.7508.46.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@Sun.COM>
To: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:58260 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751565AbYFCBLx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 21:11:53 -0400
Content-Disposition: inline
In-Reply-To: <1212171647.7508.46.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 30, 2008 at 07:20:47PM +0100, Ricardo M. Correia wrote:
> This patch adds ZFS filesystem detection to libblkid.
> 
> It probes for VDEV_BOOT_MAGIC in the first 2 ZFS labels in big-endian
> and little-endian formats.

Applied, with a few minor changes.

						- Ted
