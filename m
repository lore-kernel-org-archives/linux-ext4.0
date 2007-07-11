From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [EXT4 set 4][PATCH 4/5] i_version:ext4 inode version update
Date: Wed, 11 Jul 2007 09:47:37 +0100
Message-ID: <20070711084737.GA17675@infradead.org>
References: <1183275465.4010.130.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37353 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbXGKIrj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2007 04:47:39 -0400
Content-Disposition: inline
In-Reply-To: <1183275465.4010.130.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Jul 01, 2007 at 03:37:45AM -0400, Mingming Cao wrote:
> This patch is on top of i_version_update_vfs.
> The i_version field of the inode is set on inode creation and incremented when
> the inode is being modified.

Which is not what i_version is supposed to do.  It'll get you tons of misses
for NFSv3 filehandles that rely on the generation staying the same for the
same file.  Please add a new field for the NFSv4 sequence counter instead
of making i_version unuseable.
