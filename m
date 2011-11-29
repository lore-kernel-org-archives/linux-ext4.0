From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH v2.1 00/50] e2fsprogs: Add metadata checksumming
Date: Mon, 28 Nov 2011 22:17:35 -0700
Message-ID: <484E5140-D0E7-4BE2-BF59-F88406D95E8C@dilger.ca>
References: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:16785 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab1K2FRg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Nov 2011 00:17:36 -0500
In-Reply-To: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-11-28, at 5:27 PM, Darrick J. Wong wrote:
> This patchset adds support in e2fsprogs for attaching crc32c checksums to most of the ext4 metadata objects.  A full design document is on the
> ext4 wiki[1].  Please see the cover letter for the kernel patches for a
> more thorough summary of this work.
> 
> [1] https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums

This URL has changed:

https://ext4.wiki.kernel.org/articles/e/x/t/Ext4_Metadata_Checksums_4d24.html

It would also be useful to include in this wiki page the tests you
did for the checksum speed of different algorithms at different chunk
sizes, since checksums of 512MB of data are few and far between
(especially since this is not computing the checksum of file data).

Cheers, Andreas





