Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9F7111
	for <linux-ext4@vger.kernel.org>; Wed, 29 Nov 2023 00:51:18 -0800 (PST)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2855e4715e4so9629804a91.0
        for <linux-ext4@vger.kernel.org>; Wed, 29 Nov 2023 00:51:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701247878; x=1701852678;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DC68Fan9U1mDvvm9HS7/KL5cq/tCfXtYDl7pvERFoFo=;
        b=T8KkhzbLwre4rEKvvdu6+jJbxsAn75Bg3MZuoBBPrJs5+IMAdnDmQHvGdxPJQKO75a
         s0SVmEPUc01AEFcyYuseCQWmTq1SHI+zWozIz2rEcsChcfsXQmjTt/6lZeGtnHWLeyAv
         2FtzLp4WWcON8ggfJS9sDZE2PXxRcxTnBrmSWZU7AJIK7PAzq9eRFtCLDutde1UFrx6j
         CbuTLv76MN9+D4T65mckCENSJvEOYZf1Qox/fcLGU5YQCh7NV1ecS5FBsO/7kotwD9eg
         Y5ePZcLdPTI25YZEIvSIzz+s3Y3W8OT6WwSH8yyNKjh+DcAwfags3UYUzMVq/jvKlQ20
         7bVQ==
X-Gm-Message-State: AOJu0Yydstn1Nanin1ek1nQy+knHzROLZzSo+XuvKzLZgBby8DmdFIIP
	Ves2JqKDyz7IbshzqV3mTbhPIsMY4cjX6JQzOhH2uv6Ah3qe
X-Google-Smtp-Source: AGHT+IF1MYdBNjdusmKFxsuZ/Nr/VSjghO6WRZ54GK864hsFL2YuTIprEZmQCeIMEbRyAlQzutP5Q08V4iUeTRqpO76M2EbgqcvB
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a17:902:f68e:b0:1ce:5c2d:47e with SMTP id
 l14-20020a170902f68e00b001ce5c2d047emr4297801plg.5.1701247878586; Wed, 29 Nov
 2023 00:51:18 -0800 (PST)
Date: Wed, 29 Nov 2023 00:51:18 -0800
In-Reply-To: <000000000000dfd6a105f71001d7@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007a6a45060b46a377@google.com>
Subject: Re: [syzbot] kernel BUG in ext4_write_inline_data
From: syzbot <syzbot+f4582777a19ec422b517@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nogikh@google.com, syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

This bug is marked as fixed by commit:
ext4: fix race condition between buffer write and page_mkwrite

But I can't find it in the tested trees[1] for more than 90 days.
Is it a correct commit? Please update it by replying:

#syz fix: exact-commit-title

Until then the bug is still considered open and new crashes with
the same signature are ignored.

Kernel: Linux
Dashboard link: https://syzkaller.appspot.com/bug?extid=f4582777a19ec422b517

---
[1] I expect the commit to be present in:

1. for-kernelci branch of
git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git

2. master branch of
git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

3. master branch of
git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

4. main branch of
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git

The full list of 9 trees can be found at
https://syzkaller.appspot.com/upstream/repos
