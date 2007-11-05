From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/4][e2fsprogs] Relax group descriptor checking.
Date: Mon, 5 Nov 2007 10:41:57 -0500
Message-ID: <20071105154157.GB10001@thunk.org>
References: <20070814043245.32206.34785.stgit@gara> <20070814043303.32206.10239.stgit@gara> <20071103233609.GA30710@thunk.org> <20071105085352.36405a00@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46975 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbXKEPmn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Nov 2007 10:42:43 -0500
Content-Disposition: inline
In-Reply-To: <20071105085352.36405a00@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 05, 2007 at 08:53:52AM -0600, Jose R. Santos wrote:
> Yes, the patch is slightly off and I did send an email pointing to
> exactly this, but you had already committed the patch by the time the
> email was sent.  This patch was submitted to the mailing list before
> the final kernel changes made it into the queue.

Feel free to resend patches series that are only in the pu series.
(Don't bother if it's just to fix merge changes, since I can do that
fairly easily; if I need help I'll people know.)  But if you want to
fix substantive issues, send me a new set of patches and I'll replace
them; the whole point of the "pu" branch is that it will rewind as
patches get refined and "cooked".

              	       	       	      	 - Ted
