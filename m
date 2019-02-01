Return-Path: <SRS0=gd00=QI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF6BC169C4
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 01:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0ED320844
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 01:45:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="D6KXrh/w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfBABpe (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 31 Jan 2019 20:45:34 -0500
Received: from mail-pf1-f169.google.com ([209.85.210.169]:33576 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfBABpd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jan 2019 20:45:33 -0500
Received: by mail-pf1-f169.google.com with SMTP id c123so2368764pfb.0
        for <linux-ext4@vger.kernel.org>; Thu, 31 Jan 2019 17:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=Dk9TPM/GdHHvDXo1P3dyIp+qMpX7IJSJ1nAf4Wsnz0Y=;
        b=D6KXrh/wqM7FCn4S0q58BwA3kcEMo33yNHTvxVpN429OKJp43/xeAdY0pM7yt4N946
         6lHbO6w5exNiaCQ7XhaWi5jcIaY728E6+kI9ix1UtJ75cpMBeBIwJ8hiySL01Rpcbfs2
         tire1n7RDse+Rh/ftC0IUIzL1Hlgng2W6oDByKtvwp/9DwlCBsf2qmSHx6Cp6Cy3XWDq
         u2c4PdvLEqile+fgvfoNe2GuVS+SWGVYlXkPfhdo6tSVBxBo/am4SY6uc2dLubVOAKIF
         Vxscwivs+hLJGa4/4ZAr/w0UVe9UddVOu8Ye5ep96vNqrG5nkxxcZy+PcfNtUHNd7SBI
         6jcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=Dk9TPM/GdHHvDXo1P3dyIp+qMpX7IJSJ1nAf4Wsnz0Y=;
        b=o+ec5aKkPF4p5JBNqsW051vSbCkwqhTkHly+uzFHRNGdfbI7qc9iOzhg73UozqtMJ0
         Y5d9WyDOSoDzLkTZoojIvWRh4/5hgBo3AUqKB1LcvfO/ttjo79hUioJD/A9iR9du3AR/
         wIueLHT2HVUIZ2eCaVxonZR9gVdiKOByq9v5wIimmF+QV5OY5rN6RseG/LPEmssB0mzJ
         rAGNkbgVT9c5VI06FWnJTuR9xOl79aaSN+rKzqva9sy6wmFy0c0uzIVElmGq3ujYYi3a
         phE3aIT9CSdsK7X0eE3ckcEL3S/QQydFBqd4VG6T+EVgwA9r9VlbDdSOqrKZmEMzdInW
         a+xA==
X-Gm-Message-State: AJcUukeRVQRiV8PTSMnp0MtvvYplqdn3nDuZTjOWQk7YGWs82fOn8ccR
        mG4W4y7CbuaIyHK4+Tx5sdU/yYvGIvQ=
X-Google-Smtp-Source: ALg8bN4ZiIzZ49m+I3ISHk5IHfEg60V/WKdkjVf/NH+TbBIVfXb/EKxmHT+m+QrOt1fPbD9YGhDPQQ==
X-Received: by 2002:a65:50c1:: with SMTP id s1mr32886387pgp.350.1548985532648;
        Thu, 31 Jan 2019 17:45:32 -0800 (PST)
Received: from cabot.adilger.ext (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id l74sm10617797pfb.145.2019.01.31.17.45.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Jan 2019 17:45:31 -0800 (PST)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <B510E1BD-618E-4E26-88B1-8D70F78C9EEF@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_3D2DBF02-7125-4239-A639-44D714FE66E6";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: question about ext4 backup block group descriptors
Date:   Thu, 31 Jan 2019 18:45:29 -0700
In-Reply-To: <4fc3271a-3098-afcd-24c1-e2e130e1e86a@linux.alibaba.com>
Cc:     linux-ext4@vger.kernel.org
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <4fc3271a-3098-afcd-24c1-e2e130e1e86a@linux.alibaba.com>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_3D2DBF02-7125-4239-A639-44D714FE66E6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 31, 2019, at 1:07 AM, Xiaoguang Wang =
<xiaoguang.wang@linux.alibaba.com> wrote:
>=20
> Anyone can help answer when ext4's backup block group descriptors are =
updated?
> I had used blktrace to track the corresponding backup block group =
descriptor
> block, but didn't find that any backup blocks were written.
> Thanks in advance.

The ext4 kernel code never updates the backup block group descriptors.  =
That is only
done by e2fsck.

Cheers, Andreas






--Apple-Mail=_3D2DBF02-7125-4239-A639-44D714FE66E6
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlxTpLkACgkQcqXauRfM
H+A3kQ//dVyUSJXrLZe5yszNJlo94dOJeoG8DFaMosKr+6J8KBvwWo0OdToGYjB+
ms+/Ct6q7m4vAcd+J9nTj3a0YMFqKFKX21DZRzGDaqXnyhKOly+U/3Eb1iQMWcU1
IqFuCIEIqEJh/y1f9L87izhsahlu0qesQ4QH8M0fHZxuuHrEQZ01wLFS/BPWGDzn
7seHrG4Sdg/+pRInVg1n266gl0s9K23wMvh0caYqf9F6/j2Xk+u80/eOWmWeMbbK
LKAkROJgbYorPoKgt+aOWGdkhzWbpROg6jvC/xeRrys1Ye6jaejTf4NsMuwb7268
vPI+WbrLw5WsI0dGff4tBz+FxqEGu1pAXu/nxl4H52B5dNjOv0aZuJIQ6S6VHu5e
dVpDjZsgkdKwfyDHvHu0M65CCXyhX1HMzpLcznjFKGrSirXVVkyJXxaUMvSx4Ks/
nAPH96ih0vDR2ZA3TRsQpqr3OidddhS4r6NcWTVe+tc0R2cB17pgxs/wgMkyJhPH
aJtam5ceMAoOzmy/drh2BL6yTP4XRF46a32WAImB3o/JdKN4rnA3R0XRBu5+e45U
LEtLpGi2ywR55EyAO2axoF3LBOK5rC9HSEayADOxqpqnFq7lp8gxZrbED+nQendI
lMCTWETn3R5J/9F5nM5wi29IEegE/pqZruK4COP7TqfaFZXE3M4=
=adm6
-----END PGP SIGNATURE-----

--Apple-Mail=_3D2DBF02-7125-4239-A639-44D714FE66E6--
