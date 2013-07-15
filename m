From: Eric Sandeen <sandeen@redhat.com>
Subject: fallocated blocks past EOF & past parent node range OK?
Date: Mon, 15 Jul 2013 10:19:12 -0500
Message-ID: <51E412F0.3040206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932364Ab3GOPTT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Jul 2013 11:19:19 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r6FFJH0h020079
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 15 Jul 2013 11:19:18 -0400
Received: from Liberator-563.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r6FFJCBP032011
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 15 Jul 2013 11:19:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm sorry I missed the conversation earlier this morning, but ewhitney let me know that the consensus was that for fallocated blocks past EOF, it's fine to have those blocks live outside the parent node's range in the extent tree.

This seems quite strange to me, and unexpected.

What is the rationale for this?  Why would these past-EOF extents look unique in the extent tree, and not be covered by the parent node?

Thanks,
-Eric
