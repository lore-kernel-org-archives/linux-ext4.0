Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E60C3C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 15:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AADEA21874
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 15:59:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j/gfm5Jz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbfCUP7r (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:59:47 -0400
Received: from mail-lj1-f180.google.com ([209.85.208.180]:42046 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728013AbfCUP7r (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2019 11:59:47 -0400
Received: by mail-lj1-f180.google.com with SMTP id v22so5732696lje.9
        for <linux-ext4@vger.kernel.org>; Thu, 21 Mar 2019 08:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=wR7yoRq52RgK4xNiDnd7qZmPBbQfKwDqcHytURCgh+E=;
        b=j/gfm5JzXi0+7WAwquyvQdwN5VZIBBPwA8hIuIYLFAKpgDh3pLcn1otpt+46xIZbF0
         a0LDC11wjmV1ct5k8iwG7XeGP3XXKedD6O82wpB9FaEU9S/N5Yj4srSdmiEx4WpCINTx
         hlzVGz/Rrcr2DdQ1GIBoDyZtj4DSdT7d84UTsee3yONcZ2qWdW41KxGT2LqBmg7wXBB7
         USMX846SppvbeCQr4YAt5IWMgYxMahN5CR1OU4L2l0+KQ8XyV0RV8bTcPAUvc8ULC57e
         ct5v3xlFK7I7Irr75NRrxkzv6VrJhnLT7xkWlm25PJ+lJ5Ni5ILOutHAXgQrWr9r1t81
         v0gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=wR7yoRq52RgK4xNiDnd7qZmPBbQfKwDqcHytURCgh+E=;
        b=KEnk3sWI+qqz2bN46W034k2FrvNQDPfxoFncf3Id5hej+ivIjZweDPkVbv90kwkvqC
         8l/bThd3XFri+3/x7zzfYW7Nft3KEBZWOypKNlBb+z/ziJcOVIfretEe+CTmEocOgaui
         wpQ1xAeJAkE3KFIAI9U6Rt7uE2dEDwuaePr8BybqS1qPIkCI8l6P/xdrB/+4KFZjYsqm
         D0125suwwZ9Cyq9I4qOheT92H8suEg6bEkK3+kj+Gjf342nLTHN9HyNhwh1v/VDMrncr
         6++/1JksgAVthLwhs9rNDgdVyegzuq3vycBeeIdYOFXXxDRMwo1HM2HmhVUIYwP7eQzy
         uZOA==
X-Gm-Message-State: APjAAAVLLp4ewvHZWV5s2ar456fKnFXso5PqP8RhgMV2tvvV1jQbpRWv
        33oH6dX07j01LNs3y21c6GmWGJaH
X-Google-Smtp-Source: APXvYqxAAd6fwBS1XHI7+0MGalF37vxepvv1VHqXqfU3wJvRtz47EufzV9eni1qVQaoyKV7Gdviekw==
X-Received: by 2002:a2e:8701:: with SMTP id m1mr2445973lji.132.1553183983855;
        Thu, 21 Mar 2019 08:59:43 -0700 (PDT)
Received: from localhost ([5.172.255.168])
        by smtp.gmail.com with ESMTPSA id 15sm1027449lft.88.2019.03.21.08.59.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Mar 2019 08:59:43 -0700 (PDT)
Subject: Re: Question about ext4 extents and file fragmentation
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     linux-ext4@vger.kernel.org
References: <aad2611a-9640-9ec1-108a-f67ba662c301@gmail.com>
 <20190321031833.GB32021@mit.edu>
 <a1dba5a8-ecdd-4618-0dc2-7cf4a67b0d40@gmail.com>
 <20190321150520.GE9434@mit.edu>
From:   Mikhail Morfikov <mmorfikov@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=mmorfikov@gmail.com; prefer-encrypt=mutual; keydata=
 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
 VyIzwTcJuLgTKoPQBcfsUkg=
Message-ID: <d32355a6-19b3-7861-9323-a761ea02d9f5@gmail.com>
Date:   Thu, 21 Mar 2019 16:59:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190321150520.GE9434@mit.edu>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="0CQslNEktQ03I0Tdzk8zN80nzu56XiWbQ"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0CQslNEktQ03I0Tdzk8zN80nzu56XiWbQ
Content-Type: multipart/mixed; boundary="F2dwoE7XqK1AQQupyKxcTfG0bCPqW1hMR";
 protected-headers="v1"
From: Mikhail Morfikov <mmorfikov@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Message-ID: <d32355a6-19b3-7861-9323-a761ea02d9f5@gmail.com>
Subject: Re: Question about ext4 extents and file fragmentation
References: <aad2611a-9640-9ec1-108a-f67ba662c301@gmail.com>
 <20190321031833.GB32021@mit.edu>
 <a1dba5a8-ecdd-4618-0dc2-7cf4a67b0d40@gmail.com>
 <20190321150520.GE9434@mit.edu>
In-Reply-To: <20190321150520.GE9434@mit.edu>

--F2dwoE7XqK1AQQupyKxcTfG0bCPqW1hMR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 21/03/2019 16:05, Theodore Ts'o wrote:
> It *could* be read sequentially from the beginning of the file to the
> end.  There are many things that might cause that not to happen, that
> have nothing to do with how we store the logical to physicla map.

And this is what I wanted to know, because some people tell that if you=20
store a file in a filesystem, it can't be read sequentially as a whole=20
because of the filesystem layer (compared to "dd if=3D/dev/sda ..."). So =

the filesystem layer doesn't really matter and doesn't really add any=20
additional delays compared to the raw read of a device when we deal with =

data that is stored in contiguous blocks. I know that many things can=20
prevent the sequential read from happening, but I just wanted it to be=20
clarified.=20

Thank you for the answer, I really appreciate it.



--F2dwoE7XqK1AQQupyKxcTfG0bCPqW1hMR--

--0CQslNEktQ03I0Tdzk8zN80nzu56XiWbQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE5JPPWm5C7TFDUMqpzQRoEHcbZSAFAlyTtOwACgkQzQRoEHcb
ZSAiihAAv1/G2ZphjsZ2aVwCnTjazcEc8OxWLf0K4tpr+3vxjjDPR59ENyD/YQjf
rCrJgyJR9ahu/A17PonwcFUPduVtqr2KeFvwztqlpaIr1o9zT1hAoPX8TQN1+dy+
MGgi8gsePRdOCynb4gkTYiFPU+/NKVueN6bDl14/Ud+oB7Dh42FtJphG3Z96wdsr
DY5lvAlb5Zrkx3aBK/TxKHvT2MmTGEEkJVxmYj/D5+ZZlegr8xO3qFdVbYn/l/W9
9vBjad9+1oIr7dOl1OxPtMJ3TZ25gBsFIx+Rg3a11QOjH0AvpX1v7YvTwCAcGwcG
I3tCY1pT+DAeXXoTOIAShWts+YI9wXjwZOIVH6z+kU98Isi2BPsl/3Mr6Hk4EqAX
x2CGc9cn/jf8v+HJ4Xk9Ddah9AK+ETG/xizYoOysOrL31QSFiFfJSxSdNy2t20S1
mzP9fQ8KSREJOPbXKPlRNVMqQBu91eM+Uky7Tq8064xGVow1ULV3l0dwR7K94nAS
nsYkDTsqcdGFLL2uGcLL8dLHowwFqbAyyq7Uj1iS+vo4+GgejmroZnXzpMnEfiKu
BNUT4zM/lpCwVkNMH4OYqp5NIE6zWhULQhRrvUheLHf2BMDH5qEZ4E395aPoeKZz
dLCXuaeu1DIZtnJKPDGvlaYWM+emoFTlRz/csan7yNtrs01GrQU=
=4UPo
-----END PGP SIGNATURE-----

--0CQslNEktQ03I0Tdzk8zN80nzu56XiWbQ--
