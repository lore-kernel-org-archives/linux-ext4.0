From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/3] mke2fs: print a message when creating a regular file
Date: Mon, 05 May 2014 09:46:29 -0500
Message-ID: <5367A445.9070209@redhat.com>
References: <1399295044-24489-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.1405051532280.2223@localhost.localdomain> <20140505135239.GB22287@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
	=?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932770AbaEEOqb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 10:46:31 -0400
In-Reply-To: <20140505135239.GB22287@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/5/14, 8:52 AM, Theodore Ts'o wrote:
> On Mon, May 05, 2014 at 03:41:01PM +0200, Luk=C3=A1=C5=A1 Czerner wro=
te:
>> On Mon, 5 May 2014, Theodore Ts'o wrote:
>>
>>> Date: Mon,  5 May 2014 09:04:02 -0400
>>> From: Theodore Ts'o <tytso@mit.edu>
>>> To: Ext4 Developers List <linux-ext4@vger.kernel.org>
>>> Cc: Theodore Ts'o <tytso@mit.edu>
>>> Subject: [PATCH 1/3] mke2fs: print a message when creating a regula=
r file
>>
>> Description is missing.
>=20
> I didn't think more of a description was needed; can you suggest one?

Well, sometimes the summary is enough - if this patch just added a prin=
tf,
the summary covers the functional change.  However, I think it's useful
to see the rationale for a change, not just the description of the chan=
ge.

"Close file descriptors before exit" doesn't really need any rationale,
but changing program behavior and/or output might.

AFAIK, nobody ever complained that a changelog was too descriptive or
informative.  ;)

>>>  	/* Can't undo discard ... */
>>> -	if (!noaction && discard && (io_ptr !=3D undo_io_manager)) {
>>> +	if (!noaction && discard && dev_size && (io_ptr !=3D undo_io_mana=
ger)) {
>>
>> I wonder whether it's possible not to have dev_size set at this poin=
t ?
>=20
> I checked, and I don't believe so.  ext2fs_get_device_size2() never
> returns EXT2_ET_UNIMPLEMENTED any more; and it hasn't for quite some
> time, since it will use st_size for a regular file or do a binary
> search trying to figure out the device size in the worst case.  So in
> fact, there are some code paths we can eliminate in misc/mke2fs.c
> which will simplify this analysis.
>=20
> Even if there is some case in the future where dev_size could be left
> unset, it will be initialized to zero, at which point we will fail
> safe by skipping the mke2fs_discard_device() call.

I kind of lost the thread here; if it is impossible to be unset, why
add the check?

And if (!dev_size) what would happen on this path?  I guess I need to g=
et
all the pending patches applied to see what's changed in this area.

-Eric

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
