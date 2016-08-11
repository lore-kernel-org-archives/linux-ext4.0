From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/11] ext4: Check that external xattr value block is 0
Date: Thu, 11 Aug 2016 13:33:20 -0400
Message-ID: <20160811173319.GF10626@thunk.org>
References: <1470220795-17045-1-git-send-email-jack@suse.cz>
 <1470220795-17045-7-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45604 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbcHKRdV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Aug 2016 13:33:21 -0400
Content-Disposition: inline
In-Reply-To: <1470220795-17045-7-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 03, 2016 at 12:39:50PM +0200, Jan Kara wrote:
> Currently we don't support xattrs with values stored out of line. Check
> for that in ext4_xattr_check_names() to make sure we never work with
> such xattrs since not all the code counts with that resulting is possible
> weird corruption issues.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
