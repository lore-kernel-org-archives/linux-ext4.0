Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EB8309EEC;
	Mon, 10 Aug 2026 13:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786368968; cv=none; b=bplN+ODQlNmg5843CM63LTpXR+8onfpqkDLq61U06QahHbzH3MmxmNiixFzCrHamX2tDfqsHtZPYNXO743UJbt3zrXCFWX02s8pu3qNk0vO1VwDq3gA7z4DPz3vcnopHdz9LzGF89DjGP0QGT0IjQvYxQSWWOG8nQfC9/GhIfbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786368968; c=relaxed/simple;
	bh=2ZpX8gZKvffWKSbKGBRSuLalWYU2V/ggtcoN9f/aRvQ=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=LgGoHN3Qn/SdPnGz/TD1u6psEs2Q/tLKULi907MLaHCCW726s55izud9Y610XBV0uSIXH80HMse83ZtABtMADBFPdwLamSDmWAIiG9EE3EPh6PuiGLHVJFrPOQ9umfksjLdZgho/TnJ+er3aHQcPhLtQt0CORSsAFrOMwK3ajMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DkdwxEYC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DkdwxEYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDD31F000E9;
	Mon, 10 Aug 2026 13:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786368966;
	bh=eOb2Z1hphz1RYa4gK968nW0ZC5n/6YaEBN0orjNm9nk=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=DkdwxEYCTtCrBIQBGsViLcBazHEaTfAt9GzdkvVSbsOIgC0f5Wcg8u7oL+FJi7eFW
	 IDFGBgK0T0/vkYUs1gbA6mzMAKKbnXJMMlJhaUiXg9FMlN3JPlSpBMNDj5Ilotmxsx
	 pZ2uSJ6hlUSUP1WpP7wRobl2ZGiwR6t4Hrg6fUC2J2xowFUtZcCOoKZFvlDQa0wpQ/
	 7WsjMiUHHZd5lhTvGsQCVTJYG8pyg1uEqSoxC2Givg39SPs1DvLJSbcvDYne13D9rI
	 6ts/oPaywVu8tfbmh5lRLyN2oxHNoIcJbZuojpiBqEboW7aCz/FUbS0It1mvcTQVsw
	 0AXHVeVTzcbXg==
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
To: Theodore Tso <tytso@mit.edu>
Cc: "Zhou, Yun" <yun.zhou@windriver.com>, Jan Kara <jack@suse.cz>, 
 Mateusz Guzik <mjguzik@gmail.com>, adilger.kernel@dilger.ca, 
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
 yi.zhang@huawei.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, xiaowu.417@qq.com
In-Reply-To: <akbouO1usgN6burE@mit.edu>
References: <20260629110848.3085662-1-yun.zhou@windriver.com>
 <20260629110848.3085662-2-yun.zhou@windriver.com>
 <4k4crl4oobz4xtmvjoqwoefrd6in46xf725z3ewme3smgh5ide@6dmywcnp6o6y>
 <txvgbvn77wjgfz4ywdb25v7ol4ecszqh5yg3p4g56sbxq6prlo@rpfwveotnfvz>
 <6c4e9256-5727-44b2-b63c-e18fe1b95194@windriver.com>
 <mqchxi74vrsmsitr46gtnw5w7tooj7go2tm2jadg4mktppjafc@5uplsind6ooq>
 <12a0d660-2794-4dc0-910a-3c63155624ba@windriver.com>
 <akbouO1usgN6burE@mit.edu>
Date: Mon, 10 Aug 2026 15:36:01 +0200
Message-Id: <20260810-regress-blocken-bisweilen-82c67408dd20@brauner>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=689; i=brauner@kernel.org;
 h=from:subject:message-id; bh=2ZpX8gZKvffWKSbKGBRSuLalWYU2V/ggtcoN9f/aRvQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRVXj7sNL3q9a1Wi7YPa3SVn3gtnZFq3tcbePiY+mOXu
 6E28QsVO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACaS/43hf8327RLcKas/7Z/f
 c6HFXGf/ou6GN54lVyW/vMypnlswIZjhn/rE63k77m3WYDFR27edZ1az56LZwgcYJCawvNRtMrz
 /mwsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On 2026-07-02 18:41 -0400, Theodore Tso wrote:
> On Thu, Jul 02, 2026 at 10:55:31PM -0500, Zhou, Yun wrote:
> > > I think there will be no more feedback to this series. So just
> > > include this suggested change (keeping current Reviewed-by tags -
> > > the change is minimal) and submit one more version. Mention in the
> > > cover letter that there's only minor adjustment to this one patch,
> > > everything is reviewed and ready to be merged so that Ted knows.
> 
> No worries, I've been paying attention.  :-)
> 
> Christian, I assume you have no objectoins to my taking this first
> patch through the ext4 tree, since you've reviewed it.

Yep, totally fine with that!

