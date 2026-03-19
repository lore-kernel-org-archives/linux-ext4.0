Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980CF38B140
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 07:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773905311; cv=none; b=b2G8TvILG34exzIVerG2N8m/LcCRWQ/aUvsRiJiJISOSeYqJz5YpGRKJjCvj6YhxPXc9eh2FrcO5Y/QJIONQMR8huFZ+YdFHAG5Ih/GAWDHqC2qwIQhGC4M9nA4WD93okB6ZpqNUOIK1AzViumHdrOyz+ywKj53V0YDgW98nT0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773905311; c=relaxed/simple;
	bh=iav2cLlZCS5Xo4XXCbu79fxtbB2QJn5dqssJwFXp4po=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DWj3M8h6SYAlKAHJXg1z1rOEpndXROgE+LAyRBgXW62C9i3ojiSe8CSm9iBw1sC11sAttUg12eNKuvHrtJKHYwgmsyahTFBJSfnhYmt2g8X+5UR+gByyoLqbav+tZEzgJ63X4C7Q6wsTlUhyv8fqMsg+dIA2rD4QspEiHIGe8tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bDpTdXNU; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bDpTdXNU"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-79801df3e42so7390467b3.0
        for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 00:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773905309; x=1774510109; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+61vtNSvszNmenUwP/98X5OrqGA0rN1WyPtrA/5C/wQ=;
        b=bDpTdXNU54oZxU3oUXnHNHIns/JWPnFWIdxRsjb0oWKOlIG730wTSw76d5w9SVN0nN
         5DA1fyrxSCWWAVbOR45xwm3a3X4zwCx6EkvdnkoWL3ckcw3C9sRDNgGJQD50fIbHHbpe
         e8YLLDZ2Lj/zlda0Hkix2FkoEe8eBrP3HC7XhY+mMWDL9SDeTeyw0j6r/04qhLRVj0yM
         uVMA8Ckp6hzTe68ZjV4uFSJF36dZTY/rVSlLB30NFa6VY+NZf/ezQF5xPq9xBdBLIS/X
         qLTDJSYRJDXb7ynMs8d0EGKfwDyyB9FiGdf9fM5Sw37PIHGWVkOq6lUYwUw0g2XoQKJM
         m//A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773905309; x=1774510109;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+61vtNSvszNmenUwP/98X5OrqGA0rN1WyPtrA/5C/wQ=;
        b=Ic1b53Iq4EI+OYjn/7kFmbId5qERRSAJ8Wntcj6p47vYOj7N96ad9oT5vfc1zYlBEL
         qoyHsQ1f8tLs1YQb9LdAZjvmlWAEoRPt0TQDvm4SCwjO5GPcpuIZoG0EvVE3GCubVcQR
         bL6aKhxoQ8yEQfoAM8xX3fTNQOiRWXQVmSO4b1Y5h8A9bdLjb5hvfedtxXot4tS3SYUv
         1nSHtQ+4EavOfmcwWEzq0TV8zAmpxpU4zaLhK6456CVH5N9gQSAlqqf4XOv6P17d8M7e
         7m8DS6GMFkkkWyc0y8kd5kYlr94rrW4fcTQ6HgkDK7X8iD22EZBXHsd62NW2Ft7AteJc
         jdLw==
X-Forwarded-Encrypted: i=1; AJvYcCWcj+fjVPO8oUkaYcn8Cz7ucSVzF/+J9RtdzSc1tE9PMkXN08xnQHG07wPiPVwVQp7GGpBeMS3zLYWg@vger.kernel.org
X-Gm-Message-State: AOJu0YwR+PD+NJCH31QxMxCfHuaOnsYemnjfX6jBrgmxrds28pZ2phJo
	jZH/BkKxy4J+rkz6j/wxaiGN0qxwKo2glLuarSQ6yIucFTREM5vgjyhb
X-Gm-Gg: ATEYQzzsiZ1fEkE80vt6hEIQQHP/k9++F13m1azd9hn1kUKab0mbqplJPIQAjEUMqiX
	orqcKAWGRcSyJGHT5Xfl5tuEKCgTu3/3PIJxFifuhXDcKp2HKCPXAQqfuJ03KSZt4ELvix86kn3
	H9yqQ9oo7AUozf8QL3HE2iIE4sPQrWzY2qU09KBgZY6xJaHWRuqq4KWr9yQNM1IKGBu2ydd9QIL
	ubLgMwikETPI/RpFxrSS29ZilqATYZMMT0sl6tF/RYR2LorA2qXiKxzzLdhTrMf4fBgAGjzoaC7
	nVDw/QbBX1dxrXqz7cFtYWnlXDjdtYJ8FXW8J4DhJmgu8KVhA4YSYDgosYhUhwJdPMKgVXFk5Al
	oHs+Nbz3Qf0Qgxetah46PZWBCp80oRK9lD7SCE+gH2SpcwQXVVATC9jaIxgIuWlv26zGSSCSCma
	9cmHFrk6pdm7fc4KMzWIYvXg++Qs7a1shJXuzsJy/qvoYgITMi4GPbK0tePmVVqrzXRoQ2Jyxnn
	HijNjGtIn6muAZD2KN1OlCuEQyy8IHp4flwtLK0xb7BDz72Ng==
X-Received: by 2002:a05:690c:397:b0:79a:7cff:7b7e with SMTP id 00721157ae682-79a81c0fcbcmr22128047b3.30.1773905308492;
        Thu, 19 Mar 2026 00:28:28 -0700 (PDT)
Received: from [10.138.34.110] (h69-131-148-49.cncrtn.broadband.dynamic.tds.net. [69.131.148.49])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a7136e513sm31869077b3.10.2026.03.19.00.28.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2026 00:28:26 -0700 (PDT)
Message-ID: <c7866006-bd17-4fd8-a603-bd3016fdfeb0@gmail.com>
Date: Thu, 19 Mar 2026 03:28:21 -0400
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHBLIZZARD v7] fuse/libfuse/e2fsprogs: containerize ext4 for
 safer operation
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, bpf@vger.kernel.org,
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
 <208bfbd2-d671-462c-925f-4d51b7df1f18@gmail.com>
 <20260318213129.GB6004@frogsfrogsfrogs>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <20260318213129.GB6004@frogsfrogsfrogs>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------vIhdbkSOLMJQt8x0nBZ9EWkr"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------vIhdbkSOLMJQt8x0nBZ9EWkr
Content-Type: multipart/mixed; boundary="------------HHsfsbA1ONUwdZ3230mdsUS6";
 protected-headers="v1"
Message-ID: <c7866006-bd17-4fd8-a603-bd3016fdfeb0@gmail.com>
Date: Thu, 19 Mar 2026 03:28:21 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHBLIZZARD v7] fuse/libfuse/e2fsprogs: containerize ext4 for
 safer operation
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, bpf@vger.kernel.org,
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
 <208bfbd2-d671-462c-925f-4d51b7df1f18@gmail.com>
 <20260318213129.GB6004@frogsfrogsfrogs>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <20260318213129.GB6004@frogsfrogsfrogs>

--------------HHsfsbA1ONUwdZ3230mdsUS6
Content-Type: multipart/mixed; boundary="------------fHYglZ8MU0VZGSXbY09Gawku"

--------------fHYglZ8MU0VZGSXbY09Gawku
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 3/18/26 17:31, Darrick J. Wong wrote:
> On Mon, Mar 16, 2026 at 08:20:29PM -0400, Demi Marie Obenour wrote:
>> On 3/16/26 19:41, Darrick J. Wong wrote:
>>> On Mon, Mar 16, 2026 at 04:08:55PM -0700, Joanne Koong wrote:
>>>> On Mon, Mar 16, 2026 at 11:04=E2=80=AFAM Darrick J. Wong <djwong@ker=
nel.org> wrote:
>>>>>
>>>>> On Mon, Mar 16, 2026 at 10:56:21AM -0700, Joanne Koong wrote:
>>>>>> On Mon, Feb 23, 2026 at 2:46=E2=80=AFPM Darrick J. Wong <djwong@ke=
rnel.org> wrote:
>>>>>>>
>>>>>>> There are some warts remaining:
>>>>>>>
>>>>>>> a. I would like to continue the discussion about how the design r=
eview
>>>>>>>    of this code should be structured, and how might I go about cr=
eating
>>>>>>>    new userspace filesystem servers -- lightweight new ones based=
 off
>>>>>>>    the existing userspace tools?  Or by merging lklfuse?
>>>>>>
>>>>>> What do you mean by "merging lklfuse"?
>>>>>
>>>>> Merging the lklfuse project into upstream Linux, which involves run=
ning
>>>>> the whole kit and caboodle through our review process, and then fix=
ing
>>>>
>>>> Gotcha, so it would basically be having to port this arch/lkl
>>>> directory [1] into the linux tree
>>>
>>> Right.
>>>
>>>>> user-mode-linux to work anywhere other than x86.
>>>>
>>>> Are lklfuse and user-mode-linux (UML) two separate things or is
>>>> lklfuse dependent on user-mode-linux?
>>>
>>> I was under the impression that lklfuse uses UML.  Given the weird
>>> things in arch/lkl/Kconfig:
>>>
>>> config 64BIT
>>> 	bool "64bit kernel"
>>> 	default y if OUTPUT_FORMAT =3D "pe-x86-64"
>>> 	default $(success,$(srctree)/arch/lkl/scripts/cc-objdump-file-format=
=2Esh|grep -q '^elf64-') if OUTPUT_FORMAT !=3D "pe-x86-64"
>>>
>>> I was kinda guessing x86_64 was the primary target of the developers?=

>>>
>>> /me notes that he's now looked into libguestfs per Demi Marie's comme=
nts
>>> and some curiosity on the part of ngompa and i>
>>>
>>> Whatever it is that libguestfs does to stand up unprivileged fs mount=
s
>>> also could fit this bill.  It's *really* slow to start because it tak=
es
>>> the booted kernel, creates a largeish initramfs, boots that combo via=

>>> libvirt, and then fires up a fuse server to talk to the vm kernel.
>>>
>>> I think all you'd have to do is change libguestfs to start the VM and=

>>> run the fuse server inside a systemd container instead of directly fr=
om
>>> the CLI.
>>
>> The feedback I have gotten from ngompa is that libguestfs is just
>> too slow for distros to use it to mount stuff.
>=20
> Yes, libguestfs is /verrrry/ slow to start up.
>=20
>>>>>> Could you explain what the limitations of lklfuse are compared to =
the
>>>>>> fuse iomap approach in this patchset?
>>>>>
>>>>> The ones I know about are:
>>>>>
>>>>> 1> There's no support for vmapped kernel memory in UML mode, so any=
one
>>>>> who requires a large contiguous memory buffer cannot assemble them =
out
>>>>> of "physical" pages.  This has been a stumbling block for XFS in th=
e
>>>>> past.
>>>>>
>>>>> 2> LKLFUSE still uses the classic fuse IO paths, which means that a=
t
>>>>> best you can directio the IO through the lklfuse kernel.  At worst =
you
>>>>> have to use the pagecache inside the lklfuse kernel, which is very
>>>>> wasteful.
>>>>
>>>> For the security / isolation use cases you've described, is
>>>> near-native performance a hard requirement?
>>>
>>> Not a hard requirement, just a means to convince people that they can=

>>> choose containment without completely collapsing performance.
>>>
>>>> As I understand it, the main use cases of this will be for mounting
>>>> untrusted disk images and CI/filesystem testing, or are there broade=
r
>>>> use cases beyond this?
>>>
>>> That covers nearly all of it.
>>
>> It's worth noting that on ChromeOS and Android, the only trusted
>> disk images are those that are read-only and protected by dm-verity.
>> *Every* writable image is considered untrusted.
>>
>> I don't know if doing a full fsck at each boot is considered
>> acceptable, but I suspect it would slow boot far too much.
>=20
> Not to mention that an attacker who gained control of the boot process
> could inject malicious filesystem metadata after fsck completes
> successfully but before the kernel mount occurs.
>=20
>> Yes, Google ought to be paying for the kernel changes to fix this mess=
=2E
>>
>>>>> 3> lklfuse hasn't been updated since 6.6.
>>>>
>>>> Gotcha. So if I'm understanding it correctly, the pros/cons come dow=
n to:
>>>> lklfuse pros:
>>>> - (arguably) easier setup cost. once it's setup (assuming it's
>>>> possible to add support for the vmapped kernel memory thing you
>>>> mentioned above), it'll automatically work for every filesystem vs.
>>>> having to implement a fuse-iomap server for every filesystem
>>>
>>> Or even a good non-iomap fuse server for every filesystem.  Admittedl=
y
>>> the weak part of fuse4fs is that libext2fs is not as robust as the
>>> kernel is.
>>>
>>>> - easier to maintain vs. having to maintain each filesystem's
>>>> userspace server implementation
>>>
>>> Yeah.
>>>
>>>> lklfuse cons:
>>>> - worse (not sure by how much) performance
>>>
>>> Probably a lot, because now you have to run a full IO stack all the w=
ay
>>> through lklfuse.
>>
>> How much is "a lot"?  Is it "this is only useful for non-interactive
>> overnight backups", "you will notice this in benchmarks but it's okay
>> for normal use", or somewhere in between?
>=20
> Startup is painfully slow.  Normal operation isn't noticeably bad, but =
I
> didn't bother doing any performance comparisons.
>=20
>> Could lklfuse and iomap be combined?
>=20
> Probably, though you'd have to find a way to route the FUSE_IOMAP_*
> requests to a filesystem driver.  That's upside-down of the current
> iomap model where filesystems have to opt into using iomap on a
> per-IO-path basis, and then iomap calls the filesystem to find mappings=
=2E

If it does get done it would be awesome.  I don't think I'll be able to
contribute, though.

>>>> - once it's merged into the kernel, we can't choose to not
>>>> maintain/support it in the future
>>>
>>> Correct.
>>>
>>>> Am I understanding this correctly?
>>>>
>>>> In my opinion, if near-native performance is not a hard requirement,=

>>>> it seems like less pain overall to go with lklfuse. lklfuse seems a
>>>> lot easier to maintain and I'm not sure if some complexities like
>>>> btrfs's copy-on-write could be handled properly with fuse-iomap.
>>>
>>> btrfs cow can be done with iomap, at least on the directio end.  It's=

>>> the other features like fsverity/fscrypt/data checksumming that aren'=
t
>>> currently supported by iomap.
>>
>> Pretty much everyone on btrfs uses data checksumming.
>>
>>>> What are your thoughts on this?
>>>
>>> "Gee, what if I could simplify most of my own work out of existence?"=

>>
>> What is that work?
>=20
> Everything I've put out since the end of online fsck for xfs.

Is pretty much all of that work either on better FUSE performance or
fixes for problems found by fuzzers?
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
--------------fHYglZ8MU0VZGSXbY09Gawku
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

--------------fHYglZ8MU0VZGSXbY09Gawku--

--------------HHsfsbA1ONUwdZ3230mdsUS6--

--------------vIhdbkSOLMJQt8x0nBZ9EWkr
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmm7pZYACgkQszaHOrMp
8lPxABAAiyrwZLj/rX1jHPynCw5cQkko3SI5z4ijyfGJKgqDa//zA4UPoLAT4CrY
U8DhWLWmHzz8bys1mp24dV/iOeJS9OItNAza8KBwfFCoXjzZl/KA3NxEgNbYUGJi
9IVgV2PuOYRHcHDeZ/TNI1kUu6j1sfvOTWocVD9IlNEFr+aI9itDuoJuz4lR24Uy
i1KnYzcW70BM0YIP8+eqGnNG7EDmc8EuywLf/zNOzaChkQMbp9UeiDSvSItzsFzg
0BuRl2U4X34bNX40cKZTjymyetgaEZ+6pFZs6KvW3MG28PYZH5hjECe4YFGgqEyW
BCPP4MR9w4LZrcY4PsGVPE2EqLAQmg5j/NsRXhnOnIpS35fXd0BpcI2fu1pxSreD
HIQWB3pRxVmHRrp6sXJaGmOYo02b6xDLXfhohaoidzRf2tsH4ovIRN8Xqkaca7iH
6IDgYF747yk2+QALhOkQP2U4iRUBjfXA1ywjrJK6JcwC3M/QENYYGWaBGZHxa/A3
NhxV8JboowAeWyKzJ59ECVg5tDqbV4KX7E2V2PnPl2j3gJny6w/R4HpZLwsP9egw
esQiXw2UBhrumo/B+u8wIr4ERQ2h5hvIsZbCTDkpSNtCE/mJnNH5/EJAQ3hvI7CP
ySPSwJ8ev3lBJHnUTQmFntIszzt+aaULW+MQIprXel/jJxoQfYc=
=kAhD
-----END PGP SIGNATURE-----

--------------vIhdbkSOLMJQt8x0nBZ9EWkr--
