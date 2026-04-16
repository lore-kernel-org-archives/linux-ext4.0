Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05BA39DBDB
	for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2026 23:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776381703; cv=none; b=fu7hfNir9w696urMc0FYNf84e8wVRvFioOGHkf8HV5LcldZj3kHbeuMyLtDo67MbI5MQD5A6OxKqFjgxZl96DA04qUlsmSCgPCRjU9n5ZAW9I0nxogrvy06DLRjPKHlRor707FIN3mEFjnBaBy9E8FxcPELcYSdR79Vy8NmNzeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776381703; c=relaxed/simple;
	bh=1zJh+gMNLh3n9Gp3wdZERWR7klivM5dIWbl3gOrvCZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F5zatPnBgcg51QUeyxPkIVQ9SEloS6BS1X3U0lYPXZT+ChLyL6FjI+uQ6uR5gnQlzqDdmxdhMe8317GApZjlqryBqO6LNzsv6hiv5I+rzIor29UJ4eBgsdy0vbm9qKmKzagcuMxOwUXqDgs5EovbTthwz0Po1ohbXL37cd2+teo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m4J6vtIQ; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m4J6vtIQ"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4888375f735so698985e9.3
        for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2026 16:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776381700; x=1776986500; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gtSi1JUHvm8h9ZtScbheLnAanBRgPo0T9nN7jS0tLq8=;
        b=m4J6vtIQ0er4WBcUyW7Vs+GyWO0eI3k33YIr6/cLkiRai6ad7kokNdfk6bnBBbVgu7
         p03pcRtlu4Wga1uf7P1AV3TP6JETrN+3zf+UemEd1fio6FClZGj2UzHczYkQcHxdDTeI
         0s4j0Zw/AGYXKZ9g/3lNbLmfKfUeRDHMBtdOM2LENcL97WWm0tpNQwSV1ityaWu7Eqk+
         0cASWkUhGEYG+oO9GB4ZqcGIw7nWo7h9rnXljqMD1YnlFu/VCC/Rsv3DkQaFd2f66vQ+
         64ErKCHXqABWqma8RppIWHqO/jLA7SIT5TAjvYUm0HRoYkwNcSAGjl/tzthmVqZ/Six8
         LQyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776381700; x=1776986500;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gtSi1JUHvm8h9ZtScbheLnAanBRgPo0T9nN7jS0tLq8=;
        b=glM0ER1IhoQgczJPvwaLkHhF4XpiihF+vuZB9J+LIAggBXeAxyne5JbnHGywFdt3wc
         GIARiaqTqCPkMH6BFQFbL8R1nr+xy2M3EhFDG2VUUyyctpLqao9x93a1G6IhgViL4BQa
         0dF9HdPt2aXrtUvacPKMT1IFr6U7NDphNlYBja8kCYDqMyOdhZqqu6RFLhwpoK6VcYXg
         hO2MdVoUDE7eqU5rw5/BohZ6jT/iDF5I2TlXgQ3cTlnipdgb0BiZclQQCXK4j6SAkcQ2
         TslLmQwa76O0mvasEK/awOmpfz8RFU8upqkUEO6BDflmSlH83y1Gbv533oEsS9INbUbU
         F45A==
X-Forwarded-Encrypted: i=1; AFNElJ9MZnfgD9GwnzNWZmAxJ+6QRcIcpgJyZT76raMUazGver3tLwyXmHxTU942MFu8OKXiutbSzaZWVfx7@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2n6aqr09MIawdSD/c+Jlie576KTGfx3ugdQohTcL/o94lr9pf
	dcPXUK0OL4L6ASEuabrkweazehD4HaQTBk/4yTt5jTUN+tT7ER5SkPSY
X-Gm-Gg: AeBDiet4n/NRGE0DuNZHJY2ESmAGrgru0YspWtKxXJP/qqVcsfWM/rXqT973U/Nlhp5
	772ocRi98gRNc/RSARoPzt1+KqwBz0P94zxGewcEJ6NCDd/GXA5egX0uxVTvL6FrnvuBae+m3xk
	NmdFfWN5tLGHiSynB7ycI9YGPX1l22rvY/BcYW3fJTHb0NJ49BWUpcwY4Kf0M1aFsP2BXO5+8os
	0HuAYj8n73ByfcyT7mnkOmyCvg4cLISQ0cjHsH0FMhoSCbpz/Xr2o8eZVsQtEKXO9XNiCueRmlH
	S+P/PO1d6KwC+0e8eSVeLiTm34wDUbETZEOp76bVjKEMIH+MCRq+WesmaHj7/vTnD6iISnt3h7V
	X1FnlgBu4Ciu4ACPBcv3c/cTD0EUmOaQ5OZdZQoapS2u9NMzUI9OQJB5Zdhdt//XmHIa/qa95Po
	qJYzv00jCcrI0eJlQvQXHIiBwKQzhaRUEuZN5/I1pRVE9iF1sACi1HpW7p4YigqMKqgZyWqdndB
	viYUcTvcmgWPz8bAODa
X-Received: by 2002:a05:600c:34c3:b0:485:41c4:e2e4 with SMTP id 5b1f17b1804b1-488fb792dd0mr7666275e9.23.1776381700006;
        Thu, 16 Apr 2026 16:21:40 -0700 (PDT)
Received: from f (cst-prg-89-171.cust.vodafone.cz. [46.135.89.171])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe43021cfsm429354f8f.2.2026.04.16.16.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 16:21:39 -0700 (PDT)
Date: Fri, 17 Apr 2026 01:20:27 +0200
From: Mateusz Guzik <mjguzik@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, 
	Fengnan Chang <fengnanchang@gmail.com>, brauner@kernel.org, hch@infradead.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, lidiangang@bytedance.com, 
	Fengnan Chang <changfengnan@bytedance.com>
Subject: Re: [PATCH] iomap: avoid memset iomap when iter is done
Message-ID: <hgug5jbkwk352zrwcngdofwiy2hq4nk7eq7yvzi6nru5zyebd2@fe64yziutvlk>
References: <20260416030642.26744-1-changfengnan@bytedance.com>
 <aeDjui2LGSidEHcJ@bfoster>
 <20260416152705.GC114239@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260416152705.GC114239@frogsfrogsfrogs>

On Thu, Apr 16, 2026 at 08:27:05AM -0700, Darrick J. Wong wrote:
> What kind of computer is this where there's a 5% hit to iops from a
> memset of ~150 bytes?
> 

Such a memset is not free in its own right, but here the real problem is
*how* it is done: by default gcc emits inlined 'rep stosq' which has
utterly horrid performance (same as 'rep movsq') and in this particular
case the 2 memsets in the source code result in 2 separate 'rep movsq'
invocations.

I complained about it numerous times, see this to get a taste:
https://lore.kernel.org/all/20250605164733.737543-1-mjguzik@gmail.com/

Also see
https://lore.kernel.org/all/202504181042.54ea2b8a-lkp@intel.com/

If memory serves right gcc is going to fix it, so this is largely going
to clear itself down the road.
