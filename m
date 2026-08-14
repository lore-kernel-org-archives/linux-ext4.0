Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D914854FD
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 15:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786721769; cv=pass; b=jD++hwfkmQ1TYwx5RtsBMe4wf4sR7WXN0MI0mufgXYR7SlfYYpx/NDH6Utd6aX7nG3r/0x08r2K5vg7UqRfOtxBoayloxCCd2ymlNNMhA3NoKPfdqszw/cKb/35SYo8jklpxc5Mki7ZYHqKnavBOw451rGeQdwlhDw0ueg/WhkA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786721769; c=relaxed/simple;
	bh=c4H+AL4puqGwLT/pm4pEwIvcw/8v5pzNb/24xtEav2Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MSa5TFpONj2EXPHxOvQP9yxqJkRPqls49iaWt8lmQEt6yWFKMn6zt6yG7ibACeKxNz6dZENynJLSFYGaF/TnOVegeJ2XHP2ivxKmwDogK1M555JM9VPh94/H4I4zEc21IgMHCijGuSULQ4ID44TZKMylse6PCd0sFaizVluGwx4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ooADTodE; arc=pass smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ooADTodE"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-6b050a35f9dso766220eaf.1
        for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 08:36:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786721763; cv=none;
        d=google.com; s=arc-20260327;
        b=GzT08/i1tOwpceF4X9LQIyN/hQT0LsfT+AceuFccZuMmDk0Mtd0A4ZnNgf83jLAr1f
         cgJwPWekKCf3tE/W8NhP/Y8qpTLjMsQ4ONEuKPcSjRSCmeQbkm+S2YL7PTD1GPf2XkPv
         cSmqC3w6T5RrH6/hh6AmbKTGcIu5K3Yac0t21JvybpTfZU13mEwibTfy57nfggsmKt//
         0+sQ6vvrVvNY333ZnuSe6Y+G8D90rEEjaFJeta9tGZyN4uNHhLwcKX7UvLvPGTUJzfUK
         Fwa4SHmx+QWEauoLNADqtjaF8GHgmkz+7lOzod3xnr08jHeRTkE5tDp6CGDX+sLS0G0I
         OaTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=c4H+AL4puqGwLT/pm4pEwIvcw/8v5pzNb/24xtEav2Y=;
        fh=3bRU1+r3fcBxpaLRXx5eLyrOXezFSxGJZeC7JFXBt8A=;
        b=B8S+6QXxJj1GAPOyAMgNL554GoXSiTXS953893opQHpL6+xj3dVil6XJaRVWfJpBMj
         rf3oRksU2TieZCIq96dPlInEjALDoVHJ2Wzdc+MOQ+qdcOAXJ0Gk/Jxl9cEEU4+ZKKBK
         OTOiU/yXromsUZZ/w91p5uWnSl01cAl0ikqTts0lyVHJYcVg9tAsQjesCIXuVP5VBk5Z
         8eLk2MEuwxAMDN7YupUhpMTKYT68ZA8XJ03ckfGMZW1irosAnmk9apgKvt7ruaK4dcHT
         M/KxoknjeFZ5wci0sAhkeCTOoABMTnSzETXAPdCPeLpD90hNwocCt40D134G8DIyAswk
         mmQg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786721763; x=1787326563; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c4H+AL4puqGwLT/pm4pEwIvcw/8v5pzNb/24xtEav2Y=;
        b=ooADTodEjr21aohonAL1vdkwMdw/o6l/HArZrovJtYOciGIA6Ab29tN0YqJqZY7REu
         jtS1p5zslhhL95qPCWlM4r7Mu6iPmNBtLYSzrsSZr2DNcARZESbuqCK3WUyOBnmJPSIw
         NMJbIoanXBQRrCqhIj4eCdLEcS6Tso45ucJGgYLenAj0wKiVUUBv2man0CDEfWHnPdd9
         28iNVt7fsG3H6AA5a8gUj0TrkVE7WxI3hLI4ZGFQU4Xu0bcagWyj2NcrlBfqx7/VGgIO
         0nyVCf2AefaQnHl4elc+oF6DDuS6SZytKCYYLrrvmD/JDR7cllhdoc3hZg10MVCW7O1/
         d1fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786721763; x=1787326563;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=c4H+AL4puqGwLT/pm4pEwIvcw/8v5pzNb/24xtEav2Y=;
        b=XL99543uhU6MMfJUag3CG/GQS8U5mL1nuK9i9zIdo4FDTS5O74kA+zSzT9gk1onwfB
         sZ3PBI1PWZgGKgSfN0kYe5BS8kq6ymoOs6sa/4U7x3psQft4f/u5EIzDsvH/dofjmMgP
         V31Ndl/notagh5F2DbjeacMZGsFw4uaXBqOORJFCNESc66Tv3UzogoMEogxzykHY1ijP
         +g+r5z5tjjSfDE8FIasRVVPetJOY424pFDjFJbY0uhcESvEoHmlytUht+mYcA2zJ23P1
         4lIyvbBafYCkGU8VhU+bfMsIvUw49T0kzCzlVBZ9vN9PuLxf1BL9TSWZxn4rwQvt2NlC
         RGIg==
X-Forwarded-Encrypted: i=1; AHgh+RqxEnkB6S4kNRAxCJHlFkfYd+7RTYxvehqdnUannBMydYGYgg6zJlAT+5BZpkUX+OBAOSY5NO9pepLq@vger.kernel.org
X-Gm-Message-State: AOJu0Yy37v/mTc7Oif8RL7jYKgkkT945ZPVobHeSIQ+596shEOQWZmIH
	d3MHGo6V+TfamMecTF30nNEFnJTAOuwMaow8BZvf8uFd3PqJYtkVK7WbdcW7ACFqr77uUpF7Qdc
	OipZ2F/dV1L4a1+OJ5VeKOA5DS+gcevE=
X-Gm-Gg: AR+sD10KcJKFORNvIM7PJlOxTKQ77b2cYhTBw5KzMQnnflo8NmRROf7DTJ7P0hlfRpk
	AsNE3gG59h3bUeckJ15OnwBH8a17Yq8tzXdowUSVbjWqPYRyz89qNxj0dOLQVnmdh4na+ofDLOR
	R4L85NIUk4HPhLoZ0/AnM1L4gY4MRcT7fQAG0TnU6kcHBTfJcLAOIRKRWbeFPHcYfKzUa5IgnBx
	End2ct4zMoMWKF8TGs4yy4RrGh/5+K9SdsBtAq7N2U1pj73jphKI27JSqrpIMTZxhrJPWQJFimI
	+s4AHnUuFVG33yiGjMFd07PrIMdEgg0Bqax5soE7rvjoidu8MzxJiRk=
X-Received: by 2002:a05:6820:150c:b0:6a1:47c8:c86 with SMTP id
 006d021491bc7-6b0d6139eaamr5716989eaf.10.1786721762684; Fri, 14 Aug 2026
 08:36:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785951556.git.coshi036@gmail.com>
In-Reply-To: <cover.1785951556.git.coshi036@gmail.com>
From: Chris S <coshi036@gmail.com>
Date: Fri, 14 Aug 2026 11:35:48 -0400
X-Gm-Features: AUfX_mzYtb9BIJuMN8HL5w2k5Mt2S6D9ha7J2YgkZZzhpnVk4PtV6PYfTcDSSaI
Message-ID: <CACd_6n2pG1UO=e_zbySWNMm_3=btwstaPY9T3+2QR3C-dXhO2A@mail.gmail.com>
Subject: Re: [PATCH v2 00/21] buffer: stop clearing BH_Uptodate when a write fails
To: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	Zhang Yi <yi.zhang@huaweicloud.com>, Bob Copeland <me@bobcopeland.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Weidong Zhu <weizhu@fiu.edu>
Content-Type: text/plain; charset="UTF-8"

Gentle ping. Please let me know if anything needs to be added or
changed. Thanks for reviewing.

Best,
Chao
