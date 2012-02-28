From: Eric Sandeen <sandeen@redhat.com>
Subject: Why does e2fsck stop on system clock differences?
Date: Tue, 28 Feb 2012 10:22:13 -0600
Message-ID: <4F4CFF35.2040504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756251Ab2B1QWP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Feb 2012 11:22:15 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q1SGMFO1031568
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 28 Feb 2012 11:22:15 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q1SGMEjP002725
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 28 Feb 2012 11:22:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've got Fedora users concerned (again) about clock problems stopping their boot in e2fsck.

I know about the +/- 24h slop, and the broken_system_clock e2fsck.conf setting, which we might just set to do away with this issue.

But I wonder if I can get a little historical perspective from the extN elders on why e2fsck is so clock-obsessed. (I think this has been discussed in other threads, but I'm not finding them now)

What are the actual risks if we just ignore time differences at fsck time, can we get this stated on the record (hopefully in a somewhat google-able $SUBJECT?)

Thanks,
-Eric
