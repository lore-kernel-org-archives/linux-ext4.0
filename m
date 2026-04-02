Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3DB317161
	for <linux-ext4@vger.kernel.org>; Thu,  2 Apr 2026 14:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775138576; cv=none; b=WcwzYRTRGs2G/GqPOjk7kFK8UF6IIheZ+zHXV3v+F/Z3oX+QGgfsZYETZh8XFDAAlw2Azx0NG6iowt/uR0TgERghnQ2WcID6a7U5UyW7UOF2ZM7wNhBo+eP4IPv1VttfaBH2U5LrZqDpZvw/qxFrX3+B0p+Vb1pWxZoPVK3LxIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775138576; c=relaxed/simple;
	bh=9Fkhm2ZSRSyJHuWQcaBHkcSrvxp8mNJsd/iY+/b2TWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o1Iz4kcArHbckFOv5JvvU0xzCcibAV4cLAJG+mMhbuojmS+VuMifAJ80H3RchNNvVIDOUoM0HRVIhw6KeB2Zz5DQqtU6PDCW3fQTRbyYbPXz0orlrWq1QBcDkVvvw7IEURldYNneveL9nvygwMX/NBVNwoVabMkMaoBAWA9dcIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XY6n7m1g; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=k7IL0NJx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XY6n7m1g";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="k7IL0NJx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775138573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c8VJHK7d7kEAfjuBkOl9dg73X5S+EbES2+s86mo3ZVk=;
	b=XY6n7m1gNSVpch7FSQuknCL6QmH90fjFIXmmk9SE6Ueg4+KyRLz197cZiWMaCsBNeS260u
	DxHajBcx+GzEcR7hPHIiP+3bEBR5dpeJxsubiWbRAYBag0JOICNkhRjrFr0MXpI8h0qFTQ
	/1ukXi4g6bu1/KVxgpTRDTxTMeTOqdM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-Im4-MNmsMLeVK_YjECWDfg-1; Thu, 02 Apr 2026 10:02:52 -0400
X-MC-Unique: Im4-MNmsMLeVK_YjECWDfg-1
X-Mimecast-MFC-AGG-ID: Im4-MNmsMLeVK_YjECWDfg_1775138571
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4888b17ffa6so7101105e9.3
        for <linux-ext4@vger.kernel.org>; Thu, 02 Apr 2026 07:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1775138571; x=1775743371; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c8VJHK7d7kEAfjuBkOl9dg73X5S+EbES2+s86mo3ZVk=;
        b=k7IL0NJx5GiJG7TcS+R7guHCiD12IMVscKOKQbcTDmRkvNQt0oOGgbeshheDGgW4na
         23075yP3zTxm0v1iQLJQs+FhFIQlrNxnSUZ+Ls0Am035O1A06QCvS+5edOet999ovDKS
         ravdSWdGEjUVvan4SqeI3gQAmm9NsDuXvu99Li60xHUnbiv57TrRn8xRZyAEHofV/+No
         iDldBDLQ4LNH3antfoz327iFePCugTHpEv2VAFRhargYVfH4u9sK90oAuoQZgaWyvH4i
         AVHBCEbalvo0p6g5ynD4gykJScLw6gtcs9Kesz1sOCK3CQb6dhM7rC2hf82FAYSokJIx
         03fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775138571; x=1775743371;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c8VJHK7d7kEAfjuBkOl9dg73X5S+EbES2+s86mo3ZVk=;
        b=BBPefyM2QfsNJEBWAWqBclmRWqDzK26trpvCy58MILKDhf0vMA7rR7IQasEN4OJQ3s
         gdbk0GF9aDQUt2WiLSCEduK3RYIBJH4SG4l06zKUkt3AGG6q7M+PKFwKDTzOyRbTVS63
         znttlfS5WlTYveNW7p6kKWEreZo7zLeA0CGzuq3Ysy+/fcow6s/7RD26YFFEtzxNRWCf
         mxylndXjrQoaAOfNzPbbvd6F+shwvIWYkXYsz6wew4kw49cQxhdJ8GC8NldFgmbBFeZv
         La5LpcDmyG7raF6fSAL3OooIZDpZfwdZqoM5t3Htzcgub60zhZc4R1nP3gxAOFTaKZbZ
         1tUw==
X-Forwarded-Encrypted: i=1; AJvYcCU2FkqcQusu5X5HM5bqxwyBlPaQu9+vKWEIyHlian52tr1Db5vE9dMAtVTuFi0bTzYWG+sYJK0jWzFy@vger.kernel.org
X-Gm-Message-State: AOJu0Yybi7ALO7nd5LsTXvl6bKXyMCWzIXDF3kvbn4VOW8kcKZDlomXl
	n0X1bMwfgOKzOVHr/lqEQx9P/UZnjSVGXvrw2ji84gnn6LBFQGtXCilIOpvJGk8KbFGk0zcxssv
	HePEydqSJVZX1h+UawT/BXPHWLF64a6OuyRtS3GukxjGN7Fu7vlja4zmwPLMBnZwd+M+5dw==
X-Gm-Gg: ATEYQzyiUXmln4bn1i0EYFsmSXxgYSJ02R5jmFwELCLO5AZcGpzYhAuHQCEV/OF1/G3
	2T+z3o86SGygZIZvIKtnk4xH/TiDOq9OQqvZJeezDxSbKOm+zX4nKnPVIJFinOFyOSi0bBpsqit
	6HLQDVsjLriwoCLnO2SSXCoCZyd4PoldRfP+vJkOW5DN0McsjdaQlzhRlAgozg/bOJEG0hMilj7
	WWnf2CKVNBiAHR0XlsWBpZtDl4CUF9Y5bL++RlSeoR90oaLY9O2I57PmQ76dPk4zSFz6wq7t5Dm
	B2gHT5FAX/Yr2nDmZ2ouH8poKj4JLQKgUx0V+bBjIeTw+rmvd4wORCYM68lfrkKUZXZtfC/kucp
	+MCnTuOTcGqZD8g==
X-Received: by 2002:a05:600c:310d:b0:487:18c:7acf with SMTP id 5b1f17b1804b1-48883599311mr128837375e9.25.1775138570819;
        Thu, 02 Apr 2026 07:02:50 -0700 (PDT)
X-Received: by 2002:a05:600c:310d:b0:487:18c:7acf with SMTP id 5b1f17b1804b1-48883599311mr128836745e9.25.1775138570201;
        Thu, 02 Apr 2026 07:02:50 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4e6224sm8771795f8f.25.2026.04.02.07.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 07:02:49 -0700 (PDT)
Date: Thu, 2 Apr 2026 16:02:47 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v6 02/22] fsverity: expose ensure_fsverity_info()
Message-ID: <giol5m6uy5ech26k4cnthqicx7qjzbg6kt6mfg7cyrvbrwwcjd@yi53k4epbu3q>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
 <20260331212827.2631020-3-aalbersh@kernel.org>
 <20260401220241.GG2466@quark>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401220241.GG2466@quark>

On 2026-04-01 15:02:41, Eric Biggers wrote:
> On Tue, Mar 31, 2026 at 11:28:03PM +0200, Andrey Albershteyn wrote:
> > This function will be used by XFS's scrub to force fsverity activation,
> > therefore, to read fsverity context.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> 
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> 
> > +/**
> > + * fsverity_ensure_verity_info() - create verity info if it's not in memory yet
> > + * @inode: the inode for which verity info should be created
> > + *
> > + * Ensure this inode has verity info attached to it. Read fsverity descriptor
> > + * and creates verity based on that. Inodes opened outside of
> > + * file_operations->open will not have any verity info attached. This
> > + * info is required for any fsverity related operations.
> > + *
> > + * Return: 0 on success, -errno on failure
> > + */
> > +int fsverity_ensure_verity_info(struct inode *inode);
> 
> As Christoph mentioned, fs/verity/ uses the convention of the kerneldoc
> for functions being above the function definition.
> 
> I think the comment could also be clearer:
> 
> > create verity info if it's not in memory yet
> 
> Maybe "cache verity info if it's not already cached", to avoid potential
> confusion with enabling fsverity on the file.
> 
> > Ensure this inode has verity info attached to it.
> 
> Maybe add: "It's assumed the inode already has fsverity enabled."
> 
> > Inodes opened outside of file_operations->open will not have any
> > verity info attached. This info is required for any fsverity
> > related operations.
> 
> The first sentence could be misinterpreted as saying that this function
> won't do anything in that case.  The second sentence isn't clear what
> counts as "any fsverity related operation".  Also "opened" doesn't seem
> like the right word to use when talking about a filesystem-internal read
> that occurs without a file descriptor having been opened.
> 
> Maybe replace with:
> 
> * This needs to be called at least once before any of the inode's data
> * can be verified (and thus read at all) or the inode's fsverity digest
> * retrieved.  fsverity_file_open() calls this already, which handles
> * normal file accesses.  If a filesystem does any internal (i.e. not
> * associated with a file descriptor) reads of the file's data or
> * fsverity digest, it must call this explicitly before doing so.
> 
> By the way, should there be a patch that converts
> ovl_ensure_verity_loaded() to use this?

sure, I will add a patch on top replacing ovl's function

-- 
- Andrey

