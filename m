From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6/6] ext4: Remove i_ioend_count
Date: Tue, 8 Mar 2016 23:53:25 -0500
Message-ID: <20160309045325.GF3150@thunk.org>
References: <1455897582-13292-1-git-send-email-jack@suse.cz>
 <1455897582-13292-7-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49326 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbcCIEx3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Mar 2016 23:53:29 -0500
Content-Disposition: inline
In-Reply-To: <1455897582-13292-7-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 19, 2016 at 04:59:42PM +0100, Jan Kara wrote:
> Remove counter of pending io ends as it is unused.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

(I'm kicking off a full gce-xfstests run just to make sure there are
no regression across all of the various file system configs that I
normally test.)

						- Ted
