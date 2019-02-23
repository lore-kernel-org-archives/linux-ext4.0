Return-Path: <SRS0=oYny=Q6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 213B9C43381
	for <linux-ext4@archiver.kernel.org>; Sat, 23 Feb 2019 18:32:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8671206B6
	for <linux-ext4@archiver.kernel.org>; Sat, 23 Feb 2019 18:32:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="1UqbDm98"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbfBWScB (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 23 Feb 2019 13:32:01 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43129 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbfBWScB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Feb 2019 13:32:01 -0500
Received: by mail-pl1-f195.google.com with SMTP id m10so2561508plt.10
        for <linux-ext4@vger.kernel.org>; Sat, 23 Feb 2019 10:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=33kht1tEiIljCUmsfuWNLk5Ou5i5ioTDW+nyE0225Rk=;
        b=1UqbDm98olj35j5QUteKAm+t6P6o7jDMlyRGpYQmaWBq/gxM/taTASetTs33ULfRX8
         tLJG0nhJJEDAPjFisOsqSqfCZasn2+oodKc6PFLNoO1RWCRrMsBKG3fPC4faYmFGQ6vN
         r76acysjr6fifCbh5zDHxC0U9wPP8DO/l9+VI5kDw+L08+kZwef/6KdRjovUvdMcNOrq
         Q42tjfrCFR3YM+GdLtZEuRbjyNd5ODQBXmetgDrqGu+jclsQ5/sGfL53lxWz74B1w9h0
         ZY0EJBHkXnYO0/1fFJiEVJc8z6K3C8/v+jP4GCvrDHQp12murNa4vZFWwXaZdH/9Nm8W
         lv4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=33kht1tEiIljCUmsfuWNLk5Ou5i5ioTDW+nyE0225Rk=;
        b=lOLxiO5dG0XGTwGNG2CMOanneWa95xQb8H/6ZCKuuf5jrAUogPYh6hoWRznHLwQy5D
         XNw8NK4bW9lw6F38QZIuH5rOewov8B0OR4btcDgnaT26rRZW/PtjKyq7eqQ9DKVM/LP/
         QAWH9Yl1sYd5eJAPjpUmnkl9RupSwHqeJxsptGsTBpKlwhPb87wV57CZGtJsL0GN54SB
         Va8AiYyJ1weQ8GIVQ063zoLOy8UD0/Q9vnDj9RBFf1i/Fq8GQ4NCeTghjpOD/Ot1aRkw
         UDDTUpXRmGf6d80eZmnk28hwOVjE3J23y78oefHGIPNPaKVtU9TNUXHPqy7ss7vwU/Z/
         v57w==
X-Gm-Message-State: AHQUAubPgJ7OJBaBh7DKls8sARhTgEuYXZVKjnwvtT874z9P5992pojx
        QhPFCfZ7WtXHrE7Io99PvKNDGQ==
X-Google-Smtp-Source: AHgI3IbiDvhz3GHdfeaIPpY8z9whimj0XRN3YEkTF0J895nuhWgMtfPgTKyqvsTChF6f2nwGby0JiA==
X-Received: by 2002:a17:902:2a47:: with SMTP id i65mr10663623plb.237.1550946720693;
        Sat, 23 Feb 2019 10:32:00 -0800 (PST)
Received: from cabot.frontierlocal.net ([47.158.158.91])
        by smtp.gmail.com with ESMTPSA id e9sm9359151pfh.42.2019.02.23.10.31.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Feb 2019 10:31:59 -0800 (PST)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <80675DA8-062B-4A31-ACC9-449AC55D1847@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_87B4C2F2-8451-4D21-B0CF-FBF2A4C6CE5D";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Date:   Sat, 23 Feb 2019 10:32:37 -0800
In-Reply-To: <20190222190048.GA29624@vader>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, kernel-team@fb.com,
        Linux API <linux-api@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Steve French <sfrench@samba.org>
To:     Omar Sandoval <osandov@osandov.com>
References: <cover.1550136164.git.osandov@fb.com>
 <20190214220626.GV14116@dastard> <20190214231429.GE9819@vader>
 <20190215001657.GY14116@dastard> <20190215065947.GG9819@vader>
 <72A04438-5991-4A60-8AAB-021A41DE6711@dilger.ca>
 <20190218221820.GF14116@dastard> <20190222190048.GA29624@vader>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_87B4C2F2-8451-4D21-B0CF-FBF2A4C6CE5D
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii


> On Feb 22, 2019, at 11:00 AM, Omar Sandoval <osandov@osandov.com> wrote:
> 
> On Tue, Feb 19, 2019 at 09:18:20AM +1100, Dave Chinner wrote:
>> On Sat, Feb 16, 2019 at 06:57:45PM -0700, Andreas Dilger wrote:
>>> While it may be a bit of a stretch to call this "forensic evidence",
>> 
>> We do forensic analysis of corrupt filesystems looking for evidence
>> of what went wrong, not just looking for evidence of what happened
>> on systems that have been broken into.
>> 
>>> making it hard to change from except via total root compromise by a
>>> skilled hacker is very useful.
>> 
>> *nod*.
>> 
>>> If this were to go in (which I'm not in favour of), then there would
>>> need to be a CONFIG and/or runtime knob to turn it off (or better to
>>> only turn it on), similar to how FIPS and other security options can
>>> only go in one direction.
>> 
>> The problem here is that "inode birth time" is being conflated with
>> "user document creation time". These two things are very different.
>> 
>> i.e. One is filesystem internal information and is not related to
>> when the original copy of the data in the file was created, the
>> other is user specified metadata that is related to the file data
>> contents and needs to travel with the data, not the filesystem.
>> 
>> IMO, trying to make one on-disk field hold two different types of
>> information defeats one or the other purpose, and nobody knows which
>> one the field stores for any given file.
>> 
>> I'd suggest that "authored date" should be a generic system xattr so
>> most filesystems support it, not just those that have a birth time
>> field on disk. Sure, modify it through utimesat() and expose it
>> through statx() (as authored time, not birth time), but store it a
>> system xattr rather than an internal filesystem metadata field that
>> requires was never intended to be user modifiable.
> 
> It seems that this is the general consensus, so I'll look into
> implementing this functionality as an xattr.

I would recommend to look at how Samba is storing these attributes
today, and do the same thing, maybe add support into GNU coreutils
to handle this transparently.

Cheers, Andreas






--Apple-Mail=_87B4C2F2-8451-4D21-B0CF-FBF2A4C6CE5D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlxxkcUACgkQcqXauRfM
H+C9Xw//X1n0jOmRTE6hBjU23kQZyxxsgJVPhG+wekrSO2IixYt9aKoeRWnL/Umq
4o9LvCkUB0bs40X6kr+r8K/QfjJt9tKlUSxZ80F159ecEPfJAUO9ZOvjPOt1jeA3
hlPoOwPziYNht90m8Sc9WpYN0qmtN1021rcU8hwBbaX31DBs6JEUj4MxO2Oo8XA/
C+eiORtc6EBqsVUF38V8ln3b384C51//1WqG2/HMlWxbzNILK8jkV71slD7xb7Vj
lkgHXcJKK8uDs+908XqNnjtn+qs2HpyJxQ4N46EIEE5PNStbDfSluBHTG7ME4TqH
GB9ezg2wEh1cSjGsg3Vx4jFsKow+esxWAruZYlW36k1MmBucd1ALSSuJ6IfC2WrZ
8iGnpUaLmLvlnlSKeIgv6nkZppYCbY9DHfZFmn5GoOtCDCZvi0QgFo17Nf/SifeD
nP6lp8Mt9Jlymrpc8qTbxfM0e4cO2Zp9gPkzFKIwXrp4sMBBGcnC8+cHRKgIX56h
M/cM49ApzP08XRSf9kClLnkEMOnMxEvf3kXySqd3yyqJnG5X9xotdiGNldQMTcnc
Rq83fqRrMJShOIHwvqFnDmsqGOvPdWN56mBMEjKNbQ2Yj2OPybJMVaRcIURs0iLs
A64oEE8lLjK+PdMkugInBhfu0gSxYVScA1r/CSBIgTKmp21LfTo=
=UOd0
-----END PGP SIGNATURE-----

--Apple-Mail=_87B4C2F2-8451-4D21-B0CF-FBF2A4C6CE5D--
