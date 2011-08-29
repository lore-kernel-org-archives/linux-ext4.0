From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 41502] cfq-iosched: a regression
Date: Mon, 29 Aug 2011 21:33:16 GMT
Message-ID: <201108292133.p7TLXGxT009091@demeter1.kernel.org>
References: <bug-41502-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:40294 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab1H2VdS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Aug 2011 17:33:18 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p7TLXGhH009097
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 29 Aug 2011 21:33:16 GMT
In-Reply-To: <bug-41502-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=41502





--- Comment #1 from Rafael J. Wysocki <rjw@sisk.pl>  2011-08-29 21:33:11 ---
On Monday, August 29, 2011, Shaohua Li wrote:
> On Mon, 2011-08-29 at 02:30 +0800, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 3.0.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=41502
> > Subject		: cfq-iosched: a regression
> > Submitter	: Shaohua Li <shaohua.li@intel.com>
> > Date		: 2011-08-16 2:47 (13 days old)
> > 
> the offending commit is reverted.
> b53d1ed734a2b9af8da115b836b658daa7d47a48

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.