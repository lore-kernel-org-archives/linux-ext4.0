From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Punching hole using fallocate is not removing the uninit extent from
 extent tree
Date: Mon, 28 May 2012 19:38:05 +0530
Message-ID: <CAOiN93=S4jEBJGwDfrTCsQQ2Yzm_BOGHT_pOivcdAkx5gTLxjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61707 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab2E1OIG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 May 2012 10:08:06 -0400
Received: by dady13 with SMTP id y13so4193418dad.19
        for <linux-ext4@vger.kernel.org>; Mon, 28 May 2012 07:08:05 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have created a formatted EXT4 partition such that every single
extent is exactly 6blocks (24KB) of length.
I used hole punch on 2 different files.

CASE 1: In first situation, file size is 72KB. There are total 3
extents each 24KB length. Using fallocate to punch hole starting at
offset 4096 and length 4096,
dump_extents gives the following expected output :

Before punching hole :
Level Entries =A0 =A0 =A0 Logical =A0 =A0 =A0Physical Length Flags
0/ 0 =A0 1/ =A02 =A0 =A0 0 - =A0 =A0 5 =A01856 - =A01861 =A0 =A0 =A06
0/ 0 =A0 2/ =A02 =A0 =A0 6 - =A0 =A011 =A01868 - =A01873 =A0 =A0 =A06

After punching hole :
Level Entries =A0 =A0 =A0 Logical =A0 =A0 =A0Physical Length Flags
0/ 0 =A0 1/ =A03 =A0 =A0 0 - =A0 =A0 0 =A01856 - =A01856 =A0 =A0 =A01
0/ 0 =A0 2/ =A03 =A0 =A0 2 - =A0 =A0 5 =A01858 - =A01861 =A0 =A0 =A04
0/ 0 =A0 3/ =A03 =A0 =A0 6 - =A0 =A011 =A01868 - =A01873 =A0 =A0 =A06

The 1st extent: 0-5, is splitted into 3 extents, "0-0", "1-1", "2-5"
Extent 1-1 is first marked as uninitialized in function
ext4_ext_map_blocks() and later removed from the extent tree by
ext4_ext_remove_space().

CASE 2: File size is 9.4MB. There are total 400 extents each 24KB
length, depth of extent tree at root header is 1 and there are 2 index
entries.

dump_extents output before punching hole:
Level Entries =A0 =A0 =A0 Logical =A0 =A0 =A0Physical Length Flags
0/ 1 =A0 1/ =A02 =A0 =A0 0 - =A02039 =A01922 =A0 =A0 =A0 =A0 =A0 2040
1/ 1 =A0 1/340 =A0 =A0 0 - =A0 =A0 5 =A01856 - =A01861 =A0 =A0 =A06
1/ 1 =A0 2/340 =A0 =A0 6 - =A0 =A011 =A01868 - =A01873 =A0 =A0 =A06
< Continued likewise till 340/340 >
1/ 1 340/340 =A02034 - =A02039 =A05942 - =A05947 =A0 =A0 =A06
0/ 1 =A0 2/ =A02 =A02040 - =A02399 =A01923 =A0 =A0 =A0 =A0 =A0 =A0360
1/ 1 =A0 1/ 60 =A02040 - =A02045 =A05954 - =A05959 =A0 =A0 =A06
1/ 1 =A0 2/ 60 =A02046 - =A02051 =A05966 - =A05971 =A0 =A0 =A06
< Continued likewise till 60/60 >
1/ 1 =A060/ 60 =A02394 - =A02399 =A06662 - =A06667 =A0 =A0 =A06

dump_extents output after punching hole :
0/ 1 =A0 1/ =A03 =A0 =A0 0 - =A0 =A0 5 =A01922 =A0 =A0 =A0 =A0 =A0 =A0 =
=A06
1/ 1 =A0 1/ =A03 =A0 =A0 0 - =A0 =A0 0 =A01856 - =A01856 =A0 =A0 =A01
1/ 1 =A0 2/ =A03 =A0 =A0 1 - =A0 =A0 1 =A01857 - =A01857 =A0 =A0 =A01 U=
ninit
1/ 1 =A0 3/ =A03 =A0 =A0 2 - =A0 =A0 5 =A01858 - =A01861 =A0 =A0 =A04
0/ 1 =A0 2/ =A03 =A0 =A0 6 - =A02039 =A06674 =A0 =A0 =A0 =A0 =A0 2034
1/ 1 =A0 1/339 =A0 =A0 6 - =A0 =A011 =A01868 - =A01873 =A0 =A0 =A06
1/ 1 =A0 2/339 =A0 =A012 - =A0 =A017 =A01880 - =A01885 =A0 =A0 =A06
< Continued like wise...>

Comparing CASE2 with CASE1, still uninit extent "1-1" is present
within the extent tree.

In function ext4_ext_remove_space(), there is call to function
ext4_ext_rm_leaf which is responsible for removal of this extent.
But this function is not getting called in CASE 2 :
if (i =3D=3D depth) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* this is leaf block */
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D ext4_ext_rm_leaf=
(handle, inode, path,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0start, end);
/* root level has p_bh =3D=3D NULL, brelse() eats this */
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0brelse(path[i].p_bh);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0path[i].p_bh =3D NULL;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0i--;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}

Varibale "i" does not become equals to "depth" because
ext4_ext_more_to_rm is returning "0" hence the following if condition
is turning out to be false for 1st extent index:
if (ext4_ext_more_to_rm(path + i)) {

Looking at the defination of ext4_ext_more_to_rm :
/*
* ext4_ext_more_to_rm:
* returns 1 if current index has to be freed (even partial)
*/
static int
ext4_ext_more_to_rm(struct ext4_ext_path *path)
{
=A0 =A0 =A0 =A0BUG_ON(path->p_idx =3D=3D NULL);
=A0 =A0 =A0 =A0if (path->p_idx < EXT_FIRST_INDEX(path->p_hdr))
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;

=A0 =A0 =A0 =A0/*
=A0 =A0 =A0 =A0 * if truncate on deeper level happened, it wasn't parti=
al,
=A0 =A0 =A0 =A0 * so we have to consider current index for truncation
=A0 =A0 =A0 =A0 */
=A0 =A0 =A0 =A0if (le16_to_cpu(path->p_hdr->eh_entries) =3D=3D path->p_=
block) <=3D
This condition is turning out to be true
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0; =A0 =A0 =A0 <=3D The function =
is returning zero from here.
=A0 =A0 =A0 =A0return 1;
}

I could not understand the significance of the above mentioned if
condition check, if anyone could explain a little, it will be help.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
