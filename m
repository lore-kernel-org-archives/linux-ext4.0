Return-Path: <SRS0=aCZM=QN=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA12C169C4
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Feb 2019 16:43:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFD1720811
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Feb 2019 16:43:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rTTyfTEn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731335AbfBFQng (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 6 Feb 2019 11:43:36 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33453 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730620AbfBFQnf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Feb 2019 11:43:35 -0500
Received: by mail-wr1-f67.google.com with SMTP id a16so8368982wrv.0;
        Wed, 06 Feb 2019 08:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XunTbA/qOGmGVXWLcmM2qvWl/ERcm3+O9CJBRBVoA3I=;
        b=rTTyfTEnMcDlpvbI4oV1D75HzRRIxQOt6cp06zZ598/z3BAKb0IpxccKUl4hl6E7au
         DJvnVSgBN4fArGotZHVRwEzYKSDHbpfXHCPGuq6tqpQHhGIwdzcB6zJSUkAm1rValsK2
         lb2cuVtiz3QPWomj0Lu0IcIRQvc5hBLPyUoWSPlKBU4Ol59D28C8MrsjkujuFERpuI1C
         n36gkS9KrJqgwmyX7ivOwPiqvLFetuLIgCYk0FDSAXLQCTl+RVmt6UNMP4iWzJtEKrWH
         ypum1XmwQPKCDHH1DZ9JWfh06ueoP1LlYmvRvgO9CtDZ6PaskQKqSWqZEPmAmN32iPkT
         rPDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XunTbA/qOGmGVXWLcmM2qvWl/ERcm3+O9CJBRBVoA3I=;
        b=GY4P6oT6Pthxo4teJAdJpBKpe8Qme2njF/q3ShcIQWr0kgualtZTpQxOPAqJ/3QNe5
         7fbYwRgOWr8hn1Q/U4sIX/1YNgsu1oT9GTB+ts2hXUC9QNlIsjlSBbao6Dg4k2Kop4W4
         /BcIlSs6GFeFUQ7ikcmnBEfssRB/DSY2Nw1ahkLe+XVZB9qm8OPNzG4+REylZ1Vl3R4q
         J7e0R4UkIGxWu0J/daTlAPniC9Rjpt0QPlpgzAkCKiw77/hv5kjyAx0C+IZMfKd1n/3x
         LmLPHkrfTIO4gp/YUKB400nCUBVk8SeWt0s24Iag0LJjB3yCU4Er+Y/8BNHGB6J+6xEE
         f00g==
X-Gm-Message-State: AHQUAuaGHmKedrmjEJiPsGdjhYZtl3OQsz9XJNShqSudK1YSwzxYGoJc
        BLmvrcGgr62GstpFrBWgZ2Q=
X-Google-Smtp-Source: AHgI3IYwz40wfVzzYyAghkT2M/S2ny2FfTA3Bn2gvMIAY72QKHXG0efDkQ8MiCXVJkmr2TJ08wzyag==
X-Received: by 2002:adf:fd0a:: with SMTP id e10mr8995390wrr.190.1549471412693;
        Wed, 06 Feb 2019 08:43:32 -0800 (PST)
Received: from pali ([2a02:2b88:2:1::5cc6:2f])
        by smtp.gmail.com with ESMTPSA id z17sm16833478wrv.2.2019.02.06.08.43.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 06 Feb 2019 08:43:30 -0800 (PST)
Date:   Wed, 6 Feb 2019 17:43:29 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     tytso@mit.edu, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, sfrench@samba.org,
        darrick.wong@oracle.com, samba-technical@lists.samba.org,
        jlayton@kernel.org, bfields@fieldses.org, paulus@samba.org
Subject: Re: [PATCH RFC v5 00/11] Ext4 Encoding and Case-insensitive support
Message-ID: <20190206164329.3kxq7h7qfqnqlbvr@pali>
References: <20190128213223.31512-1-krisman@collabora.com>
 <20190205181041.cdyt5jt7yrqswyy2@pali>
 <8736p2jbov.fsf@collabora.com>
 <20190206084752.nwjkeiixjks34vao@pali>
 <87sgx0hpiv.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mopuc73fnrog47ew"
Content-Disposition: inline
In-Reply-To: <87sgx0hpiv.fsf@collabora.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--mopuc73fnrog47ew
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wednesday 06 February 2019 11:04:24 Gabriel Krisman Bertazi wrote:
> Pali Roh=C3=A1r <pali.rohar@gmail.com> writes:
>=20
> > On Tuesday 05 February 2019 14:08:00 Gabriel Krisman Bertazi wrote:
> >> Pali Roh=C3=A1r <pali.rohar@gmail.com> writes:
> >>=20
> >> > On Monday 28 January 2019 16:32:12 Gabriel Krisman Bertazi wrote:
> >> >> The main change presented here is a proposal to migrate the
> >> >> normalization method from NFKD to NFD.  After our discussions, and
> >> >> reviewing other operating systems and languages aspects, I am more
> >> >> convinced that canonical decomposition is more viable solution than
> >> >> compatibility decomposition, because it doesn't ignore eliminate any
> >> >> semantic meaning, like the definitive case of superscript numbers. =
 NFD
> >> >> is also the documented method used by HFS+ and APFS, so there is
> >> >> precedent. Notice however, that as far as my research goes, APFS do=
esn't
> >> >> completely follows NFD, and in some cases, like <compat> flags, it
> >> >> actually does NFKD, but not in others (<fraction>), where it applie=
s the
> >> >> canonical form.  We take a more consistent approach and always do p=
lain NFD.
> >> >>=20
> >> >> This RFC, therefore, aims to resume/start conversation with some
> >> >> stalkeholders that may have something to say regarding the normaliz=
ation
> >> >> method used.  I added people from SMB, NFS and FS development who
> >> >> might be interested on this.
> >> >
> >> > Hello! I think that choice of NFD normalization is not right decisio=
n.
> >> > Some reasons:
> >> >
> >> > 1) NFD is not widely used. Even Apple does not use it (as you wrote
> >> >    Apple has own normalization form).
> >>=20
> >> To be exact, Apple claims to use NFD in their specification [1] .
> >
> > Interesting...
> >
> >> What I
> >> observed is that they don't ignore some types of compatibility
> >> characters correctly as they should. For instance, the ff ligature is
> >> decomposed into f + f.
> >
> > I'm sure that Apple does not do NFD, but their own invented normal form.
> > Some graphemes are decomposed, and some not.
> >
> >> > 2) All filesystems which I known either do not use any normalization=
 or
> >> >    use NFC.
> >> > 3) Lot of existing Linux application generate file names in NFC.
> >> >
> >>=20
> >> Most do use NFC.  But this is an internal representation for ext4 and =
it
> >> is name preserving.
> >
> > Ok. I was in impression that it does not preserve original names, just
> > like implementation in Apple's system, where char* passed to creat()
> > does not appear in readdir().
> >
> >> We only use the normalization when comparing if names
> >> matches and to calculate dcache and dx hashes.  The unicode standard
> >> recomends the D forms for internal representation.
> >
> > Ok, this should be less destructive and less visible to userspace.
> >
> >> > 4) Linux GUI libraries like Qt and Gtk generate strings from key str=
okes
> >> >    in NFC. So if user type file name in Qt/Gtk box it would be in NF=
C.
> >> >
> >> > So why to use NFD in ext4 filesystem if Linux userspace ecosystem
> >> > already uses NFC?
> >>=20
> >> NFC is costlier to calculate, usually requiring an intermediate NFD
> >> step.  Whether it is prohibitively expensive to do in the dcache path,=
 I
> >> don't know, but since it is a critical path, any gain matters.
> >>=20
> >> > NFD here just makes another layer of problems, unexpected things and
> >> > make it somehow different.
> >>=20
> >> Is there any case where
> >>    NFC(x) =3D=3D NFC(y) && NFD(x) !=3D NFD(y)   , or
> >>    NFC(x) !=3D NFC(y) && NFD(x) =3D=3D NFD(y)
> >
> > This is good question. And I think we should get definite answer for it
> > prior inclusion of normalization into kernel.
> >
> >> I am having a hard time thinking of an example.  This is the main
> >> (only?) scenario where choosing C or D form for an internal
> >> representation would affect userspace.
> >
> > For decision between normal format, probably yes.
> >
> >> >
> >> > Why not rather choose NFS? It would be more compatible with Linux GUI
> >> > applications and also with Microsoft Windows systems, which uses NFC
> >> > too.
> >> >
> >> > Please, really consider to not use NFD. Most Linux applications real=
ly
> >> > do not do any normalization or do NFC. And usage of decomposition fo=
rm
> >> > for application which do not implement full Unicode grapheme algorit=
hms
> >> > just make for them another problems.
> >>=20
> >> > Yes, there are still lot of legacy application which expect that one
> >> > code point =3D one visible symbol (therefore one Unicode grapheme). =
And
> >> > because GUI in most cases generates NFC strings, also existing file
> >> > names are in NFC, these application works in most cases without prob=
lem.
> >> > Force usage of NFD filenames just break them.
> >>=20
> >> As I said, this shouldn't be a problem because what the application
> >> creates and retrieves is the exact name that was used before, we'd
> >> only use this format for internal metadata on the disk (hashes) and for
> >> in-kernel comparisons.
> >
> > There is another problem for userspace applications:
> >
> > Currently ext4 accepts as file name any sequence of bytes which do not
> > contain nul byte and '/'. So having Latin1 file name is perfectly
> > correct.
> >
> > What would happen if userspace application want to create following two
> > file names? "\xDF" and "\F0"? First one is sharp S second one is eth (in
> > Latin1). But file names are invalid UTF-8 sequences. Is it disallowed to
> > create such file names? Or both file names are internally converted to
> > "U+FFFD" (replacement character) and because NFD(first U+FFFD) =3D=3D
> > NFD(second U+FFFD) only first file would be created?
> >
> > And what happen in general with invalid UTF-8 sequences? Because there
> > are many different types of invalid UTF-8 sequences, like non-shortest
> > sequence for valid code point, valid sequence for invalid code points
> > (either surrogate pairs code points, or code points above U+10FFFF,
> > ...), incorrect byte which should start new code point, incorrect byte
> > when decoding of code point started, ...
> >
> > Different (userspace) application handles these invalid UTF-8 sequences
> > differently, some of them accept some kind of "incorrectness" (e.g.
> > non-shortest form of code point representation), some not. Some
> > applications replace invalid parts of UTF-8 sequence by sequence of
> > UTF-8 replacement character, some not. Also it can be observed that some
> > applications use just one replacement characters and some other replace
> > invalid UTF-8 sequence by more replacement characters.
> >
> > So trying to "recover" from invalid UTF-8 sequence to valid one is done
> > in more ways... And usage of any existing way could cause problems...
> > E.g. not possible to create two files "\xDF\xF0" and "\xF0\xDF"...
>=20
> Basically there are 2 ways to sanely handle invalid utf-8 sequences
> inside the kernel.  I don't see much gain in handling different levels
> of incorrectness.  Opening up to "we now accept surrogate characters,
> but reject unmapped code points (which we must do, because of stability
> of future unicode versions)", makes everything much more unpredictable.

Yes, this just make lot of mess.

> Anyway, two ways to handle invalid sequences...
>=20
>   - 1. An invalid filename can't exist in the disk.  This means
>     reject the sequence and fail the syscall when coming from the
>     userspace, and flagging it as an error to be fixed by fsck when
>     identifying any of these sequences already on the disk.  This has
>     obvious backward compatibility problems with applications that want
>     to create filenames with invalid sequences.

Personally I'm for this variant. If directory is marked as "Unicode" I
would expect that file names in that directory are in Unicode. And not
mix of garbage (bytes, Latin1) and Unicode.

If directory is marked as Unicode and some application wants to store
into that directory Latin1, I think it should be really prohibited.
Otherwise, why such "Unicode" flag is there if it cannot be enforced?

>   - 2. An invalid filename can exist in the disk as a unique sequence.
>     In this case, we must decide how to handle invalid sequences that
>     eventually will appear.  The only sane way is to consider the entire
>     sequence an opaque byte sequence, essentially falling back to the
>     old behavior, which prevents userspace breakage.  We loose the
>     normalization/casefold feature for that directory entry only, but
>     the file is still accessible when using the exact match.
>=20
> Any variant of these, like trying to fix invalid sequences or trying to
> do a partial normalization/casefold as a best effort are insane to do in
> kernel space.

+1

> Patch 09 already implements both of the sane behaviors.  Through a
> flag in the file system, which defaults to the second case, ext4 will
> either reject or treat invalid sequences as opaque byte sequences.
>=20
> There are more details about handling of invalid sequences in the patch
> description.
>=20

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--mopuc73fnrog47ew
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQS4VrIQdKium2krgIWL8Mk9A+RDUgUCXFsOsAAKCRCL8Mk9A+RD
Ung/AJ99GnwIsFr1wkLs/h9WFlXPSMvi5ACfYo7Hu9EBvVhhruSbUJurwhjrkT8=
=hksn
-----END PGP SIGNATURE-----

--mopuc73fnrog47ew--
