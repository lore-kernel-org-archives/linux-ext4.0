From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH v2] ext4: fix initialization of UNINIT bitmap blocks
Date: Tue, 23 Sep 2008 17:13:46 -0600
Message-ID: <20080923231346.GT10950@webber.adilger.int>
References: <1221478895.6733.26.camel@frecb007923.frec.bull.fr>
 <1221481007.6733.32.camel@frecb007923.frec.bull.fr>
 <20080915133604.GA6548@skywalker>
 <1221489026.6733.36.camel@frecb007923.frec.bull.fr>
 <1221745514.3550.83.camel@frecb007923.frec.bull.fr>
 <20080921004451.GA15402@mit.edu>
 <1222070998.3581.25.camel@frecb007923.frec.bull.fr>
 <20080922084721.GA6691@skywalker>
 <1222075960.3581.33.camel@frecb007923.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: =?utf-8?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:59298 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbYIWXOZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Sep 2008 19:14:25 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8NNEKDw006031
	for <linux-ext4@vger.kernel.org>; Tue, 23 Sep 2008 16:14:20 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K7O00A018DV4200@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 23 Sep 2008 16:14:20 -0700 (PDT)
In-reply-to: <1222075960.3581.33.camel@frecb007923.frec.bull.fr>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 22, 2008  11:32 +0200, Fr=EF=BF=BDd=EF=BF=BDric Boh=EF=BF=BD wro=
te:
> Le lundi 22 septembre 2008 =C3=A0 14:17 +0530, Aneesh Kumar K.V a =C3=
=A9crit :
> > What you can do is make ext4_group_info generic for both mballoc an=
d
> > oldalloc. We can then add bg_flag to the in memory ext4_group_info
> > that would indicate whether the group is initialized or not. Here
> > initialized for an UNINIT_GROUP indicate we have done
> > ext4_init_block_bitmap on the buffer_head. Then=20
> > instead of depending on the buffer_head uptodate flag we can check
> > for the ext4_group_info bg_flags and decided whether the block/inod=
e
> > bitmap need to be initialized.
>=20
> That makes sense ! I agree with you, we need an additional in-memory
> flag to know whether buffers are initialized or not. Anyway, making
> ext4_group_info generic will lead to unneeded memory consumption for
> oldalloc. Maybe a simple independent bits array could do the trick. I=
s
> there any advantage to re-use ext4_group_info ?

=46or ext4 I think 99% of users will use mballoc, and the reduction in =
code
complexity is itself useful.  I don't think the in-memory overhead is v=
ery
much, maybe 1 MB per TB of filesystem space.

Also, if you are considering this approach (to initialize the in-memory
bitmaps at mount time) they should be written to disk even if unused.
Please also consider doing the inode table zeroing at the same time.
This would allow uninit_bg to avoid doing it at mke2fs time.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
