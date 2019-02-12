Return-Path: <SRS0=DlHj=QT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5002AC169C4
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 01:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EA25214DA
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 01:25:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="GmGCX6aK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbfBLBZK (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Feb 2019 20:25:10 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36872 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbfBLBZK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Feb 2019 20:25:10 -0500
Received: by mail-pf1-f193.google.com with SMTP id y126so443022pfb.4
        for <linux-ext4@vger.kernel.org>; Mon, 11 Feb 2019 17:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=/Pm3Bb+RHwTrdb0UaKe/H8RCoLVOnEb7jTG1+IbjhAI=;
        b=GmGCX6aKSfO9clA+CFX67HQBCB3hw6VVCAPglGeMfNPvfBJ85k+BIGgKYlG50KAATJ
         3l0cfb6QA+Hg8gqxq50pdbYiF4D8TbwxiCnNC8AIo09NgCMkV+SxsLMmCyVLU0cPcvI8
         +NmmHzU1Ra2D/gHJfv4OD17d8nAIokQu2v8v9lkxxNwilbCKZVpWRsm+N4oq0CMhXtNC
         RiM0VhqDQSZTMo6bKJfOo4OHBErYSKzE9cEaJzbZ5+DDpJnSB/z9DUcctWO8s94ETd2B
         qKZSRha7jlg2ZoGuNY2vUY+bopL1lb+3xk7JI9Pmt6yLRzcquQJkCLDsR/3Qx3isiMwL
         ADtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=/Pm3Bb+RHwTrdb0UaKe/H8RCoLVOnEb7jTG1+IbjhAI=;
        b=s7Tmezz543D8S1d3r0WXR6Fmwhf4peT4Aw+xXlJTLBU/fJuzFQxWn/1oM8HYqkgBXJ
         uHzn6v6iKXH01XOwmMfxGWiIS17vPKo8lESpEDh2w4cAtbVGAOH8ZVl1ua0bdd3NjbUq
         rjOpcncVQMbCLTcZlTwPfP8gtsL3qg35TlquIEWxk20grjOoy6BNBRfVlIoJWRbY2VYh
         motBpxM6Xy7zEzoyPMOmEaq42eaadNu0COC+QkYY1Qg91HlZvdGiBGGKqR+2WwZvIinq
         1dV2e1fJvv0613saot01xVwMTJcHxIIy62bKiQMt9sYUlLCGD/FtU8iLtQJcJf4c29hs
         6E2Q==
X-Gm-Message-State: AHQUAuZ73s71MN/UgnJfG17IQPecXToyMEfjKu1ADqNM3dNA+FaMuKP8
        HgtPMerEqXuSdvbg6yljBEvGiQ==
X-Google-Smtp-Source: AHgI3IYWYkze9lmrIJ5cbLM0pUpz4ictUsNPB6RU1G/K/SBaARbSPZseY6uOme8bNpabcTlAcC24EA==
X-Received: by 2002:a62:6204:: with SMTP id w4mr1300743pfb.5.1549934709231;
        Mon, 11 Feb 2019 17:25:09 -0800 (PST)
Received: from ?IPv6:2605:8d80:4a0:73cb:1cd:bb5e:89f6:a394? ([2605:8d80:4a0:73cb:1cd:bb5e:89f6:a394])
        by smtp.gmail.com with ESMTPSA id i12sm12141914pgs.28.2019.02.11.17.25.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Feb 2019 17:25:08 -0800 (PST)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <12FEF208-5FAE-4EE7-93D1-34359A0CBE4F@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_649C0EA8-2988-4C52-8CEE-4A4387E24F45";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: Selective Data Journaling in ext4
Date:   Mon, 11 Feb 2019 18:25:00 -0700
In-Reply-To: <CAHWVdUVW7VMefDQBpas4Trm2SrJupKqKSgAXN9ZiMWJFQCryKA@mail.gmail.com>
Cc:     linux-ext4@vger.kernel.org, jesus.palos@utexas.edu,
        Theodore Tso <tytso@mit.edu>
To:     Vijay Chidambaram <vijayc@utexas.edu>
References: <CAHWVdUVW7VMefDQBpas4Trm2SrJupKqKSgAXN9ZiMWJFQCryKA@mail.gmail.com>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_649C0EA8-2988-4C52-8CEE-4A4387E24F45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Feb 11, 2019, at 5:14 PM, Vijay Chidambaram <vijayc@utexas.edu> wrote:
> 
> Hi all,
> 
> We would like to present an idea to improve the performance of data
> journaling in ext4. Data journaling is expensive because data is
> written twice: once to the journal and once to the actual file system.
> Passing data through the journal provides consistency guarantees that
> ordered journaling mode cannot provide (for example, data journaling
> prevents a data block from being partially written).
> 
> The idea behind Selective Data Journaling is simple: create a new
> journaling mode by modifying ordered journaling mode to journal data
> blocks which are already part of a file. Data blocks which are newly
> allocated are not part of the journal, and are written out before the
> journal blocks in accordance with ordered mode's ordering guarantees.
> If there is a crash before transaction commit, the only side effect is
> un-allocated data blocks getting written with new data.
> 
> Selective Data Journaling provides a lot of the benefits of data
> journaling, at significantly lower cost. For workloads which mostly
> deal with new data blocks (any applications which update files via
> atomic rename), Selective Data Journaling can increase performance
> significantly.

One major caveat here is that files are *very rarely* overwritten in
place.  This is mostly useful for database-type workloads, and most
databases already have their own transaction journal independent of
the filesystem journal, so AFAIK this would not be a very widely-used
feature.

That said, a related, but IMHO much more useful form of selective data
journaling would be for "random IOPS" workloads, where there may be
many small writes either to a single file or to many small files, and
this IO could be aggregated and optimized with fast linear writes to
the journal, possibly on a separate flash device.  That avoids a lot
of seeks for the main filesystem device for small IO (which would
otherwise be IOPS limited and not bandwidth limited, so the double data
writes are not a limiting factor), while allowing large writes to go
directly to the filesystem device and avoid the double writes (which
would otherwise reduce IO bandwidth by half).

Since we already have delalloc to pre-stage the dirty pages before the
write, we can make a good decision about whether the file data should
be written to the journal or directly to the filesystem.

This could likely leverage the work that was already done for SMR journal
mode (Ted has patches, and I think they are available online as well),
and hopefully integrate both those patches and this new work into mainline
ext4.

I'm happy to discuss this further if you are interested.

> We came up with Selective Data Journaling during my PhD at the
> University of Wisconsin Madison [1]. I haven't inspected the ext4
> codebase deeply since then, so this optimization may already exist.
> There may also be problems with this approach that we have not
> considered -- we are open to discussion. It may also be the case that
> nobody uses data journaling so the extra complexity is not worth it.
> 
> If this is something you would like to see implemented, my student
> Jesus Palos (cced) is interested in doing so. We would like to discuss
> how best to implement this if you are interested.
> 
> [1] http://research.cs.wisc.edu/adsl/Publications/optfs-sosp13.pdf
> 
> Thanks,
> Vijay Chidambaram, UT Austin
> http://www.cs.utexas.edu/~vijay/


Cheers, Andreas






--Apple-Mail=_649C0EA8-2988-4C52-8CEE-4A4387E24F45
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlxiIGwACgkQcqXauRfM
H+BqUQ/8DggAleOfiK9nYE8Xnrcm7UcMo0aIIppt1E7L3X0bjOHGNQtK0OHRbhsw
3lKul2WBvatpUsDBzC+ob6Yd+xMRTp6MLxI37Lj36QUdN1YG/yUkeO1MrNYNGlwe
BsE5zayLVKk9KC6oCpgOiwE3BR321xA8W5DLjrG376Ka2n7nfatuUHzbtTFJy06F
Ym6XBm2sxq4097IHJQXo+dWCw1KeAE4whu5OTVeIWirWnP8fLRkV263g9eyw1es0
2iRpG7yJcQ8o3Y3Zu96O17bhwGcrxmMVqOICN+6clXhOmLiuuMTzq4+V87/ZtiSB
h8JbJODSWUrOLJ6VPtqDK3Yj0MFNicmAvnhFSiDgxtKSFTMN7NU/36963A7hYfnX
6wyO0xk1UWTH8e7uUS5h39TNATqpyTTr2297q1Rif8ufLjgrLPAdXxTYO1R/BflF
qVibuG4vOqkjArIYaJdD7e4baA7NW0l3bcwoJ/MISHQt4937LKYU1k2TzsfDIU32
6ljjQ6FoupcSvBLHTpVPcPxaNiMvBaKSuVzfd4sF2nlV3R1S2kZ01oiaqMZleLqh
+C4oCE5KI3/1Od7YE6b8K6jJ//CxtRb/HV4DDw0a61O/13Yu4iENyk5db5Bprwul
2uA19QM5xVnJs/se3a2YZQ2tqU/x/LksTR9YoKJ7geN5rLFxZT8=
=GWHP
-----END PGP SIGNATURE-----

--Apple-Mail=_649C0EA8-2988-4C52-8CEE-4A4387E24F45--
