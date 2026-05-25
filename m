Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E524D23BD02
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 17:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779729700; cv=none; b=P0SDdZy5RY2O2VI5pcHnk2uKW+fGTjBnNo/O4SNq9OU8cGIQw69P2RoliEhhigZxt67ouHqo7zBYMPRFKQUn1AAgvAnylwDMcU72rfX2ScxYCCiRy0zPblL6Zi0uxZ+LZOKVmMkeB/px1Vb6AzQB5Qp1B3tA00VNIFgf14bXJtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779729700; c=relaxed/simple;
	bh=VCEFYOA8bvBB0He6GPuue1J5cPggJ9r83oKY1RULIeM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=onfb0ufWmwAoGjuvKzMtv6KsRGQDbIx+GB1bJukrystVn2aq73YeegagZXOTRHdyuwWiFAuBFcRX81Y7msQuafdba0FRXb05TLnF91Oolk42hh7/xW6BIJ3VEA0ICTN+zlsE5uM5W/7JvGCp89TtcBc7ecEDI6FP716KvfRwI+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nFLYqe1t; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nFLYqe1t"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48d146705b4so103170135e9.3
        for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 10:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779729696; x=1780334496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sNWXusXZo+ITDqzjd8lv9UPW26DbKQzVTY3kSMXJqIc=;
        b=nFLYqe1tk7qwCxZBvuRvWqGDl/PP1t56e6sHt9JBmmmYmlbOXU8xnMDPX+8rPndMNa
         2zgBc7yUrnJOp9pyEBh4d/26MNx5cn3UNMTWA5ijw8O2EKGD44exJ9D+89Ul/Qc1Pt+R
         /EOZDji4aBNJqur9ul7T5t00BS5di3PrdKi2XezOB//+KK/86ne/3D2AmRBY6ANpdjCb
         ThvzY2xpYZ+2BNNBxmDNt1N/CaZP22TNh0pp4Q7X428uuzBIbbBges+roGw8JwlrYKUn
         xPu/34xris6plMkYf5LQoMtInpdT2hWsLdOTyXxGzT9tEeMg/Y98J2QfxTtUdj6zOITs
         b2cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779729696; x=1780334496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sNWXusXZo+ITDqzjd8lv9UPW26DbKQzVTY3kSMXJqIc=;
        b=K/JczNAm9D31xVJR5i8OSUyiIAwQj8s8YrvHU6A2pGfZSSjlWBzXunGfuo6ghB23RK
         Jbj2I3Xgh6pmY/GxflRPmYljwEQdKJzlQXqxTQC9rC1LenlZrbPe675Vm5Bv05MWyZBQ
         Hc2Z0mC3MKLczjK5rkR8Ih7XbmXbMQGhEnx+GjH9n4A+GgLgMn6xA+5pOhCM497icU7E
         JKsxw+dU7cLeIMP9kSPT0s4MGLYkEM5Cj4OmrEEUg+NMd0wnu77WclnjtL5PEQKRIp51
         vakoric8Z26rQYwIt57KEXe2vnFnVi/UBzgfFdXuqK8K7x/r5LlffyLrncoOA9otx227
         JEPw==
X-Forwarded-Encrypted: i=1; AFNElJ/f/4VD/1VZoPqMPMTlZfwlKOPjUM+CHsdQdbxPmwNf47o4OqjyTCmDeDrOrEWYwo7rCMVL1A/mUZyD@vger.kernel.org
X-Gm-Message-State: AOJu0YwSGspzYGx90ofCmXf3UiA8MHf1nGR58j+sB2JVu5abFaQlbeAI
	KCvjocgMxfFI1pn9jLoYBOKFB0AJdyim4AQSr8LGfzAR+rbaZBW/LB5/
X-Gm-Gg: Acq92OEg+N9wu8whrbFioAJzrGwipYQ/15jgcusYSpEH3xCG4kP1RxfPKUuDoU67KsC
	cWV+MjxhlIaZ4HaQsYNCAUUxMZbvHln6XHcye6te+S9uzvng7LlEZ7H869Ju6TFJ9FDo1jD2QcP
	/Yzg3bnmDkFHhX4NhK8KZZCWN7QPK9cxkb9BTxypWqlQehIVTDXqzw6UVBr13wXgfFxEeT+yf3n
	h3st+UxWpjt0jTTLEnHdZmBRbVgmr3kb9Ns+mssZqkjUQ9xK+YwmA0n0OVeKy+QcldGSQkI4MRy
	Pxg17A/FYC6bQbPAxDdINDZlPTkinBqrLkKa2ORfDOJRRWD2fzNlyAlXGgO+L1S3FgAjXGvRYgI
	hqjOa4j+eKnbpBGCLHNFymbGVzPCWLVX0Z1bdUkJShGzNUo3UGZv+JJiQVHeDS66Hu7aMgXZ2no
	Kz153HIvShC8n4idI4XtpNF0UyEl6zH1knxFCRKnNwb5r47HYF0nNq9KmvzV0Dqt6C
X-Received: by 2002:a05:600c:83c6:b0:490:5872:e641 with SMTP id 5b1f17b1804b1-4905872e758mr158057335e9.18.1779729696288;
        Mon, 25 May 2026 10:21:36 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490428d63f8sm88577605e9.18.2026.05.25.10.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 10:21:35 -0700 (PDT)
Date: Mon, 25 May 2026 18:21:34 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Jan Kara <jack@suse.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph Qi
 <joseph.qi@linux.alibaba.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>, Trond Myklebust
 <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck Lever
 <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, NeilBrown
 <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo
 <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Dave
 Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Miklos Szeredi
 <miklos@szeredi.hu>, Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao
 <leitao@debian.org>, Kees Cook <kees@kernel.org>, "Tigran A. Aivazian"
 <aivazian.tigran@gmail.com>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, ocfs2-devel@lists.linux.dev,
 linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org,
 jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH 10/17] jbd2: replace __get_free_pages() with kmalloc()
Message-ID: <20260525182134.04045610@pumpkin>
In-Reply-To: <2omm5gmnv2khshoxkrag5rusd3qzrsqyjgsef2syxgryrtg6vq@ao7oabqwebgo>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
	<20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
	<2omm5gmnv2khshoxkrag5rusd3qzrsqyjgsef2syxgryrtg6vq@ao7oabqwebgo>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 25 May 2026 18:17:04 +0200
Jan Kara <jack@suse.cz> wrote:

> On Sat 23-05-26 20:54:22, Mike Rapoport (Microsoft) wrote:
> > jbd2_alloc() falls back from kmem_cache_alloc() to __get_free_pages() for
> > allocations larger than PAGE_SIZE.
> > But kmalloc() can handle such cases with essentially the same fallback.
> > 
> > Replace use of __get_free_pages() with kmalloc() and simplify
> > jbd2_free() as both kmem_cache_alloc() and kmalloc() allocations can be
> > freed with kfree().
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>  
> 
> Looks good. Feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> I'll just note that we allocate here fs block size large buffer so the same
> kind of allocator as we use for folios would be even better. But that's a
> different cleanup I guess.

Would kvalloc() be more appropriate here?
Does __get_free_pages() return physically contiguous memory?

-- David

> 
> 								Honza
> 
> > ---
> >  fs/jbd2/journal.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> > index 4f397fcdb13c..1137b471e490 100644
> > --- a/fs/jbd2/journal.c
> > +++ b/fs/jbd2/journal.c
> > @@ -2784,7 +2784,7 @@ void *jbd2_alloc(size_t size, gfp_t flags)
> >  	if (size < PAGE_SIZE)
> >  		ptr = kmem_cache_alloc(get_slab(size), flags);
> >  	else
> > -		ptr = (void *)__get_free_pages(flags, get_order(size));
> > +		ptr = kmalloc(size, flags);
> >  
> >  	/* Check alignment; SLUB has gotten this wrong in the past,
> >  	 * and this can lead to user data corruption! */
> > @@ -2795,10 +2795,7 @@ void *jbd2_alloc(size_t size, gfp_t flags)
> >  
> >  void jbd2_free(void *ptr, size_t size)
> >  {
> > -	if (size < PAGE_SIZE)
> > -		kmem_cache_free(get_slab(size), ptr);
> > -	else
> > -		free_pages((unsigned long)ptr, get_order(size));
> > +	kfree(ptr);
> >  };
> >  
> >  /*
> > 
> > -- 
> > 2.53.0
> >   

