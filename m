From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V5] ext4: fix BUG when calling ext4_error with locked
	block group
Date: Wed, 3 Dec 2008 10:57:31 +0530
Message-ID: <20081203052731.GB9481@skywalker>
References: <1228198197-23752-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1228258056.6378.20.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:41154 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbYLCFc5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Dec 2008 00:32:57 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id mB35VPOL002091
	for <linux-ext4@vger.kernel.org>; Wed, 3 Dec 2008 16:31:25 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB35SFYO4223230
	for <linux-ext4@vger.kernel.org>; Wed, 3 Dec 2008 16:28:15 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mB35Rnww020849
	for <linux-ext4@vger.kernel.org>; Wed, 3 Dec 2008 16:27:49 +1100
Content-Disposition: inline
In-Reply-To: <1228258056.6378.20.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 02, 2008 at 02:47:36PM -0800, Mingming Cao wrote:
>=20
> =E5=9C=A8 2008-12-02=E4=BA=8C=E7=9A=84 11:39 +0530=EF=BC=8CAneesh Kum=
ar K.V=E5=86=99=E9=81=93=EF=BC=9A
> > The mballoc code likes to call ext4_error while it is holding locke=
d
> > block groups.  This can causes a scheduling in atomic context BUG. =
 We
> > can't just unlock the block group and relock it after/if ext4_error
> > returns since that might result in race conditions in the case wher=
e
> > the filesystem is set to continue after finding errors.
> >=20
> > -V5 changes:
> > update ext4_commit_super to use the percpu free blocks and free ino=
des
> > counter values.
> >=20
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> > ---
> >  fs/ext4/ext4.h    |   47 +++++++++++++++++++++++++++++++++++++++++=
++++++
> >  fs/ext4/mballoc.c |   30 +++++++++++++++---------------
> >  fs/ext4/mballoc.h |   47 -----------------------------------------=
------
> >  fs/ext4/super.c   |   45 +++++++++++++++++++++++++++++++++++++++++=
++--
> >  4 files changed, 105 insertions(+), 64 deletions(-)
>=20
>=20
>=20
> >  void ext4_update_dynamic_rev(struct super_block *sb)
> >  {
> >  	struct ext4_super_block *es =3D EXT4_SB(sb)->s_es;
> > @@ -2820,8 +2858,11 @@ static void ext4_commit_super(struct super_b=
lock *sb,
> >  		set_buffer_uptodate(sbh);
> >  	}
> >  	es->s_wtime =3D cpu_to_le32(get_seconds());
> > -	ext4_free_blocks_count_set(es, ext4_count_free_blocks(sb));
> > -	es->s_free_inodes_count =3D cpu_to_le32(ext4_count_free_inodes(sb=
));
> > +	ext4_free_blocks_count_set(es, percpu_counter_sum_positive(
> > +					&EXT4_SB(sb)->s_freeblocks_counter));
> > +	es->s_free_inodes_count =3D cpu_to_le32(percpu_counter_sum_positi=
ve(
> > +					&EXT4_SB(sb)->s_freeinodes_counter));
> > +
> >  	BUFFER_TRACE(sbh, "marking dirty");
> >  	mark_buffer_dirty(sbh);
> >  	if (sync) {
>=20
> I thought the per cpu s_freeblocks_counter is not as accurate as the =
sum
> of group free blocks counters, we are depending on
> ext4_count_free_blocks() to gets the accurate free blocks counter
> flushed to disk...
>=20

The super block values are not used in the kernel. A wrong value of
free_blocks/free_inode count in super block will be fixed by a
subsequent e2fsck. I guess we can afford to have less accurate value
of free_blocks/free_inodes in super block.

-aneesh


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
