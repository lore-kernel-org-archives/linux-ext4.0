From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH 1/2] kobject: introduce kobj_completion
Date: Wed, 11 Sep 2013 12:53:45 -0400
Message-ID: <5230A019.5030101@suse.com>
References: <522F5A6A.2000201@suse.com> <20130910180627.GA4274@kroah.com> <522F65DC.1010303@suse.com> <522F6882.2070900@suse.com> <20130911045042.GA31241@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="7EnnKGs7HwOlq6iVl5qkcesXhLxXHSfiI"
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Greg KH <gregkh@linux.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50827 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002Ab3IKQx7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Sep 2013 12:53:59 -0400
In-Reply-To: <20130911045042.GA31241@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7EnnKGs7HwOlq6iVl5qkcesXhLxXHSfiI
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 9/11/13 12:50 AM, Greg KH wrote:
> On Tue, Sep 10, 2013 at 02:44:18PM -0400, Jeff Mahoney wrote:
>> On 9/10/13 2:33 PM, Jeff Mahoney wrote:
>>> On 9/10/13 2:06 PM, Greg KH wrote:
>>>> On Tue, Sep 10, 2013 at 01:44:10PM -0400, Jeff Mahoney wrote:
>>>>> ext4 exports per-filesystem information via sysfs. The lifetime rul=
es
>>>>> have historically been painful for this but the solution has been t=
o pair
>>>>> the kobject with a completion and call complete in the kobject's
>>>>> release function.
>>>>>
>>>>> Since this is a pattern I've used in btrfs as well, it makes sense =
to
>>>>> turn the pairing into a convenience structure with a standard API.
>>>>>
>>>>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>>>>> ---
>>>>>  include/linux/kobj_completion.h |   18 +++++++++++++++
>>>>>  lib/kobject.c                   |   47 +++++++++++++++++++++++++++=
+++++++++++++
>>>>>  2 files changed, 65 insertions(+)
>>>>>
>>>>> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
>>>>> +++ b/include/linux/kobj_completion.h	2013-09-10 12:58:03.530554144=
 -0400
>>>>> @@ -0,0 +1,18 @@
>>>>> +#ifndef _KOBJ_COMPLETION_H_
>>>>> +#define _KOBJ_COMPLETION_H_
>>>>> +
>>>>> +#include <linux/kobject.h>
>>>>> +#include <linux/completion.h>
>>>>> +
>>>>> +struct kobj_completion {
>>>>> +	struct kobject kc_kobj;
>>>>> +	struct completion kc_unregister;
>>>>> +};
>>>>> +
>>>>> +#define kobj_to_kobj_completion(kobj) \
>>>>> +	container_of(kobj, struct kobj_completion, kc_kobj)
>>>>> +
>>>>> +void kobj_completion_init(struct kobj_completion *kc, struct kobj_=
type *ktype);
>>>>> +void kobj_completion_release(struct kobject *kobj);
>>>>> +void kobj_completion_del_and_wait(struct kobj_completion *kc);
>>>>> +#endif /* _KOBJ_COMPLETION_H_ */
>>>>> --- a/lib/kobject.c	2013-09-10 12:57:54.198666613 -0400
>>>>> +++ b/lib/kobject.c	2013-09-10 13:16:31.750607946 -0400
>>>>> @@ -13,6 +13,7 @@
>>>>>   */
>>>>> =20
>>>>>  #include <linux/kobject.h>
>>>>> +#include <linux/kobj_completion.h>
>>>>>  #include <linux/string.h>
>>>>>  #include <linux/export.h>
>>>>>  #include <linux/stat.h>
>>>>> @@ -711,6 +712,52 @@ const struct sysfs_ops kobj_sysfs_ops =3D
>>>>>  };
>>>>> =20
>>>>>  /**
>>>>> + * kobj_completion_init - initialize a kobj_completion object.
>>>>> + * @kc: kobj_completion
>>>>> + * @ktype: type of kobject to initialize
>>>>> + *
>>>>> + * kobj_completion structures can be embedded within structures wi=
th different
>>>>> + * lifetime rules.  During the release of the enclosing object, we=
 can
>>>>> + * wait on the release of the kobject so that we don't free it whi=
le it's
>>>>> + * still busy.
>>>>> + */
>>>>> +void kobj_completion_init(struct kobj_completion *kc, struct kobj_=
type *ktype)
>>>>> +{
>>>>> +	init_completion(&kc->kc_unregister);
>>>>> +	kobject_init(&kc->kc_kobj, ktype);
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(kobj_completion_init);
>>>>> +
>>>>> +/**
>>>>> + * kobj_completion_release - release a kobj_completion object
>>>>> + * @kobj: kobject embedded in kobj_completion
>>>>> + *
>>>>> + * Used with kobject_release to notify waiters that the kobject ha=
s been
>>>>> + * released.
>>>>> + */
>>>>> +void kobj_completion_release(struct kobject *kobj)
>>>>> +{
>>>>> +	struct kobj_completion *kc =3D kobj_to_kobj_completion(kobj);
>>>>> +	complete(&kc->kc_unregister);
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(kobj_completion_release);
>>>>> +
>>>>> +/**
>>>>> + * kobj_completion_del_and_wait - release the kobject and wait for=
 it
>>>>> + * @kc: kobj_completion object to release
>>>>> + *
>>>>> + * Delete the kobject from sysfs and  drop the reference count. Th=
en wait
>>>>> + * until any outstanding references are also dropped.
>>>>> + */
>>>>> +void kobj_completion_del_and_wait(struct kobj_completion *kc)
>>>>> +{
>>>>> +	kobject_del(&kc->kc_kobj);
>>>>> +	kobject_put(&kc->kc_kobj);
>>>>
>>>> Why the extra kobject_put() call?  Who added this extra reference to=
 the
>>>> object?
>>>
>>> There's an assumption that kobject_add will have been called on the
>>> initialized kobject. If it hasn't been called, the object can just be=

>>> deleted without the completion. It makes the calling code easier to
>>> read, so would it work for you if I documented that assumption in
>>> _del_and_wait?
>>
>> Actually, that's not it. The refcounting works out in my tests.
>>
>> The kobject's refcount is initialized to 1. kobject_add doesn't
>> increment it and kobject_del doesn't decrement it. So we need the
>> kobject_put to trigger the release function.
>>
>> Or am I missing something here?
>=20
> Ugh, no, you are right, this is all good as-is.  Do you want to take
> these through the ext4 tree, or do you want me to take them?

I'd prefer to get this one in now and wait until Ted's available to
discuss the ext4 change. My btrfs changes depend on this as well and I'd
like to get those moving now.

I have a newer version with an updated comment that explains the
lifetime a bit better that I'll send separately as a single patch.

Thanks.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--7EnnKGs7HwOlq6iVl5qkcesXhLxXHSfiI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSMKAfAAoJEB57S2MheeWyZ0wQAImQpZbfSlewxjczKKVaWUtf
JNkvqtdRL+S1N+298S3ySZb9gwL9Z8leDsjxSlQFD6HoifhPi6xtkV71nAC9ZLV6
sqthHOBSb2d0JVrKnW1xfY/CmV2vl47MtsSjHoDU24pXamOVMRadqk3TEWMTObIE
7p1dxknAhWMQycRqssGmw8y5q6ZMIrrxPycqqJHTvpbc9Df6/Ai611ZZ8Bcat3Ze
hAx+dRVbELMQuxjdVF7zbsNy6dlDVAsLgp9mVK9DRTu0kP/x+dikzXpmrPzEHKWL
87eXTDori+Cq1yw+r40p22IA5p/3X5AK/yyqvsZBjDr7EobQWBizG+h4O+GZgdBU
MRrTcsZlN7OV8HcGKiVnTFp8bUtBTJ3T+m3Di+IgBrvMghYm20G2MdL/Zu5MsSMG
rL7xMhbqcgkli6hw/+fZGNuYhvTsydO+WEjK6dyoPKav/kIjM0GF7tgS20kmsoOR
DNGdmMJEeoIap0NIbXKQlIi/PbgyDi9Bb6mabr1N9j5djizVm3RDWT3q/PVFhtq2
KIIC2BYnGgBruFya4p+SuWXbpBOBf/0kkbH8b+vyiXghUZAMRbJKFaDDHID7f74f
ngNKq21vlo0+0l88AQqj2955zO9o4zsfmFfUwCwjQSmk52nG6XlKluNvlTI63uNm
FYdjyqc5HZSYqjqRpZi/
=jjob
-----END PGP SIGNATURE-----

--7EnnKGs7HwOlq6iVl5qkcesXhLxXHSfiI--
