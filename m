From: Eric Sandeen <sandeen@redhat.com>
Subject: Should journaled quota be default for ext4?
Date: Thu, 25 Mar 2010 23:30:24 -0500
Message-ID: <4BAC3860.7010905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074Ab0CZEa3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Mar 2010 00:30:29 -0400
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2Q4UT4U014612
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 00:30:29 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o2Q4UOVr000624
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 00:30:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted's email about quotacheck made me think:

Is there a reason that journaled quota is not default for ext4?
(or ext3 for that matter, but we're not messing with that now)

IOW - if we do mount -o quota, is there any reason that we should
also need more options to journal that quota?  When would we not
want journaled quota?

(Forgive me if it's a dumb question, I'm not as well versed in
extN quota as I probably should be).

-Eric
