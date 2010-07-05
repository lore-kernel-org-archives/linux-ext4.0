From: Eric Sandeen <sandeen@redhat.com>
Subject: extent counting fun
Date: Mon, 05 Jul 2010 14:24:52 -0500
Message-ID: <4C323184.8020401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590Ab0GETY4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Jul 2010 15:24:56 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o65JOuJg024447
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 5 Jul 2010 15:24:56 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o65JOrWd017541
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 5 Jul 2010 15:24:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[root@host ~]# filefrag -B /mnt/test/file
/mnt/test/file: 34 extents found
[root@host ~]# filefrag /mnt/test/file
/mnt/test/file: 1058 extents found, perfection would be 1 extent

Hum, is it 34 or 1058? :)

Older filefrag counted contiguous metadata as part of a contiguous
extent... newer filefrag works in fiemap query-only mode by default,
and just takes what fiemap tells it.  The inconsistency is weird
though, and led to a Red Hat bug that I'm inclined to NOTABUG... but
do people think this needs to be made any more consistent?

Should we hack ext3_fiemap() to include the checks for contiguous
metadata?  Or was that too shady/clever to start with ...? :)

-Eric
