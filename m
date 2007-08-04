From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Patch 1/13] iostats
Date: Fri, 3 Aug 2007 20:07:27 -0400
Message-ID: <20070804000727.GC7449@thunk.org>
References: <1185275076.3789.66.camel@dhcp4.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Girish Shilamkar <girish@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35373 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbXHDGCe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Aug 2007 02:02:34 -0400
Content-Disposition: inline
In-Reply-To: <1185275076.3789.66.camel@dhcp4.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 24, 2007 at 04:34:36PM +0530, Girish Shilamkar wrote:
> This patch instruments the libext2fs unix I/O manager and adds bytes 
> read/written and data rate to e2fsck -tt pass/overall timing output.
> 
> Signed-off-by: Jim Garlick <garlick@llnl.gov>

Applied with a number of changes/fixups.

					- Ted
