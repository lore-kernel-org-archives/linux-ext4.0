From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 3/3] e4defrag: avoid unsuccessful return in non-privileged
	user
Date: Wed, 30 Sep 2009 14:37:24 -0400
Message-ID: <87f94c370909301137s40f09b7wb08ca7dee9f8dd15@mail.gmail.com>
References: <4AC3073D.9070606@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f199.google.com ([209.85.210.199]:41672 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbZI3ShU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Sep 2009 14:37:20 -0400
Received: by yxe37 with SMTP id 37so7065730yxe.33
        for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2009 11:37:24 -0700 (PDT)
In-Reply-To: <4AC3073D.9070606@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2009/9/30 Kazuya Mio <k-mio@sx.jp.nec.com>:
> If non-privileged user does e4defrag, e4defrag returns 1 despite
> its success. This patch fixes this problem.
>
> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
> ---
>
> =A0e4defrag.c | =A0 =A01 +
> =A01 file changed, 1 insertion(+)
> diff --git a/misc/e4defrag.c b/misc/e4defrag.c
> index 94f8529..98dda92 100644
> --- a/misc/e4defrag.c
> +++ b/misc/e4defrag.c
> @@ -2025,6 +2025,7 @@ int main(int argc, char *argv[])
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!(=
mode_flag & DETAIL) &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0current_uid !=3D ROOT_UID) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0printf(" Done.\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 success_flag =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}

I should know this, but this patch made me wonder about the underlying
implementation of EXT4_IOC_MOVE_EXT.

After EXT4_IOC_MOVE_EXT is called, can userspace somehow modify the
defragged file?

ie. If I only have readonly access to a file and I call
EXT4_IOC_MOVE_EXT to replace some of the data blocks, is it possible
now for me to write data to the donor_fd and thus modify the data in
the original file?

Greg
--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
Preservation and Forensic processing of Exchange Repositories White Pap=
er -
<http://www.norcrossgroup.com/forms/whitepapers/tng_whitepaper_fpe.html=
>

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
