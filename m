Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794336692;
	b=rRtYW0h61FNoyeR8kNSDSpT5eq4GxM5tf+h945k4WMpFHvNv+wPSEn8eJ35AVaNCmXy9
	 IIRacp+NQv+PAr3Va3OYb1KEI01qgBwMtJm6DUkLpKWcWVCV1V4yd+9JElXIvaJS4mzTv
	 076kPAcce6d+ylmOc69Bcaq0jGdBuKodSihMyjr8yOGS2lFc3y+vkpb5CCt33PeD5/ESI
	 ssZZBnB4FtwnCyA36S7Whi8lGlC02rjteL6RGCkzIQll4e42j/VP7kIP7isl5Or6FtB7N
	 zQcoIl2xnojLBIpmuQAAXbba/nPYIxleCqYMeQBrBSiVUkd3v0FFC9r54oRcRjoYYZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794336692;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eSWtkVU6mS+isDiyOe0c8DoQ/PK3FUw0h39/ptl7nhQ=;
	b=ezBddtu6jc+pRGuTPqdDaa5gb0A32RdnaoufKzwzxwwXmsGgm1DenvnFcEbMOx2wd9TW
	 JexnYwMdJA9XBOiAV3/bYGlvoOTqKHSASlOo0vB+Hj0+FYaY1FviaQpkIQfyAyhnp4qiT
	 OSV0Jyj+jai2E+U49d3WJ80jODGE/R/jEOS3rzf01WINVOIhgE7RLbZ4pw9rWj8lM48xi
	 Y07NBk4RYjCKjvIX5sBNhP6rT7fsI4rQOYAopBXuqf0bIHK42sdo029mk8ui9xjEJuLX0
	 J+P+W+YpKMgfvH/GBOgCQ+D/DkvqN/BhNOcfey0N47mkwUs6aqg+qdvQN2I53GXh+6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vCh6SPUY;
	arc=none smtp.remote-ip=74.125.82.53
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8AF606A321
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 18:51:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC8AF606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vCh6SPUY
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-15dd124bbe7so3182904c88.1
        for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 10:51:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794336691; x=1794941491; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eSWtkVU6mS+isDiyOe0c8DoQ/PK3FUw0h39/ptl7nhQ=;
        b=vCh6SPUYYBgQGIMv11JBHQ1ZpHG1YmpKKy5z+PXKqrS6wvzLt+Jd96wRXDx3xAl9Zs
         eqHWZ1n9wDAWlHKO5CkPw4UotjvIcrK0884KDbHvz5p9p7KQTkJqv5sTw/JBAHknmVTc
         +wP7x6qNAd7K8sNrY31mCjYhvP3jjfem3Lk+JNugwr9HA5oie3JA5NtyNSkVuubkdgRU
         33Kk1iyy9S88ZnullO0/56DouCUG+sX8fPRgm8+uiTm/aE2cqdzBuXzSqiOAk6bbQAow
         k8asWa5p9oAsXMqiHne/qDa3fprJ5tb89OjqiXvvDaYxMTTLrJineT/aeibpPyUQhXuV
         hKJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794336691; x=1794941491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eSWtkVU6mS+isDiyOe0c8DoQ/PK3FUw0h39/ptl7nhQ=;
        b=KgcOUPUmwK0531DtVT8uyKTcDc3vBApGmuO0l5ajDVF/irMigklttWU3wqUY2XlYZn
         e5dhG5dVFnBvG+cZ8RjIjRCXciwGCOBJ+LDc/9hCM+mdb+4C+fh3BJEBdoVLbpPcir1C
         wVc1cRjw7o/GLLeu7CD3pmHX1+rUfgMwgnio4l8N8036eQ7YUfpewRrnEgzcfsSbfIrc
         mpcmys67e6wLjCXzOCP43iLQPIoh5z9CCtcwLkqx69JxU3bDqkqfTZijnePOY68Do/+r
         3fDob+hUgEl3nk2mXau8tOy32VEMiRPhb6g/Wo3QxpKy+Io+rmcWlK3hpScWh9yPycgJ
         Mx1Q==
X-Forwarded-Encrypted: i=1; AL+hErEskLUuFqeQMJrxWTeVcvbYRo0Q12pPWI8d5HYY9rYMTADilu2BmHQnWpZldO7sJD+hA95UKEOT+y1g@vger.kernel.org
X-Gm-Message-State: APuU4Z+CaxjpQGYQ3uud4MA2cN6HVSs1DhF0RW0BQYpLcionVatg2I/n
	qTTKWr9TTO+zJIkocfLN1f0nZAlrU6aWGQ4i80uMgHTjQYLjWAchY/yk
X-Gm-Gg: AYBFou293O/1Q9E6c2Zrtkml5gWHN0Fi75DRJ2xwtEs4jpU31JxelzJAwDKO6b2PD9M
	9EE6ptx+xIf2+e5bgzADvQqGkoWsGVLb897byHCG2QGvD2zw3NPLPfLt9Ehph9509fYpnxVomdL
	BdsVUDtPDK1IJYgnEYZ/p8cGFEEmz3LkruKMwdB4JDqBSdLPHckami1t2ubCCpvb0B1AUsDI/rO
	CHJdBBPzSAPMgjMRU+X73+IHybBw7mSKbWPck5UFw//jczUwLGVtrX2bWcmeg4IoFx6YNDlbwhn
	jt0JgL70JoffENobby9S6S6GUKaH3bXtfK8eek7It+nvWWaRgSqE22JvlINd0fA2B+EOvflJzeU
	EVFb8LuctWttvkJgztsYpl2To/v8c8RQnVDogore5Djy9NuhjZpJS9Gc3X7kvMvo7fm6AE1fuEH
	4htVRKAmco0eixLP6Z4OPgTucjGGt97QQHNdUfYYXLWZosiKxOHr4Iu2NOTmapT3HAO+wkOCorN
	2Z48r4gQKkkdD7fHOBOf9Hz20lihqYH08Rq+Af3srX+Mrap19VfSQ9ObAdDJvWSjgQTJU5zf8FH
	LZAdWHYPfTwTfsfcFG5HwotzjEkUT5IDBsW8h9VafALORCSzTaM1jJB3AA==
X-Received: by 2002:a05:7022:ed02:b0:1b2:4e2c:6838 with SMTP id a92af1059eb24-1b3b6057a1fmr4809191c88.15.1794336690874;
        Tue, 10 Nov 2026 10:51:30 -0800 (PST)
Received: from obadmin-Precision-3680.atlascopco.group ([167.103.3.1])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b75d42sm7359570c88.20.2026.11.10.10.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 10:51:30 -0800 (PST)
From: Sahaj Chaudhari <sahaj123.sc@gmail.com>
To: fstests@vger.kernel.org
Cc: Zorro Lang <zlang@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2] ext4: test reserved GID block allocation
Date: Wed, 11 Nov 2026 00:22:17 +0530
Message-ID: <20261110185217.867117-1-sahaj123.sc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261107193050.330685-1-sahaj123.sc@gmail.com>
References: <20261012112109.3363168-1-sahaj123.sc@gmail.com> <20261107193050.330685-1-sahaj123.sc@gmail.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

I've posted v3 in a new thread, addressing Zorro's suggestions and the
setup/error-checking concerns:
https://lore.kernel.org/fstests/20261110182040.798390-1-sahaj123.sc@gmail.com/

It supersedes v2:
https://lore.kernel.org/fstests/20261107193050.330685-1-sahaj123.sc@gmail.com/

Sorry for posting v3 separately without linking back to this thread.

Thanks,
Sahaj
