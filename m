From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 5/6] kvm-xfstests: add initrd support
Date: Fri, 19 Aug 2016 16:59:22 +0300
Message-ID: <874m6g7tc5.fsf@openvz.org>
References: <1471553651-9547-1-git-send-email-dmonakhov@openvz.org> <1471553651-9547-6-git-send-email-dmonakhov@openvz.org> <20160819134432.GH10888@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34192 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754186AbcHSN7f (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Aug 2016 09:59:35 -0400
Received: by mail-lf0-f67.google.com with SMTP id k135so3127255lfb.1
        for <linux-ext4@vger.kernel.org>; Fri, 19 Aug 2016 06:59:28 -0700 (PDT)
In-Reply-To: <20160819134432.GH10888@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain

Theodore Ts'o <tytso@mit.edu> writes:

> On Fri, Aug 19, 2016 at 12:54:10AM +0400, Dmitry Monakhov wrote:
>> +	--initrd) shift
>> +		  INITRD="$1"
>> +		  if test ! -f "$INITRD" ; then
>> +		      print_help
>> +		  fi
>> +		  ;;
>
> We should only allow --initrd for kvm-xfstests, or add support for
> uploading the initrd to gce-xfstests, and then adding support to it to
> the gce-kexec script.
>
> We can just allow it for kvm-xfstests first, and then only later add
> support to gce-xfstests, if you don't have time to work to get
> gce-xfstests support for --initrd working.
No problem, but it looks like my knowledge about GCE is too low at the
moment. BTW are there are any way to make a bullet prof method to stop
gce instance after predefined timout? Your systemctl timeout script
does not always work. In my case it stuck somewhere inside FS and
timeout.service can not do it's job. Probably we can do it via
kernel watchdog or external watcher ala Jenkins.

>
> Cheers,
>
> 						- Ted

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCgAGBQJXtxC6AAoJELhyPTmIL6kBmPYH/0qBKGugvFmjKrAV6wKuATx4
fIbgtnySxRZUDEgvkPlwTkSb5RVWFf1MOo2fijuwIDWmtesDqWVbilSSNVMCaTWf
pCK2uHFSz/gXWNqf9Av/u8b37S5kUh2kBYf37HY5vg9fE10iVzAKkoJe7kLmrPO4
f2rY8TlYtsuStqVZfNt6POlxZBu1l05yPoGBpydZcbkzao4dGORIfYoWta2kW9Q+
JItqYN1InUHK+wFr0KAwZgydvc/E+duS0P8xEyqTo0nbOkhK3IcDItVw54/W6Y+A
lNLa8fkVZcPKOcL4F5ZzwcnPO211PMh8TJmAvLRUK7PdUXT7tydrcVPHYCiIU8Y=
=u7Pt
-----END PGP SIGNATURE-----
--=-=-=--
