Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B9E370D45
	for <linux-ext4@vger.kernel.org>; Fri, 10 Apr 2026 06:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775802495; cv=none; b=dP0tnjrJs0G4zV6dkbuOWQ3oPwviq/AC0L+ldcWyaoaRdDVkXsNVuk7nfRT4CGsHZDDUWpFTKIWzW3VxyYwLz5MoGLg/G5OQ3axIeg8nVl8HxndVsGm/zUHyR7qDUVsXiq1c6L4CFn2sEEVCEIFvGDsBardgGJpHHMp6jYFB0qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775802495; c=relaxed/simple;
	bh=m1YMIlPxD9t/AaOp9EEFB+xyByDNHj+SrqAgIsds02o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ct9ZCC4Arj2OUozXfqEqtDRPZTlS4jGa9COuAg0DetHr0quQRn1Pizq8+G94CdD8jZOJkTND+WCl3iFGE/di1aAviiVd6oB4GC/wlnmEqgZz6TzC92Io0fceXhuLela2z9VXGO7kHvALkAfbzZq4AeNd0dmcfMVUGrhPVMD/y8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20251104.gappssmtp.com header.i=@gms-tku-edu-tw.20251104.gappssmtp.com header.b=n/4dXuAc; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20251104.gappssmtp.com header.i=@gms-tku-edu-tw.20251104.gappssmtp.com header.b="n/4dXuAc"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-82a655cfab5so1640388b3a.1
        for <linux-ext4@vger.kernel.org>; Thu, 09 Apr 2026 23:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20251104.gappssmtp.com; s=20251104; t=1775802492; x=1776407292; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iKMiJv4/DR/USL0D3ZJwTqklRAdWaGUIC2HNzBIVPNs=;
        b=n/4dXuAcBJIwux+TeI6zDz3kO13WsdrKHYeKXZyNzuAgsDNpOcKB1LPdfEwGwdKsg1
         JhZ3mDP/GLvJmFvhpbIVQEcOxkdea7wMNq0w84V1Xaf4ZgU0a0Ix7G1SNvf3v/OaBZAV
         BpTLJHJz0nISkBKvmJoVpCTOwAq1u75+4VmoV6oDFWJn5uiy7WPRzMdK44Nj/x+1Bosi
         5J/bf5hSqxTNWsu9og2xIgyeWM7D2Mqbgfe3zwS0hUZzBQfHI7+Dx7k0QLBYd01IdmZT
         bvo5jr7DLQJ1UhzY2FOzs/WFG6GrktBPAhMNL3xnnTMfQuNNR5G95NAZZ8vn5wvKWyye
         HkpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775802492; x=1776407292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iKMiJv4/DR/USL0D3ZJwTqklRAdWaGUIC2HNzBIVPNs=;
        b=PpdtiPdbRDb9DPi+GaZmKDj4GNv0Haf5BNlS83IWHXehEKflR8Fq6WlTs15a5ixLhx
         Q29MboSPwCPh8bIz9lf9K+0Ph5gfFgwT12VUh4ZvX0zHajz/i4meZxH8ZOVUpsXqwvbG
         BKR8oNpYEFTY7JTXgrPqjef282U73+tTj0E3M4NicNTxBpRcAc/YO1th0O7gPNNSBXxn
         JbVVYATxxnDvgOBufj9N/ip3nmzC/9/OXqU50bkhsUbztzHwpJrpVs/phFZ7zXFBXc9S
         kV/PgkOjU4fjPkMjlz6v55JCD16DcRKd4pCFI98ZFWm2iAYGZeBZQvaddOGMcFF//ju1
         5jmg==
X-Forwarded-Encrypted: i=1; AJvYcCW9dpN58mzyfJ5IHqS8rMaU/UrBqqCbidU0EmGwQyqA6L0MfQBXWfA+CyTTMQmMc6FzixFUO6WzB1sX@vger.kernel.org
X-Gm-Message-State: AOJu0YwYBs8JU7IO2tAcocXRrPErxhyxqI4mLFeLt5C1kXPJS5+i7TFT
	ooimj5WByH+BDo0OK/UOA0JwDWFjhN41FBDzkMevUVTN/5xNceEfVoZ5OzQUO8Esb/0=
X-Gm-Gg: AeBDieuCr7tTObjnVa6Ybc6/NWUc1FDmXQ4d4T0u0PDr4uHmjT4iXeIhh2yUxUBHhs7
	XVFUxdCqB/Yyn0ttbJwo8E+U08cw1hMWztOsOLaxnRBMtXoJcDerYyoN0ph1UwUadkIXugBU9ad
	8kPXRpD7CnBwQCGgoe0YMLUwGRJz4l7D0+26zl62BI1G5ZvkzeMuvQ7UaaLJdqCRtNwxLh1Ct4H
	X7tVjQQhtDpAId4BpZtDsfpfXrNzVFgbAKhZp5vkaVuPSWa24aK+s8sVxnwlMYrt/i9thbIGYnG
	FzWXDBdH08T+jzuoV/Gdf3eJylyJPamIrZBWkuxfK397KoRYLy2uDr9R9jhCzB/i1X13nRbpGhz
	zSbideNYRunzyoKdAkg+HJeyuTwWHUohFxon97Z8swZIZAtYmO+jwlmlsjlNHCWoYjBHPBYmnGC
	hCM2WI3KHF3MoTX1c6DnMTAS4xsE6Z0aW4AWwX62Cu7MQ=
X-Received: by 2002:a05:6a00:9a3:b0:82a:75be:d377 with SMTP id d2e1a72fcca58-82f0c2c8331mr1978149b3a.41.1775802492119;
        Thu, 09 Apr 2026 23:28:12 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T ([2001:288:7001:2703:7a3:1dc3:54ac:17b7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c4b7d10sm1661503b3a.28.2026.04.09.23.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 23:28:11 -0700 (PDT)
Date: Fri, 10 Apr 2026 14:28:07 +0800
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: Theodore Tso <tytso@mit.edu>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, visitorckw@gmail.com,
	david.laight.linux@gmail.com
Subject: Re: [PATCH v2] ext4: improve str2hashbuf by processing 4-byte chunks
 and removing function pointers
Message-ID: <adiYd7APmgkR3dIi@wu-Pro-E500-G6-WS720T>
References: <20251122043929.1908643-1-409411716@gms.tku.edu.tw>
 <20260409141050.GA59468@macsyma-wired.lan>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409141050.GA59468@macsyma-wired.lan>

On Thu, Apr 09, 2026 at 10:10:50AM -0400, Theodore Tso wrote:
> On Sat, Nov 22, 2025 at 12:39:29PM +0800, Guan-Chun Wu wrote:
> > The original byte-by-byte implementation with modulo checks is less
> > efficient. Refactor str2hashbuf_unsigned() and str2hashbuf_signed()
> > to process input in explicit 4-byte chunks instead of using a
> > modulus-based loop to emit words byte by byte.
> > 
> > Additionally, the use of function pointers for selecting the appropriate
> > str2hashbuf implementation has been removed. Instead, the functions are
> > directly invoked based on the hash type, eliminating the overhead of
> > dynamic function calls.
> > 
> > Performance test (x86_64, Intel Core i7-10700 @ 2.90GHz, average over 10000
> > runs, using kernel module for testing):
> > 
> >     len | orig_s | new_s | orig_u | new_u
> >     ----+--------+-------+--------+-------
> >       1 |   70   |   71  |   63   |   63
> >       8 |   68   |   64  |   64   |   62
> >      32 |   75   |   70  |   75   |   63
> >      64 |   96   |   71  |  100   |   68
> >     255 |  192   |  108  |  187   |   84
> > 
> > This change improves performance, especially for larger input sizes.
> > 
> > Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> 
> Apologies for the delay in looking at this.  It fell through the
> cracks on my end.
> 
> Because of how I'm a bit late with reviewing patches before the merge
> window, I'm going to be very conservative in which patches I'm going
> to land.  So this is going to be deferred until the next cycle, but I
> wanted to let you know that I haven't forgotten about it.
> 
> If this was a comprehensive set of Kunit tests for fs/ext4/hash.c, I
> might have taken it.  And that's something that I would look at adding
> for the next cycle, but if you'd be interested in creating the kunit
> tests for hash.c, that would be great.
> 
> 						- Ted

Thanks for the update.

I'd be happy to add Kunit tests for fs/ext4/hash.c. I'll work on them and
send a v3 patchset with the tests and the optimization in the next cycle.

Best regards,
Guan-Chun
