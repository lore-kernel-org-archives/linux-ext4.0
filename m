From: Alex Tomas <alex@clusterfs.com>
Subject: Re: Ext4 devel interlock meeting minutes (Nov. 29 2006)
Date: Wed, 29 Nov 2006 22:08:13 +0300
Message-ID: <m3hcwiul42.fsf@bzzz.home.net>
References: <456DD933.2090304@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.248.82] ([80.71.248.82]:26805 "EHLO gw.home.net")
	by vger.kernel.org with ESMTP id S967573AbWK2TIf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Nov 2006 14:08:35 -0500
To: Avantika Mathur LTC <mathur@us.ibm.com>
In-Reply-To: <456DD933.2090304@us.ibm.com> (Avantika Mathur's message of "Wed\,
	29 Nov 2006 11\:02\:11 -0800")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


>>>>> Avantika Mathur LTC (AML) writes:

 AML>     o reduce file fragmentation because less extents are needed for
 AML> large files

say, current limit for a single extent is 2^15 blocks or 128MB.
after regular mke2fs, a group has ~125MB free.

thanks, Alex
