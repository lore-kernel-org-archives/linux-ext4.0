From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] fsck: fix strange logic
Date: Tue, 9 Aug 2016 14:26:21 -0600
Message-ID: <0F4CAD2B-88EB-4727-8937-E50D776F3264@dilger.ca>
References: <1470773576-18604-1-git-send-email-andreas.dilger@intel.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_6221A721-3732-46F6-940C-5DAE3297F2B9"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33630 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbcHIU0Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Aug 2016 16:26:25 -0400
Received: by mail-io0-f194.google.com with SMTP id y195so1519091iod.0
        for <linux-ext4@vger.kernel.org>; Tue, 09 Aug 2016 13:26:25 -0700 (PDT)
In-Reply-To: <1470773576-18604-1-git-send-email-andreas.dilger@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_6221A721-3732-46F6-940C-5DAE3297F2B9
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Aug 9, 2016, at 2:12 PM, Andreas Dilger <andreas.dilger@intel.com> wrote:
> 
> llvm warns about the confusingly written comparison:
> 
>                              !strncmp(argv[i+1], "-", 1) == 0) {
>    misc/fsck.c:1178 col 9: warning: logical not is only applied to
>      the left hand side of comparison [-Wlogical-not-parentheses]
>    misc/fsck.c:1178 col 9: note: add parentheses after the '!' to
>      evaluate the comparison first
>    misc/fsck.c:1178 col 9: note: add parentheses around left hand
>      side expression to silence this warning
> 
> It makes sense to simplify this to a character comparison
> rather than using strncmp() to check only one character.
> 
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
> ---
> misc/fsck.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/misc/fsck.c b/misc/fsck.c
> index 826aaeb..4f918b7 100644
> --- a/misc/fsck.c
> +++ b/misc/fsck.c
> @@ -1174,8 +1174,8 @@ static void PRS(int argc, char *argv[])
> 						progress_fd = 0;
> 					else
> 						goto next_arg;
> -				} else if ((i+1) < argc &&
> -					   !strncmp(argv[i+1], "-", 1) == 0) {
> +				} else if (argc > i + 1 &&
> +					   argv[i + 1][0] == '-') {
> 					progress_fd = string_to_int(argv[i]);
> 					if (progress_fd < 0)
> 						progress_fd = 0;

Note that it isn't clear whether the original logic also contained a bug,
with both "!strncmp()" and the comparison with "== 0".  At first glance
it appeared that this was a bug to both negate and compare with 0, but
in further review I think that this should _not_ parse negative numbers
and use "-" as the fd.  Unfortunately, it isn't documented what "-" means.

I'll push a v2 patch that keeps the original logic, and Ted can choose
which one is correct.

Cheers, Andreas






--Apple-Mail=_6221A721-3732-46F6-940C-5DAE3297F2B9
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBV6o8bXKl2rkXzB/gAQim5Q//TooNKmpAoTgFM2tgGuTQ6FHG4xaYpZW7
ZewCu/SF5aHNTaQSNhAXJZsdxX32r4l4eaRgdSjSeHe9DwmnJmdQgFs1ZDlUVbxo
yukdRnFZHiIYuG7CAgIIYvEk/dv26w+qUDr3VVFMaYUMB8fxDrA5wTBcYGQW9W5c
rEJzpu8crqJo5IvydbP7UJQ/43AhD2XE181RZelNIvpfuXOXG7TfLdbqV0UjIb3F
Ab2srxMUVyotCv5PJTmvHFit6LDPYikzOo4OP8vrhyd/VpfpIDrR6ZEaXQB1HAb6
4C+Pv4vq8yZAw2oah16ss9rOFByV2wJkgshMqfiNjQPZfpbZXiCuAEcKvc3b7oVC
veIwlNB4o3xN0AkBinkqPMO7xK5ENqUm/nAZKCZ8Ugu29OWPISWN9k8G5LLjbpCd
orSR0xsj/bSi4Kk9mmezwhOSv9DIz93eH+6+RAvo4k3MDPrJNVwfsDSBIzqSHFAp
1yHiYT26Iz7FQ18mzYCQ0NtpKmSX2IaL/s9TCs7QHq5iNgJSL3EgJ0QAI8iO+OO3
2/KtXxmhXIEhSdkVLcrTjIojJhtHdty1uBOZ1d1cyKQEHSDDH7fHtR+ekvvKDvZv
WCd9s3XmDKD+65Uh8iZCr2LqDiz6z255lTSHRRpfUtDXMHhmQeXKK6kXAg0Jvp2C
4oj6/zpXOmw=
=1cGZ
-----END PGP SIGNATURE-----

--Apple-Mail=_6221A721-3732-46F6-940C-5DAE3297F2B9--
