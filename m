From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH 1/2] kobject: introduce kobj_completion
Date: Tue, 10 Sep 2013 14:33:00 -0400
Message-ID: <522F65DC.1010303@suse.com>
References: <522F5A6A.2000201@suse.com> <20130910180627.GA4274@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="or2pxexQWTElAll3emr5ai2nr9n0lrpb1"
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Greg KH <gregkh@linux.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57489 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab3IJSdL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Sep 2013 14:33:11 -0400
In-Reply-To: <20130910180627.GA4274@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--or2pxexQWTElAll3emr5ai2nr9n0lrpb1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 9/10/13 2:06 PM, Greg KH wrote:
> On Tue, Sep 10, 2013 at 01:44:10PM -0400, Jeff Mahoney wrote:
>> ext4 exports per-filesystem information via sysfs. The lifetime rules
>> have historically been painful for this but the solution has been to p=
air
>> the kobject with a completion and call complete in the kobject's
>> release function.
>>
>> Since this is a pattern I've used in btrfs as well, it makes sense to
>> turn the pairing into a convenience structure with a standard API.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  include/linux/kobj_completion.h |   18 +++++++++++++++
>>  lib/kobject.c                   |   47 ++++++++++++++++++++++++++++++=
++++++++++
>>  2 files changed, 65 insertions(+)
>>
>> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
>> +++ b/include/linux/kobj_completion.h	2013-09-10 12:58:03.530554144 -0=
400
>> @@ -0,0 +1,18 @@
>> +#ifndef _KOBJ_COMPLETION_H_
>> +#define _KOBJ_COMPLETION_H_
>> +
>> +#include <linux/kobject.h>
>> +#include <linux/completion.h>
>> +
>> +struct kobj_completion {
>> +	struct kobject kc_kobj;
>> +	struct completion kc_unregister;
>> +};
>> +
>> +#define kobj_to_kobj_completion(kobj) \
>> +	container_of(kobj, struct kobj_completion, kc_kobj)
>> +
>> +void kobj_completion_init(struct kobj_completion *kc, struct kobj_typ=
e *ktype);
>> +void kobj_completion_release(struct kobject *kobj);
>> +void kobj_completion_del_and_wait(struct kobj_completion *kc);
>> +#endif /* _KOBJ_COMPLETION_H_ */
>> --- a/lib/kobject.c	2013-09-10 12:57:54.198666613 -0400
>> +++ b/lib/kobject.c	2013-09-10 13:16:31.750607946 -0400
>> @@ -13,6 +13,7 @@
>>   */
>> =20
>>  #include <linux/kobject.h>
>> +#include <linux/kobj_completion.h>
>>  #include <linux/string.h>
>>  #include <linux/export.h>
>>  #include <linux/stat.h>
>> @@ -711,6 +712,52 @@ const struct sysfs_ops kobj_sysfs_ops =3D
>>  };
>> =20
>>  /**
>> + * kobj_completion_init - initialize a kobj_completion object.
>> + * @kc: kobj_completion
>> + * @ktype: type of kobject to initialize
>> + *
>> + * kobj_completion structures can be embedded within structures with =
different
>> + * lifetime rules.  During the release of the enclosing object, we ca=
n
>> + * wait on the release of the kobject so that we don't free it while =
it's
>> + * still busy.
>> + */
>> +void kobj_completion_init(struct kobj_completion *kc, struct kobj_typ=
e *ktype)
>> +{
>> +	init_completion(&kc->kc_unregister);
>> +	kobject_init(&kc->kc_kobj, ktype);
>> +}
>> +EXPORT_SYMBOL_GPL(kobj_completion_init);
>> +
>> +/**
>> + * kobj_completion_release - release a kobj_completion object
>> + * @kobj: kobject embedded in kobj_completion
>> + *
>> + * Used with kobject_release to notify waiters that the kobject has b=
een
>> + * released.
>> + */
>> +void kobj_completion_release(struct kobject *kobj)
>> +{
>> +	struct kobj_completion *kc =3D kobj_to_kobj_completion(kobj);
>> +	complete(&kc->kc_unregister);
>> +}
>> +EXPORT_SYMBOL_GPL(kobj_completion_release);
>> +
>> +/**
>> + * kobj_completion_del_and_wait - release the kobject and wait for it=

>> + * @kc: kobj_completion object to release
>> + *
>> + * Delete the kobject from sysfs and  drop the reference count. Then =
wait
>> + * until any outstanding references are also dropped.
>> + */
>> +void kobj_completion_del_and_wait(struct kobj_completion *kc)
>> +{
>> +	kobject_del(&kc->kc_kobj);
>> +	kobject_put(&kc->kc_kobj);
>=20
> Why the extra kobject_put() call?  Who added this extra reference to th=
e
> object?

There's an assumption that kobject_add will have been called on the
initialized kobject. If it hasn't been called, the object can just be
deleted without the completion. It makes the calling code easier to
read, so would it work for you if I documented that assumption in
_del_and_wait?

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--or2pxexQWTElAll3emr5ai2nr9n0lrpb1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSL2XfAAoJEB57S2MheeWyDDcQAKwQ8KO6F86TKfpZpyvPXoMT
2hQg0poEErEl7Z9DTYYm8LSpgZcbj99HQkMjOukVTyAc7ZBoRVwtaNsQOiwPAwUW
3xgRJ0UekiygS0Ieug4LYPpIZTdha38S+hJGkmOgtATS947Der0SAafaIzuKG5eF
UhGwQLcPqTwqkh9h0iZsQe9dMWvllP+ZKLdbBnqY3BBunmwgOD7nOOWT6T/AB1rz
6OZHAxHRzcLWDLNyk9LgWnAArpfmzdXm8/P2bNfM2wtcW0vqoKaN/PeOSli3cvFi
MMJTl7txfcQI24T6q6O7U7MJB34B/Bw9KFIhfkUbE6vMqeDKiirPeGiEQup6i1ON
QW3i70gUxb0KdkMg23LcHD7lN2CtSbUBWwctP9puxzhDZLuS0VvyRYjjJRIbEyiZ
e9VDcQZrNo3xqag2U7dHtZ8xGYDNbQNGBDr/oAnS4XUtLPUYPoF3YKow5dpA0j6a
QwnMZb/iUjRWyRAkxlkInMbqamSvEGmaas4brQCqF058iphx7ehiJ8FSevXN5XAB
Tedlewpmsqcxyuli0BRh3mRq5zVGnUdAB1WmQUK96gbLAhOOqiQNiI8lu/h+upe+
1ixvy1eSelXDZ/wQjLTmc0DAslLfDZ41YRayLCLQUp8/B7hGoIwSF/SYMZ9rVVz3
frRfmf8Q/zJ6jD1C/yYu
=utfS
-----END PGP SIGNATURE-----

--or2pxexQWTElAll3emr5ai2nr9n0lrpb1--
