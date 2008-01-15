From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [CALL FOR TESTING] Make Ext3 fsck way faster [2.6.24-rc6 -mm
	patch]
Date: Tue, 15 Jan 2008 13:16:40 +0000
Message-ID: <20080115131640.GB5766@infradead.org>
References: <200801140839.01986.abhishekrai@google.com> <20080114163412.83a8b18d.akpm@linux-foundation.org> <20080115030441.a0270609.akpm@linux-foundation.org> <20080115131533.GA5766@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Abhishek Rai <abhishekrai@google.com>,
	linux-kernel@vger.kernel.org, rohitseth@google.com,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:60186 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYAONQp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jan 2008 08:16:45 -0500
Content-Disposition: inline
In-Reply-To: <20080115131533.GA5766@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 15, 2008 at 01:15:33PM +0000, Christoph Hellwig wrote:
> They won't fsck in planned downtimes.  They will have to use fsck when
> the shit hits the fan and they need to.   Not sure about ext3, but big
> XFS user with a close tie to the US goverment were concerned about this
> case for really big filesystems and have sponsored speedup including
> multithreading xfs_repair.  I'm pretty sure the same arguments apply
> to ext3, even if the filesystems are a few magnitudes smaller.

And to add to that thanks to the not quite optimal default of
peridocially checking that I alwasy forget to turn off on test machines
an ext3 fsck speedup would be in my personal interested, and probably
that of tons of developers :)
