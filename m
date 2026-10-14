Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56F6344D8C
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2026 10:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791975100; cv=none; b=bxXIKMJXYteFm5PHnxRsDP3ZHcDmttdaLngImmkFX0nt1V819BH6s8pMuGaoTUcZg4K7mfDRQAgQddnONgInduVdJe/XuQffjss15enF5NdX+aqS2ZZktwwzLCYSk3nvJ+oA96Mo+Qn8szAC3+N1KMkdThy6iZxz0Jfg5NBBC4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791975100; c=relaxed/simple;
	bh=E9Kq7zpdPnHWmFVX/x9FhO2NwA/jw8Sx7RNZfL2Zyis=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=nYA3xsyAPvfsnfVCWp1uiG8aPzoJVlnE8RpjJZrJlCx5Uaqdo28sscTWj3H5zSHFVD/VOVKeVHx41F/GZhbItI7KcMQzFoca1oUmPyF+WZsNRstzfMxIXsVO6h8DhZAhYa/9RbM5beO/Zt8VRhXi/DbvsM25rrilofXr6b0upTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=Z/lMQEl7; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="Z/lMQEl7"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e8fe8e343fso13711345ad.2
        for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2026 03:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1791975097; x=1792579897; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cOGJYqRb00q3kYr5FR79P9Y+XQTbq+vJqBx4LX3QFi0=;
        b=Z/lMQEl7gc5AgG9yOSaLC2XM/Mwez6Yy9JEVPWcBPNWFfSkvx1ofrbc43lHcgk4zVY
         HfRDD8kd9MwRoSMvddsKVNeIDSZoE7EpDpwI+mWqPGI0X5HJgKPDOqkkfjkRTVkpSZ5K
         Qb0wVw7blx8b5SfreNfTCG2iT7P0ruvuh/xvOygdXTM9W4kV7QvdW7ySBzl+yanmJBXh
         jz36SV2t0yGQ4bAi8GeUvecp+CHev5oH+N3sCR2Pvd9KUZxx5bcctjT08DsNT79PeAfN
         C64smbBV2q+78QahZH8yxfVSjBuOb8L8g3YH3VekwsW0rLh79nNM+AlkB7Mzs4Ty72jq
         pYfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791975097; x=1792579897;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cOGJYqRb00q3kYr5FR79P9Y+XQTbq+vJqBx4LX3QFi0=;
        b=lOUP6/XX1Av2y4QlkIHMESw+SSTGy/kWwaAHuaN71BbKP8j4ZjxgY8jBPsjOtWIzl7
         UsFT+1AK0Nyi2k4PFtHXCLG2e/nWMuc1IUCg+lJN/omNkSDzI/mh2iaKNnwdLZ2UfMBs
         c4PQyWFQUAer5XBtLoRO1sB0xvw2RWg+Xybguerc6Fc+6BGTyd1xuwCJWc51X3Cz/l7X
         gXRwHbmqNG8DLBWE6WIC68q3wiHkeyEkBpAEPg6RfyNue3VorzY16ZB8RuyI4N3YsplO
         GS2EQHqnNbmPScrgyoAd4y6MwfTwj2Eu+wydlAPHkS93yfdv2t42LDe7uteD759EFj0R
         aQtA==
X-Forwarded-Encrypted: i=1; AKwUvBwXjTllDr80RfLcro2QTAtjB0Ciw9TR15eeyVlCvFspHe3BztFNbmVw7L69DPjPOLlW+GJkHynJYjg6@vger.kernel.org
X-Gm-Message-State: AFq9FYI4gRhAaH+w68eY+OlbS+eJ08TjxVnn3gJnn9mnoIjy2n5wLCzU
	bmd7J/DwJP6+k5PbM3aTMj8bUZYQe3ECKdkGZw+1s8mhDtIFfdb4K+sbdFuY0XfXymY=
X-Gm-Gg: AYBFou3soLerFMwYDUeG6ZeFCBcxFM5TFoUZI1L6KBTEhvh99rM5opi3JhvEZXyDke1
	wfHmQvyori4BojK1J9PXvqKlOzd7qGtSyyDVVI8k6Q3eVgxsT8LmmtMi6XVVI0ZWpKZVgHXDnWR
	3RaN2nlhtT5srjbQg+qiZyZ3tSfxNTFK5MiPTt9f5qhySNC3zuypIeVXAozQ7swdzUS9aFF0lAU
	50WkrZjk+XkX900Lgx2Nhon1PTu+9Hu+/P7YL6JvGMeuZZy0C8xVyezYxmGnpkj2ajVbtL92mIi
	FLpNPtPdc06IM6Q1XYFsqG8+CRX8Y3WTgbzZ7WNIEcc/8rr1TedXO2+JJeIMelFO8lgZJDe5ZWq
	V/nk/h7oI1pZA4gItIgT4H9FN0lUzySPZwpbN7vv2uUt49orAREr1eeFuHBREGma/7n0yb4/Wl+
	VbX7UGvV8V6vZ+AWHzv3TZzsk0rztD+YmDhjxKJpt0SFgbjLmJzm1JatxWbLq5TlpibLnISwfAD
	n1yrWOQKjfIF21QiutC9NC2mjcqjujCdA9shO57uSi0kpAVY/QCPQ==
X-Received: by 2002:a17:903:2f91:b0:2e8:b20a:88cf with SMTP id d9443c01a7336-2e8b20a8a88mr76668635ad.11.1791975096754;
        Wed, 14 Oct 2026 03:51:36 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [24.64.171.237])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421b15ffsm67040755ad.36.2026.10.14.03.51.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Oct 2026 03:51:36 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.3\))
Subject: Re: ext4 data=journal deprecation: long-standing industrial use case
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <as0U-lfet5slrD8o@mit.edu>
Date: Wed, 14 Oct 2026 04:51:24 -0600
Cc: Gabriele Moabiti <gabmoa@gmail.com>,
 linux-ext4@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <22E03C78-7327-4D78-B851-531CD9C90B8E@dilger.ca>
References: <CAAbJaeALOrZwWs++mz9Wv0pfvyDoHmfzPKyVHR0v6TwnzLkYGw@mail.gmail.com>
 <as0U-lfet5slrD8o@mit.edu>
To: Theodore Tso <tytso@mit.edu>
X-Mailer: Apple Mail (2.3864.700.51.1.3)

On Oct 12, 2026, at 12:53, Theodore Tso <tytso@mit.edu> wrote:
>=20
> On Mon, Oct 12, 2026 at 03:41:29PM -0500, Gabriele Moabiti wrote:
>>=20
>> In these deployments, we have not experienced problems with this
>> configuration over those 15 years. It has been a reliable solution =
for our
>> operating conditions.
>> I understand that data=3Djournal is deprecated and scheduled for =
removal in
>> January 2028. Given this established industrial use case, could the
>> decision be reconsidered, perhaps retaining full data journaling as =
an
>> optional feature?
>=20
> The challenge with data=3Djournal is that it adds a lot of complexity,
> and more and more of the advanced featuers are simply "turned off" and
> the original code path is used for data=3Djournal --- and the =
"original
> code path" is only used by the data=3Djournal case.  This has the
> following of undesireable outcomes:
>=20
>   * Extra code paths =3D=3D extra maintenance overhead
>   * The data=3Djournal specific codepaths are getting much less =
testing
>   * There are known test failures with data=3Djournal which are not
>     getting addressed.  (n.b.  If paying customers were supporting =
with $$$
>     the SWE investment of data=3Djournal this could be better =
addressed, but
>     at the moment data=3Djournal is essentially best efforts by =
volunteers.)

Ted, do you recall if data=3Djournal is used for the SMR patches that =
were
presented at FAST several years ago?  I've been thinking about reviving
them to help address the looming SMR drive armageddon that is coming.  =
My
recollection is that this patch used a large (data=3D?)journal to hold =
small
and unaligned writes until they could be aggregated, while =
large/aggregated
data writes go directly to a zone.

Metadata would basically live in the journal until checkpointed, and the
buffers for the metadata blocks could be dropped from RAM to allow huge
journals (either on a CMR HDD or NVMe today).  Checkpointing the journal
would either flush the blocks to an HDD linearly (with updates for the
block allocation in the inode/bitmap being journaled), and metadata =
being
"cleaned up" could just be re-journaled to the head of the journal =
(maybe
never actually being written into the filesystem).

The main other thing that would be needed is for mballoc to add a mode =
to
allocate blocks contiguously inside each zone.

Cheers, Andreas

>> If removal goes ahead, will ext4 provide an alternative with =
equivalent
>> protection against interrupted data writes and abrupt power loss? In
>> particular, I would appreciate clarification on how users relying on =
full
>> data journaling are expected to preserve comparable guarantees within =
ext4.
>=20
> The phrase "comparable guarantees" is not particularly well defined, =
because...
>=20
>> I understand that data=3Djournal does not make application-level =
updates
>> atomic or preserve data still buffered in userspace. Nevertheless, =
its
>> protection beyond metadata-only journaling is valuable for our =
deployments.
>=20
> Given that there is no guarantees of what writes will be persisted
> with respect to program execution, it's unclear exactly what your
> deployments are requiring or assuming.
>=20
> That being said, I *suspect* that this should cover most, if not all
> of your deployments' requirements.
>=20
> echo 500 > /proc/sys/vm/dirty_expire_centisecs
> echo 100 > /proc/sys/vm/dirty_writeback_centisecs
>=20
> To make these changes persistent after a reboot, put the following in
> /etc/sysctl.conf, or in a file in /etc/sysctl.d/
>=20
> vm.dirty_expire_centisecs =3D 500
> vm.dirty_writeback_centisecs =3D 100
>=20
> What these changes will do is if there are any dirty pages, writeback
> will be initiated after 5 seconds (vm.dirty_expire_centisecs) and the
> writeback flusher kernel threads will wake up once a second
> (vm.dirty_writeback_centisecs).
>=20
> The default values of these two settings are 30 seconds (3000) and 5
> seconds (500), respectively.  By default, ext4 uses a commit time of 5
> seconds (mount option commit=3D300).  In data=3Djournal mode, when we
> close an jbd2 journal commit, we effectively force data to be
> persisted after a crash.  So by setting vm.dirty_expire_centisecs to
> 500, this will have roughly the same effect --- which is to say, after
> a write first dirties a page, that page will be persisted after 5
> seconds.
>=20
> If the application wants a guarantee that a write is persisted, it
> should use fsync(2).  But if you don't want to modify the application,
> the window between when the application writes a file to when the data
> is persisted can be reduced from 30 seconds to 5 seconds either by
> using data=3Djournal *or* setting dirty_expire_centisecs.
>=20
> There will be some slight differences in behavior, but given that
> data=3Djournal doesn't have any real guarantees ---- if you want those
> guarantees, using fsync(2) or fdatasync(2), hopefully it should be
> good enough.  You may also find that performance may be improved by
> using dirty_expire_centisecs if you are bottlenecked by the storage
> device's I/O throughput limits, and it will also reduce flash write
> endurance impacts (and hence improve SSD lifetime) if you are using
> flash storage.
>=20
> Can you give it a try and see if it works for you?
>=20
>> We would prefer to continue using a normally writable ext4 =
filesystem,
>> without introducing an overlay or migrating to another filesystem.
>=20
> Note that no other file system has anything like data=3Djournal, so
> introducing an overlay (not sure what you mean by that) or migrating
> to another file system is not likely to help you.
>=20
> Cheers,
>=20
>                             - Ted
>=20


Cheers, Andreas





