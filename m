Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4369CC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 09:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2C1721873
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 09:29:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QwgjG8E1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbfCUJ3h (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 05:29:37 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36658 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727870AbfCUJ3h (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2019 05:29:37 -0400
Received: by mail-lf1-f65.google.com with SMTP id d18so4097795lfn.3
        for <linux-ext4@vger.kernel.org>; Thu, 21 Mar 2019 02:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=CLedUwqhxF+R5WJmpzJrZZ4h952dWY02weYXKrnz16M=;
        b=QwgjG8E1pLO6IFRgtm8oIbYmTJoRS24l0k91O4WB4WAa/7PBD64ueEfZHTWmV0bdpT
         86faxdOIYlfCR1O0I9zPSndALRjyoSSTHszmhLeqjRhy5X7IaZOsrIzw4DLW4asSyB0s
         CMl4PCUvo96NMc/oCNKXXi6zX55dT7Y2PjUVSKNe52k5lzx9mcLsSsIf7LpDxZPOHCjO
         CHkquOQOcksTGISbHZ1e3dRVsK1AuTVdan4IrAkrXrAlQc+4J9+ps32qYqWrwh++upFr
         YsbxhuxIJgtLTm2VDuhcgL1FrXW5JLoC6Z9PkSfnX8er3OjyWk2S6P4SKAW05jEeT75G
         PqXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=CLedUwqhxF+R5WJmpzJrZZ4h952dWY02weYXKrnz16M=;
        b=mU7qj/C+yt1SHxrE7yiDjjSFMQbh5dFxKXwr7bG9VybOfuy65GGXL6my+fG7K8ASOj
         UQ12U9INmDlQ3a68CvwvEtuhrZ3u4keGPwE6EeiccAPkaKikHgScqtPxx76O7/IRoMGP
         CxTM/CgvSU3JfUh3UewMvmgZ282jBk1oWbZTW7yWotD2e1tz7oaS0EARmFbZCjoXq8AD
         ILVfQG6VbZiVON9JlboXowDg4g+8Ow296L7LPDDHW+6iZI+WxeITIQjrKON5PWZLJ2YS
         PVahumlsnPvxnNuOpgsTGM4qAnbJUVrJLb0ZyhlK77PugWJRy596thzl99UFAdvl57BC
         q9DQ==
X-Gm-Message-State: APjAAAVKm7Y2pvOmN/aKpMxJ1iM7mfji2OXPVJe8BsL/IQaPhFM4woHj
        CUznoUS09LZT9MlrCUpxAbCEwUyz
X-Google-Smtp-Source: APXvYqwrRUF6UbUtRay/bSFvKDI8fBYCFjAFk9neKkuuUsYVHxnEz5Bym5uep3S6DhJpOiVqbrkpPQ==
X-Received: by 2002:a19:7007:: with SMTP id h7mr1434743lfc.23.1553160573471;
        Thu, 21 Mar 2019 02:29:33 -0700 (PDT)
Received: from localhost ([5.172.255.105])
        by smtp.gmail.com with ESMTPSA id g24sm855537lfb.49.2019.03.21.02.29.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Mar 2019 02:29:32 -0700 (PDT)
Subject: Re: Question about ext4 extents and file fragmentation
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     linux-ext4@vger.kernel.org
References: <aad2611a-9640-9ec1-108a-f67ba662c301@gmail.com>
 <20190321031833.GB32021@mit.edu>
From:   Mikhail Morfikov <mmorfikov@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=mmorfikov@gmail.com; prefer-encrypt=mutual; keydata=
 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
 VyIzwTcJuLgTKoPQBcfsUkg=
Message-ID: <a1dba5a8-ecdd-4618-0dc2-7cf4a67b0d40@gmail.com>
Date:   Thu, 21 Mar 2019 10:29:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190321031833.GB32021@mit.edu>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="ZfwKZG9yaXO0lsffW53751r3zSayYjmj3"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZfwKZG9yaXO0lsffW53751r3zSayYjmj3
Content-Type: multipart/mixed; boundary="YbyqMDX5x3IgPDmJWNnXXtHC1uoE1jg5N";
 protected-headers="v1"
From: Mikhail Morfikov <mmorfikov@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Message-ID: <a1dba5a8-ecdd-4618-0dc2-7cf4a67b0d40@gmail.com>
Subject: Re: Question about ext4 extents and file fragmentation
References: <aad2611a-9640-9ec1-108a-f67ba662c301@gmail.com>
 <20190321031833.GB32021@mit.edu>
In-Reply-To: <20190321031833.GB32021@mit.edu>

--YbyqMDX5x3IgPDmJWNnXXtHC1uoE1jg5N
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 21/03/2019 04:18, Theodore Ts'o wrote:
> On Wed, Mar 20, 2019 at 11:44:19PM +0100, Mikhail Morfikov wrote:
>> When we have a big file on an ext4 partition, and filefrag shows
>> the following:
>>
>> filefrag -ve /bigfile
>> Filesystem type is: ef53
>> File size of /bigfile is 1439201280 (351368 blocks of 4096 bytes)
>>  ext:     logical_offset:        physical_offset: length:   expected: =
flags:
>>    0:        0..   32767:      34816..     67583:  32768:           =20
>>    1:    32768..   63487:      67584..     98303:  30720:           =20
>>    2:    63488..   96255:     100352..    133119:  32768:      98304:
>>    3:    96256..  126975:     133120..    163839:  30720:           =20
>>    4:   126976..  159743:     165888..    198655:  32768:     163840:
>>    5:   159744..  190463:     198656..    229375:  30720:           =20
>>    6:   190464..  223231:     231424..    264191:  32768:     229376:
>>    7:   223232..  253951:     264192..    294911:  30720:           =20
>>    8:   253952..  286719:     296960..    329727:  32768:     294912:
>>    9:   286720..  319487:     329728..    362495:  32768:           =20
>>   10:   319488..  351367:     362496..    394375:  31880:             =
last,eof
>> /bigfile: 5 extents found
>>
>> 1. How many fragments does this file really have? 11 or 5?=20
>> 2. Should the extents 0 and 1 be treated as one fragment or two=20
>>    separate ones? I know they could be one from the human=20
>>    perspective, but is it really one for ext4 filesystem?
>=20
> They are encoded as two separate physical extents on disk.  Logically,
> extents 0, 1, and 2 are contiguous regions on idks.So 5 fragments then?=


>> 3. What does actually happen during the read in the case of=20
>>    some HDD and its magnetic heads? If the head finishes reading=20
>>    the whole extent (ext 0), will it be able to read the data of=20
>>    the next extent (ext 1) without any delays like in the case of
>>    raw read (for instance dd if=3D/dev/sda ...), or will it be=20
>>    delayed because of the filesystem layer, and the head will=20
>>    have to spend some time to be positioned again in order to=20
>>    read the next extent?
>=20
> The delay won't be because of the file system layer, as the
> information about these first three extents will all be stored on the
> same block on disk.  In addition, ext4 has an in-memory "extent cache"
> which stores the logical->physical block mapping, and in memory, it
> will be stored as a single entry in the extent cache.
>=20
> It takes *time* to read 128 megabytes (32768 4k blocks), and from a
> hard drive perspective, you are doing a streaming sequential read, how
> the file system metadata is stored is not going to be the limiting
> factor.  In fact, it's likely that they won't be issued to the hard
> drive as a single I/O request anyway.  But that doesn't matter; the
> hard drive has an I/O request queue, and so the right thing will
> happen.
>=20

Yes, I know that many things can happen during the 128M read. But wecan a=
ssume that we have some simplified environment, where we have=20
only one disk, one file we want to read at the moment, and we have=20
time to do it without any external interferences.

If I understood correctly, as long as the extents reside on a contiguous =

region, they will be read sequentially without any delays, right? So if=20
the file in question was one big contiguous region, would it be read=20
sequentially from the beginning of the file to its end?=20

Also I have a question concerning the following sentence[1]:=20
  "When there are more than four extents to a file, the rest of the=20
  extents are indexed in a tree."=20
Does this mean that only four extents can be read sequentially in a=20
file that have only contiguous blocks of data, or because of the=20
extent cache, the whole file can be read sequentially anyway?

[1] https://en.wikipedia.org/wiki/Ext4#Features



--YbyqMDX5x3IgPDmJWNnXXtHC1uoE1jg5N--

--ZfwKZG9yaXO0lsffW53751r3zSayYjmj3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE5JPPWm5C7TFDUMqpzQRoEHcbZSAFAlyTWXMACgkQzQRoEHcb
ZSDaVA//c5y+IvcZRKsns7EuuHhcFoWIP+eiLP/qCNaMaARQFb7ZomH48BI/28rR
O3ysEaiZJo3hP9uyLYEavwmjLUzd8JT5gQ3MXl8HiOCvaca1GT/LbmwMQltzwq3r
UM/9kWCdcNeyHWjS1NYXIRYe4hiZMGKqsF+uFW7Q+J8BIBx2BLC3gFrxQ8mh+I+6
wMga7Mvqb9w7JlNEzxcGkWD+HH5UGFsp7UBaCiP8qOxi4byEjVLVhhdGsXtSD6uA
foRQ1Hx/aXVaoMDdoMIeaugJ2uFtU4VnHMvZNUdbCqpN330Qu+VEAr5pkqUjyu5P
qB5+YhUkDNvOy5RzueQo4rnx+PEmXiX0S3vrVJ/gBBescxHMm2efpj5+QnSQ06Tk
JkySu5TEjfuiRq8ozb0R4Wr0IduTP+hJhyW5ABjSF5KVEMFCfzc6dWHdlLCK8+k6
kXrWaRZjsxzvAin3vGxR3EgvZZ+iWxCt+OlDr3p3cLolDDNk9Pd/XL4Q8W65xr7B
gzwmGIwXWQRdexaz6tjTWoocKK+bIaJt95a41CkeMZvgxRaB2k9av9Odn7jCw8jd
58dRyOlyIeJCKLU4hcZft95OsKX6DYkmLu6853aX7UDvYDayArblnOdePfijW122
8PRXFEikHtT0CpHuvO9aOKj9xb5WeAm9xi35EDh2mwFIO+TSB0w=
=MVnJ
-----END PGP SIGNATURE-----

--ZfwKZG9yaXO0lsffW53751r3zSayYjmj3--
