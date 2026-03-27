Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299E63F65EF
	for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 14:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774621964; cv=pass; b=crULCDhGC7kwe5zpp51fyIULAteY9woIFUJwiIUfcxXd2N7JgdEbBsRkP97QcgR9qPAY7kcd821iUckifrVMRajHywLQ0m+aNQ03zaE2+nPFBb+e6JB1ujehSULhU4FVy5zOedjhjz2iIEgvNPTrLPqfdq62p/Iz2gY0lck1Idk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774621964; c=relaxed/simple;
	bh=nCelOdHZNw8XFpBeptkvcXsW+7OvP71QYNzLqewXlEQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QV80lExnux8kYxvUxuvJFufPxDtpLz4vlG3ZOJDXyrDVLnrB/VuPEOih4WQ7B+DehyvaVQbSPY/S2LSEefIOSyQzQDQ/EGh0zeELKSq55lvYpu/qnC4SZ9xKhIXrC/Fn0nNy9nQ4MsWbGGF2aGODEtl7399xuyMhvo6M8qJg63Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dvn4brt5; arc=pass smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dvn4brt5"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-798374d0f44so46690467b3.0
        for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 07:32:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774621962; cv=none;
        d=google.com; s=arc-20240605;
        b=W2WjMNr1ce2bpuqI8XWAgExwSxiLsssh+5xFfZxuqMhmrSw1Jut9EACufxo2aLPi28
         ni45TGPAty6vKSiGBNU9Uml3tnEXPs97uuxFKVSLnBCvrA0hbN10L7h/XPuNwBJI94q9
         YAi2Qz/hNV8ZfkJWjdI1oBQnWjLcdExaj4YqRrQD1OADcMKnuRXyibX/K/s57QG3Jjk9
         bsHygfaXp2FFqImdA1Lf3Tu46PEM0w4rz0VKzXbiyho23ppvK/gheYuz+N8kHe7h7BqW
         mSFGOwHpPZplGbNf840uUyJZkujYQG/cG06NeOVQNDjY8DHarIlUwAUMbqY9IGw6cBxy
         g4fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HcYDJmr2WQTqVomu4iLT8CyKaPhhK/TZ8XSdB/RFZd0=;
        fh=EesgSEu3PTIqN8MhuK4+eiK1pXCUb+NxRfQ7dNBLuBI=;
        b=MSiJ8fDtzStSaF35FKEiAx1UYtUVPo5dHEY69leMraX4wDunBhoFO+ZD7GiHvxQlWB
         KxJDCODk1zbA8Fl5J/UYg2Di6pyT+5HLT2dbO5CVjZKP5NoYtYJBO8/jTtisl7mWhTWe
         XjslczCFWJKKOUemIlheian4NDZzZO2E+qBZxVdSHwMkOf4ApacsJ3FdphzwOOshHbeE
         P8IfCvf/M0npascDpdF/RB03F6tZ1OO7A8qaIOMJMrWO3jMBNSRKAUq/7XCNfgYpRD5P
         7quQcETuQVJR+HDMQO1XxCDnp268LDzR7+lHQNdIvCSEjDXUefCqrJPWb8y6BnA0ocOZ
         X/fg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774621962; x=1775226762; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HcYDJmr2WQTqVomu4iLT8CyKaPhhK/TZ8XSdB/RFZd0=;
        b=Dvn4brt5rsaX6+qfGIk7m0lpdM2DjW4jzXHY/rn+U61PH2c5c7Kcc6T7H8NtAXNTA8
         v6ToQ6SF7tuIBXcBPtn/ah/5/XIe+0gL/1tYVpVUbbYe8HsE0fSCN4j7erhpbjO8N57H
         eWyx24NOHdnYhH1850wseke9mjyyQNQB0iPBXTLjYfG/hzzGQp75b28gcIB2gham5aNO
         snIHhB+g4h8syhAoKYPk9hxoNo4+gPBp4RN/Ju2wMonDLvFkRuo5A3WC1Pz0xy48kuXG
         FuvlhZt30wqv/VxExDUew1EkUWuJVFoMhCJKtUj8nIy4ZNnLHr6QHfv8GvTS17E05L/d
         ul8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774621962; x=1775226762;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HcYDJmr2WQTqVomu4iLT8CyKaPhhK/TZ8XSdB/RFZd0=;
        b=qV95uSAFDXpYwBS4cmMD7i5fjc57vmnCV44BLI3QZ3WOgNAYuTdMXCrvlCrdQqjfJi
         9Jo9b815w1xthZ6OGIeT12LRpnyQoBoFbjsrfyICXJEHVFDpDqMve7tOx1xqdZl2gQOm
         dJl2JZJWGGF9Mnx0/0aig0J+4y81yljNOXcWi+bb261dhjgK1kg7uJE2mtXCo/1l4RvA
         xLe8GYJD5+Svr0EKQvOLlAh3H2B5Kx/AFgYFJRF1N9XVOL/c2eA/QNIWnHFafsqdGulu
         fxQd8ySWZnQmEpfsPBrOF7i2G+HXVC5NAEuqGTS5+fAfiSAYqMfzqptUumJPzlJiGx0D
         gJ2g==
X-Forwarded-Encrypted: i=1; AJvYcCXWIXimJ4nZbMmCuw5a1+Oh+gJY74npOen8XohkA3THBv5s2a4bGAONopF31fwsxN5IGyFvNoOuHqqP@vger.kernel.org
X-Gm-Message-State: AOJu0YzM3uZxK0B0rqxnn6qXkZEzRazzUpLLNTtuWf+oMChXMyjKXX9B
	m4+tovKZQnddOvv1pgXNzFgGZCWHnZbNcsHWMotAErkT1MhBzNNugDGPYzTAxALCyqsDlZhWtRF
	UAMZ1oqhL+5juUwhClkAq3gjALdBR6N0=
X-Gm-Gg: ATEYQzz5v1qxO7jb3gNftIazIim4eDc5yDXQbRQFl008FKVusAy5RjSWQLp+GxiYHLe
	YH6SokfFbiMDZNGNkrV3oFhUq/nTzkUjU3ro4eNIRrgG8t10pD7HeBmhKkaPsTpDIS1VlRYFJTz
	gbYwP9Onl9CODG3FDJzLg3nyYTKHwqUcJWxLEqMkDwieVueI2b6XhfDAx53twtOCClqflbV5SvK
	s0PqWi8+zHELMBL0JK++LDgr2AcNnthtlANAbZ0ZQin7QWeOqvAoDUU+Mg0diH3kJEWuolla98M
	ihI5UElqdkmZadTVDOZ2H2py+2Fw15U0cVMj2kA4G4GJsoXseIsJBvkQX89F0k+nVEo/g0zs
X-Received: by 2002:a05:690c:6e86:b0:79a:b520:c8b7 with SMTP id
 00721157ae682-79bde574b5bmr20164707b3.22.1774621962177; Fri, 27 Mar 2026
 07:32:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224231429.31361-1-kartikey406@gmail.com> <20260326054718.GC4383@macsyma.local>
In-Reply-To: <20260326054718.GC4383@macsyma.local>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Fri, 27 Mar 2026 20:02:30 +0530
X-Gm-Features: AQROBzDREIjBINZA4dJz-aNiWO4sz3DAogt0m-xEsjbXzzozFsZYXUFQWm1Huxg
Message-ID: <CADhLXY5E_4Hi=Uzu3LPwg_YNgcFR+UcAbfY-XzwVnmFBaJqjkA@mail.gmail.com>
Subject: Re: [PATCH] ext4: add bounds check in ext4_xattr_ibody_get() to
 prevent out-of-bounds access
To: Theodore Tso <tytso@mit.edu>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+fb32afec111a7d61b939@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 26, 2026 at 11:17=E2=80=AFAM Theodore Tso <tytso@mit.edu> wrote=
:
>
>
> Actually, it does more than that.  It also calls xattr_check_inode()
> which should validate the xattr block in the inode.
>
> So instead of adding the check in ext4_xattr_ibody_get(), we should
> fix the check in __xattr_check_inode().  This is preferable since it's
> more efficient than checking every time we try to fetch an extended
> attribute, instead of validating it when the inode is read from the
> inode table block.
>
>                                         - Ted


Subject: Re: [PATCH] ext4: add bounds check in ext4_xattr_ibody_get()
to prevent out-of-bounds access

Hi Ted,

Thank you for the review. I tried moving the fix to check_xattrs()
as you suggested, but the syzbot reproducer still crashes. I added
printk statements to trace the code path and found the root cause.

The issue is that __xattr_check_inode() runs once during ext4_iget(),
but ext4_xattr_ibody_get() re-reads the inode from disk via
ext4_get_inode_loc() on every call. The reproducer exploits this by
shrinking the loop device after mount, causing the re-read to return
corrupted data.

Here is the relevant debug output showing the sequence:

1) Inode 12 is loaded, __xattr_check_inode passes with gap=3D92:

  DEBUG: inode 12: calling ext4_iget_extra_inode
  DEBUG: inode 12: __xattr_check_inode called,
         IFIRST=3Dffff88805b9f9fa4 end=3Dffff88805b9fa000 gap=3D92

2) The loop device is then shrunk:

  loop0: detected capacity change from 1024 to 64

3) First access after shrink, inode re-read still looks okay:

  DEBUG: inode 12: ibody_get
         IFIRST=3Dffff88806edbcfa4 end=3Dffff88806edbd000 gap=3D92

4) Second access, re-read returns corrupted data with gap=3D-4:

  DEBUG: inode 12: ibody_get
         IFIRST=3Dffff88806edbd004 end=3Dffff88806edbd000 gap=3D-4

5) Crash follows immediately in xattr_find_entry().

Note that IFIRST and end are at different addresses between steps
1 and 4 - ext4_get_inode_loc() returned a different buffer_head
with corrupted i_extra_isize, pushing IFIRST 4 bytes past end.
The initial __xattr_check_inode() validation cannot protect
against this because it validated the original buffer, not the
corrupted re-read.

I think we need both fixes:

  1) The bounds fix in check_xattrs() as you suggested, changing
     (void *)next >=3D end to (void *)next + sizeof(u32) > end

  2) A bounds check in ext4_xattr_ibody_get() before calling
     xattr_find_entry(), to catch corrupted re-reads

Should I submit a v2 with both fixes as a patch series?

Thanks,
Deepanshu Kartikey
