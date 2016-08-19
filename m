From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 3/6] kvm-xfstests: update command line help
Date: Fri, 19 Aug 2016 16:51:16 +0300
Message-ID: <878tvs7tpn.fsf@openvz.org>
References: <1471553651-9547-1-git-send-email-dmonakhov@openvz.org> <1471553651-9547-4-git-send-email-dmonakhov@openvz.org> <20160819134238.GG10888@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:33567 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754333AbcHSNvY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Aug 2016 09:51:24 -0400
Received: by mail-lf0-f66.google.com with SMTP id f93so3120781lfi.0
        for <linux-ext4@vger.kernel.org>; Fri, 19 Aug 2016 06:51:23 -0700 (PDT)
In-Reply-To: <20160819134238.GG10888@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Theodore Ts'o <tytso@mit.edu> writes:

> On Fri, Aug 19, 2016 at 12:54:08AM +0400, Dmitry Monakhov wrote:
>> diff --git a/kvm-xfstests/util/parse_cli b/kvm-xfstests/util/parse_cli
>> index 83400ea..edbbafa 100644
>> --- a/kvm-xfstests/util/parse_cli
>> +++ b/kvm-xfstests/util/parse_cli
>> @@ -26,10 +26,47 @@ print_help ()
>>      echo "	-o opts		- Extra kernel command line options"
>>      echo "	-r ram		- Specify memory to be used in megabytes"
>>      echo "	-X test		- Exclude test from running"
>> +    echo "	--no-punch	- Do not run tests w/ patch hole"
>> +    echo "	--no-collapse	- Do not run tests w/ collapse range"
>> +    echo "	--no-insert	- Do not run tests w/ insert range"
>> +    echo "	--no-zero	- Do not run tests w/ zero range"
>
> The reason why I don't document these options is they depend on an
> out-of-tree patch for xfstests.  It's in my githup repo, but it's not
> something which xfstests upstream has seen fit to take.
>
>>      if test "$GCE_XFSTESTS" !=3D "yes" ; then
>>  	echo "	--kernel file	- Boot the specified kernel"
>>=20=20
>> +    else
>> +	echo "GCE speciffic commands:"
>> +	echo "	ls-instances"
>> +        echo "	ls|ls-instances"
>> +        echo "	rm|rm-instances|abort|abort-instances"
>> +        echo "	start|start-instance|start-instances"
>> +        echo "	stop|stop-instance|stop-instances"
>> +        echo "	ls-disks|ls-disk"
>> +        echo "	rm-disks|rm-disk"
>> +        echo "	ls-results|ls-gcs"
>> +        echo "	rm-results|rm-gcs"
>> +        echo "	get-results"
>> +        echo "	setup"
>> +        echo "	ssh"
>> +        echo "	console"
>> +        echo "	serial"
>> +        echo "	get-results"
>> +        echo "	create-image"
>> +        echo "	export-image"
>> +        echo "	import-image"
>> +        echo "	--numa"
>> +        echo "	--log"
>> +        echo "	--local-ssd"
>> +        echo "	--pmem-device"
>> +        echo "	--machtype"
>> +        echo "	--image-project"
>> +        echo "	--instance-name"
>> +        echo "	--no-virtio-rng"
>>      fi
>> +    echo "Base image update commands:"
>> +    echo "	--update-xfstests-tar"
>> +    echo "	--update-xfstests"
>> +    echo "	--update-files"
>> +    echo
>>      echo "	--no-log	- Don't save the log file for this run"
>>      echo "	--no-action	- Print the command to start the VM"
>>      echo ""
>
> The options don't belong next to the GCE specific commands.  And
> gce-import, as well as the base image update options, are really
> intended for the maintainer (e.g., for me to update the xfstests-cloud
> public image project).
>
> The main issue is I'm a bit concerned about making the help message
> too long.  My long term vision is to go in the direction of git and
> gcloud's style of help messages / man pages.  So gce-xfstests --help
> and kvm-xfstests --help will display a list of the most commonly used
> / useful commands and options.  And where "gce-xfstests get-results
> --help" will display a full man page for the get-results subcommand,
> and "gce-xfstests help commands" will display a full list of all
> commands, and "gce-xfstests help topics" will allow you to see the
> documentation currently available as markdown files in Documentation.
Agree. My point was that it is easier to:
0 place info about all commands here fist: DONE
2 visualize it,
3 make a decision about readability
4 cut less interesting options.
5 goto 2
>
> Cheers,
>
> 						- Ted

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCgAGBQJXtw7UAAoJELhyPTmIL6kBMAMH/32+tnPSaS21aNczg1EIXTOI
49EjicxV4F7Ky838A3kQxMKsoqvSrJT75j8XqAUwqxggy+Ap2P8On3aTuK7VXN3x
LFZR3eUpP7lH7PvTy2c3arHrRaleqRxvEeSQRVPYa5+DMmIUzrlNjgzvCszVUy+l
TmYoLgcIcPuba2te5L6iy4w4j4ImoSGv3AhEYRjreOtixVoZcVpTy+NV7zyxJOyo
Lizxnusjm2p9CLllpWtLMnTr5dMhom8aiPZikDX+oGnm/onQCzG9z4PVVINZ7sLp
Xl7l2iv7rw3D3/W8Aahv8A2nuI8LQppWY8TEDQOD/zuh4BcP2/904/UpLAbgKJM=
=6qOM
-----END PGP SIGNATURE-----
--=-=-=--
