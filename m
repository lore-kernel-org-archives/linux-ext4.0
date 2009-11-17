From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14620] WARNING: at mm/page_alloc.c:1805 __alloc_pages_nodemask
Date: Tue, 17 Nov 2009 22:51:54 GMT
Message-ID: <200911172251.nAHMpsae011703@demeter.kernel.org>
References: <bug-14620-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49627 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576AbZKQWvs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Nov 2009 17:51:48 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAHMpsOY011716
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2009 22:51:54 GMT
In-Reply-To: <bug-14620-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=3D14620





--- Comment #1 from Rafael J. Wysocki <rjw@sisk.pl>  2009-11-17 22:51:5=
4 ---
On Tuesday 17 November 2009, Theodore Tso wrote:
> On Mon, Nov 16, 2009 at 11:37:47PM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >=20
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me=
 know
> > (either way).
> >=20
> >=20
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D14620
> > Subject		: WARNING: at mm/page_alloc.c:1805 __alloc_pages_nodemask
> > Submitter	: Rog=C3=A9rio Brito <rbrito@ime.usp.br>
> > Date		: 2009-11-06 23:10 (11 days old)
> > References	: http://marc.info/?l=3Dlinux-kernel&m=3D125754907413892=
&w=3D4
>=20
> This isn't technically a regression, since the warning is simply
> complaining about something that apparently ext4 has been doing for a
> long time, which is that it allocates some very large order data
> buffers.  So the change referenced simply printed a warning message
> that complained about the fact.
>=20
> The actual problem will be fixed in 2.6.32, as we no longer allocate
> the big data buffers at mount time.

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
