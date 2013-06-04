From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/26] ext4: Deprecate max_writeback_mb_bump sysfs
 attribute
Date: Tue, 4 Jun 2013 12:53:22 -0400
Message-ID: <20130604165322.GC3030@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-13-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54760 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366Ab3FDQxZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 12:53:25 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-13-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:45AM +0200, Jan Kara wrote:
> This attribute is now unused so deprecate it. We still show the old
> default value to keep some compatibility but we don't allow writing to
> that attribute anymore.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
