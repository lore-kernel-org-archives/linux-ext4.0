From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC] fs: add FIEMAP_FLAG_DISCARD support
Date: Mon, 4 Nov 2013 02:03:43 -0800
Message-ID: <20131104100343.GA10004@infradead.org>
References: <1383435930-29295-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38122 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab3KDKDn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Nov 2013 05:03:43 -0500
Content-Disposition: inline
In-Reply-To: <1383435930-29295-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 02, 2013 at 07:45:30PM -0400, Theodore Ts'o wrote:
> Add the ability for a user who has write access to a file to issue a
> discard request for blocks belonging to a file.  This can be done via
> a new flag to the FIEMAP ioctl, or via the BLKDISCARD ioctl (which
> previously only worked on block devices).

As Dave already pointed out overloading a data manipulating operation
over FIEMAP is a no-go.  

Besides that I really miss an explanation what the intended use cases
are.  What does this buy us over punching a hole on an actual real
workload?  Where is the overhead?  Is it our shitty discard
implementation? If so there's tons of low hanging fruit to fix there
anyway that we shouldn't work around by interfaces taking shortcuts.
Is it problems in ext4's extent management on hole punch?  Is the
bit of metadata created when doing an actual hole punch too much for
that very specific workload?

Also you really need to restrict this to devices that set the
discard_zeroes_data flag, without that you'll expose random
uninitialized data.
