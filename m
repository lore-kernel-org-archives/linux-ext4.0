From: Joakim Ziegler <joakim@terminalmx.com>
Subject: What happened to e4defrag relevant file and free space defrag?
Date: Sat, 23 Aug 2014 06:04:50 -0500
Message-ID: <53F87552.6050000@terminalmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from famine.copyleft.no ([188.94.218.115]:63062 "EHLO
	mail9.copyleft.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaHWLbU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Aug 2014 07:31:20 -0400
Received: from 187-176-226-3.dynamic.axtel.net ([187.176.226.3] helo=deck.local)
	by mail9.copyleft.no with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.72 (FreeBSD))
	(envelope-from <joakim@terminalmx.com>)
	id 1XL97y-000F9E-5U
	for linux-ext4@vger.kernel.org; Sat, 23 Aug 2014 13:04:58 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm using ext4 on quite large filesystems, for large image sequences. S=
ome times=20
these file systems fill up, and things get fragmented and a lot slower.

When reading this presentation from Linuxcon Japan 2010:

https://events.linuxfoundation.org/slides/2010/linuxcon_japan/linuxcon_=
jp2010_fujita.pdf

I see references to "relevant file defrag", which would be useable for =
me to=20
defrag image sequences to get them in sequence, specifically:

"Patches related to relevant file defrag (e4defrag -r) are under review=
=2E"

Also, about free space defrag, it says:

"Implement free space defragmentation (e4defrag -f). We might implement=
 this=20
feature when the relevant defrag development is completed."

Both of these, but especially relevant file defrag, would be very usefu=
l to=20
solve the problems I'm facing. What happened to the patches that were u=
nder=20
review? Was anything done? Was development of these features abandoned?=
 Is there=20
any chance of any of them being implemented in the relatively near futu=
re?

--=20
Joakim Ziegler  -  Supervisor de postproducci=F3n  -  Terminal
joakim@terminalmx.com   -   044 55 2971 8514   -   5264 0864
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
