From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sun, 8 Nov 2009 21:05:40 GMT
Message-ID: <200911082105.nA8L5eFA002306@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49829 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675AbZKHVFf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 8 Nov 2009 16:05:35 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA8L5esw002307
	for <linux-ext4@vger.kernel.org>; Sun, 8 Nov 2009 21:05:40 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #183 from Linus Torvalds <torvalds@linux-foundation.org>  2009-11-08 21:05:37 ---
On Sun, 8 Nov 2009, bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> It's pretty simple to do this; in fact it's a one-line change in
> ext4_symlink() in fs/ext4/inode.c:
> 
>         /* clear the extent format for fast symlink */
>         EXT4_I(inode)->i_flags &= ~EXT4_EXTENTS_FL;
>         inode->i_op = &ext4_fast_symlink_inode_operations;
> -        memcpy((char *)&EXT4_I(inode)->i_data, symname, l);
> +        strcpy((char *)&EXT4_I(inode)->i_data, symname);
>         inode->i_size = l-1;

I think that's wrong.

First off, it's slower. Secondly, 'l' is already 'strlen+1', so it looks 
like ext4 _already_ copies the NUL terminating character.

So I suspect the debugging patch complained about writing a NUL to a 
location that was already NUL to begin with.

        Linus

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
