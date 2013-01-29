From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 11/12] ext4: Make ext4_bio_writepage() handle unprepared
 buffers
Date: Mon, 28 Jan 2013 20:59:46 -0500
Message-ID: <20130129015946.GB7003@thunk.org>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-12-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45948 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755998Ab3A2B7u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 20:59:50 -0500
Content-Disposition: inline
In-Reply-To: <1358510446-19174-12-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 18, 2013 at 01:00:45PM +0100, Jan Kara wrote:
> So far ext4_bio_writepage() unconditionally cleared dirty bit on all buffers
> underlying the page. That implicitely assumes we can write all buffers. So
> far that is true because callers call into ext4_bio_writepage() make sure
> all buffers in the page are mapped but
> a) it's a data corruption bug waiting to happen
> b) in data=ordered mode when blocksize < pagesize we do need to write pages
>    that may have only some of dirty buffers mapped.
> 
> So change ext4_bio_writepage() to skip buffers that cannot be written without
> clearing their dirty bit.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
