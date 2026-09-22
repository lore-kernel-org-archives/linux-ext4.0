Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FE752E07A
	for <linux-ext4@vger.kernel.org>; Tue, 22 Sep 2026 08:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790067376; cv=none; b=iZ7Y5iIbR2g+xR7FRkWSGhpaaR+952slUfbx/wTOFl/vJRD9xcMxWgh9UFUxlFGMmK/Lys817rDwsQrbasNN+M7stHvC0K7wfxhS1TKHIZaEFzA6OSnu9hln3EDNqI5mApLm675LtnXPR0+wflvnr4ZAfMZU/vIEpVJ5w0o5pZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790067376; c=relaxed/simple;
	bh=dTZ74AujbnWToEkdYNhWDDknBgtfEGUv+/3pS6per/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kh4/rWozljvysn7nuQZdr2HoPmIVgJhpyL9O2SIvv/v5rmEjFabWlcbDGHA9ftIz+RiafbLs7kWz8d1P6xqsef10KCbzBtzy4K27itIKi09KnS0N1DFk4+jAt0Dr+CMS5rc2fM3rmAOp9ldBzdzu1TabpkU+457eyfejcXtv8wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cZl6BiUc; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=eZbtqite; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cZl6BiUc";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="eZbtqite"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790067374;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ovEqrxQiNC1fApdCYwkn/e/ow08kQkdi30NnfIiXj3g=;
	b=cZl6BiUcgYmcphPIvPGDPjGttzMWJKx0suBU0Y8R3WK3CCQw2bnk+j/lzSgCBLH5RLKENZ
	lef44Aj1hFLGLnkqZ/Mb7okdMT0ET7qoVhn3EvUaZdvHylJswTgSqTbbxNbsyn91rcAI8W
	oHXDjH8htIDuKhOxE/bgJSYVa9yTHSE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-436--Y_9tehpOUWJh6F_-RulNg-1; Tue, 22 Sep 2026 04:56:12 -0400
X-MC-Unique: -Y_9tehpOUWJh6F_-RulNg-1
X-Mimecast-MFC-AGG-ID: -Y_9tehpOUWJh6F_-RulNg_1790067371
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-487041c4c82so1181820f8f.2
        for <linux-ext4@vger.kernel.org>; Tue, 22 Sep 2026 01:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790067371; x=1790672171; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ovEqrxQiNC1fApdCYwkn/e/ow08kQkdi30NnfIiXj3g=;
        b=eZbtqitewffqEAtbuZvziZPr1toNvg5J/UstrD6538H1I0iyAiiDGGPPbtWAM1HcGV
         lIUnJ1EHJIfDGY5LMGVjjjKJKB2Zuc1ec7j8tAHuhGiwKkIleUKRFjUZx24t3DTpSswJ
         TH7+eZYGzF0+CQS4EhY0FqhNpjCuAat9FgJRxyY/hgBa9Cgt2YvpXv9hH/5rGcWAxwZ5
         WpA6ceg3/mjQL4E9xXnCjMSakIMxHEq6CXZ0n5RYFtAuMebBxuP/AE9hEy+pGFGIrXUJ
         oMwULrLe6l2XCjRk9u3et+3lf/vrFxFYu5cm3x5q3k0pvP8xg9tb1a4X3gCqUYhh6lG9
         UEHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790067371; x=1790672171;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ovEqrxQiNC1fApdCYwkn/e/ow08kQkdi30NnfIiXj3g=;
        b=GFxgirakVRwSLpaqqQEJ9YZ9oV+UnOgH3NA12kUoo5X1vq/mGM+xUoHgG3LjJeDpo8
         SGzTlUzYJ3HxbRVbtdSxc52yeRyhCrUAdWbbI8GteTGUCD4/ipbobK02VAsFt7yfq/Mi
         LY31aF1ZlFl0J9Qp0cA3fRmLWRjut01MsisileTmUMJvJ+7gxvXGuTK6gm0IyJkNKUwT
         MTuJbHUk/eYaHSHYTn88uBHDXX58Fnz0jDPAtSgdidasoG3ILAeGpFyaJzXl++er6f1i
         iKASg4oTQ5WqOAReqAlYhOZHIHHinHk99hbVetbkse6NW83lyAjLl9d353bKyethbgdV
         pGLA==
X-Forwarded-Encrypted: i=1; AKwUvByaZxGVzuJRKHD555HAAWesjs0apluUtRZjwNbtYC+jKMM5w6KFoNeoGTRwxz4sm9VZASaWXPe2+edz@vger.kernel.org
X-Gm-Message-State: AFuF++mxKueiPWqWU0pNDubdZZC+iMVdK+jb6+WtiIRAn67Jfxx65PFT
	KaH/h5L7YSPNJBQnkHmsQOsPwGSI9eyz2EUi3cueIFrVrCD6am7iFchMFbJeEH/8emOqFy8h7j1
	XzCmOBv1Z+7sjvOhuCmCX7zVDcOHQacBMtPpauRznbwyvy1FYqoZ5qB/nbEBUwA==
X-Gm-Gg: AYBFou3YrZVilKKZsJYt64Ka/mqSk0PNaO4/JNm3W1QqvDJJYofAfcPmumYlreKg8qn
	i4Jw5XSXktmJz3mZ/S7lBGlQBcw56Hs5y70NOFfxZJtYa3Be6H1DMNqhKTe8JOBhWxBQdqyqaBw
	1nRy7Up7wZG1LnVGiEz6VuFGG+sabRxe+O1PVco5UlvpHDyqxuJ56jfoLKKVHYh8XA89SNYEap6
	ElfYu3lHIKPcZbqE8m0wCBF59PHSyHjaQvkNWFP0vbwUzYXpI3AtBfOeCQTLop1w32wVWhyXvm4
	cCLz+zaMEJNcgPWCNHFYh0NxdmBBHs5DGCBZsKZgmtnXhefRDl7pXxfcrMlfjTG5Mvhgscpw84h
	bFQ4DVuAUgxuFjoY88t3seRAY6ePnUBSXhg==
X-Received: by 2002:a5d:64e8:0:b0:484:3310:f394 with SMTP id ffacd0b85a97d-4871e25c7f7mr20485486f8f.23.1790067371019;
        Tue, 22 Sep 2026 01:56:11 -0700 (PDT)
X-Received: by 2002:a5d:64e8:0:b0:484:3310:f394 with SMTP id ffacd0b85a97d-4871e25c7f7mr20485428f8f.23.1790067370461;
        Tue, 22 Sep 2026 01:56:10 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48862795083sm3236382f8f.33.2026.09.22.01.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 01:56:10 -0700 (PDT)
Date: Tue, 22 Sep 2026 10:56:09 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, djwong@kernel.org, 
	ebiggers@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 15/21] xfs: add fs-verity support
Message-ID: <arI-5Ejg0Xw7OVmH@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-16-aalbersh@kernel.org>
 <arIszDCcy0VbRVFp@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arIszDCcy0VbRVFp@infradead.org>

On 2026-09-22 00:22:52, Christoph Hellwig wrote:
> On Fri, Sep 18, 2026 at 01:15:27PM +0200, Andrey Albershteyn wrote:
> > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +	xfs_trans_ijoin(tp, ip, 0);
> > +
> > +	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));
> 
> We can't call truncate_inode_pages with the ilock held.
> 
> I also don't see what this is trying to protect to start with.
> 

I added this to remove stale pages created post-EOF, so, writeback
doesn't try to flush them latter (but now I see that writeback will
fail to map them to extents anyway). Also, if EOF gets extended
these pages would be exposed as they are up-to-date which would be
unexpected garbage.

-- 
- Andrey

