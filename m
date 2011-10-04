From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: mkfs'ing a 48-bit fs... or not.
Date: Tue, 4 Oct 2011 08:06:13 +0100
Message-ID: <20111004070613.GA10216@amd.home.annexia.org>
References: <4E8A2F3F.30700@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab1JDHGU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Oct 2011 03:06:20 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p9476KNM025756
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 4 Oct 2011 03:06:20 -0400
Received: from localhost (vpn1-7-184.ams2.redhat.com [10.36.7.184])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p9476IYX008976
	for <linux-ext4@vger.kernel.org>; Tue, 4 Oct 2011 03:06:19 -0400
Content-Disposition: inline
In-Reply-To: <4E8A2F3F.30700@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Thanks Eric.  Here is the original thread (see also the replies).

https://lists.fedoraproject.org/pipermail/devel/2011-October/157618.html

In theory I could test this up to ~ 2**63, but it requires a number of
bugfixes and changes in qemu.  Obviously that size is ridiculous :-)
but it may reveal bugs that wouldn't be found by ordinary testing.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-p2v converts physical machines to virtual machines.  Boot with a
live CD or over the network (PXE) and turn machines into Xen guests.
http://et.redhat.com/~rjones/virt-p2v
