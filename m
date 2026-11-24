Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795531860;
	b=sgKxkew8Hv0hhUXZmUbu8KQ0rxdJkR2x17LXFsD9+BglDpU6OZ+oUbAgFL/pmOt4rfV/
	 w/HG9SBBheB8Cg8enBPuMQ1KQvFF7Qi1xXNvQ5vPHJnQg/eSx6waWL1UrqkQAB75wDP0w
	 F1iU9DUy2UsLIvttAgYagq4SeEYIIf+yU6K5hLC4lMOe0grfNsIaDPJI4DiYMXo/JZeZQ
	 2rAyARDsDhx50+Z1y7yURjgUn1AV2aTIKQXmnyFfYsuhxsHwAXl2u4KFvY/aUE7OsKpXa
	 5SbLsT8/9dPmi5ndOUS8Zymbo/L0N8ywtl3HXnnX/9DeJJGYWGqq80AycYP6gPkHgIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795531860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=q1mVTpKtsYq34wJU58aoHOKVTZCenVaAYtou9aH3SZ8=;
	b=3ZUc9MnOFWq+eE1mnX/GmQvuoQokFL7MiWV0gzF2y8ojLce0uz1G0hWTLjnMwmZfv8ym
	 NOAxZHXzqQI7Bt5D2DG/SOCU0S20EXeSJJ9RZKnYfjG9QTDjO+yK7jtdtlbqNqAUD3vP/
	 4sXiKrvBLFOqXjOz80cWyouI+pAFjpa1w8fRkRMO9Izx1vntDXdlbTF7MRrwZQRY2UAup
	 msJrCQI2NZf7XiqA+MR9NAVlp299lIDnHLZe9IufSuiVTdYQznY+KPFHs2TKZKNAk2X6I
	 uy5ypudvhfcbRq511OXSulqCEQPW96IN+OVZRUVko0F1cvig71ItqCYO3+a31mS0z6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m40usXzM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D60D606A31E;
	Tue, 24 Nov 2026 14:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m40usXzM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C061F000C0;
	Tue, 24 Nov 2026 14:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795531860;
	bh=q1mVTpKtsYq34wJU58aoHOKVTZCenVaAYtou9aH3SZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m40usXzMEQLIEN51v7Np61Zy7OP+IfMF9cP+UnqoagvBeUhHfmK0v++EIFMtC+hfT
	 2MXY0OFhNtJMGSwZN8iTq7K0CZq0fupDtlIuiX9+j1rzcDBbNU4v9e9x1QnWBW/zFS
	 M1vZw4Sm/IzXgtEQpoTw6ICHD+FXWvR7sFk4FN7k6NCbMGw+Wa5lxeoSl1MKVOJ7ct
	 SEO8TAp92PDtz5ohLMRg90TSYcvZgUsvf3FRzy79RhmoZB0qekhHShQ3zjJRycIaD6
	 cm41x0dcASDXHl1BGVjueNVkYNJ85wkrpkW9YcuHkOgnTMHwyWIclwkXFxx2tQFYBk
	 29+28aVGjcWWQ==
From: Sasha Levin <sashal@kernel.org>
To: "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>,
	Edward Adam Davis <eadavis@qq.com>,
	"cve@kernel.org" <cve@kernel.org>,
	=?UTF-8?q?Fusong=20Li=20=E6=9D=8E=E7=A6=8F=E6=9D=BE?= <fusongli@ieiworld.com.cn>
Subject: Re: 6.1.y: missing "ext4: avoid infinite loops caused by residual data" (CVE-2026-31448)
Date: Tue, 24 Nov 2026 09:50:53 -0500
Message-ID: <2026-11-24-1-daily-reply-0002@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <JH0PR04MB74644C65BBF68069425C8B8392442@JH0PR04MB7464.apcprd04.prod.outlook.com>
References: <JH0PR04MB74644C65BBF68069425C8B8392442@JH0PR04MB7464.apcprd04.prod.outlook.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> - c66545e83a80 added it to 6.1.y, and 9594622f8a39 reverted it in the
>   same release (6.1.168), together with the "get rid of ppath" series
>   that it was written against.

Right. It went out with the revert of the ppath series, not because of a
problem with the fix itself.

> Could this be backported to 6.1.y? A patch adapted to the 6.1 API can
> follow if that helps.

Queued for 6.1, and for 5.15 and 5.10, using Bin Lan's backport [1],
which makes exactly that condition change on the old API. No need to
send yours, thanks.

[1] https://lore.kernel.org/all/20260506073835.32481-1-lanbincn@139.com/

-- 
Thanks,
Sasha
