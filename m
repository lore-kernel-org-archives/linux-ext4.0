Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49985505D4
	for <linux-ext4@vger.kernel.org>; Wed,  9 Sep 2026 12:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788955990; cv=none; b=bG+GALESXI4bWDcoCYwqRbdDjgY3EOTAfaFSqfbFlRJfjx9GyKcn4eox1m2jTHVfaEHyC407L4koFF9oGqbtxca4J/iILQ2bgSbuzXc+aSI0nwHhPeQ+r69OhVo7l7BSD3qP5HIev4vMaFfKVriyq2g44kuiHwgQ/ORRLwWmqvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788955990; c=relaxed/simple;
	bh=YgpBxgo5YofLBw4A7X3QhxHUmNkjqC1fwunjTx+7hIY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=idpe7zYmk4nlhBnr3qiO1cQ0t/Mrg8bd0TqQT6Bcz9G532LKdhmDuUkT5OXyU4mrYPAxu2ff/O+NG9IOVy/qY25MfhM+KBRCQAr0N76uO89zWFgTGDVGxoonje1C5TvGe8goP1NByPh6rx/n/i1igAvlQsO8jbtB5AQySQTRVkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6be260da3fdso651590eaf.1
        for <linux-ext4@vger.kernel.org>; Wed, 09 Sep 2026 05:13:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788955982; x=1789560782;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=UvYP6Qzj931TtA4FMiDKHWlI/21Br1rJ1AJggB3Ijk0=;
        b=ZtTwSyZWtqU+mmUdTlClaoWt2qsd9bFinFJwvDji/mNWFYhj4Bv7PKXFua6E1WH+Jn
         xRWNNvx/DIo3u97OdZ5MhwkjG9icIloT7fw5jDN/prIIcXgvNoT7NUe8oivDVoZ134hK
         wd9klU/mqCrm/Jtt6xB22q+3P66tIEV7m72pNuffZx0YhNSkpVZbhHmx7mGQRwCdnMrs
         v6UtZ0kL5PngcK5HJ19cse8bNj9l9Mxg9uWdqoZkWsILTdZB9eJ3EYqHKbqpBc5hJ1Gz
         VmiBxouRkUGrpQQHKaDVI91fyDo6K3dtRiWbcgXBip/ksDtT21SoAwj8S7CpMxGL9Mgf
         Eu9Q==
X-Forwarded-Encrypted: i=1; AKwUvByX5Z9Qj58K5V7vHLmqzmuqLPIR+e1pJOBvp9kphlf07rtWqVWR38ioo4TVRkKi3mShX7pxvukAsUT7@vger.kernel.org
X-Gm-Message-State: AFuF++mBOcd4S8EhEGTeJeblCz/II3zKXk6p9D7bsStEkuq291moq2Hz
	DSdOsoCJLDXu6ePSK9vVyHkoqMS07aM1F6jqL5RBFW2i/uYzStk+OL3KR2Tm6FtL6V7W6iEGCnc
	JdOKM9laaCe0w+SRTeXWybe7/pPiK3eQQHsBc7w8JCG0OFxyAlDV/XKI8Wo0=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:3106:b0:6b1:39b1:80ee with SMTP id
 006d021491bc7-6bee53998d1mr631749eaf.24.1788955982411; Wed, 09 Sep 2026
 05:13:02 -0700 (PDT)
Date: Wed, 09 Sep 2026 05:13:02 -0700
In-Reply-To: <05177a9e-111c-4595-a7ef-d3de398f0a85@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa14d4e.f2639fcc.29487d.0003.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] [ext4?] INFO: task hung in io_write
From: syzbot <syzbot+2eb3d983669d3e49d4fa@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+2eb3d983669d3e49d4fa@syzkaller.appspotmail.com
Tested-by: syzbot+2eb3d983669d3e49d4fa@syzkaller.appspotmail.com

Tested on:

commit:         57ab5080 io_uring/io-wq: don't trigger hung task for s..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git syztest
console output: https://syzkaller.appspot.com/x/log.txt?x=127b7af9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=679ea3cb74b430f3
dashboard link: https://syzkaller.appspot.com/bug?extid=2eb3d983669d3e49d4fa
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
