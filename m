Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D715E3CD8A2
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 16:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775233073; cv=none; b=esc7hG3X+gjKhdQWaV7j7tsgo/zRIF4dpDbvGn9gDl2jG3O8aG/Jp8aTWOp2jts7FRUeAUPbpBM/cG27X901KtUYoPQDVIx2dHc6k2KEpAFFEoMAHQOzSNNxjGnHiW1jbRbOftXJKAgshh0C72LHyuKH3h42LSBcDt5QoKWMpyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775233073; c=relaxed/simple;
	bh=uM7SjGoPZZAGLvjzh+XtSqNrOS39f4TaP9nfYVRxuoo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=BqUwRZPFkDaWybG56NRNa0WwoDpka1FBpFUiiPC+ozVby6URvEC9E+tAeoAuBxLUX+rTti14NQTGbGJb9IQj7ke36df19Jyr9h5EGFEGk2gBsZXnokhhviiAoXkmJhpG07bcod6oUc/EpkfJyeX8cvI2GDPTqhI7kXMtY1gqBDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=yJ0aAXol; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="yJ0aAXol"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-82c70e4654eso954604b3a.2
        for <linux-ext4@vger.kernel.org>; Fri, 03 Apr 2026 09:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1775233071; x=1775837871; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uM7SjGoPZZAGLvjzh+XtSqNrOS39f4TaP9nfYVRxuoo=;
        b=yJ0aAXolu/fW6/xIBPBPuMxgfa5q9URYeV6EmdPIf5lox8bmqeP6nwgz3Nu+Y4MKPn
         Lj/GVjUJD3VdkgciZ7HMIwJ1YD6G+dKfiZwV7lfxJVIT8nEknBb3zCbE+yyXuZhayho8
         +ZOjmMrsGBwZT7IRKl4qyV1mC8jMmmnyjP9yeZs7ODsarG0n9Xk3aqPLxvOZuFj442oV
         b6YKWKowYbr6dL4nMjvxmhxLF0uSItCFiHpZU+DbGfe+jbqpmQo0HC9ihFqjdG2eujeT
         9UCqohC4hWFMcjDHP9YvolQaSpeXTjBZeyt+TNXEdSKt4rg8fweZcQd/Cy2QRh2Ibhv/
         3VoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775233071; x=1775837871;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uM7SjGoPZZAGLvjzh+XtSqNrOS39f4TaP9nfYVRxuoo=;
        b=F7iSSpEEbPWXys+p0RzMkFWFHDj+E49mPivT4XHyr+l11IOsWZEFP8GRkGw2/r/tYD
         VsNAyNovCOF3DkhOnjC3ZwkAWG0nGkoDFI+3DQs3/S2ZI6F8IG0F5vSo/j3Xe8S2rD8z
         6S0KyiL3/OH9vZtWw7BxVuGr+T2h2DYOOEuczuf5Ly35FUKyINm5sZkH1JW2Izbnyyxh
         bKN47Ik/6kvgi5tP/ogwV3H0HkRIFFDCRTumh3Uy2u7xXR0tfpd0hMovTwZky4aZ2F+v
         rTKPCgTkDFELejlRUBK248m2g+Vmi7ktriU8q3MMe/ti9GRd8tluRPvhKK+TPP8Sh7B6
         sNNQ==
X-Gm-Message-State: AOJu0YynGcHXhzuN7NLwgRmeChIzhPIqlfZaXnRqxdRwcTLWsxM03sCj
	hYH0hLfjLrUs5khkL7+ckXloxtZL2iD0PigKeWhAUWpVS+S1vsEqzyIW+zRvOWepnwZq0vR64bQ
	mRjGJ+o4=
X-Gm-Gg: AeBDieusbktdCewsLDCMZ54lVelp5TnJSc6sN4jjjmRirzKUXaoBg7P44zD9jC2fDCz
	LoDNuNbKqRcsGjz1rokjIG2vDkkRR2reAbWVePcpyNw/17xx65zPVk7waeVYf2hJMyx+wV/uloX
	t5h70ujExspTv2qa4rhk64Z8TOJ7pJWAfBhWUK+KaCiB93Sazan+HSga5avquVqSinRWQyPXcm6
	0vs8YNDef0m/Dap6FJ3iDXCEOjpxt1cGbnztr7+1ISwzTfFUOVyGBdeA8SwbJuzyghlIA7OCWN+
	Tc1aB1eUybLLNOEsqPlkXLwgZmntWmhqWujDrFzPs5PDWluJpxOiZtITQFcNAzPyCEcM+2yUkvD
	pVVKfTFJUWTb/+8C4JkaJNAnluCXvyWf/7Y+zzcGTxD4j2UNn1WP+Pe32MBOkZorBJOfHygSziy
	kzHVWOac0dTlTGbL1DyQ4oy6jqo652rVyZL+TIB/sX+I4dzWNVh63nMKo0RZ6fJHGKuS2UKkG/K
	LprNw==
X-Received: by 2002:a05:6a00:909a:b0:7f1:7b2a:ab5b with SMTP id d2e1a72fcca58-82d0db6c3femr3716741b3a.27.1775233071053;
        Fri, 03 Apr 2026 09:17:51 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c41bc6sm6365897b3a.29.2026.04.03.09.17.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Apr 2026 09:17:49 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: =?utf-8?Q?Re=3A_=5BSECURITY=5D_e2fsprogs_v1=2E47=2E4_Vulnerabilit?=
 =?utf-8?Q?ies_=E2=80=94_Orphan_File_=26_Extent_Handling?=
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <DJq7WqGAG9HBnpd-DVD5sVNGDUoSoP2sJ5RAXlucoYhtbqxJXFNUUfhFETwaDeDr6Q8a5xp0hVJb0yIt8EucI-F-PQ28zg8i0Y9HmF8qk5Q=@proton.me>
Date: Fri, 3 Apr 2026 10:17:38 -0600
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0778B5AC-16ED-4736-AE64-849541629466@dilger.ca>
References: <DJq7WqGAG9HBnpd-DVD5sVNGDUoSoP2sJ5RAXlucoYhtbqxJXFNUUfhFETwaDeDr6Q8a5xp0hVJb0yIt8EucI-F-PQ28zg8i0Y9HmF8qk5Q=@proton.me>
To: 4fqr <4fqr@proton.me>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Apr 3, 2026, at 05:29, 4fqr <4fqr@proton.me> wrote:
>=20
> linux-ext4@vger.kernel.org,
>=20
> I'm disclosing three security vulnerabilities in e2fsprogs v1.47.4 =
affecting orphan file inode processing and extent tree validation. This =
follows responsible disclosure notification to the maintainer (Theodore =
Ts'o).
>=20
> **Vulnerability Overview:**
>=20
> F1 (CRITICAL): process_orphan_block() lacks inode range validation =
before calling release_orphan_inode(), allowing arbitrary inode =
destruction via crafted orphan file blocks.
>=20
> F2 (HIGH): pass1 dispatch chain aliases s_orphan_file_inum with =
reserved inodes (5=E2=80=9310), bypassing reserved inode guards and =
enabling mode corruption on critical system inodes like the resize =
inode.
>=20
> F3 (MEDIUM): ext2fs_extent_fix_parents() contains an unsigned =
underflow where blk64_t subtraction truncates to __u32, corrupting =
parent extent length metadata.

I don't see how this exposes any kind of security vulnerability if it
requires that the image be specially modified in the first place?
At that point the "attacker" can directly modify the image in any way
they want, regardless of how e2fsprogs behaves.

It's like saying "the curatins on the inside of my windows do not
protect my privacy if I'm inside the house and I open them up...

Cheers, Andreas

>=20
> **Technical Details:**
>=20
> All three are exploitable via crafted .img files processed by e2fsck =
-y with no special privileges. Detailed technical report with code =
locations, attack scenarios, and exact fixes is attached.
>=20
> **Timeline:**
> - Primary maintainer contact: Theodore Ts'o (tytso@mit.edu)
> - 90-day embargo from maintainer acknowledgment
> - Kernel security team notified concurrently
>=20
> Patches and coordination discussion will follow once the maintainer =
has reviewed.
>=20
> Thanks,
> 4fqr
> 4fqr@proton.me
>=20
> Attachment: e2fsprogs_audit_4fqr.txt
> <e2fsprogs_audit_4fqr.txt>


Cheers, Andreas





