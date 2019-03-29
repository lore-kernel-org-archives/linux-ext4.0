Return-Path: <SRS0=q+9q=SA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC91C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 21:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAEAB21773
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 21:52:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="nBb8uQvX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730233AbfC2Vwh (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 29 Mar 2019 17:52:37 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37992 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730062AbfC2Vwh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Mar 2019 17:52:37 -0400
Received: by mail-pg1-f193.google.com with SMTP id j26so1820848pgl.5
        for <linux-ext4@vger.kernel.org>; Fri, 29 Mar 2019 14:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=nbziDRi1cx2zkCr/A1GCMCqcbT7DwFfCZS0HDNFf6/M=;
        b=nBb8uQvXmL1uzW9u1VDkcyuYfyirqwyxBQT31viXFeDEuu2BBqJXPAllmF9d4HBxNq
         9NktfW3TVCsA7FzAty3Fes8prL3Q99S7DMYZdiTATqVlbNBD1wnTzqhMhi4HPrtIgkPq
         AGWbk2FXnNCSXax9VHJF9aRnN8o8ft8HUPa9GiFgb+AQFB20dqG0moXVT0HqqNXb15+f
         7FK5CjRhLL9aK00wAE4saQN5bBggYoM/9n2TdUnQxGr1XIQuk1U0JDLWvt4SfiFFWU9O
         kCONfVg90PsHVAZeV4S1LPO0LWhLvNX0P+V5wnV2L7Ro/wGU2bOJOeytBP2Z6jKAmpQ8
         mLng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=nbziDRi1cx2zkCr/A1GCMCqcbT7DwFfCZS0HDNFf6/M=;
        b=GdUdvvDOJiaFP7iYEtOqA80aRqotni21qd6svOsYgvLql+6+mJq/xstLP2IQmshI/M
         1fU1W0jtZXAyrPRQS4znXEYn1824eevyUMxwO0upurrH6JlBPHMzrMAm83PRUcRQfYxe
         St+2d5p2eWo8ygZ2yTJsIBQQ/HW8bXcJgUcqjtnvghD1gJM5SHljOBoOUo+91bHwX2nC
         puoHJ/hqj/qmAw4SNST8mRHsNJtFqHpdG6AXTV9sNtv6B8+lyXn5SaUYEUCmYCNLCHkz
         LpyawukVgGf+1FcYY2WE41bm0BpOXyFYwtmXHJ0dXmqLueepDlCWoeFChq/AT9lU7BBT
         TbqA==
X-Gm-Message-State: APjAAAXpzjFbXkj8yxhEPUhiGQ2sjZ0Y3NXn/ZbYgzZ1MTr7H8ys1fX6
        XIyVBbhva90dFGf3v9zNBKoQGw==
X-Google-Smtp-Source: APXvYqy89IyE/GpcSX30yfFEGvv7Q1LpDYsaXnmO2MS76bFEd5YRA04C30G0gSGmqUZ4dlEVMky9sQ==
X-Received: by 2002:a63:f24f:: with SMTP id d15mr14702380pgk.410.1553896356394;
        Fri, 29 Mar 2019 14:52:36 -0700 (PDT)
Received: from cabot.adilger.ext (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id k4sm4101238pgk.1.2019.03.29.14.52.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Mar 2019 14:52:35 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <AE779190-182F-472B-8E91-678ABEFF8506@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_BC80F2B2-9665-432E-B261-89B3C9ECD293";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] jbd2: do not start commit when t_updates does not back to
 zero
Date:   Fri, 29 Mar 2019 15:52:27 -0600
In-Reply-To: <20190329212523.GC8757@quack2.suse.cz>
Cc:     Liu Song <fishland@aliyun.com>, tytso@mit.edu, jack@suse.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        liu.song11@zte.com.cn
To:     Jan Kara <jack@suse.cz>
References: <20190324033835.55858-1-fishland@aliyun.com>
 <20190329212523.GC8757@quack2.suse.cz>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_BC80F2B2-9665-432E-B261-89B3C9ECD293
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 29, 2019, at 3:25 PM, Jan Kara <jack@suse.cz> wrote:
>=20
> On Sun 24-03-19 11:38:35, Liu Song wrote:
>> When t_updates back to zero, it guaranteed wake up process which
>> waiting on j_wait_updates. If we triggered a commit start without
>> considered t_updates, the commit thread wakes up and find t_updates
>> is not zero, it have to wait on it once again. So, add checking code
>> to avoid this happen.
>>=20
>> Signed-off-by: Liu Song <liu.song11@zte.com.cn>
>=20
> Do I understand correctly that this is a performance improvement? If =
yes,
> did you measure any benefit of the patch? Because I have some doubts =
that
> t_updates =3D=3D 0 case is very common.

In the past there have been times when periodic journal commits keep a =
disk
from spinning down, but I don't know if that is the case here...

Cheers, Andreas

>> ---
>> fs/jbd2/transaction.c | 5 +++--
>> 1 file changed, 3 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
>> index 79a028a7a579..e0499fd73b1e 100644
>> --- a/fs/jbd2/transaction.c
>> +++ b/fs/jbd2/transaction.c
>> @@ -144,12 +144,13 @@ static void wait_transaction_locked(journal_t =
*journal)
>> 	__releases(journal->j_state_lock)
>> {
>> 	DEFINE_WAIT(wait);
>> -	int need_to_start;
>> +	int need_to_start =3D 0;
>> 	tid_t tid =3D journal->j_running_transaction->t_tid;
>>=20
>> 	prepare_to_wait(&journal->j_wait_transaction_locked, &wait,
>> 			TASK_UNINTERRUPTIBLE);
>> -	need_to_start =3D !tid_geq(journal->j_commit_request, tid);
>> +	if (!atomic_read(&journal->j_running_transaction->t_updates))
>> +		need_to_start =3D !tid_geq(journal->j_commit_request, =
tid);
>> 	read_unlock(&journal->j_state_lock);
>> 	if (need_to_start)
>> 		jbd2_log_start_commit(journal, tid);
>> --
>> 2.19.1
>>=20
>>=20
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR


Cheers, Andreas






--Apple-Mail=_BC80F2B2-9665-432E-B261-89B3C9ECD293
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlyek54ACgkQcqXauRfM
H+CPkQ//fnziWA69QSL0P2ssmjqFD356Va9kU+SzNPmMLRts92WFN/P6gGpQZ2VI
hC2At76cdOeEWkLCFr6RaUIHCl8BHOJwmP+5BAtkcXwpkk/P1NgJ3Xjiv0KGMFMb
qc9VYLv0zJ3O7IMl/abgEOj7h1/FBCZBxOXgP4SmKWpJOuulUcKtxckqsjizeSBK
yCsV6NmTPSXWS63FMDF0lJWDvyXXMQzTVQiuJUHMODR9Jcj6KTiD6EYHHHhffjLA
mjVcNc/YXK/rVzkEuNQPpqM9PtPGa95fyKDptt1QdiVHL9RJbGGqikIRJmFEAjxm
BjQ3p42uRJ+ZW7yfPtRDlVRFojfXnFr8Hff5Tppsr84J5tRwJu3VDGGbdm2cwpOF
d0XiR2J85PUNglVHYVtd9ELRLGUkue/S7vuofcbKvfXQCMhPTlDQlftpkagpdaSW
NGfbwJNIKJH23y+rzWgWP7DmijhkhObGO4dpqnwrEWr+3tMuepqlNJQWvR6Gi6GI
nULcTXwGg9NcsNebHpiD4v1V6JX704nwODwgdMOZ2ENgkavOtGFPgX+2NTmtLMnc
9JAfWfrcl/NmeD4Ql46tqouxcH6Pl0HocSVGLPLLjMJ5zZ0pLVXAEL0rxROwbxra
LRa1aa7P9RVD4fwVvltivJ5q7L9I3KLnfblJI8I5a7IvjmBgnBA=
=qK2c
-----END PGP SIGNATURE-----

--Apple-Mail=_BC80F2B2-9665-432E-B261-89B3C9ECD293--
