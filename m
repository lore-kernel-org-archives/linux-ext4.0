Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099689;
	b=k2a6b4dAQorISyRw+rGWElL6k9xreLPXB1qB2IN636Zsp45UEfPfgsQrSgG9N5HGcfdO
	 aPzkfouDUeRLrVrkQmfKr9jP324Z1uSwn3i56NhQ89sHptxeuy5ipr80mPI4XwgqHbYL4
	 vO+6juKNDxvnSkmBNqamfpg6ivzpTfLDSymJcCBEt78hr8sEwvWIyynXOZs9KiThJZhjt
	 UJXhJAtKZp5sKUw+VUcyV4jF9AtYOJf9wjn/l8a5YNobx5MSzngO0TPJZG2EcyOFINVbT
	 78Z4sXmFCpdEhw/AducFdmNMYtLlKPGSLsBH37zJ+nIsI4JtD5NQTbAzCW5zw8ZcXpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099689;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=5+6gkTgsng8jvnirFTry6sEeQS4I2Yoabogyt7eNnEw=;
	b=cC3hC/PYsM/Zx6nbVZ3XgWdzF9vbYTg2d2SYRl7yMw5rkO2bcgYfYAyvt8LBTRTua/3s
	 d7QKiz6lSc8OodSGr8lCWMP+2DoZVDEee+ruwDMy0vMH/gd14t8W0biGtSwJ2dlAGgJpu
	 Bm/qAPtBnqFFtMhTOGvtSjwjuWI0BayYQXCvgqnsLImWdBFJMgHyPAy1ttIeNiCZRmNE2
	 F8FWtGTzCn0gD47os7p2oAWvSBs7gFt3X0MswfNbghTFk8lqL1XTy46XjdCErHrZIK1tq
	 qTgRb0jV35MtdIkNt8IRmXQia/tSY6OiDgz9RsyiuVA4WfBFwbhfqk2MDOtNQb3/nAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=WXmiUOzv;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05734606E89A
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05734606E89A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=WXmiUOzv
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElWqn017774
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099656; bh=5+6gkTgsng8jvnirFTry6sEeQS4I2Yoabogyt7eNnEw=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=WXmiUOzvCn1LV5Y5sRzDwzRJoV7MdOrVU4cUzHdfGHrY4xnkSOkqh7dtL7JBLgreB
	 Yn/uLbiUm98f9iCmWSJ8Wz1Bvh0oczEa/+aDKjK2VGKfDMXQhXcP4rzED7MLTMQf4L
	 xSRRMHD+xSekI13fwAIOBuH9+eCVN1GkYX/uit+40EWyC2DRsfCtm1eOd/+h4KBp9J
	 U05vYeher/j5A+J9QajHFGPVWDUHvflWGlyaV0dMMo0ogk33Hgs9oddtu0UVeQpJWF
	 zKjD9005M+MApQ99L7ysLtqFUujyoRXKuylPcMW+HHLyBTGtA36Do7PY6AMKqy0mxG
	 XFzvnij6ZJuPw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id B0D9F2E00BC; Thu, 19 Nov 2026 09:47:32 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        shuo chen <1289151713@qq.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
        yi.zhang@huawei.com, Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: Re: [PATCH v2] ext4:Fix WARNING in ext4_journalled_invalidate_folio
Date: Thu, 19 Nov 2026 09:46:31 -0500
Message-ID: <179509948673.1938961.5454939746083171977.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <tencent_87F5A404ED65B0B1349C60E830C485716705@qq.com>
References: <tencent_87F5A404ED65B0B1349C60E830C485716705@qq.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 15 Sep 2026 00:41:44 +0800, shuo chen wrote:
> Thanks to Jack's suggestion.
> Call the ext4_wait_for_tail_page_commit() helper before
> ext4_truncate_failed_write() from ext4_journalled_write_end(),
> which avoids invalidating the folio while it is being committed.
> 
> Closes:https://lore.kernel.org/linux-ext4/CA+0ovCgxFN3TLpdS_O_Z48sARuQ-WR-JLDCqQWEmd9ELtkzddA@mail.gmail.com/T/
> 
> [...]

Applied, thanks!

[1/1] ext4:Fix WARNING in ext4_journalled_invalidate_folio
      commit: c1fa31d8a08ce735d8abde9b2555f415de806881

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
