From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: creation time stamps for ext4 ?
Date: Thu, 5 Oct 2006 09:19:37 -0600
Message-ID: <20061005151937.GV22010@schatzie.adilger.int>
References: <E1GVUd2-0006O6-00@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext3-users@redhat.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:53739 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1751495AbWJEPTj
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Oct 2006 11:19:39 -0400
To: =?utf-8?Q?Bj=F6rn?= JACKE <bjacke@sernet.de>
Content-Disposition: inline
In-Reply-To: <E1GVUd2-0006O6-00@intern.SerNet.DE>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 05, 2006  15:57 +0200, Bj=EF=BF=BDrn JACKE wrote:
> I would like to know if there are any plans to introduce a creation=20
> timestamp in future ext3/4 versions. Having a 4th timestamp saving th=
e=20
> creation time would be very good for projekts like Samba for example.=
=20
> It would be important that creation time can also be set manually=20
> later on by some system call. Systems like FreeBSD's UFS and Solais'=20
> ZFS already support creation times. Unfortunately Linux doesn't have=20
> such a thing standarized anywhere but it would be geat if it would.
>=20
> Are there any plans to add this?

I've given this some thought for adding as part of the nsec timestamp
patch.  That is more feasable if we move the nsec ctime into the main
inode to double as the version field.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

-
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
