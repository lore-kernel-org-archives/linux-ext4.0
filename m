From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH, RFC] Don't do page stablization if !CONFIG_BLKDEV_INTEGRITY
Date: Thu, 08 Mar 2012 20:08:39 -0500
Message-ID: <yq14ntyeg2w.fsf@sermon.lab.mkp.net>
References: <E1S5QTU-0005Cc-Kl@tytso-glaptop.cam.corp.google.com>
	<4F57F523.3020703@redhat.com> <4F581BF6.8000305@zabbo.net>
	<20120308155419.GB6777@thunk.org> <20120308180951.GB29510@shiny>
	<4F59148A.4070001@panasas.com> <20120308212412.GC11861@thunk.org>
	<20120308213808.GK29510@shiny> <20120308214148.GD11861@thunk.org>
	<20120309010207.GM29510@shiny>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Ted Ts'o" <tytso@mit.edu>, Boaz Harrosh <bharrosh@panasas.com>,
	Zach Brown <zab@zabbo.net>, Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:33372 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab2CIBIt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Mar 2012 20:08:49 -0500
In-Reply-To: <20120309010207.GM29510@shiny> (Chris Mason's message of "Thu, 8
	Mar 2012 20:02:07 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Chris" == Chris Mason <chris.mason@oracle.com> writes:

Chris> Btrfs crcs before submit_bio, not sure when the dif code does it.

Slightly later. At make_request time.

-- 
Martin K. Petersen	Oracle Linux Engineering
