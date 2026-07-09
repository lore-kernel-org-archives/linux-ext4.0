Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABD03F0765
	for <linux-ext4@vger.kernel.org>; Thu,  9 Jul 2026 08:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783587109; cv=none; b=Oja16u2pTTemK9XHJPjTHkpsVC/9ASlzgvBfU9EguSPqlCLfXWPram1QI+UqXAefYYbgSkq8S1CJKqk/b/ETdjsiv2Nrhk/RUb55OXItWHGcBY5CcxNpp78vAycWYZ5n5PWzZgEXlDwcMe4eDtBUZrwzxT82fd4+PvkPXT7GDbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783587109; c=relaxed/simple;
	bh=znq26plhwxInEG6rMm+26AmDR8mHesOo4g2XGqxnm+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aSbsG5Rjeuaa2AVDLThKpUTWkUprRcJ99LNtWEqlTD5ZAq1EKVDVK7pcrah2wIfbxzNk8ccQuteSIq1+/beoC5vxjUrJYKPdYlDXo9qw4v02BEhYsWrInX4kydfqup+xmHj1JALnSqT4shel2ZmVuUDzdm6Kf2WWgSUTtB3lDl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iza834L5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mb9tmnJO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iza834L5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mb9tmnJO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783587106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eb5jDTkXBTPOE342mmNfwm5lDoBFxjZ2KPIK/Aydl/0=;
	b=iza834L5VL4ghd3uS/qwfK26v06iCDCHiZ2z7zsaJ0ylLcpa1eWADTc9i9X/fWm19bl264
	QgI4N5jNYKNxZTzfat48yOmrhvb4Ppip5zPTruRZhbA8nwMVjFxHxJrVCipqrgHMlrH0Qy
	8cA6E9aJVUxYbReHXlmNFov4FiM2kHE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-676-fxIUUcJrO7CwL7FKvzg0KA-1; Thu, 09 Jul 2026 04:51:45 -0400
X-MC-Unique: fxIUUcJrO7CwL7FKvzg0KA-1
X-Mimecast-MFC-AGG-ID: fxIUUcJrO7CwL7FKvzg0KA_1783587104
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-490a767c7dcso12304285e9.2
        for <linux-ext4@vger.kernel.org>; Thu, 09 Jul 2026 01:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783587104; x=1784191904; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eb5jDTkXBTPOE342mmNfwm5lDoBFxjZ2KPIK/Aydl/0=;
        b=mb9tmnJOxe0IeNGz8lpg27hc0lZao0ZDKiErb8gR+oA1BiN/M0lEjw703xzD/rhdRo
         TaSzi7ZFGw/M/gLoZmBUquUvTfTEgo2gjYfqZCYRAwgnL4AcnzmZgKGTVcBjfSPNICEJ
         vMO/w0GLOdKHabVF0gAlcG/BYJTV7A3tnSIsrfa9HFGiOWHaZtf9scgQobSq7VK4r+ls
         JBC7nremmJR/3XtQewg5q4xDZAyFrZZ1z6/VziesNr59dPCAdH2KnmhMv8DWF678Rr8P
         2NPcS4x3HD36QI0TsD3LLrsUcKdPimzk5uINsuWpHb5o59TzVu79mfEziF+zBU4e+pbs
         mu5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783587104; x=1784191904;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eb5jDTkXBTPOE342mmNfwm5lDoBFxjZ2KPIK/Aydl/0=;
        b=PCJ+NmiRF3/BbctNvRanf9UrprTBlcm8ggPkolI6pA5uP/GBaPe7m7jVdhDaU249FJ
         dG+lwYotd9EpeItx+zpVVZA5iCgLzCM4A5duCO9NWKUrzsr1yIQvon0JChSy/hoNxScy
         9+H9u1f85kv5t5axc78VOUN1rh4iqU7M3qkvxpwXU2tuuZJ/gunl6VeuyTbYVNK3mQrx
         bF8hFZEyTW68oNOgo0fnYsfHkEYCyMqSGk9eTREkWPAOZ5rID4WJrGR2dZ9mI7XJm/HA
         axnK/SA3AVRqcIigyDKETtHCBloV6IowPHvDU4f00rSlNaeK83f4Eq3u1sdOBtuCeeJk
         e2Qg==
X-Forwarded-Encrypted: i=1; AHgh+RoZQ/LpfAU32Q0RXZOQNlw0uMKy/OE6eyk/x66QKNSGAiaiyRYAToyMdwyTiHyWVhcYemstKOW4YlVc@vger.kernel.org
X-Gm-Message-State: AOJu0YyCQw4i1WhFTOOP4u7JxixwSE7IXqWotoqKFNQO++BeSnquElGm
	z87mg39Rcv+J1b4LNWjmlTDieZWmnecqP472cWEnlKNCuTShK9z8F0DUqNK9JoOkjc/tVXDsDR1
	PXFf5G4Q665tZaFqGyxLe9M7pA5Ocl5J8DEHjzH5N1VChyJqCEhHLY6UaoH7UHQ==
X-Gm-Gg: AfdE7cmUVQF6jvQlTrVa6PeM5P0jGyvlQU8fnV/xnnDSVdHk8B0G5vrvGRSrT24u1du
	FcYk8O6Amfk0OnlIL119pzddTBnJHCXGMfDnMWfRdI5SRUM5WdJ7c6IDRdPEeLuKIHpBCzUxyZu
	/sq9x52kQbK2DHAe1MocwHpp4ZXflTQIpvQDOJn5t8RZEWesSmxE8HgQNMgeQRW36YLvOocItUb
	Jjf1zMVOD+vGb/VEqkSYClZxBzlKiIR+2NKg/Xte2g+VAeAjqYsbECCiTVRNjSdv2z8FqCAcSaQ
	f79n7IRJHcQHFYStu+EgqEPpCliS5iGKY9SyrdPddeJx4zAN7NSunuV6PsvA7NKyHQrochjfk9x
	Qz6W0q+95Iycsjpj+YaQg6qeRNxthzIRE0uRjkSybNFljiA==
X-Received: by 2002:a05:600c:628d:b0:493:bcef:5646 with SMTP id 5b1f17b1804b1-493e6862b68mr57369665e9.12.1783587103529;
        Thu, 09 Jul 2026 01:51:43 -0700 (PDT)
X-Received: by 2002:a05:600c:628d:b0:493:bcef:5646 with SMTP id 5b1f17b1804b1-493e6862b68mr57369285e9.12.1783587102989;
        Thu, 09 Jul 2026 01:51:42 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e5a5d174sm144100205e9.2.2026.07.09.01.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 01:51:41 -0700 (PDT)
Date: Thu, 9 Jul 2026 10:51:39 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, jack@suse.cz, 
	brauner@kernel.org, cem@kernel.org, jaegeuk@kernel.org, aalbersh@kernel.org, 
	tytso@mit.edu, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH] fs: report direct io constraints through file_getattr
Message-ID: <ak9f0CXSegLq8l5w@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260708011843.1036846-1-kbusch@meta.com>
 <20260709071352.GA20180@lst.de>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709071352.GA20180@lst.de>

On 2026-07-09 09:13:52, Christoph Hellwig wrote:
> On Tue, Jul 07, 2026 at 06:18:43PM -0700, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > Memory alignment constraints for direct io can vary depending on the
> > backing storage hardware. Provide support through file_getattr to report
> > the attributes necessary for applications to know how to construct valid
> > read and write requests.
> 
> This probably wants to be split in one patch for the new UAPI,
> one for the helper and one for each user.
> 
> And especially the UAPI one needs a much more detailed commit log
> explaining it, including why this duplicates some of the informastion
> already in statx and documenting the semantics for all the fields.
> 
> Andrey, is there a man page or other official documentation for
> file_setattr/file_getattr?

No, I had a draft in cover letter but haven't got to sending it to
man-pages. I will prepare a man page.

-- 
- Andrey

