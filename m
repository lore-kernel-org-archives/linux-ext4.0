From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16312] WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
Date: Fri, 23 Jul 2010 20:11:24 GMT
Message-ID: <201007232011.o6NKBOo0030002@demeter.kernel.org>
References: <bug-16312-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42421 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab0GWUL0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Jul 2010 16:11:26 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o6NKBPne030003
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 23 Jul 2010 20:11:25 GMT
In-Reply-To: <bug-16312-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16312





--- Comment #4 from Rafael J. Wysocki <rjw@sisk.pl>  2010-07-23 20:11:24 ---
On Friday, July 23, 2010, Larry Finger wrote:
> On 07/23/2010 06:42 AM, Rafael J. Wysocki wrote:
> > This message contains a list of some regressions from 2.6.34,
> > for which there are no fixes in the mainline known to the tracking team.
> > If any of them have been fixed already, please let us know.
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16312
> > Subject		: WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
> > Submitter	: Zdenek Kabelac<zdenek.kabelac@gmail.com>
> > Date		: 2010-06-28 9:40 (26 days old)
> 
> I still have this in 2.6.35-rc5.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.