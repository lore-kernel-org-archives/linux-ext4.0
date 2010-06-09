From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16122] 2.6.35-rc1: WARNING at fs/fs-writeback.c:1142
 __mark_inode_dirty+0x103/0x170
Date: Wed, 9 Jun 2010 08:50:23 GMT
Message-ID: <201006090850.o598oNg7020402@demeter.kernel.org>
References: <bug-16122-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34746 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab0FIIuY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jun 2010 04:50:24 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o598oN3g020403
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jun 2010 08:50:23 GMT
In-Reply-To: <bug-16122-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16122





--- Comment #9 from Rafael J. Wysocki <rjw@sisk.pl>  2010-06-09 08:50:19 ---
On Wednesday 09 June 2010, Larry Finger wrote:
> On 06/08/2010 05:10 PM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.34.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16122
> > Subject		: 2.6.35-rc1: WARNING at fs/fs-writeback.c:1142 __mark_inode_dirty+0x103/0x170
> > Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> > Date		: 2010-06-04 13:18 (5 days old)
> 
> Still present in 2.6.35-rc2.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.