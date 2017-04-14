From: Artem Blagodarenko <artem.blagodarenko@seagate.com>
Subject: Re: [PATCH] e2fsck: fix type mismatch bug in the largedir patch
Date: Sat, 15 Apr 2017 00:25:27 +0300
Message-ID: <CAO3qy=Hs0aPRjQzAT7jceo9sikiT22yooJkRT8QUmyqEnCcqWQ@mail.gmail.com>
References: <20170414205640.31710-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0b-00003501.pphosted.com ([67.231.152.68]:40715 "EHLO
        mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752624AbdDNVke (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 14 Apr 2017 17:40:34 -0400
Received: from pps.filterd (m0075029.ppops.net [127.0.0.1])
        by mx0b-00003501.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3ELJsfg006996
        for <linux-ext4@vger.kernel.org>; Fri, 14 Apr 2017 17:25:30 -0400
Received: from mail-qt0-f197.google.com (mail-qt0-f197.google.com [209.85.216.197])
        by mx0b-00003501.pphosted.com with ESMTP id 29u08p9xxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Fri, 14 Apr 2017 17:25:29 -0400
Received: by mail-qt0-f197.google.com with SMTP id l25so17611406qtf.11
        for <linux-ext4@vger.kernel.org>; Fri, 14 Apr 2017 14:25:29 -0700 (PDT)
In-Reply-To: <20170414205640.31710-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Theodore,

Thank you for fixing this mistake. I didn't fixed this after switched
from my ext2fs_has_feature_laregdir to
EXT4_FEATURE_INCOMPAT_FUNCS(largedir, 4, LARGEDIR).

Reviewed-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>

On Fri, Apr 14, 2017 at 11:56 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> Commit ae9efd05a986: "e2fsck: 3 level hash tree directory
> optimization" introduced a bug when checking for the largedir feature.
>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>
> I should have noticed the build warning sooner, but then again, so the
> patch author should have as well.  :-)
>
>  e2fsck/pass2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
> index fc98e833..09b79c3b 100644
> --- a/e2fsck/pass2.c
> +++ b/e2fsck/pass2.c
> @@ -978,7 +978,7 @@ static int check_dir_block(ext2_filsys fs,
>          * very large and then the files are deleted. For now, all that i=
s
>          * needed is to avoid e2fsck filling in these holes as part of
>          * feature flag. */
> -       if (db->blk =3D=3D 0 && ext2fs_has_feature_largedir(fs))
> +       if (db->blk =3D=3D 0 && ext2fs_has_feature_largedir(fs->super))
>                 return 0;
>
>         if (db->blk =3D=3D 0 && !inline_data_size) {
> --
> 2.11.0.rc0.7.gbe5a750
>



--=20
Artem Blagodarenko Ph.D.=C2=B7 SW Developer on my.seagate.com
Seagate Technology, LLC
www.seagate.com
