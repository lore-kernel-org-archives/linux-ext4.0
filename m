From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17361] Watchdog detected hard LOCKUP in
 jbd2_journal_get_write_access
Date: Tue, 14 Sep 2010 18:08:43 GMT
Message-ID: <201009141808.o8EI8hDJ024317@demeter1.kernel.org>
References: <bug-17361-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54302 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab0INSIo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Sep 2010 14:08:44 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o8EI8hkP024318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 14 Sep 2010 18:08:44 GMT
In-Reply-To: <bug-17361-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D17361





--- Comment #3 from Rafael J. Wysocki <rjw@sisk.pl>  2010-09-14 18:08:3=
1 ---
On Tuesday, September 14, 2010, Christian Casteyde wrote:
> Yes, still present, as well as my other bug that says that the system=
 freezes=20
> short after the boot.
>=20
> Le dimanche 12 septembre 2010 20:14:29, vous avez =C3=A9crit :
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
> > Date		: 2010-08-29 19:59 (15 days old)

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
