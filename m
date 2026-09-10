Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D93650EC0A
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2026 16:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789057444; cv=pass; b=iDIvLy7W8vgUAgorf4lxiUvjfKOgqMeBXyFhka1dUvEj+jJNuI4WvpUwikwc/o/BL6OWi+03Ec6wNzzDWiqkqHDUTWgdt5+10KBPzZCv0cturaEDjCU8/2oEl3F4AZ5KQiFmEF4GyIz/cNRJ7Mk5RB3R9Y/aZTtycV7hvaC68y4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789057444; c=relaxed/simple;
	bh=9VQjJt6a+185GkYjPMQmDeyCxl5xt0e29jz5LgzWiBs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FHF4+IO2iL71TBHeMve53/kkZuJCF7qVO/ACUCzFGfWksM+nTV0RFa8dJtUaB2x7mYY72oDooGmfs7gWb0/LuX+5PMTokhymQB8Xv2TqKNpy1B8ZV5iDuSXrBVZldn1du1RAvxRF/oM0obWSJvffbVpGDIzCIqsZvhoMUTNQXwU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iLgn4IHp; arc=pass smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iLgn4IHp"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a6249b76a8so2822425a12.2
        for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2026 09:24:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789057439; cv=none;
        d=google.com; s=arc-20260327;
        b=WkfHbRrQKFNsA+daTkhdmtPl3fKh3J8kho50eSe3eoHlGfxtHFoI9j4gQIv0nD+hA+
         JY4U9Uaw2h3t+K3WkUJGPS+uOTUkXgbkUx/Z6L39LPVx2Wq3V+/e69/cpTMzq/uVlxtf
         05QYlF7jVZ8CVXUY8fjBNKEEhgV6gnk0wvb5AHelzq8cZzmg8OAdBnJ4Z0Tqm51PaqUo
         wHSlOUVh5SoqKgERNtuExjt6gSrnZOGPZC2PCpItQcvftL3nOEpF1XryxQR6Oq2XVRaI
         J1jwzXNxEbnheP3jXDK03mnGA0sH6SjfVZZq5oCQXdDJ1UbAQxdB42SpxgC0806XGDDd
         XaTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W02XYVTB0Nl5fojAG5hBMBTOksfDYePfH5xC6TePd8A=;
        fh=j97PSSF6CE/CpMPTkD6nUeRt3ZKUo7sXF4dcKB6PkIc=;
        b=Scvcuo8GPT6sbYvJVbo6mjz42mFzgu1JmC3pI7Tvr4lHI8kY+LWega9kXYxavw8sJv
         EF82ulcn2+jCttJERuZW0OAC+sojixgLL45VOI9TraMokck/ckvtf6BsNTPcYqyZWEhH
         +lnPihG+fhHGn1T6kij4HqtJ9w8PtlvVkzD82iLm7QnnHb3ISum6jspLVmWXUkF75TaY
         n5LcmvcRktSMjPcnQkm5sYHAltSnCc9/sJZWW/Vdc2Oa4oiNrEyvXc7fF5UAdCLn49rh
         CUk8TUSSRriUIWeSYa8/dc9MZXphA/bUPJ/mJ1rwti+5uZdawCVZjIfgLHL79/PE2dqQ
         46Iw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789057439; x=1789662239; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=W02XYVTB0Nl5fojAG5hBMBTOksfDYePfH5xC6TePd8A=;
        b=iLgn4IHpAuwfMDo89vfFxOBs+Gsqm9tddlrtO+bOLA71QrS+muAk0AQ5udV1sn96jZ
         AmyT26VlUHRudqCmXesAeBEIbWpn5CiQXfxZ1Sx10OF6rNYNHw1mgu/AZSDBR+IseeDB
         ivoJU+r4vuqGeDkpdIAoIclYvSzyIUXHQ0uwl69oS4saB0bcUgp9afjqB9+w+qXayAnj
         JkT4sMokdt7YNIqSLm85upv5T/o0pVk9xd+KkkS9Hi/RaO2d/Fgu0cliW+x3gZu6+kLI
         XnRulPVPp5hnvsphSKNbeCagZ7lE2RN3cUuUsWVl46qBSlSBWPytJkE8JtWBR9X0Lurn
         eUqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789057439; x=1789662239;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W02XYVTB0Nl5fojAG5hBMBTOksfDYePfH5xC6TePd8A=;
        b=CFj2cC4GyBM+ueU6esgPrHZPoKPgg7Gg1wolDfpckGS6LVLCkUBTfW2tCsM1ETyYz7
         P+w9juY7jtXklFS/JSoaNdyhwMsPeH3ZbqRApcCwh0kqMzsCVKN1PHJ8WiaVuWqxD5jb
         lmVEZqeNZm4yQyesN2Deirs2VzboseXKEaodeZS99OdQbThiYLclSv7uGlrkxEdPEWV7
         vHxREkhcjagoZWxH+G/p4grcTYuJFTCQGEsyZC+0n+nG2vnzl2/EzTeN1fEuu/PzROgQ
         uyIoMiNjUDSvBXifqCSmGLhIVF09pZJb9+lkQbNWCXZRyCQAIgqwz68g1UGItLttlkp8
         xRsQ==
X-Forwarded-Encrypted: i=1; AKwUvByg3SCtZEvsIE2vo0AwxDZaJ2Lsc+pkYbnGDE/5Xx0HQmkHpSU2if2IonQtzb1ZgJqcVzFBkD7yi0WZ@vger.kernel.org
X-Gm-Message-State: AFuF++lZUn+zr3yrGNSU91NcZRJJLJAzeDkqGHHNg7hKWkJ/XVBdJFzr
	agdJECq3BEBnloiD5PvULLANaEPP6nf7PKl0zo000DELjoBGcTBceJ1MnSR4YRzQXJ/jIc1nn5r
	LC4OtltPxF60Tn0STLp7SQwVZu8n0se/qQ3Thwpw=
X-Gm-Gg: AYBFou22w26SNK0M+2gW5ivKzFugpVuHDCdOi1Vqyercn1TqXI1S3mBr59bvmrU51vf
	OpDFusr1LQRjNq8eUwjv2/yjNc+Hvrs5PMUHvBBTUPiHglvkWpmXMtx7NCh6gJtgc6vhPK+l6S/
	0Jdv19CqIE74PzQz9Sxg/vcG0jC2ZrHcTVoe5E7wW3Ke4kCURbHOhUqvQMyKRl5c/HWMt8ftJzN
	44ir+krOQeAYdwTGTnEwj1mxkBjw2YN0oKFG07IEh/kVUQI/pdFOsSJKUH8DWYjeB04MaXiO1ec
	1jRf+GuIh8v5xFbUe4z1Jggjr1MDS+UY+SsL0fa2MvWi6dfDLVqx8oYCN8Zkmk4uZw==
X-Received: by 2002:a05:6402:3512:b0:6a8:451:32b4 with SMTP id
 4fb4d7f45d1cf-6a99ccf0837mr3371397a12.23.1789053870395; Thu, 10 Sep 2026
 08:24:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <9CC2EE8A-9F67-408A-87A1-62AF671B4BFB@linux.ibm.com> <20260910141524.12362-1-spasswolf@web.de>
In-Reply-To: <20260910141524.12362-1-spasswolf@web.de>
From: Chris S <coshi036@gmail.com>
Date: Thu, 10 Sep 2026 11:24:19 -0400
X-Gm-Features: AcwNN1XO9GRsWlKpqFSX7PpQbLAxVz7EBaLMtD1MZCmQjL9KwHLULMUzhoKDyzc
Message-ID: <CACd_6n2cPqmqs=Ao6yKGSzW8WxUPPsHaLJBOHGeMtKPkk6aR_Q@mail.gmail.com>
Subject: Re: [PATCH v2 03/21] jbd2: point the shadow buffer at the frozen data directly
To: Bert Karwatzki <spasswolf@web.de>
Cc: Joseph Qi <jiangqi903@gmail.com>, Jan Kara <jack@suse.cz>, Venkat <venkat88@linux.ibm.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Zhang Yi <yi.zhang@huaweicloud.com>, 
	Bob Copeland <me@bobcopeland.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, linux-ext4@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, 
	Weidong Zhu <weizhu@fiu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

You are right - I checked rather than taking my own word for it,
next-20260909 still has the unguarded dereference.

The fix is in, just not where linux-next takes its vfs branch from yet.
Christian folded the b_folio check into the commit that introduces the
folio-less buffer rather than carrying a separate patch, so on vfs.git's
vfs-7.4.bh branch 781bf9c7e307 ("buffer: allow a buffer_head to point at
memory outside the page cache") now reads

if (bh->b_folio && folio_test_dropbehind(bh->b_folio) &&
   op_is_write(opf))

That finished this morning.  linux-next merges vfs.all with tip is still
2026-09-02, so it carries the series without the fix - which is exactly
what you are hitting.  Should go away once vfs.all is regenerated.

Thanks,
Chao

On Thu, Sep 10, 2026 at 10:16=E2=80=AFAM Bert Karwatzki <spasswolf@web.de> =
wrote:
>
> Just a quick reminder, in linux next-20260909 this has not been
> fixed, yet.
>
> Bert Karwatzki
