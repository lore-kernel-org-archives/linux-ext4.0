From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 00/16] ext4: Add metadata checksumming
Date: Tue, 06 Sep 2011 08:59:53 -0400
Message-ID: <yq18vq17rna.fsf@sermon.lab.mkp.net>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
	<CAGpXXZ+Cq9_aS4BPC5BKNj6aWHzzL7+e8ZQKO3=C7UV+xcnqWA@mail.gmail.com>
	<20110902182214.GC12086@tux1.beaverton.ibm.com>
	<yq1d3fgwn5c.fsf@sermon.lab.mkp.net>
	<20110905184524.GQ12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:51482 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab1IFNA4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Sep 2011 09:00:56 -0400
In-Reply-To: <20110905184524.GQ12086@tux1.beaverton.ibm.com> (Darrick
	J. Wong's message of "Mon, 5 Sep 2011 11:45:24 -0700")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Darrick" == Darrick J Wong <djwong@us.ibm.com> writes:

Darrick> I have some benchmarking data for various crc algorithms here:
Darrick> https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums#Benchmarking

I've been meaning to update my own benchmark results from a few years
ago but your table is much more comprehensive. Nice work!


Darrick> Yes, the only downside to the slice-by-8 method is that it eats
Darrick> 8K of data cache for the table.  Not a huge issue on recent
Darrick> Intel and POWER where the L1D is 32K, but I imagine it could be
Darrick> painful elsewhere.

I'll see if I can come up with something better for the DIF CRC. It's
always calculated over either 512 or 4096-byte buffers.

-- 
Martin K. Petersen	Oracle Linux Engineering
