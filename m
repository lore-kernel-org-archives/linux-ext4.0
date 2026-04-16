Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2DB2882B6
	for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2026 15:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776354935; cv=none; b=rEYxptLVVsYZ84K8ysnNjjYy1dm6l+zX+e6MzPdj8vyWWDcONiuJN8Zd7iW23zphhWVPChWfgoMStpLdVJHMQP2MNFgO9iR25KHMNE75gw2gbQp+p7aoQwcmaNl5GzD75rqARwMGpjhbcraauGpIEi/WwHUWzNgKA2+9CgwSsno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776354935; c=relaxed/simple;
	bh=heVWTHGVCiX2I8vXvVIMJcPy8ejJ4b2yKmKsalU7Reo=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s6Hnnn6Y0HhqfhN1z3VvRahyEsjLO7jI/dODCnMfNflUICC6FjOLtd6ACQGM13pKEfeA/nR0EvYXw2uhZTcUdBDO9JyB1o/5OWTjCB2oLjtlSgheKlclYRFzYS5tWvrbtshv/zzJqbERcycM2WlUoCLvpJ97BCKKvwBYTkFpsQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tA3YK7oP; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tA3YK7oP"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35fb7f51171so4089702a91.1
        for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2026 08:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776354934; x=1776959734; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:date:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=chO0qG8Bm9Pj7C9gKdTzSncNYRCISPnp8yWh/BT53sw=;
        b=tA3YK7oP+F5z0ytpj2IEEs8wCJK5cUnuV252b9SmqcNTvTNm7BEi8OmbqHbuWcUAbd
         RU9g+FE68KYK5Iav//5rC6i7f0DkbQxcSPm6IyDtnwgcKgqksc+zJM0ub0Szym0voOlG
         RNUUzOgQncC2iVwewy+iTG3/FISr0kTRcnFIgKGBhr7FB4d1C5gZmHS0A6yPB7+orVxJ
         EbkEKQGg1DC2yk+3IRMnOUrNc7kjY7CZDAyTxBk3uSuBFnOolvBuhmzWEMruIy8k42fI
         K335J5jtChVuwz6jbq8mS5RRaP7B4AjcrffcfXNnd7/c7Y3pjukdiEPNthkJJSSd7l+s
         dSrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776354934; x=1776959734;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=chO0qG8Bm9Pj7C9gKdTzSncNYRCISPnp8yWh/BT53sw=;
        b=cjFM9NBL7wLbNVOnc9vtOOFSIPjXG4Vyz87z+rM5iTGQUKARXHTq04HkLg6dm/exTa
         zNFccvz/ldLmIVCyQzjHNYckLMvvP7920025TmmOGXQlcMdJ5hTz7Cmagui+SXrFr+P8
         ohUrgj0/ksDTgSn/+nQswuAgx7TLephsHXA6yRj2/88xGWvIhZaNvXuao7x9CaKVz1A2
         DjeQGYYwXUVqH3eoLJVM+1qWPnJByWXPP2dsBnNyxK+fBSWuSXiVnGmWG0veJcQQWK8l
         aqi4dLhdDWNRi4KGjYTPghu5SVE0rOTtzfxiopnljFIugb4biQTDTjKgDt1qvdBvVFpJ
         T7Iw==
X-Forwarded-Encrypted: i=1; AFNElJ8Q1TyI+KYHUitEkbASFq+dF/+TGOMXDHmT9tjJd10HDJQfgNQYwcOLzmD02/cskY0G4LW3pY8+q+nl@vger.kernel.org
X-Gm-Message-State: AOJu0YyW8FyqHJ3tJKzj4WubdMFG4VN+JXFvZD1O849W3G8OImY25d5V
	g8u7vPX1s92pz5GdL3T+LwQolMBfGsUltTAmI8/CGilWF8+hpeEbkRVG
X-Gm-Gg: AeBDieswijQbnWpsGaenXEBBHsK8F3lacGnwwpq1fioXstT6Ve17hSQ164vUOLDNE44
	x5FWc+fNZ9O0LBKrFJoFzK189fnyu//FDanWvInVG2tnfFWGe2xkI5psLoTTsSpW3gSnOLPtZuX
	t81rc4F9MK+8aicTcQki42GhhPRJNyGJRYOTUwDPp0OkMd3phJJz7uN05MN7p59lS4wX6rspw1Q
	v/CsjQfd0C8eX6iruiaw9l1TpqXQAklgHjiZGHCIfEGm2gaZY5zm/MXp2hocf9y8AygdPDE2yHc
	Y3LWjRcLvJPS651CGpaN+KHVyGoOwEVjAL4D+CSrf75MyXoBJ6KBiJ0FO34rSCpcbK89UjTWCPr
	XmWZTOpIgIcDseopzQ0qsmsFJFQfkBAcwC4ZIOQGAY1+5g3n8YneVsH+wAozGZL1EHFoT6k2NXf
	CQftjcAeV8jdFYE2Q3EFC9dijVrZsOQe0=
X-Received: by 2002:a17:90b:33ca:b0:35e:594a:5b6b with SMTP id 98e67ed59e1d1-3613dcfb87dmr12841a91.24.1776354933666;
        Thu, 16 Apr 2026 08:55:33 -0700 (PDT)
Received: from zlang-mailbox ([64.176.226.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36132c89552sm2964279a91.1.2026.04.16.08.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 08:55:32 -0700 (PDT)
From: Zorro Lang <zorro.lang@gmail.com>
X-Google-Original-From: Zorro Lang <zlang@kernel.org>
Date: Thu, 16 Apr 2026 23:55:21 +0800
To: Theodore Tso <tytso@mit.edu>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, 
	fdmanana@suse.com, ritesh.list@gmail.com, naohiro.aota@wdc.com, wqu@suse.com, 
	Disha Goel <disgoel@linux.ibm.com>, linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 4/6] generic/765: Ignore mkfs warning
Message-ID: <aeEGUqPcOO2xydDN@zlang-mailbox>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, 
	"Darrick J. Wong" <djwong@kernel.org>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, fdmanana@suse.com, 
	ritesh.list@gmail.com, naohiro.aota@wdc.com, wqu@suse.com, 
	Disha Goel <disgoel@linux.ibm.com>, linux-ext4 <linux-ext4@vger.kernel.org>
References: <cover.1775802601.git.ojaswin@linux.ibm.com>
 <afee4fedcc9b3685df0e05800d82b88d27f977f8.1775802601.git.ojaswin@linux.ibm.com>
 <20260410165435.GU6212@frogsfrogsfrogs>
 <advRgjl1tG4PMc6V@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <adyxi7156VAbL-G1@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <20260413162120.GV6212@frogsfrogsfrogs>
 <20260413204215.GA5461@macsyma-wired.lan>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413204215.GA5461@macsyma-wired.lan>

On Mon, Apr 13, 2026 at 04:42:15PM -0400, Theodore Tso wrote:
> > > > > > The output can get corrupted with warnings like below because clustersize
> > > > > > more than 16xbs is experimental:
> > > > > > 
> > > > > > + 16 times the block size is considered experimental
> > > > > > 
> > > > > > Hence pipe these to seqres.full to avoid false negatives.
> 
> You could also suppress the warnings using the -q option, for example:
> 
> mke2fs -Fq -t ext4 -O bigalloc,quota -b 4096 -C 131072 /tmp/foo.img 4G
> 
> > > Futher, mke2fs has multiple instances where we print warnings to stderr,
> > > should we go and fix all of them as well?
> > 
> > "stderr" meaning "standard error", I'd say that errors are anything that
> > prohibits the format from completing, and only errors should go there.
> 
> Sure, I'll accept those changes.  But adding -q will allow the test to
> pass using older versions of e2fsprogs, while still allowing stderr to
> go out the expected output.

Aha, good point! Thanks Ted :)

> 
> 					- Ted
> 
