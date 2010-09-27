From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17361] Watchdog detected hard LOCKUP in
 jbd2_journal_get_write_access
Date: Mon, 27 Sep 2010 19:26:49 GMT
Message-ID: <201009271926.o8RJQnWX026776@demeter2.kernel.org>
References: <bug-17361-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:59025 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759624Ab0I0T0u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Sep 2010 15:26:50 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o8RJQnlD026777
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 27 Sep 2010 19:26:49 GMT
In-Reply-To: <bug-17361-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D17361





--- Comment #13 from Rafael J. Wysocki <rjw@sisk.pl>  2010-09-27 19:26:=
48 ---
On Monday, September 27, 2010, Christian Casteyde wrote:
> Still present in rc5-git7.
>=20
>=20
> Le dimanche 26 septembre 2010 22:04:13, vous avez =C3=A9crit :
> > This message has been generated automatically as a part of a summar=
y report
> > of recent regressions.
> >=20
> > The following bug entry is on the current list of known regressions
> > from 2.6.35.  Please verify if it still should be listed and let th=
e
> > tracking team know (either way).
> >=20
> >=20
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D17361
> > Subject		: Watchdog detected hard LOCKUP in=20
> jbd2_journal_get_write_access
> > Submitter	: Christian Casteyde <casteyde.christian@free.fr>
> > Date		: 2010-08-29 19:59 (29 days old)

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
