Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625E83D1707
	for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2026 12:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774440229; cv=none; b=bQKLv6dtwV2OCHk4nhaQ+s11I0SEr1zRI6brFEe64N3TaZT/K8y+4bGCnJhrHEFHICuH0d7E8+CqO+bb7be4gzYSl6RTG5BduGZog7A8kLG7+QP4InJuJhdnq8vzw4fVe8dWFEK7KMjfW9ViCrhJPJnGeQamT4V4uIfpy/c3qIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774440229; c=relaxed/simple;
	bh=Es77No52KNJFPGo5T/ww8er3pjI2J58fF+DFC1d5WKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tpcByFn73xDoWz9EG+lRJY96go+0ibgPRFq0aa7073sF3Zq2A2CucQz0rxDCgRHkF2QjYEjdOhJ6z7JwNqXK9JwylxNlqiSsPhJmX9itMWPTdZjbQahhy3VALQboZIsVw1PzKucSwlJHoBoAolwyTDJEvhZd0ipUBSCJ6CkuzkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=icsZpUJg; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=UPY85kNK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="icsZpUJg";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="UPY85kNK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774440227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hHtDuEkZI5nETEV2K61pi5NwMLau14IczzFE7YDeBkk=;
	b=icsZpUJgksX5aS21xOoEsrXLJPEQ0IWt3+qFA33JkWHh3XSvL3vtrMGW/8Be3vMFl5m7Lq
	Pa37XKpl8XMnNpOld39exKbAeI/2uQV4OO3YREMx4eTA2Jo0Elp7xRH9hpDBcxGugV8hed
	q8sObHA0rBH20Hjam6wOZoiNcRfjJrs=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-6qib3TOuPrOwZ2j70a42IQ-1; Wed, 25 Mar 2026 08:03:45 -0400
X-MC-Unique: 6qib3TOuPrOwZ2j70a42IQ-1
X-Mimecast-MFC-AGG-ID: 6qib3TOuPrOwZ2j70a42IQ_1774440224
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b9800aa2787so223206566b.1
        for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2026 05:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774440224; x=1775045024; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hHtDuEkZI5nETEV2K61pi5NwMLau14IczzFE7YDeBkk=;
        b=UPY85kNKISxwUNJaz9fXarSB972DdMWQEnPwXztyKjQ1HH0D4sH480T4KKq+SRtwqw
         qoDk5VVHoj8UJRdfYHT+TSAGYmwpXcqixbOJ5DZ1+ZEXPYuB/1f98YTobC54Tii++3jy
         HxCfodC7sj6qShUYp+Kq1WE0MrlY86OVZ3ykJVqmh/RW3xSNrZULAimQeTWEUr9A0zSH
         JHeE7mJyO+Gw7nIQrr7Ar1lVXExGDPj+gGjrUFzx39Poi+yGoB+RrKKrNK4ASwlVc/I7
         smzeTJT8Z53psmWcQz1HHHHwTezoKmWuuKl9FgjZy3Y8+Jgvyd9JgxG7XpBA20gSRe3f
         QW/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774440224; x=1775045024;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hHtDuEkZI5nETEV2K61pi5NwMLau14IczzFE7YDeBkk=;
        b=r0t9GcpuQUuOXtSWPovkQKNJ4wpkY7sIpUymGuIjMfDjJDPrDdlr22/zosM2bT9Gj0
         aKQkIm7J7HQxCH3/gh6MNic26K+gYCZx/xzsvu8guJUMHg3WFgcGrYl0WmxL9yYXxpj3
         XqZiClTq+sA15x3S4WTIeCpqvhr74oOEwlsnuf4nSenV7xvdI5wrilhUQNriu3N4PlQj
         6zR1OQ0549VwzUuPjKjW2zJrGzW5vIaOPJFeShRGkpx4TWOjMf4aYiJ7ydqW/v/ItrS2
         hzc6LZt9+JzCVVqyc1nJXJ7IQrf0qTQFE1BAeJk1+7axpyLZeDwag7z/MyFVosNxN0jp
         9dew==
X-Forwarded-Encrypted: i=1; AJvYcCXSXDxOiZwf3crxmmBUtibpDX+5OYvq3NxpLEMpd3wm/sykdKKPqW3ziZPHBE+EQjeB4Zy/klXTDqs+@vger.kernel.org
X-Gm-Message-State: AOJu0Ywf8Ekl0WFgu4dlo8MzoAG3kGXkpT/sii8FvhvHBn/35RXImwcD
	MG9ibq11IcSq1Ui3ysP/79EJr7iDsCS98SCkrlv4eWFMFj9bAjZ5eCCLG4OBW/pyFKQU/HT9Rf0
	pSAscbMho9d6y0cqwUihoySNEyk9rU6OxKKChpz+2bcmvVKZqR/5XikEMDfAt4g==
X-Gm-Gg: ATEYQzx5/O3lscbcqjDWQvGym6WX2e169RqkKZpC9OFupi/dnuM/m4/9tGYaQ//DNPb
	7cce1c/9WjEDfKLo+G5rcYtIILEDIHvZzzGwKM2W5pAatavuhIU7JfBabR6w7H4GBI8w4fVaX8H
	X/v/lQJvC1ZMgaam8PY6uiUslJx6GwZvzKia1kOUda0h/CJWN15Rqyhi781J4WO570N9/YO8qt7
	f57/LQKU6Ji+zbypKY7VopAoLhX449hOa/K63o3xtLHYsLyf1gcV5WWXXzL+VNvB1y8ah8Aonzq
	bA7If1/6Uh935JwEBUY4L0rk/eXw5plWoc1tLl0TbhlQhcbBrUQeoidjqHoNbfN0NJUMvZrSKI8
	Lh+ZlgcaSZhPVpg==
X-Received: by 2002:a17:907:3ea5:b0:b96:ff4f:11ea with SMTP id a640c23a62f3a-b9a542834b3mr225195766b.41.1774440224217;
        Wed, 25 Mar 2026 05:03:44 -0700 (PDT)
X-Received: by 2002:a17:907:3ea5:b0:b96:ff4f:11ea with SMTP id a640c23a62f3a-b9a542834b3mr225190866b.41.1774440223277;
        Wed, 25 Mar 2026 05:03:43 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b983365a159sm760453666b.44.2026.03.25.05.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 05:03:42 -0700 (PDT)
Date: Wed, 25 Mar 2026 13:03:40 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v5 03/25] fsverity: generate and store zero-block hash
Message-ID: <vatqzcvepp7z6iotzayuyh7fajwdqs76pn4o3sdn3f5thiwsjc@dt46ylrbjnkp>
References: <20260319170231.1455553-1-aalbersh@kernel.org>
 <20260319170231.1455553-4-aalbersh@kernel.org>
 <20260325075700.GC952@lst.de>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325075700.GC952@lst.de>

On 2026-03-25 08:57:00, Christoph Hellwig wrote:
> Shouldn't we still try to get this out of the fsverity_info first?

I don't really understand why, this hash depends on salt (inode
specific) and merkle tree block size (also inode specific).

-- 
- Andrey

