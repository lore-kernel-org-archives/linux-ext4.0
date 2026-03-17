Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E701B4257
	for <linux-ext4@vger.kernel.org>; Tue, 17 Mar 2026 00:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773706837; cv=none; b=iVYItn94eg7H7nr/ubp5zgXr+zXOSbPSaRdCTKyfyioUPZdvyF709aAbJOvywtcXgsfDHdlcxEBDoIF3nyaJlq3KEW7lwbupccK6YxDdKHVriCnvx16/bqKuNN81QpFdkC44J4AOzE2JrdG1tLvNrTKsZtb68cd7sPyqBelnDsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773706837; c=relaxed/simple;
	bh=F7ypkGxHPwtRl4wfeoa7//3l2zqsKSz3HmujzyOgQ4A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bqP1PxvLE4oY+SN8MHPgXpm3A6GVak6YWJYVRsKvzBuv5p/gBc9Z+Z5yCJtolLRRUybbbZ8pL9bJdnOMlTHQwtlnBoA5H8nmcsCzhjUzhd3N1ytZ5Qa4VIL0IMZJVsDOUUb78Od1HouTZ7JhH0edMo1iX1Pv2P5aSEMln5+af+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YOiuQEeM; arc=none smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YOiuQEeM"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-64c9fcc24b3so4215385d50.1
        for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2026 17:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773706835; x=1774311635; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=48JB9E2cqyTgdUjWrBWhV/eLvghOag1WFsWhXGzBYzc=;
        b=YOiuQEeMsHnFGzTAzRaLameAIueaNygKUtSIxQEsrX/EpbPCitFG87xwR2xkykaQoq
         Lz24LvKuDD6to9SQlWwA0ueE2efXsEiEeNx16vWTG/IF5Yp47JdSdShfYpqPPCahHZbM
         0SO6biExWc/rkiKvJutmmQuSn8I1cvyl0Iv5+0LxHu3fZ4RUNz65E8JooAAnQfE95AXa
         OReE7LnNi/vX1xNhbogHV1DduX54OObijk+86tZ+42FcNSuwGjbPPqR+Iqj7iij1BBg9
         MojUohSxlToIW3vWsGU4RaU7CASXF9AT9fYjstiE0vZQIXEMspZTczbT65ErbGuYJne7
         Rm5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773706835; x=1774311635;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=48JB9E2cqyTgdUjWrBWhV/eLvghOag1WFsWhXGzBYzc=;
        b=FXHIE92f+e7OR3bSHecTLhWg0YM139lEOys8pL5Z8sCVP/2ZEhWe0xnabrlTzLTVBh
         TVyKdOKL7f4GatFrWgcgD4e6ZMx/aM82EVHjhWzBwX8yn5WRwGoHFsFnqbBpx30F2XnI
         FhWuIrJW84SMnlDQzxBeJoEVvnq0su7RNdWE+ChqvAxYRdCAS/AqbMOp8Jf2jzv7QOfr
         GasxFuy9jQi64pDmHATlcLu1OAoFv62Xcw9aEKz0HyEzsJFdGPLlxTUxf47LwK8Duphd
         nI0wn9A+ZLL9OybxmZgHxTQOGC0PseuxqP5X07mQ4M3ZAIyhzAW7HI4qa+UgSa3kDGmp
         tjjA==
X-Forwarded-Encrypted: i=1; AJvYcCX5PJgmo1HffCCGmZEiw9fv7Ba+J58y9r1pjUxViss4rLNX0U+NuSIPdBJBYpESDWmT4Z5t+9opl3mD@vger.kernel.org
X-Gm-Message-State: AOJu0YxX9uREn0quTxTijnmXfh8yZ7/2X7RySGhx6G2kFhsb4UIhpneZ
	ojzskBWUwOjfECj5TRr8QKPJ1N6q+m/fdnxJVKSVX2JbizGTIJnLWa7h
X-Gm-Gg: ATEYQzy/e/OuIL0cC7hV8cXwfZ9TMsFoBA+19Qvk/PeoWLAUW7LpBN48Cmi8LOiQvkE
	rHRIcG/xOic38UphZP1pH23HSX5mCMsYuouD0/rY9RmSkjuNlcegE/myGxUkDgJ2VaVVjgygQLk
	2OOakc6Q806U49zuVajWEBT/1mXl5n42Th6xmfnqNJS52QOewlVxIEh4pWcqFddrrGEJXIJnjob
	VUU7cw8DnyPR4hNHefQGz6vXnnVtiuk11nhH8IinY1YFP68feyOEpl8xuwJV6q7OnU5vg87YxnE
	yNHTR3IpHPhEzQD7BY4UaSL8K6Xb4pqXlGFqvBV2xV5X+zKNeVLhC/44D7MLC+PGLb7YB5G9Kqt
	WmnlNSzHts7JqiuDADLV3e4V8KbZtiiXET1vwxlqN5H9VFiOhQKgIywxTk4q20vYymWvO+MTlJ5
	jA3ecwi6Ra5VJi2zaZF4GlFIvFwWtl4XZlw2OL8FlAakQZvyhRmNSe4SNJAM1jOA3CqxWX2JqWn
	bGDs/jRrKa4vLfaeS1Fdnk1SBY1XhsbDPYi
X-Received: by 2002:a05:690e:1a83:b0:649:eb42:582 with SMTP id 956f58d0204a3-64e62f03b87mr11416294d50.2.1773706834454;
        Mon, 16 Mar 2026 17:20:34 -0700 (PDT)
Received: from [10.138.34.110] (h96-60-250-27.cncrtn.broadband.dynamic.tds.net. [96.60.250.27])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64e65b39cb8sm6454158d50.11.2026.03.16.17.20.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 17:20:33 -0700 (PDT)
Message-ID: <208bfbd2-d671-462c-925f-4d51b7df1f18@gmail.com>
Date: Mon, 16 Mar 2026 20:20:29 -0400
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHBLIZZARD v7] fuse/libfuse/e2fsprogs: containerize ext4 for
 safer operation
To: "Darrick J. Wong" <djwong@kernel.org>,
 Joanne Koong <joannelkoong@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, bpf@vger.kernel.org,
 linux-ext4 <linux-ext4@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
 Bernd Schubert <bernd@bsbernd.com>, Theodore Ts'o <tytso@mit.edu>,
 Neal Gompa <neal@gompa.dev>, Amir Goldstein <amir73il@gmail.com>,
 Christian Brauner <brauner@kernel.org>, Jeff Layton <jlayton@kernel.org>,
 John@groves.net
References: <20260223224617.GA2390314@frogsfrogsfrogs>
 <CAJnrk1Yd1J60-Ek=O7jzZQg454pbr3O=b71yZHzYbrWfqJr__w@mail.gmail.com>
 <20260316180408.GN6069@frogsfrogsfrogs>
 <CAJnrk1bmJYMt27xedN2Xza0KPXfYEbh-9g=3fNWru-HRM9WFEw@mail.gmail.com>
 <20260316234137.GJ1742010@frogsfrogsfrogs>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <20260316234137.GJ1742010@frogsfrogsfrogs>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------nTHHrQGBdX3R0zjBdnzu9bzA"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------nTHHrQGBdX3R0zjBdnzu9bzA
Content-Type: multipart/mixed; boundary="------------vgwoTj2oUpyBXwt4g5gkbSt4";
 protected-headers="v1"
Message-ID: <208bfbd2-d671-462c-925f-4d51b7df1f18@gmail.com>
Date: Mon, 16 Mar 2026 20:20:29 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHBLIZZARD v7] fuse/libfuse/e2fsprogs: containerize ext4 for
 safer operation
To: "Darrick J. Wong" <djwong@kernel.org>,
 Joanne Koong <joannelkoong@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, bpf@vger.kernel.org,
 linux-ext4 <linux-ext4@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
 Bernd Schubert <bernd@bsbernd.com>, Theodore Ts'o <tytso@mit.edu>,
 Neal Gompa <neal@gompa.dev>, Amir Goldstein <amir73il@gmail.com>,
 Christian Brauner <brauner@kernel.org>, Jeff Layton <jlayton@kernel.org>,
 John@groves.net
References: <20260223224617.GA2390314@frogsfrogsfrogs>
 <CAJnrk1Yd1J60-Ek=O7jzZQg454pbr3O=b71yZHzYbrWfqJr__w@mail.gmail.com>
 <20260316180408.GN6069@frogsfrogsfrogs>
 <CAJnrk1bmJYMt27xedN2Xza0KPXfYEbh-9g=3fNWru-HRM9WFEw@mail.gmail.com>
 <20260316234137.GJ1742010@frogsfrogsfrogs>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <20260316234137.GJ1742010@frogsfrogsfrogs>

--------------vgwoTj2oUpyBXwt4g5gkbSt4
Content-Type: multipart/mixed; boundary="------------NE9oyIaFXpZs1OIc0LAz45K4"

--------------NE9oyIaFXpZs1OIc0LAz45K4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 3/16/26 19:41, Darrick J. Wong wrote:
> On Mon, Mar 16, 2026 at 04:08:55PM -0700, Joanne Koong wrote:
>> On Mon, Mar 16, 2026 at 11:04=E2=80=AFAM Darrick J. Wong <djwong@kerne=
l.org> wrote:
>>>
>>> On Mon, Mar 16, 2026 at 10:56:21AM -0700, Joanne Koong wrote:
>>>> On Mon, Feb 23, 2026 at 2:46=E2=80=AFPM Darrick J. Wong <djwong@kern=
el.org> wrote:
>>>>>
>>>>> There are some warts remaining:
>>>>>
>>>>> a. I would like to continue the discussion about how the design rev=
iew
>>>>>    of this code should be structured, and how might I go about crea=
ting
>>>>>    new userspace filesystem servers -- lightweight new ones based o=
ff
>>>>>    the existing userspace tools?  Or by merging lklfuse?
>>>>
>>>> What do you mean by "merging lklfuse"?
>>>
>>> Merging the lklfuse project into upstream Linux, which involves runni=
ng
>>> the whole kit and caboodle through our review process, and then fixin=
g
>>
>> Gotcha, so it would basically be having to port this arch/lkl
>> directory [1] into the linux tree
>=20
> Right.
>=20
>>> user-mode-linux to work anywhere other than x86.
>>
>> Are lklfuse and user-mode-linux (UML) two separate things or is
>> lklfuse dependent on user-mode-linux?
>=20
> I was under the impression that lklfuse uses UML.  Given the weird
> things in arch/lkl/Kconfig:
>=20
> config 64BIT
> 	bool "64bit kernel"
> 	default y if OUTPUT_FORMAT =3D "pe-x86-64"
> 	default $(success,$(srctree)/arch/lkl/scripts/cc-objdump-file-format.s=
h|grep -q '^elf64-') if OUTPUT_FORMAT !=3D "pe-x86-64"
>=20
> I was kinda guessing x86_64 was the primary target of the developers?
>=20
> /me notes that he's now looked into libguestfs per Demi Marie's comment=
s
> and some curiosity on the part of ngompa and i>
>=20
> Whatever it is that libguestfs does to stand up unprivileged fs mounts
> also could fit this bill.  It's *really* slow to start because it takes=

> the booted kernel, creates a largeish initramfs, boots that combo via
> libvirt, and then fires up a fuse server to talk to the vm kernel.
>=20
> I think all you'd have to do is change libguestfs to start the VM and
> run the fuse server inside a systemd container instead of directly from=

> the CLI.

The feedback I have gotten from ngompa is that libguestfs is just
too slow for distros to use it to mount stuff.

>>>> Could you explain what the limitations of lklfuse are compared to th=
e
>>>> fuse iomap approach in this patchset?
>>>
>>> The ones I know about are:
>>>
>>> 1> There's no support for vmapped kernel memory in UML mode, so anyon=
e
>>> who requires a large contiguous memory buffer cannot assemble them ou=
t
>>> of "physical" pages.  This has been a stumbling block for XFS in the
>>> past.
>>>
>>> 2> LKLFUSE still uses the classic fuse IO paths, which means that at
>>> best you can directio the IO through the lklfuse kernel.  At worst yo=
u
>>> have to use the pagecache inside the lklfuse kernel, which is very
>>> wasteful.
>>
>> For the security / isolation use cases you've described, is
>> near-native performance a hard requirement?
>=20
> Not a hard requirement, just a means to convince people that they can
> choose containment without completely collapsing performance.
>=20
>> As I understand it, the main use cases of this will be for mounting
>> untrusted disk images and CI/filesystem testing, or are there broader
>> use cases beyond this?
>=20
> That covers nearly all of it.

It's worth noting that on ChromeOS and Android, the only trusted
disk images are those that are read-only and protected by dm-verity.
*Every* writable image is considered untrusted.

I don't know if doing a full fsck at each boot is considered
acceptable, but I suspect it would slow boot far too much.

Yes, Google ought to be paying for the kernel changes to fix this mess.

>>> 3> lklfuse hasn't been updated since 6.6.
>>
>> Gotcha. So if I'm understanding it correctly, the pros/cons come down =
to:
>> lklfuse pros:
>> - (arguably) easier setup cost. once it's setup (assuming it's
>> possible to add support for the vmapped kernel memory thing you
>> mentioned above), it'll automatically work for every filesystem vs.
>> having to implement a fuse-iomap server for every filesystem
>=20
> Or even a good non-iomap fuse server for every filesystem.  Admittedly
> the weak part of fuse4fs is that libext2fs is not as robust as the
> kernel is.
>=20
>> - easier to maintain vs. having to maintain each filesystem's
>> userspace server implementation
>=20
> Yeah.
>=20
>> lklfuse cons:
>> - worse (not sure by how much) performance
>=20
> Probably a lot, because now you have to run a full IO stack all the way=

> through lklfuse.

How much is "a lot"?  Is it "this is only useful for non-interactive
overnight backups", "you will notice this in benchmarks but it's okay
for normal use", or somewhere in between?

Could lklfuse and iomap be combined?

>> - once it's merged into the kernel, we can't choose to not
>> maintain/support it in the future
>=20
> Correct.
>=20
>> Am I understanding this correctly?
>>
>> In my opinion, if near-native performance is not a hard requirement,
>> it seems like less pain overall to go with lklfuse. lklfuse seems a
>> lot easier to maintain and I'm not sure if some complexities like
>> btrfs's copy-on-write could be handled properly with fuse-iomap.
>=20
> btrfs cow can be done with iomap, at least on the directio end.  It's
> the other features like fsverity/fscrypt/data checksumming that aren't
> currently supported by iomap.

Pretty much everyone on btrfs uses data checksumming.

>> What are your thoughts on this?
>=20
> "Gee, what if I could simplify most of my own work out of existence?"

What is that work?

> --D
>=20
>> Thanks,
>> Joanne
>>
>> [1] https://github.com/lkl/linux/tree/master/arch/lkl
>>
>>>
>>> --D
>>>
>>>> Thanks,
>>>> Joanne
>>>>
>>>>>
>>>>> b. ext4 doesn't support out of place writes so I don't know if that=

>>>>>    actually works correctly.
>>>>>
>>>>> c. fuse2fs doesn't support the ext4 journal.  Urk.
>>>>>
>>>>> d. There's a VERY large quantity of fuse2fs improvements that need =
to be
>>>>>    applied before we get to the fuse-iomap parts.  I'm not sending =
these
>>>>>    (or the fstests changes) to keep the size of the patchbomb at
>>>>>    "unreasonably large". :P  As a result, the fstests and e2fsprogs=

>>>>>    postings are very targeted.
>>>>>
>>>>> e. I've dropped the fstests part of the patchbomb because v6 was ju=
st
>>>>>    way too long.
>>>>>
>>>>> I would like to get the main parts of this submission reviewed for =
7.1
>>>>> now that this has been collecting comments and tweaks in non-rfc st=
atus
>>>>> for 3.5 months.
>>>>>
>>>>> Kernel:
>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.gi=
t/log/?h=3Dfuse-iomap-bpf
>>>>>
>>>>> libfuse:
>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/libfuse.git/=
log/?h=3Dfuse-iomap-bpf
>>>>>
>>>>> e2fsprogs:
>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.gi=
t/log/?h=3Dfuse-iomap-bpf
>>>>>
>>>>> fstests:
>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev=
=2Egit/log/?h=3Dfuse2fs
>>>>>
>>>>> --Darrick
>>


--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
--------------NE9oyIaFXpZs1OIc0LAz45K4
Content-Type: application/pgp-keys; name="OpenPGP_0xB288B55FFF9C22C1.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB288B55FFF9C22C1.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsFNBFp+A0oBEADffj6anl9/BHhUSxGTICeVl2tob7hPDdhHNgPR4C8xlYt5q49y
B+l2nipdaq+4Gk6FZfqC825TKl7eRpUjMriwle4r3R0ydSIGcy4M6eb0IcxmuPYf
bWpr/si88QKgyGSVZ7GeNW1UnzTdhYHuFlk8dBSmB1fzhEYEk0RcJqg4AKoq6/3/
UorR+FaSuVwT7rqzGrTlscnTDlPWgRzrQ3jssesI7sZLm82E3pJSgaUoCdCOlL7M
MPCJwI8JpPlBedRpe9tfVyfu3euTPLPxwcV3L/cfWPGSL4PofBtB8NUU6QwYiQ9H
zx4xOyn67zW73/G0Q2vPPRst8LBDqlxLjbtx/WLR6h3nBc3eyuZ+q62HS1pJ5EvU
T1vjyJ1ySrqtUXWQ4XlZyoEFUfpJxJoN0A9HCxmHGVckzTRl5FMWo8TCniHynNXs
BtDQbabt7aNEOaAJdE7to0AH3T/Bvwzcp0ZJtBk0EM6YeMLtotUut7h2Bkg1b//r
6bTBswMBXVJ5H44Qf0+eKeUg7whSC9qpYOzzrm7+0r9F5u3qF8ZTx55TJc2g656C
9a1P1MYVysLvkLvS4H+crmxA/i08Tc1h+x9RRvqba4lSzZ6/Tmt60DPM5Sc4R0nS
m9BBff0Nm0bSNRS8InXdO1Aq3362QKX2NOwcL5YaStwODNyZUqF7izjK4QARAQAB
zTxEZW1pIE9iZW5vdXIgKElUTCBFbWFpbCBLZXkpIDxhdGhlbmFAaW52aXNpYmxl
dGhpbmdzbGFiLmNvbT7CwY4EEwEIADgWIQR2h02fEza6IlkHHHGyiLVf/5wiwQUC
X6YJvQIbAwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRCyiLVf/5wiwWRhD/0Y
R+YYC5Kduv/2LBgQJIygMsFiRHbR4+tWXuTFqgrxxFSlMktZ6gQrQCWe38WnOXkB
oY6n/5lSJdfnuGd2UagZ/9dkaGMUkqt+5WshLFly4BnP7pSsWReKgMP7etRTwn3S
zk1OwFx2lzY1EnnconPLfPBc6rWG2moA6l0WX+3WNR1B1ndqpl2hPSjT2jUCBWDV
rGOUSX7r5f1WgtBeNYnEXPBCUUM51pFGESmfHIXQrqFDA7nBNiIVFDJTmQzuEqIy
Jl67pKNgooij5mKzRhFKHfjLRAH4mmWZlB9UjDStAfFBAoDFHwd1HL5VQCNQdqEc
/9lZDApqWuCPadZN+pGouqLysesIYsNxUhJ7dtWOWHl0vs7/3qkWmWun/2uOJMQh
ra2u8nA9g91FbOobWqjrDd6x3ZJoGQf4zLqjmn/P514gb697788e573WN/MpQ5XI
Fl7aM2d6/GJiq6LC9T2gSUW4rbPBiqOCeiUx7Kd/sVm41p9TOA7fEG4bYddCfDsN
xaQJH6VRK3NOuBUGeL+iQEVF5Xs6Yp+U+jwvv2M5Lel3EqAYo5xXTx4ls0xaxDCu
fudcAh8CMMqx3fguSb7Mi31WlnZpk0fDuWQVNKyDP7lYpwc4nCCGNKCj622ZSocH
AcQmX28L8pJdLYacv9pU3jPy4fHcQYvmTavTqowGnM08RGVtaSBNYXJpZSBPYmVu
b3VyIChsb3ZlciBvZiBjb2RpbmcpIDxkZW1pb2Jlbm91ckBnbWFpbC5jb20+wsF4
BBMBAgAiBQJafgNKAhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRCyiLVf
/5wiwYa/EACv8a2+MMou9cSCNoZBQaU+fTmyzft9hUE+0d5W2UY1RY3OsjFIzm9R
/4SVccfsqOYLEo+S0vQMIIIqFEq3FCpXXwPzyimotps05VA8U3Bd7yseojFygOgK
sAMOAee2RCaDDOnoJue01dfZMzzHPO/TVdp3OvnpWipfv5G1Xg96rwbhMLE3tg6N
xwAHa31Bv4/Xq8CJOoIWvx6fcmZQpz01/lSvsYn0KrfEbTKkuUf0vM9JrCTCP2oz
VNN5BYzqaq2M4r+jmSyeXLim922VOWqGkUEQ85BSEemqrRS06IU6NtEMsF8EWt/b
hWjk/9GDKTcnpdJHTrMxTspExBiNrvpI2t+YPU5B/dJJAUxvmhFrbSIbdB8umBZs
I3AMYrEmpAbh5x7jEjoskUC7uN3o9vpg1oCLS2ePDLtAtyBtbHnkA4xGD7ar8mem
xpH9lY/i+sC6CyyIUWcUDnnagKyJP0m9ks0GLsTeOCA0bft2XA6rD6aaCnMUsndT
ctrab42CV5XypjmC4U1rPJ8JQJUh1/3P48/8sMH+3krxpJ06KNWNFaUbaMTGiltZ
7x9DngklSYrX0T+2G4kVXNmjaljwkoLahwLla2gUWwBSyofXdqyhQdwZsp01KXNQ
UCyT/Pg+aDcm/E7OMV3d4lf7g/CSxiX2GSEe6BlhSz+Lmd7ZJ3g32M1ARGVtaSBN
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
EtJuZYM5blWncBOJCoWMnBEcTEo/viU3GgcVRw=3D=3D
=3Dx94R
-----END PGP PUBLIC KEY BLOCK-----

--------------NE9oyIaFXpZs1OIc0LAz45K4--

--------------vgwoTj2oUpyBXwt4g5gkbSt4--

--------------nTHHrQGBdX3R0zjBdnzu9bzA
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmm4nk4ACgkQszaHOrMp
8lNmOQ//S5TyJESKNg06H/u6s9ZsXOqW9CXTW80Yg+p4MD3kxTCQwG99Wz+26jw4
XmRznV93iLYr5KsMBXw/4REF4dZ8aAWUa8vXauT1KK3IFOXq66Cls7ZT6fUN9W7n
GoRPxcYHUoTiQeMD/MIEvBoXiVVtn03HukWrm3svSSVFh6iIu29FEvjsiLlMsTY0
OEOrmt8YKoDeveeK85RJHJQDodMkN4fiY5J2M60rWYMnHs6px6KuqF/bLKjcdSJS
Ug/0iLgWCmUMUq3wmiDN7GwvBYrBWo01q+3seOYCq6qor48OYBUa6AVH2fPZqvNM
ivj4ozVK40fcYnteiLoWGbuly7ec8FIKLxnqh7OIcY6sS97e4UWi4Xsff2nkn7SZ
dvxW885g+soVoiec8KEm04Xqw1H1L5i4EmtpWPFxEHOzZuVbUNT5gJOFEXTVrzPf
fr51aWLpnwuq9uNrewAOSOzDYOlkDJy7LqR9z/wbohjEdmH4zCZfUvtrlCoMAXaC
XOi0CL8rnORek2Q//Ze4I9uV9lqMeP80hDjRUQRmTGAiwh5D0fbYVdq4ZQtJ6foj
Y13gLN0nf7pCQam2BrMtbBCooIljcNUAOT9/eMIA100PdHw6DubhXxCIi1cMpzkO
/ifH46xE0PKWp8adcS9QM+hCFy9Ws788/aDFQjfzm3FoWURV91o=
=TWv5
-----END PGP SIGNATURE-----

--------------nTHHrQGBdX3R0zjBdnzu9bzA--
