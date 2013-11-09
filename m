From: David Turner <novalis@novalis.org>
Subject: [PATCH] ext4: explain encoding of 34-bit a,c,mtime values
Date: Sat, 09 Nov 2013 02:19:11 -0500
Message-ID: <1383981551.8994.27.camel@chiang>
References: <1383808590.23882.13.camel@chiang>
	 <20131107160341.GA3850@quack.suse.cz> <1383864864.23882.33.camel@chiang>
	 <20131107231445.GG2054@quack.suse.cz> <1383866807.23882.41.camel@chiang>
	 <D8C465B6-15A7-473A-BA26-8037AF9CE739@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailbigip.dreamhost.com ([208.97.132.5]:37670 "EHLO
	homiemail-a39.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932616Ab3KIHTO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Nov 2013 02:19:14 -0500
In-Reply-To: <D8C465B6-15A7-473A-BA26-8037AF9CE739@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2013-11-08 at 14:37 -0700, Andreas Dilger wrote:
> On Nov 7, 2013, at 4:26 PM, David Turner <novalis@novalis.org> wrote:
> > On Fri, 2013-11-08 at 00:14 +0100, Jan Kara wrote:
> >> Still unnecessary type cast here (but that's a cosmetic issue).
> > ...
> >> Otherwise the patch looks good. You can add:
> >> Reviewed-by: Jan Kara <jack@suse.cz>
> >=20
> > Thanks.  A version with this correction and the reviewed-by follows=
=2E
>=20
> Thanks for working on this.  It was (seriously) in my list of things =
to
> get done, but I figured I still had a few years to work on it...
>=20
> My (unfinished) version of this patch had a nice comment at ext4_enco=
de_time()
> that explained the encoding that is being used very clearly:
>=20
> /*
>  * We need is an encoding that preserves the times for extra epoch "0=
0":
>  *
>  * extra  msb of                         adjust for signed
>  * epoch  32-bit                         32-bit tv_sec to
>  * bits   time    decoded 64-bit tv_sec  64-bit tv_sec      valid tim=
e range
>  * 0 0    1    -0x80000000..-0x00000001  0x000000000     1901-12-13..=
1969-12-31
>  * 0 0    0    0x000000000..0x07fffffff  0x000000000     1970-01-01..=
2038-01-19
>  * 0 1    1    0x080000000..0x0ffffffff  0x100000000     2038-01-19..=
2106-02-07
>  * 0 1    0    0x100000000..0x17fffffff  0x100000000     2106-02-07..=
2174-02-25
>  * 1 0    1    0x180000000..0x1ffffffff  0x200000000     2174-02-25..=
2242-03-16
>  * 1 0    0    0x200000000..0x27fffffff  0x200000000     2242-03-16..=
2310-04-04
>  * 1 1    1    0x280000000..0x2ffffffff  0x300000000     2310-04-04..=
2378-04-22
>  * 1 1    0    0x300000000..0x37fffffff  0x300000000     2378-04-22..=
2446-05-10
>  */
>=20
> It seems that your version of the patch seems to use a different enco=
ding.  Not
> that this is a problem, per-se, since my patch wasn=E2=80=99t in use =
anywhere, but it
> would be nice to have a similarly clear explanation of what the mappi=
ng is so
> that it can be clearly understood.

I have included a patch with an explanation (the patch is against
tytso/dev -- I hope that's the correct place). =20

> My ext4_{encode,decode}_extra_time() used add/subtract instead of mas=
k/OR ops,
> which changed the on-disk format for times beyond 2038, but those wer=
e already
> broken, and presumably not in use by anyone yet.=20

They were actually correct according to my patch's encoding (that is, m=
y
patch used the existing encoding).  The existing encoding was written
correctly, but read wrongly.  As you say, this should not matter, since
nobody should be writing these timestamps, but I assumed that the
existing encoding had happened for a reason, and wanted to make the
minimal change.

If you believe it is important, I would be happy to change it.

>  However, it seemed to me this
> was easier to produce the correct results.  Have you tested your patc=
h with
> a variety of timestamps to verify its correctness?=20

I tested by using touch -d to create one file in each year between 1902
and 2446.  Then I unmounted and remounted the FS, and did ls -l and
manually verified that each file's date matched its name.

> It looks to me like you
> have mapped the 1901-1969 range onto 0x3 for the epoch bits, instead=20
> of the (IMHO) natural 0x0 bits. The critical time ranges are listed=20
> above.

I think the idea of this is that it is the bottom 34 bits of the 64-bit
signed time.  However, it occurs to me that this relies on a two's
complement machine.  Even though the C standard does not guarantee this=
,
I believe the kernel requires it, so that's probably OK.

Patch follows:

--
Add a comment explaining the encoding of ext4's extra {a,c,m}time
bits.

Signed-off-by: David Turner <novalis@novalis.org>
---
 fs/ext4/ext4.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 121da383..ab69f14 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -713,6 +713,24 @@ struct move_extent {
 	  sizeof((ext4_inode)->field))			\
 	<=3D (EXT4_GOOD_OLD_INODE_SIZE +			\
 	    (einode)->i_extra_isize))			\
+/*
+ * We use the bottom 34 bits of the signed 64-bit time value, with
+ * the top two of these bits in the bottom of extra.  This leads
+ * to a slightly odd encoding, which works like this:
+ *
+ * extra  msb of
+ * epoch  32-bit
+ * bits   time    decoded 64-bit tv_sec   valid time range
+ * 0 0    0    0x000000000..0x07fffffff  1970-01-01..2038-01-19
+ * 0 0    1    0x080000000..0x0ffffffff  2038-01-19..2106-02-07
+ * 0 1    0    0x100000000..0x17fffffff  2106-02-07..2174-02-25
+ * 0 1    1    0x180000000..0x1ffffffff  2174-02-25..2242-03-16
+ * 1 0    0    0x200000000..0x27fffffff  2242-03-16..2310-04-04
+ * 1 0    1    0x280000000..0x2ffffffff  2310-04-04..2378-04-22
+ * 1 1    0    0x300000000..0x37fffffff  2378-04-22..2446-05-10
+
+ * 1 1    1    -0x80000000..-0x00000001  1901-12-13..1969-12-31
+ */
=20
 static inline __le32 ext4_encode_extra_time(struct timespec *time)
 {
--=20
1.8.1.2



--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
