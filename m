Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DE53D0C1D
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2026 21:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784754120; cv=pass; b=Dmx2GOJyZKgNKx+6GDn2qb/W55UbKmkCsuVX4jMMjd8woca4chrzTd+zVNNfMFUh9O4Z1SLUO7EfTZwdjCHezE7wb3oCaAEwwsXBXiPKxEqFxX1IY5f9W6zVKZH3edl+Ycq3eU2iw7GvnrcMgDrjag9+cyjlZRgnuwc/zABqalM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784754120; c=relaxed/simple;
	bh=e2ewHyAnmUOsw1e/tN+fqYIkcR6yWRk7QczuTMtWyS4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oWNuEHy1J95OoTQQ6VM73Sr16lW/xmatLeSzwVc1ULPQaU3CDJrdl94bGHMDyd7RVOs8s4/mxIvgaTCPZSqdPt/VcA8b3EDSHCyQpw8TUe4gQcOD1R/mJTl5v/XXjYTH6fVNZjNzlEUmNF+LRu2RXXp7Mi/DZOzLtntZv5mxSlk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NP/nXZGZ; arc=pass smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NP/nXZGZ"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47de0093c42so7738140f8f.3
        for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2026 14:01:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784754117; cv=none;
        d=google.com; s=arc-20260327;
        b=AnYreymBhoBXUluRM7mykCR6sZH2W3mQrg+x6F/ic/7SCnqe2v03AC5FNmGgUpqAKN
         ZjmwKTYRsPDhh5GeLKwxmLnpQbVmSZWxO9didVqchWDs9Lv4srMBFStEuSsE04LZCp9Q
         jUhskpwSEQnATrcJfkmbLgVk+PuFjfeUIxFSLEaAhLKXiXWX3hqSmBsJ1h1ngXnZAk60
         CPoYs55K+JECi9JttUQHOKhles7yZpvLkqN5Lyl4mpQO7+iNw8B7nqFkfwzyiyHCbYEw
         iUiHXqjPv7mNBJTODkg41W249kFQRrwHrbTRqs98DhaPSG8NKX7J2v3D3rFQRmdHSDyc
         UoNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=e2ewHyAnmUOsw1e/tN+fqYIkcR6yWRk7QczuTMtWyS4=;
        fh=IB1d9eNggdN/W7zijomJnENHUwCzJtKpCJ5VzBOMzvg=;
        b=GPFCeboEXR/oGmLWiNsJckw/fKbwkvrZ3I3rmDg419QKBHVWhzsx85yn/JnaWYdItW
         5+xYUf/tEr4eTMit65qgQuXjqgZ6Y4KqiqJq4SrxxAmn7WQCiA09v18CcKk+IcvxfTXl
         XJVE2m1i+gXlYhBMub7rVvfo4q6sgO6jbHJqVYXQ32jW/llBnv9oaxMwvOwcg3z4iSIC
         YFryQRT8fKpKgGbBM6m+AjJkayvd/SEbXyybo75UZXN1+bZV73/aroyHUtCL8CzXgr1Y
         LWCasiIj9iatSszknywuhou+oUgSxt6MunU/OjDRMZjOh0eh9t0q0yk7yebwy9sZdNrt
         J73Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784754117; x=1785358917; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=e2ewHyAnmUOsw1e/tN+fqYIkcR6yWRk7QczuTMtWyS4=;
        b=NP/nXZGZe6/PNwQFXkRX+7LBw95w4hc0FiI68g+ghXpgByhpNq/AyhODxBQTE/yOGv
         7OHVXF26DkgBOefTM2P8QAndTMIJKvy9dCOS+XSxgARN6kgawKJjFLZUCMySAO7NCdua
         3m0ax3CMMPE9T6EJ++gDPkesLKdg/7TD6ckFMikXlaMJ4Uc9Ng4g2fBwfZbHhbQAP3wc
         LmeJXC6r1Wo6w56SmQLBeD/jlSmrEikpP/C7WhjU0RNhh1YPXIeGtwfIJUweDboow246
         hnULxokRMb8HCk4kepfXbuwBTdS2OhXWMJgk+HsQxCcOkXBFK5LbbgzjrdwHFCH+8/Y9
         OPgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784754117; x=1785358917;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e2ewHyAnmUOsw1e/tN+fqYIkcR6yWRk7QczuTMtWyS4=;
        b=W2FDryYyVxd3ndIfMvMw/O/ZzOREIfhpkdWO9CRtr702QWRhKidc5EeZkTxuRb1t4e
         sPQTXSiEBHVaAdcY0M0eL/HS363v25xHJp8EzN4DPo9SbZScj02lMEK7O3qZ0pGTa+s0
         6sjKw4K4X9soiXBa9nmCs21j6FwGnRzDkPhdbr/8tWAhgRJhF+8nECNXJCXGOovBqGRd
         46VJsySvqt8I7SLvnT15oWAfCg6n/LQPbtSEjlfSRP7TkUa5tDT1b4jO8ShOi7jG85vv
         VHXfHli2k4PA5Y+Sx6L2X2UMyDpQ+dbImnGr9GXavzsGpIyqhUeiHzzKgZd5+/Iz84Oh
         C00Q==
X-Forwarded-Encrypted: i=1; AHgh+Rq37QLVKYCqTl3KOGg/6w9sYvDKQCQgqVeIxLcaoPMTL8HnCk+2UU8gqI1w8guXOZReWR2TG6EdSxWb@vger.kernel.org
X-Gm-Message-State: AOJu0YwfVxB3XeOcIFvJ9G4wtX9fbW8GgnOy2weM0DsDF4S3rf3fY0vZ
	EpTPSqKydIhx0t4dazza7aENr2hxE++tzOvL62avYvxm6R0hUYLvnF8JjZKLoSuIrpDpEvy1bHh
	dLA1P9LnBmdFA8fMhBqBB/awaRXw3FbA=
X-Gm-Gg: AR+sD138fJ6Ex1xapSuL5Xt4CasiJqUbrwf1yNHMLmsb54ICXHS6+owKbfWcT5pWYFh
	lSIVsW8EjiLTNCy3XigupvEKIDG8PF8Lh03uKrIYjNc6DSUNiwxorXi94PKHIwFqexms8xYQWvH
	wA3irQ15PQcGjTxQTVd8dFDrFSRqOjAD9DnEB0HHgDbVS1JxfSQlFyVNulyVhVYazvPMnEe+/Lg
	J3vkHo8suJ5EpkmRNQk9W6c8Y1AWiOLBCfYgtGtDjuvHsita7W7ahD6mTN5W2J4Xhyl5uR5fYV8
	v+ecE+ToSR+bVLOj2F9U+GYTO8ERBRHrC4mJ1Fxnl1TinJAyS7ZX8yZB
X-Received: by 2002:a05:6000:27cf:b0:47f:8fb6:c32f with SMTP id
 ffacd0b85a97d-47f8fb6c4fdmr41413f8f.24.1784754117241; Wed, 22 Jul 2026
 14:01:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260722124931.3159664-1-hch@lst.de> <20260722124931.3159664-4-hch@lst.de>
In-Reply-To: <20260722124931.3159664-4-hch@lst.de>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 22 Jul 2026 14:01:45 -0700
X-Gm-Features: AUfX_myFnH_OaKIVvcOPcgbNKPlzrgaHUDbZ760JNGIOLPsUeq3W4FF1lWRG3bc
Message-ID: <CAJnrk1Yp_X_qKgBFoQ2JwC8DgECZ09x5xsnj83iAQ8cDeXN2dg@mail.gmail.com>
Subject: Re: [PATCH 3/3] iomap: use GFP_NOWAIT when application for
 iomap_dio_simple allocations
To: Christoph Hellwig <hch@lst.de>
Cc: changfengnan@bytedance.com, "Darrick J. Wong" <djwong@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 5:49=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> For non-blocking iocbs we should avoid blocking allocation where
> possible, so switch to a GFP_NOWAIT allocation here.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
