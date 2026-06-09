Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B19D399365
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 03:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780977257; cv=none; b=WWWyZpJaylurV8tfbfkIlEDw+/ka8HlPJiarFQ/FLWeP8kvFmBF1CY0SUSYRQRapqM1ZXNWYhR/T64ePzbZqgVHn+H2No6yuWsgf7exeEQMYWUnfzVDcJG3+Q6zaJRE6kHaT0xrHFBWB5fEMZRfIDDxjrnG/95lbkXWgn3Pza24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780977257; c=relaxed/simple;
	bh=mvpNFxgw5BGlOhcYlxQ+uaTZqopDimKnKLAb8n4GHt0=;
	h=Content-Type:To:Cc:Date:Mime-Version:In-Reply-To:From:Subject:
	 Message-Id:References; b=tWKL4jAepH2MTPN5EDFQySYDt/16s9y4rndtMJ+u3UzcMckJm75xjKQ8xcuEbcncmXDzICPnYvRmuuz27uV7uEonCWSSRQA4rzm4FLIn0vldNIieqIvloxms6lCxRqeQ7IRult5H7oO/czOVyGlMtj9aoJ6XAImsVDVNxXhTwTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=jg1nYR9O; arc=none smtp.client-ip=209.127.230.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="jg1nYR9O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1780977251; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=uo5KRq4o05V/cFeWp3gjQe2Ro38rU4Ok5QFUlwdMpL4=;
 b=jg1nYR9OHkZ2kOdBMdR55I/WqjRiSarGBEc0ajxGYr6L5dG6XWEWjZI1y8qVy1+65BZS8f
 Zg4tjbAJesr6caKVkdXvmb95M6Ct0C26sPpYOsrVvN5nxyHjF1cLbqPZTilpoMZ+edVmWP
 PrWtk+PfoluAxYaJEQ61oxkjyvtw1yKH+/KDrSINgy31Iy6Ojy602Uf7P68wa1LQfwbjfs
 jETIfjh5ZjoeKRAGksEFnGS9N6P4x85Lh301DP34mG0nAIYVWJBFWcBxaTKPafpKYIfKHw
 En1bV1H9sNTW/UPU6jlXCSpl697uzwURlkZkZdqV2XOTVTusBlD+8aDv9Ilq7Q==
X-Original-From: Jia Zhu <zhujia.zj@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: "Jan Kara" <jack@suse.cz>
Cc: "Jia Zhu" <zhujia.zj@bytedance.com>, "Theodore Ts'o" <tytso@mit.edu>, 
	"Andreas Dilger" <adilger.kernel@dilger.ca>, 
	"Matthew Wilcox" <willy@infradead.org>, 
	"Alexander Viro" <viro@zeniv.linux.org.uk>, 
	"Christian Brauner" <brauner@kernel.org>, 
	"Baokun Li" <libaokun@linux.alibaba.com>, 
	"Ojaswin Mujoo" <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani" <ritesh.list@gmail.com>, 
	"Zhang Yi" <yi.zhang@huawei.com>, <linux-ext4@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Date: Tue,  9 Jun 2026 11:54:05 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <slupx7cfhq4uuk5bd3xnzu7ybnnqghzrseg3xjao6x7tbj75v3@jxv32j4em2cu>
From: "Jia Zhu" <zhujia.zj@bytedance.com>
Subject: Re: [PATCH v2 2/2] ext4: avoid tail write_begin walk for uptodate folios
X-Lms-Return-Path: <lba+26a278e61+d15204+vger.kernel.org+zhujia.zj@bytedance.com>
Message-Id: <20260609035405.92959-1-zhujia.zj@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
References: <20260603134800.25155-1-zhujia.zj@bytedance.com> <20260608120131.45146-1-zhujia.zj@bytedance.com> <20260608120131.45146-3-zhujia.zj@bytedance.com> <slupx7cfhq4uuk5bd3xnzu7ybnnqghzrseg3xjao6x7tbj75v3@jxv32j4em2cu>

On Mon, Jun 08, 2026 at 04:29:59PM +0200, Jan Kara wrote:
> You simplify this condition to:
> 
>   block_start < to || (!folio_uptodate && bh != head)
> 
> With this updated feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks Jan.  I've applied this simplification in v3 and added your
Reviewed-by tag to both patches.
