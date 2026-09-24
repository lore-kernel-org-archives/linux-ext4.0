Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F513BFE3B
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 22:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790288992; cv=none; b=s6b6KJuA+wlo+WcXboBMnUJtk7q/NcGRXW2NOu2z+kOjyGohFyg46le/SfbXiiii/MRE4On2xqegAkLjGlPwUVn5F3lCwP4US8reXpBAJr3vgG5bfHZySFjgK1Ptx8QiG9mq4Z+wq8Xp5MTRmRf7KACC2lIU11S6rzjdbIYRqj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790288992; c=relaxed/simple;
	bh=xLvrAGkx9vrXnR1Z5blp755tsRAPCGxhcOW1872e/5o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bLhIwshh0T6JrxIAxZsSkKPlVhvAbp1CofyL+JjNWNgTMNM9Fv1PiT+PKhl0rRYfvLZdNHDMoG1I15JtiJfvWTlp/aguqAVokYj+kfJ2ipsthZ9T6AjHSufOqwzl8MgzbpbDPtDvof3M3VQgZFEVX0dNulvd8/hP65xH52G13Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZxiyMXx3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=RmGXlqe/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZxiyMXx3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="RmGXlqe/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790288989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xLvrAGkx9vrXnR1Z5blp755tsRAPCGxhcOW1872e/5o=;
	b=ZxiyMXx3j/wzWtMko7MuakiQPlRH8PNzlI4BDi40ruMI2pSdx/Ar3e3rRyHLVITT+B9S12
	XBequG0OJkdDteB9sYpZTX3vtVugISi9jAgDcEsJj6G/2n86+GE22ijkbWuoxSZ1GvDpBP
	2CBX/oFl2WppGMyOUFRKpowJbBiEh3c=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-mehN7WwYPgadyjfZNwNv1A-1; Thu, 24 Sep 2026 18:29:48 -0400
X-MC-Unique: mehN7WwYPgadyjfZNwNv1A-1
X-Mimecast-MFC-AGG-ID: mehN7WwYPgadyjfZNwNv1A_1790288988
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-934963b2bc0so66881285a.3
        for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 15:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790288988; x=1790893788; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xLvrAGkx9vrXnR1Z5blp755tsRAPCGxhcOW1872e/5o=;
        b=RmGXlqe/iRni9U/Wk62iug/13oYfV1A2nQQ0EGobSF1x9mbYoW7kzY5w18JjTDn+sS
         4LoGoL4+p520cIfPMHyMxRZkumpk/2YX0GOssWoQ9kQT0CxqGqP/e075RqcscarR/5Mx
         +5NEaVIsX2TDcXOsW4OpQpOJ/uViAZqTjBHoSxcFVxbfcXkt7B3eDahcxgQ2bDouBu+j
         7kQIXTty1PnTsCXlm+RPREo4+ypU/Y5M8r3GDwATFuLPydwCCsARzcxq+cEQBPb+IxT3
         /Z8l1Zy1859CA7aEB4VLb5aNtwy6YfRFwtUGs9DRLk9bNiZwQNPj2CyAQ2NfUtH6ZRqQ
         /Gag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790288988; x=1790893788;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xLvrAGkx9vrXnR1Z5blp755tsRAPCGxhcOW1872e/5o=;
        b=w3z7P5mxPoNhrHsf8DUiSk1xFftwsjZ/7BexVAXB2gs3g/N2Zx4KlQ0+1ZbuM88FVx
         0jwzF9Sm5D3qDRNFj3sX37uudWEVc7FQKxh+wrgFtGtPz3mgvoyaIOzCV3ewg0rjmbda
         M4kDRS7GbQXhuZv96I0R8pLWzvWhesI5tJPGuaTWgg1/cR4l3sL8X1+ItkeomXUmM2qi
         DhqtWJ9GrvFru9Qgx4O6nRqobiCxh0PMsNEySZIz6VKBWSzMHtVABkrwS98Wz0IFFOHO
         vSBSFMutsJMDwP5C9HqnT9BBgubzZdk+R5PXzvR8/HYg045riQbtolVhFYlqQC9VZ/Eq
         3HSQ==
X-Gm-Message-State: AFuF++ldsAmcROhv7UwztLJXft6oozQuDsBXoh3E3ZJntFKsG2smazt5
	eBe5dmU3zFI654kmmgtfv2zNggKHi5tuoa0+Yo5FCvNu+7G8oo2kL1Pd7Bogt5rZ0gTHw63jNdp
	QI9aLjeni+3r6Rl8YhEbZrXS2u2JH7+ncRTkjngOefW3oFVjbDLVVHrBhVO5aJaFevSp+6zG1ij
	rWUpW0pFUzJVz/PVXH7daB+6vMie6+CUOm6kG3/ic0P0mUbB1d
X-Gm-Gg: AYBFou0B+KoFYtse/4dkLvTKuYVkFidb4frl3tbgK14SYdEgFsiJmvwdECEq3HGmr8p
	ucHVL+VHMs2oQEOPgbDeTC2+bHQCKZNTA5r6wzy1Tmzfrt6wj0yqEDFI/I5BZdkzuerVLip4Bzs
	LV8A4mWKriCabl+Bo9uzasGfJcf59AQVsKeofUQpuTrbXUgvrSX46+ujahhTo2tDcRN/HDtOVZg
	NQQZ7rhrhJISb7gSfldRm5kf9kcJKbm8d5E9lNv74Z44KQbec7NrkqOq4ialF/dUHO4hnfZKqVW
	rS/rCxfVYH93yDwRAeRrho1uK0R4iPiO880gVzVH1Xsmv/myfkBq/gmBewDQ0B5GBBEsg8p0Xwz
	DNpztZGw9gU/3EtWy/U8neSjw73eZdaN8vhS1PA==
X-Received: by 2002:a05:620a:4013:b0:92e:745c:6c5a with SMTP id af79cd13be357-93c43c5e233mr142842985a.14.1790288987961;
        Thu, 24 Sep 2026 15:29:47 -0700 (PDT)
X-Received: by 2002:a05:620a:4013:b0:92e:745c:6c5a with SMTP id af79cd13be357-93c43c5e233mr142838885a.14.1790288987468;
        Thu, 24 Sep 2026 15:29:47 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c44972febsm37216985a.39.2026.09.24.15.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 15:29:47 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	sandeen@redhat.com,
	agruenba@redhat.com
Subject: [PATCH 0/8] e2fsprogs: fix extended attribute iteration loop bounds checking
Date: Thu, 24 Sep 2026 17:23:34 -0500
Message-ID: <20260924222944.3683556-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is also the result of some LLM scanning that Red Hat did.

The first patch in this series has the complete description of the
issues being addressed; the others follow that same pattern.

In short, extended attribute parsing loops across e2fsprogs share a
common set of bounds-checking bugs: they fail to reserve space for the
mandatory end marker, don't verify a complete entry header or name
record fits before accessing it, and miscalculate remaining free space
by ignoring 4-byte value alignment. </ai summary>

I'm sending these on behalf of Andreas because a few of us collaborated
on a big pile of reports and the original plan was to batch them
all up and send together regardless of authorship, but the list
got a bit too long for that. I still volunteered to handle the
series-sending.

Also, the AISLE attribution lines on these are what was requested.
If that's at all bothersome or unwanted, no problem sending without
that, or removal on merge.

Thanks,
-Eric

