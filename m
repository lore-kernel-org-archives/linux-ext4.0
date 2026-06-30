Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8402248B3;
	Tue, 30 Jun 2026 08:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782809623; cv=none; b=TV6lSSv6Rx6pE6Jn/W379J+2i2aTsJGK2diqJTxNawQyyNzaEL6m6h10goqCJSX7InIyQPmoy2T0Irb2U2JT78UypRI5Jpg9xAGSPQBgP2kAgsljZg6z7VzzjPMA2seFGqyAW/RPTuV2VNbaBGrV0BtJ6rUaS24kMujRj1awGsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782809623; c=relaxed/simple;
	bh=xdvB/uZeDlUkXK0FvmSZeUy8J9qqYKleq2SeKkwzWnY=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=NaTSdqfX8/csT87mA8gvmYt5e0lVa7z9Vz8sybjKjVmDY1lCAnOFO93XSbWX63JRS9JOhiHQMELCYcCRjgEEkIzni5VriXOu89ACel4Z3CULzauOJvZzrDBiW2eyy7AfiEn9IkT85famcqS6H0UbvdXkzwNLQjqhlSb6mddZmxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CJkAl+5i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CJkAl+5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F422B1F000E9;
	Tue, 30 Jun 2026 08:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782809622;
	bh=pfVt3yiAmveZeL++Vp3nsYenrRFasGqkEH+5Gi9PJCM=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=CJkAl+5iNfcZ1awU6nu6T9uAMdLR/S6qWg4hADg6VQ+OhTnIwMEZDsT7tU2bzYbTB
	 4oDsTqZDtph3GoqDA5kyoGyZblZZQnaWKWN1+E/TItvLujoM77B3V3+4S+0bHmOFhH
	 IH4ZaPlGXvT9HnzUbTVc029tKJJB9FeuyZxNd+46itgpWe95prQmNZVM2AxyS4qap0
	 tBDlXzLGdd48E2RBjsDlSYpjhfJY0dCnbrljleoXyvX6JmglwIDsKiGoXl4iHoraFV
	 UG/9fC2IpBehJ65PaEtUzPS6bqIc5OD89SCanhbzNj89V85HLhRFN2UEn9XdK/GWer
	 s7e0LA/OUWkAg==
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v11 1/5] fs: add iput_if_not_last() helper
From: Christian Brauner <brauner@kernel.org>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
 jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
 yi.zhang@huawei.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, xiaowu.417@qq.com
In-Reply-To: <20260629110848.3085662-2-yun.zhou@windriver.com>
References: <20260629110848.3085662-1-yun.zhou@windriver.com>
 <20260629110848.3085662-2-yun.zhou@windriver.com>
Date: Tue, 30 Jun 2026 10:53:35 +0200
Message-Id: <20260630-wellblech-waldgebiet-rederei-19d45625f8b7@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=818; i=brauner@kernel.org;
 h=from:subject:message-id; bh=xdvB/uZeDlUkXK0FvmSZeUy8J9qqYKleq2SeKkwzWnY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ5twi1X7KyTsuPvcEnce/l/slb/nj8eGl1WDz2yYImE
 f3j+4NzO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACayPJ2RYQX3/4Px3VsXf845
 PTeW02GPqbTKtEip1dwf1j++whg2ezYjwwe+R4d3l5/5ajdtWTprIOexw8tX+n/ezpEZV3TNuj3
 9MT8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

> Add a helper that drops an inode reference only if the caller does not
> hold the last one.  Returns true if the reference was dropped, false
> otherwise.
> 
> This is useful for filesystems that need to release inode references
> in contexts where triggering final iput (and thus eviction) would be
> unsafe due to lock ordering constraints.  The caller can check the
> return value and defer the final iput to a safe context.
> 
> Unlike iput_not_last() which BUG_ON's if called with the last ref,
> this variant is designed to be called speculatively.
> 
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> Suggested-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Jan Kara <jack@suse.cz>

Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>

-- 
Christian Brauner <brauner@kernel.org>
