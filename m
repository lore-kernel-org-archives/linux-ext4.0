Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC113955EC
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 09:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782294859; cv=none; b=gluJJsXOk/HmTTlcVqkJuoFfKraM5omDpnIwljolMRFMqCKlE38fqTZAPMWHMitqKVV4vpe3tYuT+6hLZNWAmNBmcC4igmmUODJasBdBGDacZoOhKjAxz5mGl6ar9zM+v2VBOsIIluy791kGE8bhUXO4BQxLJQ+1rrj4Rg1HbzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782294859; c=relaxed/simple;
	bh=joBK+B3mYaMGNAxp3fOJTks/CETcFMfVsK+aX1v74NQ=;
	h=To:Cc:Message-Id:Mime-Version:In-Reply-To:Content-Type:References:
	 Subject:Date:From; b=cZiNEftXUUl3vrsmI0DhrBW9OK0F/dwEqNWz6oP2WwoHGOFL2FfuSbpJlAMEo5RWms/JtNp9/nVkxN04/1/IRDgpMvmynCK5VxnLX17rfSPEiKlFFbmXeD5zuLdv7NUoLjQ0B/qiQvnJMDH9ouTZ5FPK/vDR6hb1LG3EgHM/P3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Qo4SovjB; arc=none smtp.client-ip=209.127.230.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Qo4SovjB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782294733; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=umShoTivTMViTlH/8dCfBir+diXBA0Qrg1F+tK6uXyw=;
 b=Qo4SovjBUNNjajxoqY/MsOZpFTAcbYMwHsGsALJDkMiBQkEQMq3mKh5ZZboe+cCTxsNuic
 proxRLjemkMxaMZaWbanMUS2cB9L54CP/j+X4F170Q5YdcXGC/Y0RdYdBI436SA07KFDBG
 frT81FqmsOOn2KHVSGyIDtSQL3UMT/mcstZo3/AgY8kSymMOfd0T0eHnY+cSgYFpDsM3Iw
 RqtoapK54KOHXjyjiECSuuwPOvAfI2vO5LL4E7kIFaJGNCNVT6fosN7vJUH+QTofoeN1UJ
 HBbLYPNPFHROWVPtI6QCxvCGqq1j1W7L4fIOmHiKgTo8kWD+10980/yPv/0vuQ==
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Content-Transfer-Encoding: 7bit
Cc: "Zhu Jia" <zhujia.zj@bytedance.com>, <tytso@mit.edu>, 
	<adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>, <jack@suse.cz>, 
	<ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>, 
	<linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<stable@vger.kernel.org>
Message-Id: <20260624094535.1-zhujia.zj@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <81ed36cc-b5c8-41cf-8b7d-16611e61e294@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
References: <20260623094947.7853-1-zhujia.zj@bytedance.com> <81ed36cc-b5c8-41cf-8b7d-16611e61e294@huaweicloud.com>
Subject: Re: [PATCH] ext4: cancel dirty accounting for folios without buffers
Date: Wed, 24 Jun 2026 17:52:06 +0800
X-Original-From: Zhu Jia <zhujia.zj@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
From: "Zhu Jia" <zhujia.zj@bytedance.com>
X-Lms-Return-Path: <lba+26a3ba8cb+b21b49+vger.kernel.org+zhujia.zj@bytedance.com>

Hi Yi,

Thanks for taking a look.

Yes, clearing PAGECACHE_TAG_DIRTY/TOWRITE would make the page-cache state
cleaner. I had a version that did this by adding a helper around
folio_cancel_dirty() and clearing the xarray tags after confirming the
folio was still the same clean page-cache entry.

It looked like this:

static void ext4_cancel_dirty_folio(struct address_space *mapping,
				    struct folio *folio)
{
	XA_STATE(xas, &mapping->i_pages, folio->index);
	unsigned long flags;

	folio_cancel_dirty(folio);

	xas_lock_irqsave(&xas, flags);
	if (xas_load(&xas) == folio && !folio_test_dirty(folio)) {
		xas_clear_mark(&xas, PAGECACHE_TAG_DIRTY);
		xas_clear_mark(&xas, PAGECACHE_TAG_TOWRITE);
	}
	xas_unlock_irqrestore(&xas, flags);
}

The reason I left the tags unchanged in this version is that I was not sure
whether it is appropriate for ext4 to open-code xarray tag cleanup directly.

If you think this is the right direction, I can add the helper back and
send a v2.

Thanks,
Jia
