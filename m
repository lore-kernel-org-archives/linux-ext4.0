From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ixt3
Date: Tue, 17 Oct 2006 02:51:30 -0600
Message-ID: <20061017085130.GX6221@schatzie.adilger.int>
References: <20061017103617.cb1a34c2.pegasus@nerv.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:6557 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1423180AbWJQIvc
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Oct 2006 04:51:32 -0400
To: Jure =?utf-8?B?UGXEjWFy?= <pegasus@nerv.eu.org>
Content-Disposition: inline
In-Reply-To: <20061017103617.cb1a34c2.pegasus@nerv.eu.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 17, 2006  10:36 +0200, Jure Pe=C4=8Dar wrote:
> http://www.cs.wisc.edu/adsl/Publications/iron-sosp05.pdf
>=20
> I think I got this link from OLS papers or from fs workshop ... and I=
 really like what it says.
>=20
> How many of ixt3 features are going to be implemented in ext4?=20

None, yet.  The journal checksum code has been brought into a basically
"ready-to-go" state, and there is also work to add checksums to the gro=
up
descriptors, so there is some chance that this will be added before ext=
4
is declared "closed".

Nothing done yet to checksum inodes, superblock, file index
or extent blocks.  None of the retry code has been looked at.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
