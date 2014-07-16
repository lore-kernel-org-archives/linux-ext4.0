From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Question about e2fsprogs/e4defrag
Date: Wed, 16 Jul 2014 12:22:36 -0700
Message-ID: <20140716192236.GA8628@birch.djwong.org>
References: <53C5FCA5.20207@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	a-fujita@rs.jp.nec.com, t-sato@yk.jp.nec.com, sandeen@redhat.com
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23876 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbaGPTWw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2014 15:22:52 -0400
Content-Disposition: inline
In-Reply-To: <53C5FCA5.20207@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 16, 2014 at 12:16:37PM +0800, Xiaoguang Wang wrote:
> Hi,
>=20
> When I run xfstests/tests/generic/018 for ext4 file system in RHEL7.0=
GA,
> sometimes it fails and sometime it succeeds. After looking into this =
case, I
> think it's not a kernel ext4 bug, it maybe an e4dfrag bug. I compiled=
 the
> newest e2fsprogs to have test, it seems this issue still exits, so I =
still
> send a mail to this list to look for some help, thanks.
>=20
> The issue is that sometimes e4defrag does not defrag file correctly.
> Steps to reproduce this issue:
> 1. cd mntpoint
> 2. rm -f lege
> 3. for I in `seq 9 -1 0`;
>        do dd if=3D/dev/zero of=3Dlege bs=3D4k count=3D1 conv=3Dnotrun=
c seek=3D$I oflag=3Dsync &>/dev/null;
>    done;
> 4. e4defrag -c -v lege
>=20
> Repeatedly execute the 2, 3, 4 steps until you get a file which have =
the similar extent layout like below:
> ################################################################
> [root@localhost test_e2fsprogs]# e4defrag -c -v lege
> <File>
> [ext 1]:        start 49365571: logical 0:      len 1
> [ext 2]:        start 49365570: logical 1:      len 1
> [ext 3]:        start 49365569: logical 2:      len 1
> [ext 4]:        start 49365568: logical 3:      len 1
> [ext 5]:        start 49365567: logical 4:      len 1
> [ext 6]:        start 49365566: logical 5:      len 1
> [ext 7]:        start 49365565: logical 6:      len 1
> [ext 8]:        start 49365564: logical 7:      len 1
> [ext 9]:        start 49365563: logical 8:      len 1
> [ext 10]:       start 49365562: logical 9:      len 1
>=20
>  Total/best extents                             10/1
>  Average size per extent                        4 KB
>  Fragmentation score                            98
>  [0-30 no problem: 31-55 a little bit fragmented: 56- needs defrag]
>  This file (lege) needs defragmentation.
>  Done.
> ################################################################
> The physical blocks are continuous but reversed.
>=20
> If we call e4defrag against this file, the output would be:
> ################################################################
> [root@localhost test_e2fsprogs]# /tmp/e4defrag -v lege=20
> ext4 defragmentation for lege
> [1/1]lege:      100%  extents: 10 -> 10 [ OK ]
>  Success:                       [1/1]
> [root@localhost test_e2fsprogs]# /tmp/e4defrag -v -c lege=20
> <File>
> [ext 1]:        start 49365571: logical 0:      len 1
> [ext 2]:        start 49365570: logical 1:      len 1
> [ext 3]:        start 49365569: logical 2:      len 1
> [ext 4]:        start 49365568: logical 3:      len 1
> [ext 5]:        start 49365567: logical 4:      len 1
> [ext 6]:        start 49365566: logical 5:      len 1
> [ext 7]:        start 49365565: logical 6:      len 1
> [ext 8]:        start 49365564: logical 7:      len 1
> [ext 9]:        start 49365563: logical 8:      len 1
> [ext 10]:       start 49365562: logical 9:      len 1
>=20
>  Total/best extents                             10/1
>  Average size per extent                        4 KB
>  Fragmentation score                            98
>  [0-30 no problem: 31-55 a little bit fragmented: 56- needs defrag]
>  This file (lege) needs defragmentation.
>  Done.
> ################################################################
> According to my understanding, this file is not defraged correctly an=
d should
> be convert into one extent.  Or because if the physical blocks are co=
ntinuous
> though reversed, we do not need to do defragment?

Oh, I think we /do/ need to defragment.  Granted, file readahead might =
paper
over the symptoms, but since the user explicitly ran e4defrag we can tr=
y
to do better.

> I have checked the e4defrag source code, whether to do real defragmen=
t
> depends on some conditions, please
> see this code(e4defrag.c).
> --main
>   --file_defrag
>    =20
> In file_defrag(), there is such a judgement=EF=BC=9A
> "if (file_frags_start <=3D best || orig_physical_cnt <=3D donor_physi=
cal_cnt)", If this returns true, the e4defrag will
> not call call_defrag() to do real defragment work.
>=20
> Here file_frags_start: number of file fragments before defrag
>      orig_physical_cnt: number of original file's continuous physical=
 region
>      donor_physical_cnt: number of donor file's continuous physical r=
egion
>=20
> In this "lege" file, the orig_physical_cnt is 1, and donor_physical_c=
nt is also 1, so the "if" is satisfied and
> call_defrag() won't be called.

This is a curious corner case of e4defrag -- if you look in get_file_ex=
tents(),
the list of extents is insertion-sorted by physical block, which means =
that
get_physical_count() (stupidly) looks only for gaps in the runs of phys=
ical
blocks.  Therefore, e4defrag thinks that this "lege" file has one physi=
cal
extent.  Ignoring logical block ordering, this is true, but as you poin=
t out,
this leaves the "file written backwards" case in a fragmented state.  S=
o let's
not ignore the logical block ordering:

What I think we really need to do here is make get_physical_count() sma=
rter --
if there's a gap either in the physical or logical offsets of extents, =
then we
need to increment *_physical_cnt so that we later decide to defragment =
the
file.

(Please keep reading)

> Here I'd like to know the comparison "orig_physical_cnt <=3D
> donor_physical_cnt" is useful? According to my understanding, what sh=
ould we
> have comparison are number of extents or average extent size.
>=20
> When I have this change:
> diff --git a/misc/e4defrag.c b/misc/e4defrag.c
> index a204793..cd95698 100644
> --- a/misc/e4defrag.c
> +++ b/misc/e4defrag.c
> @@ -1598,8 +1598,7 @@ check_improvement:
>                 extents_before_defrag +=3D file_frags_start;
>         }
> =20
> -       if (file_frags_start <=3D best ||
> -                       orig_physical_cnt <=3D donor_physical_cnt) {
> +       if (file_frags_start <=3D best) {=20

This is incorrect, since the point of the "orig_physical_cnt <=3D
donor_physical_cnt" check is to ensure that we don't increase the fragm=
entation
of a file by swapping it with pieces from a donor file whose contents a=
re
spread out over a larger number of runs of physical blocks.

(It does, however, force defragmentation for all files, so you get the =
results
you wanted.)

Please try the patch at the end of this message on for size.  It fixes =
things
on my test VM; does it fix yours?

--D

>                 printf("\033[79;0H\033[K[%u/%u]%s:\t%3d%%",
>                         defraged_file_count, total_count, file, 100);
>                 if (mode_flag & DETAIL)
>=20
> Then the "lege" file could be defraged correctly.
> ##################################################################
> [root@localhost test_e2fsprogs]# /tmp/e4defrag -v  lege
> ext4 defragmentation for lege
> [1/1]lege:      100%  extents: 10 -> 1  [ OK ]
>  Success:                       [1/1]
> [root@localhost test_e2fsprogs]# /tmp/e4defrag -v -c lege
> <File>
> [ext 1]:        start 49366583: logical 0:      len 10
>=20
>  Total/best extents                             1/1
>  Average size per extent                        40 KB
>  Fragmentation score                            0
>  [0-30 no problem: 31-55 a little bit fragmented: 56- needs defrag]
>  This file (lege) does not need defragmentation.
>  Done.
> ##################################################################
>=20
> Any opinion or suggestions will be appreciated!
> If I'm wrong, please correct me, thanks!
>=20
> Regards,
> Xiaoguang Wang

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index a204793..d0eac60 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -888,7 +888,9 @@ static int get_physical_count(struct fiemap_extent_=
list *physical_list_head)
=20
 	do {
 		if ((ext_list_tmp->data.physical + ext_list_tmp->data.len)
-				!=3D ext_list_tmp->next->data.physical) {
+				!=3D ext_list_tmp->next->data.physical ||
+		    (ext_list_tmp->data.logical + ext_list_tmp->data.len)
+				!=3D ext_list_tmp->next->data.logical) {
 			/* This extent and next extent are not continuous. */
 			ret++;
 		}
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
