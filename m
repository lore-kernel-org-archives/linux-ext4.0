From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] ext2: add wait flag support to sync_fs
Date: Fri, 20 Nov 2009 05:36:22 -0500
Message-ID: <20091120103622.GA29143@infradead.org>
References: <20091117174617.285298261@vyatta.com> <20091117174647.402219318@vyatta.com> <20091119153419.GB2943@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephen Hemminger <shemminger@vyatta.com>,
	linux-ext4@vger.kernel.org, hch@infradead.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45632 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbZKTKgR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Nov 2009 05:36:17 -0500
Content-Disposition: inline
In-Reply-To: <20091119153419.GB2943@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 19, 2009 at 04:34:19PM +0100, Jan Kara wrote:
>   BTW: Christoph, why did you choose to call ext2_sync_fs with wait == 1
> from ext2_write_super()? I'd think (and looking into callsites seem to
> confirm that) that ->write_super() was meant to be asynchronous...

No particular reason - the argument wasn't and still isn't used in ext2.
And yes, now that ->sync_fs is mandatory ->write_super should be
asynchronous.

