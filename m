From: Eric Sandeen <sandeen@redhat.com>
Subject: "- 8" in EXT2_MAX_BLOCKS_PER_GROUP
Date: Mon, 10 Oct 2011 10:50:43 -0500
Message-ID: <4E931453.3010002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab1JJPuq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Oct 2011 11:50:46 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p9AFojEm018858
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 10 Oct 2011 11:50:46 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p9AFoiE4031094
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 10 Oct 2011 11:50:44 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When looking at the maximal filesystem size issue, I found myself
wondering what the "- 8" is in here, it's not commented
or documented anywhere:

#define EXT2_MAX_BLOCKS_PER_GROUP(s)    (((1 << 16) - 8) *      \
                                          (EXT2_CLUSTER_SIZE(s) / \
                                           EXT2_BLOCK_SIZE(s)))


(pre-bigalloc, it was just ((1 << 16) - 8) )

Anyone know?

-Eric

