From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Is it possible for the ext4/btrfs file system to pass some context related info to low level block driver?
Date: Tue, 03 May 2011 09:43:29 -0400
Message-ID: <yq1mxj32932.fsf@sermon.lab.mkp.net>
References: <CE761E84DADF2947A4AF22FB8D97A47358E28022@shsmsx501.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "linux-btrfs\@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>
To: "Gao\, Yunpeng" <yunpeng.gao@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:46505 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab1ECNnm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 May 2011 09:43:42 -0400
In-Reply-To: <CE761E84DADF2947A4AF22FB8D97A47358E28022@shsmsx501.ccr.corp.intel.com>
	(Yunpeng Gao's message of "Tue, 3 May 2011 10:44:07 +0800")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Yunpeng" == Gao, Yunpeng <yunpeng.gao@intel.com> writes:

Yunpeng> So, my question is, is there any plan or discussion on
Yunpeng> supporting this feature (passing data type info to low level
Yunpeng> block device driver) on file system developments? Especially
Yunpeng> for ext4/btrfs, since now they are very hot in Linux? Thanks.

Yes, I have been working on some changes that allow us to tag bios and
pass the information out to storage. These patches have been on the back
burner for a while due to other commitments. But I'll dig them out and
post them later. We just discussed them a couple of weeks ago at the
Linux Storage Workshop.

In the meantime: Can you point me to the relevant eMMC stuff so I can
see how many tiers or classes we have to work with there?

-- 
Martin K. Petersen	Oracle Linux Engineering
