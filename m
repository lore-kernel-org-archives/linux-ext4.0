From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: Filesystem recovery - e2fsck seems to have caused my filesystem
 to get wiped
Date: Wed, 30 Oct 2013 17:00:04 +0100
Message-ID: <52712D04.1030104@fastmail.fm>
References: <1829785915.95.1383138487671.JavaMail.root@reganw.com> <5271297B.7040101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <sandeen@redhat.com>,
	Regan Wallace <regan@reganw.com>, linux-ext4@vger.kernel.org,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:34797 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab3J3QAQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Oct 2013 12:00:16 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id r9UG07d8018852
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Wed, 30 Oct 2013 17:00:12 +0100
In-Reply-To: <5271297B.7040101@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>
> # tune2fs -f -O ^has_journal sda1.img
> tune2fs 1.41.12 (17-May-2010)
> The needs_recovery flag is set.  Please run e2fsck before clearing
> the has_journal flag.
>
> nope, not even with force.  Grr.
>
> Maybe this will work; get the journal inode number & clear it:
>
> # dumpe2fs -h sda1.img  | grep "Journal inode"
> dumpe2fs 1.41.12 (17-May-2010)
> Journal inode:            8
>
> # debugfs -w -R "clri <8>" sda1.img
>
> now e2fsck will think the journal is invalid & just zap it:
>
> e2fsck 1.41.12 (17-May-2010)
> Superblock has an invalid journal (inode 8).
> Clear<y>?
>
> *maybe* that will get your e2fsck past the journal recovery problem
> w/o needing the mkfs.ext4 -S giant hammer.

Why not just unset the journal feature bit using debugfs?

debugfs -w -R "features ^has_journal"  sda1.img


And I would update e2fsprogs to the current version.


Cheers,
Bernd
