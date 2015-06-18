From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [RFC] keyctl {clear,revoke} serialization with key-users
Date: Thu, 18 Jun 2015 13:43:11 +0300
Message-ID: <87zj3xpa9s.fsf@openvz.org>
References: <87ioapt1fj.fsf@openvz.org> <29565.1434557922@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
	ext4 development <linux-ext4@vger.kernel.org>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:32770 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbbFRKp6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Jun 2015 06:45:58 -0400
Received: by lbbvz5 with SMTP id vz5so1417243lbb.0
        for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2015 03:45:56 -0700 (PDT)
In-Reply-To: <29565.1434557922@warthog.procyon.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

David Howells <dhowells@redhat.com> writes:

> Dmitry Monakhov <dmonakhov@openvz.org> wrote:
>
>> But currently there is not synchronization between 'keyctl clear' and di=
rty
>> page buffers write-back, which result in data loss(because key no longer
>> available).
>
> The way fs/afs/ deals with this is to attach the key to the pending write=
back
> record.  However, this would also benefit from writeback being triggered =
at
> key invalidation.
>
>> But currently there is not synchronization between 'keyctl clear' and di=
rty
>> page buffers write-back, which result in data loss(because key no longer
>> available).
>>
>> There are several ways to synchronize key-management with key-usage
>> 1) ext4 specific way via userspace
>>    add 'del_key' command to e4crypto which will do:
>>        ioctl(ext4_del_key)          # sync and invalidate all inodes whi=
ch referees given key
>>        keyctl(KEYCTL_INVALIDATE,..) # wipe key from kernel
>
> I'm not keen on this because it's too easy to bypass half the process and=
 miss
> the ioctl.
>
>> 2) Generic keyring way:
>>    Add kernel API to register event listeners for a key so any subsystem
>>    may listen for such events and performs necessary actions once it hap=
pen.
>>    For example:
>>    key =3D request_key(....)
>>    notify_changes_key(key, event_mask, my_callback)
>>=20
>>=20
>>    keyring_clear() {
>>    for_each_listener{
>>         notify_key(callback, KEY_CLEAR)
>>    }
>>=20=20=20=20
>> First one is easy and clean also it preserves original keyring management
>> assumptions, but second one is more generic (since other fs will likely =
to
>> implement encryption in near future), the only visible changes of second
>> option is that callbacks must be synchronous so 'keyctl clear @s' may ta=
kes
>> long time. IMHO such implicit synchronization is good for 99% use-cases,=
 the
>> only exception is 'emergency key clear' case where we do not care about =
data
>> consistency but do care about key to be wiped ASAP.
>>=20
>> I would like to implement second option. Please rise your objections if =
any.
>
> I agree that the second is the best option.  It's something I thought abo=
ut
> originally for keys that are tied to some sort of removable hardware but I
> never actually implemented.
>
> I would suggest that you consider driving the notification from the
> gc.
AFAIU it is too late to perform notifications from GS because key is
already tagged as INVALIDATED or DEAD so key_validate() will fail.

BTW: I try to find synchronous way to clear a key the one which
explicitly wait for scheduled gc work to complete. But I can not find it.
Please guide me.
>It might not be entirely practical though and might be better off done fro=
m a
> separate work item.
I'll try to implement this case.
>
> David

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJVgqC/AAoJELhyPTmIL6kBvO0H/RxvU79Ruf9DcjyO2pOkLoLJ
uRR3maPIlLrJze1hL34nH+H7eUH5SIr2yBIQbnfJLGombI1ewL4TprZDtokcZi6R
mCTHvCLpO9PNZ8K0MQIrd6my67wkdnXcbTMjh8cDzoXgk5rKziLXhUkKg57D+l8e
F6XST6ZYhyk3/4InUf13jN05HnRfok80QhkFkNPOiYeLBQlwpkshfI/UDSLaFfJn
jvpncmivqju3YxnvSzYdUnv00dzS18IellCZr6kHISPPK+SAijgkuhQwg2AD0UCr
uB/+T3ty5ldSqFdpPgw2DRxicot+njTByE2+wjO/n48isgZEZWj+1gtUj8Q77N4=
=p39E
-----END PGP SIGNATURE-----
--=-=-=--
