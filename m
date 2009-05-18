From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13232] ext3/4 with synchronous writes gets wedged by Postfix
Date: Mon, 18 May 2009 13:16:06 GMT
Message-ID: <200905181316.n4IDG6n9012558@demeter.kernel.org>
References: <bug-13232-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52292 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbZERNQK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 May 2009 09:16:10 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4IDG6Ht012559
	for <linux-ext4@vger.kernel.org>; Mon, 18 May 2009 13:16:06 GMT
In-Reply-To: <bug-13232-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13232





--- Comment #10 from Theodore Tso <tytso@mit.edu>  2009-05-18 13:16:04 ---
On Wed, May 13, 2009 at 07:13:40PM +0100, Al Viro wrote:
> 
> OK, that's probably the easiest way to do that, as much as I don't like it...
> Since iget() et.al. will not accept I_FREEING (will wait to go away
> and restart), and since we'd better have serialization between new/free
> on fs data structures anyway, we can afford simply skipping I_FREEING
> et.al. in insert_inode_locked().
> 
> We do that from new_inode, so it won't race with free_inode in any interesting
> ways and it won't race with iget (of any origin; nfsd or in case of fs
> corruption a lookup) since both still will wait for I_LOCK.
> 
> Tentative patch follow; folks, I would very much like review on that one,
> since I'm far too low on caffeine and the area is nasty.

Sorry for not having time to review this until now.  This looks good
to me.

Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>

So Bug #13232 is currently marked as a 2.6.28 regression; do we feel
confident enough to push this to Linus for 2.6.30?

                             - Ted

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
