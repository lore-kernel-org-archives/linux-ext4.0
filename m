Return-Path: <SRS0=EtEF=SK=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1704C282CE
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 08:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72ECA20880
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 08:32:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="gd2s8fuT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfDHIcs (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 8 Apr 2019 04:32:48 -0400
Received: from mx1.hrz.uni-dortmund.de ([129.217.128.51]:42695 "EHLO
        unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfDHIcr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Apr 2019 04:32:47 -0400
Received: from [192.168.111.102] (p4FD97841.dip0.t-ipconnect.de [79.217.120.65])
        (authenticated bits=0)
        by unimail.uni-dortmund.de (8.16.0.41/8.16.0.41) with ESMTPSA id x388Wae9014486
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 8 Apr 2019 10:32:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
        s=unimail; t=1554712356;
        bh=Uk6uwp4gg9ru7RqxhbYQpWbIeFsIc1fVaAZyDLRZOGU=;
        h=To:References:From:Subject:Date:In-Reply-To;
        b=gd2s8fuTkcF0FkWkKIhbpq+TAAq216cfBljwcrnOjAL5g3bLIHDsk0fXU5n4Anr7V
         ItifDhwtLJx4q38IjtmE9MQvGVm18FASrbvy6AM0Yke5BDjZlA4Oew4ZGg5i3O53b/
         v7bMBKwSS0qUHvtHi95DI2oxQnrkBC1to5WG5Pcc=
To:     "Theodore Ts'o" <tytso@mit.edu>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190318184237.20677-1-alexander.lochmann@tu-dortmund.de>
 <20190407165206.GA11370@mit.edu>
From:   Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
Openpgp: preference=signencrypt
Autocrypt: addr=alexander.lochmann@tu-dortmund.de; prefer-encrypt=mutual;
 keydata=
 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
 spNrcZJf1pbo3EKkCwUPAltq51ramtYzOu4K
Subject: Re: [v2] Updated locking documentation for transaction_t
Message-ID: <ec3b972e-8342-8359-448d-3efaa476d5b3@tu-dortmund.de>
Date:   Mon, 8 Apr 2019 10:32:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190407165206.GA11370@mit.edu>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="QujOxx9qOUhlsgJBKG2yXBfMiCpigu2y2"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QujOxx9qOUhlsgJBKG2yXBfMiCpigu2y2
Content-Type: multipart/mixed; boundary="0gJGAOjWAU57Dz8MOiGFxijoJifWO3kPJ";
 protected-headers="v1"
From: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
To: Theodore Ts'o <tytso@mit.edu>,
 Horst Schirmeier <horst.schirmeier@tu-dortmund.de>, Jan Kara
 <jack@suse.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <ec3b972e-8342-8359-448d-3efaa476d5b3@tu-dortmund.de>
Subject: Re: [v2] Updated locking documentation for transaction_t
References: <20190318184237.20677-1-alexander.lochmann@tu-dortmund.de>
 <20190407165206.GA11370@mit.edu>
In-Reply-To: <20190407165206.GA11370@mit.edu>

--0gJGAOjWAU57Dz8MOiGFxijoJifWO3kPJ
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

Thanks, Ted, for your feedback!
I'll submit a modified version.

- Alex

On 07.04.19 18:52, Theodore Ts'o wrote:
> On Mon, Mar 18, 2019 at 07:42:37PM +0100, Alexander Lochmann wrote:
>>  	/*t
>> -	 * Where in the log does this transaction's commit start? [no lockin=
g]
>> +	 * Where in the log does this transaction's commit start?
>> +	 * [journal_t.j_state_lock]
>>  	 */
>>  	unsigned long		t_log_start;
>=20
> Well, technically, that's not quite right.  It's only assigned in one
> location, and we hold j_state_lock, yes.  But that's because we need
> to access journal->j_head.  At the point where we set t_log_start, the
> transaction has already been locked down (transaction->t_state >
> T_LOCKED).
>=20
> Similarly, we happen to be holding j_state where it is currently being
> accessed, but it's not because we needed the lock in order to access
> t_log_start safely.
>=20
>>  	/*
>> -	 * When transaction started
>> +	 * When transaction started [journal_t.j_state_lock]
>>  	 */
>>  	unsigned long		t_start;
>=20
> And again, not really.  The primary place where t_start is set is when
> the transaction is firstt created, before it's visible anywhere else.
> after that, it is used exclusively by the commit thread, and so no
> locking is necessary.  It's true that in the places where it is used,
> j_state_lock happens to be taken, but it's strictly not necessary.
>=20
>> =20
>>  	/*
>> -	 * When commit was requested
>> +	 * When commit was requested [journal_t.j_state_lock]
>>  	 */
>>  	unsigned long		t_requested;
>=20
> Yes, that appears to be correct.
>=20
>> =20
>>  	/*
>> -	 * Checkpointing stats [j_checkpoint_sem]
>> +	 * Checkpointing stats [journal_t.j_list_lock]
>>  	 */
>>  	struct transaction_chp_stats_s t_chp_stats;
>>
>=20
> This appears to be correct.
>=20
> 						- Ted
>=20

--=20
Technische Universit=C3=A4t Dortmund
Alexander Lochmann                PGP key: 0xBC3EF6FD
Otto-Hahn-Str. 16                 phone:  +49.231.7556141
D-44227 Dortmund                  fax:    +49.231.7556116
http://ess.cs.tu-dortmund.de/Staff/al


--0gJGAOjWAU57Dz8MOiGFxijoJifWO3kPJ--

--QujOxx9qOUhlsgJBKG2yXBfMiCpigu2y2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEElhZsUHzVP0dbkjCRWT7tBbw+9v0FAlyrByMACgkQWT7tBbw+
9v1Q2w/+KIrz/e5uCzA/SohPCxptVjvyF5q3KhXhuZMSz5xty1XU7sIeGivkquHK
2kxx7FOlXMlUw2WGioE84EhntsgRcxO6yqFJbVlNPs665cmrijvD7i2YxsVApqCw
vF1jjlrM0Z6DOY/71xzsWmPPC0Gxd/NZ8n7tF0L3ZGCAYjp+0yxeGF6DFTFG7jmL
T8N7cEAN05+EYxC9lgcMzTOn4Moeofpg6M6uetxXTmN9eyWH2PHDU5+htYbCdPcF
3iaIKyaGh9hLBRUFP7ja1rGsUkHjX45ZcOPA4MxFRYyybn2n2R9mfeZbf9V6eMFt
DiotT8i7GHW5PQDCost7f/4ztGv33pCOadyrXVQvZkyGg1NGACnDLb5PSsUo2iLe
O0wFJcT0HdLcomoybYU1RBaBWICOkDsG9ePqNtjy+sQvwjcX0efdU0aXRAr0P1nd
QvOX4MJT6qqZv7dk0Phk3zzbRX1YqAxUFbg51k2jfGVdX8CHXCKpicLrRQVml2Fc
UDll9fbspZHtceJo3toHTDITE892uznWSHXUfOFERv++pjwbt14V26Zk7XM6nwGH
ssHSFkAKUiiaQQS3JPzfBLznddhRHHkKclh3YgqbnWOgN2cUWb63ge2BeTPghCKz
ylMEYO96qBGjbucOmqwi48FX3Hy51gGipUToy+csJPs879Aw0zg=
=oiVF
-----END PGP SIGNATURE-----

--QujOxx9qOUhlsgJBKG2yXBfMiCpigu2y2--
