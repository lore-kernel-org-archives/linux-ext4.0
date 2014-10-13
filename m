From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Replace open coded mdata csum feature to
 helper function v2
Date: Mon, 13 Oct 2014 17:11:42 -0400
Message-ID: <20141013211142.GG9738@thunk.org>
References: <1413147967-30487-1-git-send-email-dmonakhov@openvz.org>
 <20141013164319.GB12009@birch.djwong.org>
 <8761fnrjgz.fsf@openvz.org>
 <20141013172803.GE12009@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50572 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbaJMVLu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Oct 2014 17:11:50 -0400
Content-Disposition: inline
In-Reply-To: <20141013172803.GE12009@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 13, 2014 at 10:28:03AM -0700, Darrick J. Wong wrote:
> 
> Oh well, Ted already took your patch; I guess I'll just send him the fix myself.

No worries, I can always correct the patch.  It would be good if you
and Dmitry can reach agreement about what the right thing to do is
here, though.  (Since I'm in conference mode at the moment, and you
are more familiar with these code paths than I am.)

Cheers,

						- Ted
