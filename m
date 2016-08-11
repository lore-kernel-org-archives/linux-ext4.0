From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 07/11] ext4: Remove checks for e_value_block
Date: Thu, 11 Aug 2016 13:33:29 -0400
Message-ID: <20160811173329.GG10626@thunk.org>
References: <1470220795-17045-1-git-send-email-jack@suse.cz>
 <1470220795-17045-8-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45618 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbcHKRda (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Aug 2016 13:33:30 -0400
Content-Disposition: inline
In-Reply-To: <1470220795-17045-8-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 03, 2016 at 12:39:51PM +0200, Jan Kara wrote:
> Currently we don't support xattrs with e_value_block set. We don't allow
> them to pass initial xattr check so there's no point for checking for
> this later. Since these tests were untested, bugs were creeping in and
> not all places which should have checked were checking e_value_block
> anyway.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
