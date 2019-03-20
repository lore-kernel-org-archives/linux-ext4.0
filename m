Return-Path: <SRS0=eYnO=RX=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6064C43381
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Mar 2019 22:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 947F4218AE
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Mar 2019 22:44:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cs22tefv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbfCTWoa (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Mar 2019 18:44:30 -0400
Received: from mail-lj1-f175.google.com ([209.85.208.175]:34066 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727597AbfCTWoa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Mar 2019 18:44:30 -0400
Received: by mail-lj1-f175.google.com with SMTP id j89so3755675ljb.1
        for <linux-ext4@vger.kernel.org>; Wed, 20 Mar 2019 15:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:openpgp:autocrypt:message-id:date:user-agent
         :mime-version;
        bh=XAoG4CtgXiAU8+WuMctk5gLRRLMAWXeWUK1AzCq2UVc=;
        b=Cs22tefveOvDUjRVGcz+G40zz4fXaZotfQR9K+g+OSH7rYzH6RE1gJaKDohGnX6pjM
         EYJ0c6eqC3eAwIdXnNVMmBo/utszrHh6Ki1oYrKRNC8ERUhbpFIJEWjpW7cXzqJzyryO
         uv375lVC+2plqzoG7J5TFmpjiZ+mjz3hvwhEJkEI94dPAQvgBdi89RXtnSu1PsMEDf/z
         m3qiE6SluOlCZ/KOKSvGdBqwfunUX2F1SjJJxKIDlZL8DmaQUgyxyS7JCJvEDP4I/xct
         iNrmDg19kmw9GvgQuwOtnc4lmVpj9Vm8RJaP2YL1U9adE2iwY+GZaNLA0j/FsnjBSSpk
         okqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:openpgp:autocrypt:message-id
         :date:user-agent:mime-version;
        bh=XAoG4CtgXiAU8+WuMctk5gLRRLMAWXeWUK1AzCq2UVc=;
        b=S3qFWkGmi3qOuEuUlPq7c6n+JVYoiVqDHJpJ9GWzquse1Kd+Nz4R7xKeTD3VWnYpXA
         AmTtm7fdgsTz1tmLa0g/64SHkQdxpROU898WpPCyeu0E0Z7soVp/z2q7cFhiDUDEYw6G
         LM9nUwBBRJXQazmupq4wOs5Dvycu+JPbO/I8pvVbAU5faP2GBtHnNN2x31cwb9ZLmQ62
         eiG4qO4dcl8jx9kM0RKRDky2mAkybxTYdg5JBLC7krrL6svvjdoH2NOcwLPr1wCkjXxU
         L5yUJ1QiumCxKGNnciRS8SMHLnURj+Ci7uGH6UbCvpwfo36L7/kciYFJidLkUZfyTy9C
         +ScQ==
X-Gm-Message-State: APjAAAU5vXM3kZPMGIMkVOmmz3ygqTVCb/g2YDfZ0PRxBv+lyIxAvazX
        s+Im+e/9XotuCahNDs2ChiFjssL3
X-Google-Smtp-Source: APXvYqz6fJE3xH+NovO5EsW+m+Gnmoq48Z2VBOEtQCUe/FEfBjPRnA/jLnI58Gf0fC3m8+3Wuv7PVQ==
X-Received: by 2002:a2e:709:: with SMTP id 9mr287349ljh.4.1553121867258;
        Wed, 20 Mar 2019 15:44:27 -0700 (PDT)
Received: from localhost ([5.172.255.23])
        by smtp.gmail.com with ESMTPSA id i24sm549739ljb.31.2019.03.20.15.44.26
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Mar 2019 15:44:26 -0700 (PDT)
To:     linux-ext4@vger.kernel.org
From:   Mikhail Morfikov <mmorfikov@gmail.com>
Subject: Question about ext4 extents and file fragmentation
Openpgp: preference=signencrypt
Autocrypt: addr=mmorfikov@gmail.com; prefer-encrypt=mutual; keydata=
 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
 VyIzwTcJuLgTKoPQBcfsUkg=
Message-ID: <aad2611a-9640-9ec1-108a-f67ba662c301@gmail.com>
Date:   Wed, 20 Mar 2019 23:44:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="bT9jIS82RJb0WArOv5q7mJ7aNdmlagQq4"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bT9jIS82RJb0WArOv5q7mJ7aNdmlagQq4
Content-Type: multipart/mixed; boundary="kAGSEFb9zHjWpJRdlyqixx21AOGHpBYwc";
 protected-headers="v1"
From: Mikhail Morfikov <mmorfikov@gmail.com>
To: linux-ext4@vger.kernel.org
Message-ID: <aad2611a-9640-9ec1-108a-f67ba662c301@gmail.com>
Subject: Question about ext4 extents and file fragmentation

--kAGSEFb9zHjWpJRdlyqixx21AOGHpBYwc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

When we have a big file on an ext4 partition, and filefrag shows
the following:

filefrag -ve /bigfile
Filesystem type is: ef53
File size of /bigfile is 1439201280 (351368 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: fla=
gs:
   0:        0..   32767:      34816..     67583:  32768:           =20
   1:    32768..   63487:      67584..     98303:  30720:           =20
   2:    63488..   96255:     100352..    133119:  32768:      98304:
   3:    96256..  126975:     133120..    163839:  30720:           =20
   4:   126976..  159743:     165888..    198655:  32768:     163840:
   5:   159744..  190463:     198656..    229375:  30720:           =20
   6:   190464..  223231:     231424..    264191:  32768:     229376:
   7:   223232..  253951:     264192..    294911:  30720:           =20
   8:   253952..  286719:     296960..    329727:  32768:     294912:
   9:   286720..  319487:     329728..    362495:  32768:           =20
  10:   319488..  351367:     362496..    394375:  31880:             las=
t,eof
/bigfile: 5 extents found

1. How many fragments does this file really have? 11 or 5?=20
2. Should the extents 0 and 1 be treated as one fragment or two=20
   separate ones? I know they could be one from the human=20
   perspective, but is it really one for ext4 filesystem?
3. What does actually happen during the read in the case of=20
   some HDD and its magnetic heads? If the head finishes reading=20
   the whole extent (ext 0), will it be able to read the data of=20
   the next extent (ext 1) without any delays like in the case of
   raw read (for instance dd if=3D/dev/sda ...), or will it be=20
   delayed because of the filesystem layer, and the head will=20
   have to spend some time to be positioned again in order to=20
   read the next extent?


--kAGSEFb9zHjWpJRdlyqixx21AOGHpBYwc--

--bT9jIS82RJb0WArOv5q7mJ7aNdmlagQq4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE5JPPWm5C7TFDUMqpzQRoEHcbZSAFAlySwkkACgkQzQRoEHcb
ZSDtMxAA3p05Wbi24G/17i3OsZbzLarLrzPZSEJU/wgKbE/0jb1Uv0wBYyr8jDhB
/AjvIv3wRS3C4Nng6rnspIkosmK6yaGvgEjKxkCsRL3sfkNaeso6pI/u8m0RDxsv
zoniM3+QWZ0J1nT3Dft0AQpZv5lV7LDboyXaFZlnF4AvceDa8HXqSmM5patl8SvL
GnzzyOE3xGNRE5x67Hftw3jFXqS4s9XJdvxpTobtnAoz1EAx1V2UR2WY3D/oWK2X
ZeqlkaS3Zy3RE2iHYbhhPwkn54ANgBWk+boPYUKLhPw6z7s2gIKl1K1WjO5g4VPR
IGXtVS2NfMQuJXDuIJH4UIwEw4YznkYyQoRzrbRGNzLd6f5cOpRJvwcdZ4vukQmD
9E06Fw6ssdQgfZrsYfsfxAJOyoQp5q9wfal34bNswObFHvxIc58R6frmFOlBpnVl
gZIOcS9Aldn0X4FrH/NIugDomobwQynlO0DQbwVogY1LGGxw/tovfe5H2LnEvNs7
+m7GSl5YKun399FiU7csa2S1Evw0GPvkpDn4rkuGJzjgtnTRqes4bfs42E0WiuaK
jJbU9yUgo7QVlnVphv2PFm5noLQ0zcEaf4FbktDRwUaBrvMHIakSZ9907ILu6ZiJ
gjXJ2RqK4rYj69CjehlY3327hnuMvmuUXYa4Q+RZvGmVahkGjB8=
=6U+G
-----END PGP SIGNATURE-----

--bT9jIS82RJb0WArOv5q7mJ7aNdmlagQq4--
