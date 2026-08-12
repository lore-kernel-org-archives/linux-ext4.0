Received: from va-2-111.ptr.blmpb.com (va-2-111.ptr.blmpb.com [209.127.231.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB57D41D207
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2026 10:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786529175; cv=none; b=hlGzmdKJtplEIJWuuWAozL0A9piq0f4fT3Z/rWcixpzj5gKBSepfv24hinXuO1avhQX19JUWx3V1/ZDwu0HXpoV+ZfIY1jcad/qf+2+srvgzfoOLpbmleCxiZuoWlCH29LBGJ6sys476Bmg3ZjKcrJ6i2LIMkXJnH0/ISJpEn7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786529175; c=relaxed/simple;
	bh=fWhe13h1N84QKKD3dBk88QzLXvLL//weOVDz9pKczZY=;
	h=Message-Id:Content-Type:In-Reply-To:From:Subject:Date:References:
	 To:Mime-Version:Cc; b=d+JJhQ+zdzbtnTeQ8X7PelVnPwoL25Mq5cl7OiakC6bx/pMYd7dctIgkva0VSk0T2g1oKeb1NxUGGp6udyOkXe8jlh3x1bFpUjJqa+cy+ly/c3ep0pNptYaPHx5QFrxj77/yo6GMukh8ydc44DeoOlk557ORxbkzqAVF0znacsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=jRzEUloY; arc=none smtp.client-ip=209.127.231.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="jRzEUloY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1786529160; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=ptFirgCdL2MtjZiFJ/pQGe9Rj3+JjTLuHn52ce60vNc=;
 b=jRzEUloYXfttWtd3vZgLX6QRHpp/WQpRFLvpyJZfWhuqnrcBms58TsHZsXWHQR/NsToxeY
 1jASWGjTzKUT7QL2tag5xJc2XZiNc9hR+XaG7Wg+JqcMeqyBzbiitQMsZRzpa5Dh+wtFMF
 3qQrpYfIYIjLeotsCorYhu/k1xzTffY+tiXbUWBattGET8HrbjOOGOvTXAL0w9EE77oQ3y
 Ovgu+xCkgRxJ4+6Uzunwbvk5DMfiAR8WswSonK6ZniE+DXT0K8OFjaLFYMkMYtyl2A4bNK
 0dN/oi25Kss4HjK2zhvzUf0cOyNjTmsyKqAx3wfMKEhIsaeaEBL7c2D5NEjI4g==
Message-Id: <20260812100553.17029-1-zhujia.zj@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260626100740.52455-1-zhujia.zj@bytedance.com>
X-Lms-Return-Path: <lba+26a7c4586+a974c5+vger.kernel.org+zhujia.zj@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Original-From: Zhu Jia <zhujia.zj@bytedance.com>
From: "Zhu Jia" <zhujia.zj@bytedance.com>
Subject: Re: [PATCH v2] ext4: cancel dirty accounting for folios without buffers
Date: Wed, 12 Aug 2026 18:05:53 +0800
References: <20260626100740.52455-1-zhujia.zj@bytedance.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Cc: "Zhu Jia" <zhujia.zj@bytedance.com>, 
	"Andreas Dilger" <adilger.kernel@dilger.ca>, "Jan Kara" <jack@suse.cz>, 
	"Zhang Yi" <yizhang089@gmail.com>, <linux-ext4@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>

Hi Ted,

Gentle ping on this ext4 fix:

  https://lore.kernel.org/all/20260626100740.52455-1-zhujia.zj@bytedance.com/

Could you please consider picking it up for the ext4 tree?

Thanks,
Jia
