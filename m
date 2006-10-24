From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC] Ext3 online defrag
Date: Tue, 24 Oct 2006 00:14:33 -0400
Message-ID: <20061024041433.GB12506@havoc.gtf.org>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz> <20061023141641.GA29649@thunk.org> <m3vembnlwz.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:18872 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S965083AbWJXEOh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Oct 2006 00:14:37 -0400
To: Alex Tomas <alex@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <m3vembnlwz.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 23, 2006 at 06:31:40PM +0400, Alex Tomas wrote:
> isn't that a kernel responsbility to find/allocate target blocks?
> wouldn't it better to specify desirable target group and minimal
> acceptable chunk of free blocks?

The kernel doesn't have enough knowledge to know whether or not the
defragger prefers one blkdev location over another.

When you are trying to consolidate blocks, you must specify the
destination as well as source blocks.

Certainly, to prevent corruption and other nastiness, you must fail if
the destination isn't available...

(ext2meta did all this...)

        Jeff
