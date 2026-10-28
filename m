Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.129.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793225386;
	b=CarXdf1pFW9zGp5uIE7QGADfVGqw2w+Ga6HC6bIqPBgP4nYwdDDFEE+yi7Nf0yqz2cCJ
	 Q2OUcWFAEfl+dqQskBQpsjNtEbySPQIgaof0eMCL0N+vBhI1+P/2cmQFHiAescx6TXmuu
	 FlrItbeiKiQl7uQoBx/hwIgEf29j9hGXo4NGQAxsqTjp/rDAjRqs8EAFLJcmg1RT7UKra
	 hez1ntlB+6CnxHBitYrmADWnnI7NGlQUU4CRRSbC2rbuVxSjtXriW0qB4r86/Dyu57tol
	 CgjZnFMTDnElDKTBTqZq0mLBuvLjsz3ASGaFsMcTRcepURyeOZiOv0Smjqea/sF6xEQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793225386;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
	b=sc56qCyeJjnfuNxQLGD2jjtUi7UBv7mZagl7r2dHUYHw3cmKqaCHbwVoYx4HVDsBQ782
	 8Oc2kFqnfx4uHkgpkimI4IBNCpu4pInwBoKsNajKBW5TQKhTkiTzek0WvdfXiFytzsqqa
	 1pRSuhZbIJBXkItyNEmKQt4eA1iEvEom0RtbhCG97xL42AbQh59030Xsd1CiIoYErncgW
	 ppi0jwqaANUY+8UcRm8Mv5+n+7G9Owqnay40uHkinWdORf/Ns4JKspLu2yBQF/EWARQ1e
	 pqmOWY7IsKVJXI7OZ/oQWVC2ZYgJFRi/5UOgaciIqxbOPQM1GuzykqM2upFHMQDOdZw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=PNja0RrK;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=dMvVeWef;
	arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CA6606A320
	for <linux-ext4@vger.kernel.org>; Wed, 28 Oct 2026 22:09:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6CA6606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=PNja0RrK;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=dMvVeWef
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793225384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
	b=PNja0RrK+GAXFseGHRAPgDcQljq0pWRU5IrNz2yhBUldeqB5xObADIbjyjHyNHrutF7Pt+
	rJoNk3kv9NPLEvl8XKZoimFvycT999RKjoXG01AAR++Ak8kkM30MDhOQrx+KtOHBWo5kfK
	yRocWGrPgLWx6N9WURbn5mAhp5Y0UlA=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-kG2HFemiNdyH47E9u-DDdg-1; Wed, 28 Oct 2026 18:09:43 -0400
X-MC-Unique: kG2HFemiNdyH47E9u-DDdg-1
X-Mimecast-MFC-AGG-ID: kG2HFemiNdyH47E9u-DDdg_1793225383
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-67906c453b8so313566d50.1
        for <linux-ext4@vger.kernel.org>; Wed, 28 Oct 2026 15:09:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793225383; cv=none;
        d=google.com; s=arc-20260327;
        b=aK56oVMFa1oBH+kbtSsug17pMNGddADqAnyREFdzrJgQNlG9BwTLiv8basaL3OF1Jg
         v0lSr31hy/dCKtZ3fGr04XRIEr/R05OXpNdKXkRZaIhnCyHU3VQAhfaHPBabmJOGUANZ
         A6eCLiRVU+GlcaKCpx1b6BB0AHedwnhUXrq4PNmfk3VQ9espZsilnjVG2n4pz0+XD5mj
         MDTRYcueYjTl17sNk398GK4S7YhIT50SwkNgOJew5H1ZCEXy2h8t1kmmrYC0cy1BuMsA
         h0zdcbBG22fC7Kg6uq9YKflgvfcratrm7ZkE5elvUVt7P+XiUU4H5FmWQPCxyaJrq7Fc
         EB1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
        fh=qIp4kDitA0ydVa3l4W3QsaY+bFbgyGKmSoGlSctiuxE=;
        b=lTIIwffAea8ctv2Yd3jcWyg7eP1ks8Q1b2RZvJpWnFzu5BdMp1+2cMc4msw+Zlmez7
         LVmI86JAtjsYwt+MQPLiW9ErJRWdt5n5tXkU25MDZ2iS8faTSDeGQN3UhBvQEg1XtOGh
         ctsLqrPzi6fiPwzEkkqmjR3vqtb7zMlVdMdWa86u1yUOID/y05/sxIDCLC/3UBngUUMF
         Bmocowdaxev7452zvC2k2iwnulgb4/ymKIjR0sBtV+CHcu7Qho3a3P8FSXG4JRYOFFse
         T2mqxkdW04p9lOsRIOzts9Y6rf1MPbPNF5SZXbHcf7x0DLqU7/Xm1kO7FkeG5/9YfX2t
         97mQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793225383; x=1793830183; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
        b=dMvVeWefC8P+UdQKNVCTRzDnhWHngZQGob2rSgzwsZSnRN8SAHr7CL96OPYJXufFq7
         zSTFFPllhPr/w76wrseeWsykFIT3XNeylizZvRvScikFw2Vx8ZBVf5aKYuJSSTUPuuch
         XBaTxNgE5Gyy25Odb94BXqgaNMMlvyhAsHvl+cohQ1ckCaDBDm4+NkPEdFeD/j45D4SX
         9JdubWa1Rkola0sqbNiDrUuR0ynjj8Js5euvpFf83x/dOZOzpzImQtYe9Q9exxMiq/qr
         mXS/pEC6VjG6Gc4ktJQ1wDheP9WEZsIfL+MfkoZBHHuqMX4NfKOOS6gRPfYVsrX4HqWa
         L7zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793225383; x=1793830183;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j5xHrk121VJ6jsiOiBImMpaem11Ex15L22vqkzMRx+Y=;
        b=SrKXzIor1Ktprw8bYl7DW1x8mBRXnBzww3Lfl4mTv+jnGaiZP77lI1SNmDktMDvglx
         eFO2Ovv/GcxTBK5b60vjnhRQmjdpqa6RTvSVRxqExN1d6DCTXLvqTsyiDG4py81NLfiG
         pcvxc1WbAtUJxBL9VbYScc+uCJ2lPSaDtpnVk4AD7aRuVCpoZXSDWYtbPL6aHCIppDWu
         gbBYUlBQee7FRjFRFT51f72298C16RfLAPtqyVgahSci5ol/Aw6mmgVd9Pmse+F87RSE
         zD9TUa6poT8efFzyz0vxe+Rk55EGjE3RFGuOEHXCZZ5Hz6jC2YwU8iS7yYtzHqDXAVLt
         3NzQ==
X-Forwarded-Encrypted: i=1; AKwUvBwDTOBohfTGo0e339PMVxks+dNjCU+ZbW9dlQ20dbmkqsEeg9isgty0U2u7PYyroKzIFyNOhYVbUyCC@vger.kernel.org
X-Gm-Message-State: AFq9FYKby9UDr1CMRvf5zr/jMzgLjkiEdd5bOLx9aoYK+nF3rkgovrtU
	vISTMnPv473QbdqKedts8OxCWSuaMRROox4B1ArTlYGw0cbETQvwV4jrHKqxJyu1batJVZnfsSy
	LNlbhtaThK8VB+R3brNPuEUDKXyfw3YJlkM8l2tM0ItZIj0ULs4I6mTXM1KVWBaUrwQwPUF9Ggg
	ej6JENqJoxlXo626dsGCT2oeGScksyG0uoWEm50A==
X-Gm-Gg: AYBFou2tDK41jp9GmWWa868lvWcyDgNwzeJSbIjpqMp5v9x0ZcTmjGk19dgTgJHWJuy
	XEq+KSh0Jw0r3+Os42QHsiuwPNt4KLxa9vG8oNtaoTTHusfQKK0SNF4rEBtA59/MNG+TbGVB13X
	dtC288qSrTXXxc6eIdn8htYDhrWn6/n7sCAEteFS/t0EEo+HxpB8WwsVPkFbU0I+E7GLeQAp39w
	uS4YYZDlngvzMA/dPHF+19uibQbX+APo6F4uXvV7BVAzA==
X-Received: by 2002:a05:690e:1918:b0:679:ad2f:3fbf with SMTP id 956f58d0204a3-67a8d0047a5mr704875d50.8.1793225382865;
        Wed, 28 Oct 2026 15:09:42 -0700 (PDT)
X-Received: by 2002:a05:690e:1918:b0:679:ad2f:3fbf with SMTP id
 956f58d0204a3-67a8d0047a5mr704846d50.8.1793225382297; Wed, 28 Oct 2026
 15:09:42 -0700 (PDT)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-21-60743a3dc326@kernel.org>
 <CAHc6FU6z4kX5R3Og8m0dYOHsjFcw+4Btvfe87AGPxy_EWs0E7A@mail.gmail.com> <20261028-zurschaustellen-okkupieren-inkompatibel-d11525ce88b8@brauner>
In-Reply-To: <20261028-zurschaustellen-okkupieren-inkompatibel-d11525ce88b8@brauner>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 28 Oct 2026 23:09:31 +0100
X-Gm-Features: AclHuK9MzobLdiG2EG9M5KT_ibZzYxdrTghiXff6ZlesOE7YSK8Ag_RtXekxyZI
Message-ID: <CAHc6FU6VSAWQ4RJTO_eLnpqN5qvrShbJeT+ADwiA6ohpq8dO4Q@mail.gmail.com>
Subject: Re: [PATCH RFC 21/28] gfs2: don't set SB_RDONLY on withdraw
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ntfs@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 5:02=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> On Fri, Oct 16, 2026 at 02:01:00AM +0200, Andreas Gruenbacher wrote:
> > According to commit d564053f0746 ("GFS2: Clean up freeze code"), the
> > idea of the freeze sysfs file was to make it behave like the FIFREEZE
> > / FITHAW ioctls. This isn't what the code is doing at all.
>
> That's a pre-existing and separate from this series. freeze_store() calls
> freeze_super() and thaw_super() directly with FREEZE_HOLDER_USERSPACE and=
 never
> goes through gfs2_freeze_super() and gfs2_thaw_super(). So it never takes=
 the
> freeze glock. I don't think that's for this series to fix.

I mainly wanted to point out that this behavior isn't intentional.

Thanks,
Andreas

