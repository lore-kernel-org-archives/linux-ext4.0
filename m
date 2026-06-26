Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB3A3E959A
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2026 10:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782468332; cv=none; b=WMYwMWEflyUSv7X5uDsUea4OZkZ1g8taXAdPFgZZZrowZ+9MjaMBi5yjeB3I0E+s7fBXxU3/NGCsvGRY2oAVABSSTKBAk8GP7fS10Y8SXlPpC1vwC0npt4gCT4oG4asd8v4OlXeMYOxmbbj3Gc7D7h3tIOqBGE6KBcoAelkGylk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782468332; c=relaxed/simple;
	bh=C6g3oSTRv01LcmdPXswFH3AfN8+ZBuwOKaByhSZrN6o=;
	h=References:Mime-Version:To:Cc:From:Message-Id:Subject:In-Reply-To:
	 Date:Content-Type; b=nAQ97M4WDtx00Y8/4x1vkpDUGKn611MWdO8MAH425d/erjojW/DUS1j5n1P7N9TqX/zeH6WgVY588nI0XJ/Ii2Aiy/R5AiwZsgY7HXHgbXB8PjL+KzWns7bpR2ftlQhknXmY7FHsvZf8qKTmp+q4EyaPe9xpUqCxzNWL6pPGxm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=JE4g0LCy; arc=none smtp.client-ip=209.127.230.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="JE4g0LCy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782468319; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=vrWJEdeaP+BWIo9pqHkAnAToTeZrL9b56uLfVI+0FFw=;
 b=JE4g0LCyQ3qb74xBJGriRR4hLPlC4XEf5BqV6mY13ZRAeZzIzjHHbsWb7rU2J5hqQN/+Xc
 E7r8alvuKMEZ3kfnoRrupPr5ZcRV21wOkV6/ndzU0jXx4rSOBwGmitxJYzzzwNqqV/E52T
 3GXpY2sG94I9O/333tZJdcndXRYmRYf9ds9lGg0zPtpnCcCNAeVB10PeixKcWNMe1vN2dd
 Z5OzUeYAWWMbblQAKtP9uAZcUKNzMTr4tO3Xmj9xza8F/nIVPxRnR28FFgym0Aebz91ugX
 XBkGr8IJOcK7vh/TfnhqAvRC8vVhEmqWNKqR/+gEX6v+F7kjo8RfQ9tdCdxi8A==
References: <20260623094947.7853-1-zhujia.zj@bytedance.com> <81ed36cc-b5c8-41cf-8b7d-16611e61e294@huaweicloud.com> <20260624094535.1-zhujia.zj@bytedance.com> <x3jm3mhgsr7zx4hvfgdvmwoqyz5vxx2fjyxy6gs6him46767f6@dkkirnw54x6x> <7471b9cb-158a-4ed4-a1ce-95270ef38974@gmail.com> <qwe3wrfaoqoowiywhskhewfcjbh5aolmgeoy7am6xcl7id4fam@zxqmz7266uaq>
X-Original-From: Zhu Jia <zhujia.zj@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: "Jan Kara" <jack@suse.cz>, "Zhang Yi" <yizhang089@gmail.com>
Cc: "Zhu Jia" <zhujia.zj@bytedance.com>, 
	"Zhang Yi" <yi.zhang@huaweicloud.com>, "Theodore Ts'o" <tytso@mit.edu>, 
	"Andreas Dilger" <adilger.kernel@dilger.ca>, 
	"Baokun Li" <libaokun@linux.alibaba.com>, 
	"Ojaswin Mujoo" <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani" <ritesh.list@gmail.com>, <linux-ext4@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
From: "Zhu Jia" <zhujia.zj@bytedance.com>
Message-Id: <20260626095734.1-zhujia.zj@bytedance.com>
Subject: Re: [PATCH] ext4: cancel dirty accounting for folios without buffers
In-Reply-To: <qwe3wrfaoqoowiywhskhewfcjbh5aolmgeoy7am6xcl7id4fam@zxqmz7266uaq>
Date: Fri, 26 Jun 2026 18:05:12 +0800
Content-Type: text/plain; charset=UTF-8
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
X-Lms-Return-Path: <lba+26a3e4edd+cf508d+vger.kernel.org+zhujia.zj@bytedance.com>

On Thu, Jun 25, 2026 at 01:18:31PM +0200, Jan Kara wrote:
> On Wed 24-06-26 21:29:58, Zhang Yi wrote:
> > On 6/24/2026 8:32 PM, Jan Kara wrote:
> > > On Wed 24-06-26 17:52:06, Zhu Jia wrote:
> > > > The reason I left the tags unchanged in this version is that I was not sure
> > > > whether it is appropriate for ext4 to open-code xarray tag cleanup directly.
> > > > 
> > > > If you think this is the right direction, I can add the helper back and
> > > > send a v2.
> > > 
> > > That was a good judgement! Playing with xarray tags like this in filesystem
> > > code is certainly not a good thing. For now, I'd leave the xarray tags
> > > dangling - they will be eventually synced with reality on next writeback
> > > attempt. If this inconsistency of tags needs to be fixed, the fix belongs
> > > to the generic code (so that it can be used in other places as well).
> > 
> > Yes, I agree. Directly clearing the tag via open code is not a good
> > approach. However, I took a look at the !nr_to_submit branch in
> > ext4_bio_write_folio(), and it seems to have a similar simple handling
> > pattern - it directly calls __folio_start_writeback() and
> > folio_end_writeback(), which appears to be an elegant way to clear them.
> > Could we also call these two helpers just after folio_cancel_dirty()
> > here?
>
> Right, that would be actually doable there and would keep things more
> consistent so I think that's a good idea! Thanks!

Thanks Jan and Yi, your discussion makes sense. I will send v2 shortly.

Thanks,
Jia
