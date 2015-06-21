From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/5] jbd2: Speedup jbd2_journal_get_[write|undo]_access()
Date: Sat, 20 Jun 2015 21:56:41 -0400
Message-ID: <20150621015641.GN29480@thunk.org>
References: <1427983100-29889-1-git-send-email-jack@suse.cz>
 <1427983100-29889-5-git-send-email-jack@suse.cz>
 <20150608164726.GM19168@thunk.org>
 <20150617165646.GG1614@quack.suse.cz>
 <CAA1ppbhojR0aaDr-BUWQLWQDo5+sO9Tc6b=Dxf5XrRAr2DT0oQ@mail.gmail.com>
 <20150618085235.GB21820@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jerry Lee <jerrylee@qnap.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46867 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbbFUB4o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Jun 2015 21:56:44 -0400
Content-Disposition: inline
In-Reply-To: <20150618085235.GB21820@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 18, 2015 at 10:52:35AM +0200, Jan Kara wrote:
>   Yeah, thanks for catching this. I was apparently pretty lucky in this
> passing all the tests... Attached is the new version of the patch.

Thanks, I've added this to the ext4 tree.

	     	   	       	    - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
