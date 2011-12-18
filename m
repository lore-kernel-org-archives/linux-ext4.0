From: boyu <boyu.mt@taobao.com>
Subject: [PATCH V3 00/21] ext4: Add inline data support.
Date: Sun, 18 Dec 2011 22:18:08 +0800
Message-ID: <4EEDF620.8070008@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: LKML <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>, <tm@tao.ma>
To: undisclosed-recipients:;
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gateway.alibaba-inc.com ([121.0.29.128]:56587 "EHLO
	CNHZ-ExGW-01.ali.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751127Ab1LROdQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Dec 2011 09:33:16 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted, Andreas and list,
        This is the v3 attempt to add inline data support to ext4 inode=
=2E
=46or more information about the background, please refer to the thread
http://marc.info/?l=3Dlinux-ext4&m=3D131715205428067&w=3D2

Changelog from v2 to v3:
1. Add support for evict data from inode if we can store xattr in it.
2. Add support for fiemap
3. Some nasty bug fixes

The v2 can be found here:
http://marc.info/?l=3Dlinux-ext4&m=3D132189338604177&w=3D2

The v1 can be found here:
http://marc.info/?l=3Dlinux-ext4&m=3D131961438221255&w=3D2

any suggestions are welcomed.

git diff --stat master..
 fs/ext4/Makefile  |    2 +-
 fs/ext4/dir.c     |   39 +-
 fs/ext4/ext4.h    |   77 +++-
 fs/ext4/extents.c |   18 +-
 fs/ext4/ialloc.c  |    4 +
 fs/ext4/inline.c  | 1642 +++++++++++++++++++++++++++++++++++++++++++++=
++++++++
 fs/ext4/inode.c   |  236 ++++++--
 fs/ext4/namei.c   |  364 +++++++++----
 fs/ext4/xattr.c   |   64 +--
 fs/ext4/xattr.h   |  263 +++++++++
 10 files changed, 2481 insertions(+), 228 deletions(-)

Thanks
Tao


________________________________

This email (including any attachments) is confidential and may be legal=
ly privileged. If you received this email in error, please delete it im=
mediately and do not copy it or use it for any purpose or disclose its =
contents to any other person. Thank you.

=E6=9C=AC=E7=94=B5=E9=82=AE(=E5=8C=85=E6=8B=AC=E4=BB=BB=E4=BD=95=E9=99=84=
=E4=BB=B6)=E5=8F=AF=E8=83=BD=E5=90=AB=E6=9C=89=E6=9C=BA=E5=AF=86=E8=B5=84=
=E6=96=99=E5=B9=B6=E5=8F=97=E6=B3=95=E5=BE=8B=E4=BF=9D=E6=8A=A4=E3=80=82=
=E5=A6=82=E6=82=A8=E4=B8=8D=E6=98=AF=E6=AD=A3=E7=A1=AE=E7=9A=84=E6=94=B6=
=E4=BB=B6=E4=BA=BA=EF=BC=8C=E8=AF=B7=E6=82=A8=E7=AB=8B=E5=8D=B3=E5=88=A0=
=E9=99=A4=E6=9C=AC=E9=82=AE=E4=BB=B6=E3=80=82=E8=AF=B7=E4=B8=8D=E8=A6=81=
=E5=B0=86=E6=9C=AC=E7=94=B5=E9=82=AE=E8=BF=9B=E8=A1=8C=E5=A4=8D=E5=88=B6=
=E5=B9=B6=E7=94=A8=E4=BD=9C=E4=BB=BB=E4=BD=95=E5=85=B6=E4=BB=96=E7=94=A8=
=E9=80=94=E3=80=81=E6=88=96=E9=80=8F=E9=9C=B2=E6=9C=AC=E9=82=AE=E4=BB=B6=
=E4=B9=8B=E5=86=85=E5=AE=B9=E3=80=82=E8=B0=A2=E8=B0=A2=E3=80=82
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
