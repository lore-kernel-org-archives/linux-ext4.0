From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13369] kernel BUG at fs/ext4/inode.c:3123
Date: Sun, 24 May 2009 18:28:23 GMT
Message-ID: <200905241828.n4OISN1R025683@demeter.kernel.org>
References: <bug-13369-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34221 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbZEXS2V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 May 2009 14:28:21 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4OISNNH025684
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2009 18:28:23 GMT
In-Reply-To: <bug-13369-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13369





--- Comment #11 from Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>  2009-05-24 18:28:23 ---
On Sun, May 24, 2009 at 02:52:48AM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=13369
> 
> 
> Theodore Tso <tytso@mit.edu> changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |tytso@mit.edu
> 
> 
> 
> 
> --- Comment #5 from Theodore Tso <tytso@mit.edu>  2009-05-24 02:52:48 ---
> So I'm glad you're using a filesystem with a 1k blocksize since it provides a
> good test case for us --- and we don't do enough testing for the case where the
> blocksize != pagesize.   But you do realize that the ext4 filesystem will be
> far more efficient with the larger 4k blocksize, right?
> 
> I'm not able to reproduce the problem on a filesystem with 1k blocksize running
> fsx, fsstress, and dbench using a 2.6.30-rc6 kernel with the full ext4 patch
> queue, using a netbook with an dual-core N270 Atom processor.   I'm retrying
> with a stock 2.6.30-rc6 kernel now...
> 

It is with nodelalloc. I am also finding some unmapped buffer_heads in
nodelalloc mode with data=journal. See the latest update for bug

http://bugzilla.kernel.org/show_bug.cgi?id=12624

-aneesh

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
