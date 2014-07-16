From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: Question about e2fsprogs/e4defrag
Date: Wed, 16 Jul 2014 12:16:37 +0800
Message-ID: <53C5FCA5.20207@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>, <a-fujita@rs.jp.nec.com>,
	<t-sato@yk.jp.nec.com>, <sandeen@redhat.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:9939 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751567AbaGPERN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2014 00:17:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

When I run xfstests/tests/generic/018 for ext4 file system in RHEL7.0GA=
, sometimes it fails and
sometime it succeeds. After looking into this case, I think it's not a =
kernel ext4 bug, it maybe
an e4dfrag bug. I compiled the newest e2fsprogs to have test, it seems =
this issue still exits, so
I still send a mail to this list to look for some help, thanks.

The issue is that sometimes e4defrag does not defrag file correctly.
Steps to reproduce this issue:
1. cd mntpoint
2. rm -f lege
3. for I in `seq 9 -1 0`;
       do dd if=3D/dev/zero of=3Dlege bs=3D4k count=3D1 conv=3Dnotrunc =
seek=3D$I oflag=3Dsync &>/dev/null;
   done;
4. e4defrag -c -v lege

Repeatedly execute the 2, 3, 4 steps until you get a file which have th=
e similar extent layout like below:
################################################################
[root@localhost test_e2fsprogs]# e4defrag -c -v lege
<File>
[ext 1]:        start 49365571: logical 0:      len 1
[ext 2]:        start 49365570: logical 1:      len 1
[ext 3]:        start 49365569: logical 2:      len 1
[ext 4]:        start 49365568: logical 3:      len 1
[ext 5]:        start 49365567: logical 4:      len 1
[ext 6]:        start 49365566: logical 5:      len 1
[ext 7]:        start 49365565: logical 6:      len 1
[ext 8]:        start 49365564: logical 7:      len 1
[ext 9]:        start 49365563: logical 8:      len 1
[ext 10]:       start 49365562: logical 9:      len 1

 Total/best extents                             10/1
 Average size per extent                        4 KB
 Fragmentation score                            98
 [0-30 no problem: 31-55 a little bit fragmented: 56- needs defrag]
 This file (lege) needs defragmentation.
 Done.
################################################################
The physical blocks are continuous but reversed.

If we call e4defrag against this file, the output would be:
################################################################
[root@localhost test_e2fsprogs]# /tmp/e4defrag -v lege=20
ext4 defragmentation for lege
[1/1]lege:      100%  extents: 10 -> 10 [ OK ]
 Success:                       [1/1]
[root@localhost test_e2fsprogs]# /tmp/e4defrag -v -c lege=20
<File>
[ext 1]:        start 49365571: logical 0:      len 1
[ext 2]:        start 49365570: logical 1:      len 1
[ext 3]:        start 49365569: logical 2:      len 1
[ext 4]:        start 49365568: logical 3:      len 1
[ext 5]:        start 49365567: logical 4:      len 1
[ext 6]:        start 49365566: logical 5:      len 1
[ext 7]:        start 49365565: logical 6:      len 1
[ext 8]:        start 49365564: logical 7:      len 1
[ext 9]:        start 49365563: logical 8:      len 1
[ext 10]:       start 49365562: logical 9:      len 1

 Total/best extents                             10/1
 Average size per extent                        4 KB
 Fragmentation score                            98
 [0-30 no problem: 31-55 a little bit fragmented: 56- needs defrag]
 This file (lege) needs defragmentation.
 Done.
################################################################
According to my understanding, this file is not defraged correctly and =
should be convert into one extent.
Or because if the physical blocks are continuous though reversed, we do=
 not need to do defragment?

I have checked the e4defrag source code, whether to do real defragment =
depends on some conditions, please
see this code(e4defrag.c).
--main
  --file_defrag
   =20
In file_defrag(), there is such a judgement=EF=BC=9A
"if (file_frags_start <=3D best || orig_physical_cnt <=3D donor_physica=
l_cnt)", If this returns true, the e4defrag will
not call call_defrag() to do real defragment work.

Here file_frags_start: number of file fragments before defrag
     orig_physical_cnt: number of original file's continuous physical r=
egion
     donor_physical_cnt: number of donor file's continuous physical reg=
ion

In this "lege" file, the orig_physical_cnt is 1, and donor_physical_cnt=
 is also 1, so the "if" is satisfied and
call_defrag() won't be called.

Here I'd like to know the comparison "orig_physical_cnt <=3D donor_phys=
ical_cnt" is useful? According to
my understanding, what should we have comparison are number of extents =
or average extent size.

When I have this change:
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index a204793..cd95698 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -1598,8 +1598,7 @@ check_improvement:
                extents_before_defrag +=3D file_frags_start;
        }
=20
-       if (file_frags_start <=3D best ||
-                       orig_physical_cnt <=3D donor_physical_cnt) {
+       if (file_frags_start <=3D best) {=20
                printf("\033[79;0H\033[K[%u/%u]%s:\t%3d%%",
                        defraged_file_count, total_count, file, 100);
                if (mode_flag & DETAIL)

Then the "lege" file could be defraged correctly.
##################################################################
[root@localhost test_e2fsprogs]# /tmp/e4defrag -v  lege
ext4 defragmentation for lege
[1/1]lege:      100%  extents: 10 -> 1  [ OK ]
 Success:                       [1/1]
[root@localhost test_e2fsprogs]# /tmp/e4defrag -v -c lege
<File>
[ext 1]:        start 49366583: logical 0:      len 10

 Total/best extents                             1/1
 Average size per extent                        40 KB
 Fragmentation score                            0
 [0-30 no problem: 31-55 a little bit fragmented: 56- needs defrag]
 This file (lege) does not need defragmentation.
 Done.
##################################################################

Any opinion or suggestions will be appreciated!
If I'm wrong, please correct me, thanks!

Regards,
Xiaoguang Wang











--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
