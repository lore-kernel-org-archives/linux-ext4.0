Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94ADD433E84;
	Sat,  4 Jul 2026 02:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783130729; cv=none; b=nz59R6vGdoLFy/sJkkPDObR6flzuK+bhkbL54DGnJ0+1Y+z5XwSbUMDhzpyaaC+KReVD2hdUFzmJpoI/jFquWO2SnFksq21QItkeLUJ9duuacgqXrSxZI/qZkbo5U5e7wd1EXc7WwRlEOKE5q4eUsdQ2dSFsQcnG68SjvjE2Mbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783130729; c=relaxed/simple;
	bh=b9Eq2HkDjvdZwP+PG/EXhTApS/R76hFjc0OXy9Mo6n8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UigA1+h90n/3UcM8xtkdatFEQvGw6v5N1c1DmebXQjtkNkOmbR8oaNhYOCuNPTCjNfYIAg1VwaOcFLqkYm8FXypjZs5MHne6kba+A0WPq8p5w+yrwUYp8ZHJep9LzgkOSC8oBXtbWW3n30SjlelF0Hlhpu+ha1Cu08BNwoSOY4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FbURZTtX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FbURZTtX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0681F000E9;
	Sat,  4 Jul 2026 02:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783130728;
	bh=Oy9QO9LmW9JkyXSyS5R5t8f98QdLOmBIOlFsvp3RayY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FbURZTtX7hZIZJVDjHL+DUL0jmpSUbzpwxuTbmzQxlSXbSqoFtwkwjvd5bkHHsIPL
	 /fqkYh2s2v5ovR/F7I9sH5GCW2ssPgyIwkNSy5YvEEVkFqDMluRDRWQ+rRafcoOu3a
	 su9xxrgUWRP0ehCTZgnESASS8+2p7Olp0Qv1XWOpMITa32SCQsGA8FwSB3PxAGpmNa
	 NQnc4Yk4edgHp3VqvmuqXgyAQBrvnBphgfSCY0rtm4QXrkqINTV99up6wCMqfHm9xE
	 DR3vb5GnvWE3cL98QX1V9St2R9Raljy7P0djPtiFJWDtUG4RjGewMChQBzSXqNxDVg
	 Zb7kTJj6+CmvQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Ts'o <tytso@mit.edu>,
	Yoann Congal <yoann.congal@smile.fr>,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [PATCH 6.6.y] ext4: get rid of ppath in get_ext_path()
Date: Fri,  3 Jul 2026 22:04:56 -0400
Message-ID: <2026070315-stable-reply-0001@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260702154810.3435236-1-yoann.congal@smile.fr>
References: <20260702154810.3435236-1-yoann.congal@smile.fr>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Jul 02, 2026 at 05:48:10PM +0200, Yoann Congal wrote:
> From: Baokun Li <libaokun1@huawei.com>
>
> [ Upstream commit 6b854d552711aa33f59eda334e6d94a00d8825bb ]
>
> The use of path and ppath is now very confusing, so to make the code more
> readable, pass path between functions uniformly, and get rid of ppath.
>
> After getting rid of ppath in get_ext_path(), its caller may pass an error
> pointer to ext4_free_ext_path(), so it needs to teach ext4_free_ext_path()
> and ext4_ext_drop_refs() to skip the error pointer. No functional changes.

Queued for 6.6.y, thanks!

-- 
Thanks,
Sasha
