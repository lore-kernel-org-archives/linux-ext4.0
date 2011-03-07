From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29312] Unmounting fails even after the underlying device is
 long gone
Date: Mon, 7 Mar 2011 20:39:34 GMT
Message-ID: <201103072039.p27KdY5V013813@demeter2.kernel.org>
References: <bug-29312-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:54435 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab1CGUje (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Mar 2011 15:39:34 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p27KdY5r013817
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 7 Mar 2011 20:39:34 GMT
In-Reply-To: <bug-29312-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29312





--- Comment #1 from Rafael J. Wysocki <rjw@sisk.pl>  2011-03-07 20:39:33 ---
On Monday, March 07, 2011, Bart Van Assche wrote:
> On Sun, Mar 6, 2011 at 1:10 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.37.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=29312
> > Subject         : Unmounting fails even after the underlying device is long gone
> > Submitter       : Bart Van Assche <bart.vanassche@gmail.com>
> > Date            : 2011-02-17 19:20 (18 days old)
> 
> Unmounting works fine again with 2.6.38-rc7+, but I see now a huge
> number of error messages in the system log:
> # grep -c '^Mar  7 18:37:4.* kernel: sd 6:0:0:0: rejecting I/O to
> offline device$' /var/log/messages
> 4987

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
