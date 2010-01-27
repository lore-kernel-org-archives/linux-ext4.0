From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15018] ext4 backtraces out of nowhere
Date: Wed, 27 Jan 2010 09:46:43 GMT
Message-ID: <201001270946.o0R9kh5s012203@demeter.kernel.org>
References: <bug-15018-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37062 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab0A0Jqo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Jan 2010 04:46:44 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0R9kh9r012205
	for <linux-ext4@vger.kernel.org>; Wed, 27 Jan 2010 09:46:43 GMT
In-Reply-To: <bug-15018-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15018





--- Comment #6 from Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>  2010-01-27 09:46:39 ---
On Tue, 26 Jan 2010 23:19:23 GMT, bugzilla-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=15018
> 
> 
> 
> 
> 
> --- Comment #4 from Jan Kara <jack@suse.cz>  2010-01-26 23:19:18 ---
> Hmm, I don't like the code in ext4_da_reserve_space even after your patch - the
> retries are duplicated with the ones from ext4_da_write_begin and calling
> write_inode_now from ext4_da_write_begin doesn't make too much sense either -
> why not write all inodes with delayed allocation if we want to write something?
> 
> Actually, instead of retrying delayed allocation, I think it makes more sense
> to just fall back to normal allocation. Attached patch does that and it also
> allows me to completely fill user's quota.
> 

Switching to non delayed allocation may not guarantee that we succeed in block
allocation. For quota we really need to flush this inode. Even if we
flush other inodes of other user we may still get a quota error

-aneesh

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
