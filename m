From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH 1/2] kobject: introduce kobj_completion
Date: Tue, 10 Sep 2013 14:44:18 -0400
Message-ID: <522F6882.2070900@suse.com>
References: <522F5A6A.2000201@suse.com> <20130910180627.GA4274@kroah.com> <522F65DC.1010303@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="AKDATt8eef39dvNcRdNsjjEPqooxdlmkX"
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Greg KH <gregkh@linux.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab3IJSo3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Sep 2013 14:44:29 -0400
In-Reply-To: <522F65DC.1010303@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AKDATt8eef39dvNcRdNsjjEPqooxdlmkX
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 9/10/13 2:33 PM, Jeff Mahoney wrote:
> On 9/10/13 2:06 PM, Greg KH wrote:
>> On Tue, Sep 10, 2013 at 01:44:10PM -0400, Jeff Mahoney wrote:
>>> ext4 exports per-filesystem information via sysfs. The lifetime rules=

>>> have historically been painful for this but the solution has been to =
pair
>>> the kobject with a completion and call complete in the kobject's
>>> release function.
>>>
>>> Since this is a pattern I've used in btrfs as well, it makes sense to=

>>> turn the pairing into a convenience structure with a standard API.
>>>
>>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>>> ---
>>>  include/linux/kobj_completion.h |   18 +++++++++++++++
>>>  lib/kobject.c                   |   47 +++++++++++++++++++++++++++++=
+++++++++++
>>>  2 files changed, 65 insertions(+)
>>>
>>> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
>>> +++ b/include/linux/kobj_completion.h	2013-09-10 12:58:03.530554144 -=
0400
>>> @@ -0,0 +1,18 @@
>>> +#ifndef _KOBJ_COMPLETION_H_
>>> +#define _KOBJ_COMPLETION_H_
>>> +
>>> +#include <linux/kobject.h>
>>> +#include <linux/completion.h>
>>> +
>>> +struct kobj_completion {
>>> +	struct kobject kc_kobj;
>>> +	struct completion kc_unregister;
>>> +};
>>> +
>>> +#define kobj_to_kobj_completion(kobj) \
>>> +	container_of(kobj, struct kobj_completion, kc_kobj)
>>> +
>>> +void kobj_completion_init(struct kobj_completion *kc, struct kobj_ty=
pe *ktype);
>>> +void kobj_completion_release(struct kobject *kobj);
>>> +void kobj_completion_del_and_wait(struct kobj_completion *kc);
>>> +#endif /* _KOBJ_COMPLETION_H_ */
>>> --- a/lib/kobject.c	2013-09-10 12:57:54.198666613 -0400
>>> +++ b/lib/kobject.c	2013-09-10 13:16:31.750607946 -0400
>>> @@ -13,6 +13,7 @@
>>>   */
>>> =20
>>>  #include <linux/kobject.h>
>>> +#include <linux/kobj_completion.h>
>>>  #include <linux/string.h>
>>>  #include <linux/export.h>
>>>  #include <linux/stat.h>
>>> @@ -711,6 +712,52 @@ const struct sysfs_ops kobj_sysfs_ops =3D
>>>  };
>>> =20
>>>  /**
>>> + * kobj_completion_init - initialize a kobj_completion object.
>>> + * @kc: kobj_completion
>>> + * @ktype: type of kobject to initialize
>>> + *
>>> + * kobj_completion structures can be embedded within structures with=
 different
>>> + * lifetime rules.  During the release of the enclosing object, we c=
an
>>> + * wait on the release of the kobject so that we don't free it while=
 it's
>>> + * still busy.
>>> + */
>>> +void kobj_completion_init(struct kobj_completion *kc, struct kobj_ty=
pe *ktype)
>>> +{
>>> +	init_completion(&kc->kc_unregister);
>>> +	kobject_init(&kc->kc_kobj, ktype);
>>> +}
>>> +EXPORT_SYMBOL_GPL(kobj_completion_init);
>>> +
>>> +/**
>>> + * kobj_completion_release - release a kobj_completion object
>>> + * @kobj: kobject embedded in kobj_completion
>>> + *
>>> + * Used with kobject_release to notify waiters that the kobject has =
been
>>> + * released.
>>> + */
>>> +void kobj_completion_release(struct kobject *kobj)
>>> +{
>>> +	struct kobj_completion *kc =3D kobj_to_kobj_completion(kobj);
>>> +	complete(&kc->kc_unregister);
>>> +}
>>> +EXPORT_SYMBOL_GPL(kobj_completion_release);
>>> +
>>> +/**
>>> + * kobj_completion_del_and_wait - release the kobject and wait for i=
t
>>> + * @kc: kobj_completion object to release
>>> + *
>>> + * Delete the kobject from sysfs and  drop the reference count. Then=
 wait
>>> + * until any outstanding references are also dropped.
>>> + */
>>> +void kobj_completion_del_and_wait(struct kobj_completion *kc)
>>> +{
>>> +	kobject_del(&kc->kc_kobj);
>>> +	kobject_put(&kc->kc_kobj);
>>
>> Why the extra kobject_put() call?  Who added this extra reference to t=
he
>> object?
>=20
> There's an assumption that kobject_add will have been called on the
> initialized kobject. If it hasn't been called, the object can just be
> deleted without the completion. It makes the calling code easier to
> read, so would it work for you if I documented that assumption in
> _del_and_wait?

Actually, that's not it. The refcounting works out in my tests.

The kobject's refcount is initialized to 1. kobject_add doesn't
increment it and kobject_del doesn't decrement it. So we need the
kobject_put to trigger the release function.

Or am I missing something here?

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--AKDATt8eef39dvNcRdNsjjEPqooxdlmkX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSL2iFAAoJEB57S2MheeWyDGIP/REgqz4Ff+beF148u4Jo/Vln
IcHYGo/nXMKBM3Vi+CMffOLju9ou/gAdIkpbpQJMLSGPfzhg9SEI2TqAvemGOHlG
DPaxcFtGbR6+UENewRTASbqNza8n2uJVivm5ukyJ22NtPOVsVRJg+MlTqYh6Wxx4
pDtg01VWHPIe9KmVwWi3qu/8EithoPzpdHU9ehOeJWOj7rjvZn2b+onoVXnT6kCI
BgQuPUGqd/239yJieoADjPw2+Ehw5gE5ViI4jtn84OrY6qh5clfweqhwUtKY+3Pk
OyBPi5+NgwTBk9cCGiQ4tlshYAcr75ue7I5HVjWhup77nStcDs5EURcGrFVEkNLR
TJ5IliV1SI2QmTFLcZN4laDklT5DtBYyG0X2pEjARb0l3N0pAxHZVdWnpnO0DvIF
WJ5rRvdi9i3F/3mNP/ufR8n5NYPCFZC9S2itBB01u42BFwUCI2EElTcLMHiDZUDP
OwhOQmklcQrCiT62qfwJCugHCq5iedH8MTMbRhztp0OXgAp27ddvCy9lpkPjdcBf
Bx0j5oNQsPDIPsND5cJiv+TZZ2hMtA9tyr4SYlqGzo1gquREDUg0eVyoTGoQ41pe
VMFvwHp6ZFRv1Jx5UFdSTtr5G/QD0LdDCe4kc+isd0gHPU47GeDBkL0UCXoudPWG
cXQWKkFpvb1OOI7XejOr
=Du2H
-----END PGP SIGNATURE-----

--AKDATt8eef39dvNcRdNsjjEPqooxdlmkX--
