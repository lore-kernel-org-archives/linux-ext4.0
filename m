From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13232] ext3/4 with synchronous writes gets wedged by Postfix
Date: Mon, 18 May 2009 12:45:26 GMT
Message-ID: <200905181245.n4ICjQVb010015@demeter.kernel.org>
References: <bug-13232-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49137 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZERMpY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 May 2009 08:45:24 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4ICjQhY010016
	for <linux-ext4@vger.kernel.org>; Mon, 18 May 2009 12:45:26 GMT
In-Reply-To: <bug-13232-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13232





--- Comment #8 from Jan Kara <jack@suse.cz>  2009-05-18 12:45:23 ---
On Wed 13-05-09 12:07:24, Theodore Tso wrote:
> On Wed, May 13, 2009 at 03:48:02PM +0200, Jan Kara wrote:
> >   OK, the deadlock has been introduced by ext3 variant of
> > 261bca86ed4f7f391d1938167624e78da61dcc6b (adding Al to CC).
> 
> What do you mean by this?
> 
> I'm puzzled why we haven't hit this before.  This looks like
> long-standing issue; what unmasked it now?
  Unless you mount the fs with 'sync' option, hitting this is much harder
(the window is quite small in nosync case). I think that is the main reason
why we didn't see this earlier.

> > The deadlock
> > is really tough to avoid - we have to first allocate inode on disk so
> > that we know the inode number.
> 
> Well, the simple thing to do is to have a way of quickly determining
> that a particular inode number is in the I_FREEING state, and simply
> try to avoid using that inode number.  If there are no inodes
> available, it can simply close the handle (since nothing else has
> changed at that point), wait for the current transaction to close, and
> then try again.  That should fix the problem, I think.
  Yes, we could work-around it like that but other filesystems might need
similar things and generally it would be nicer if we could avoid using this
vfs-internal information in the filesystems. Al seems to have found some
other solution without changing filesystems so that would be easier for us...

                                    Honza

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
