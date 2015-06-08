From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/5] jbd2: Simplify code flow in do_get_write_access()
Date: Mon, 8 Jun 2015 12:45:20 -0400
Message-ID: <20150608164520.GL19168@thunk.org>
References: <1427983100-29889-1-git-send-email-jack@suse.cz>
 <1427983100-29889-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53281 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbbFHQpW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jun 2015 12:45:22 -0400
Content-Disposition: inline
In-Reply-To: <1427983100-29889-4-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 02, 2015 at 03:58:18PM +0200, Jan Kara wrote:
> Check for the simple case of unjournaled buffer first, handle it and
> bail out. This allows us to remove one if and unindent the difficult case
> by one tab. The result is easier to read.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, although I renamed the summary so we didn't have to commits
with the identical one-line summary in close proximity to each other.

     	 	   	    	       	     - Ted
