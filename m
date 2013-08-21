From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: Which features should I implement in my ext4 reader?
Date: Wed, 21 Aug 2013 14:16:03 +0200
Message-ID: <CACyNnZP6m96Uv_acbVvf3K2UvcMhhqk2S2gmdZS9DG9GwqbUcg@mail.gmail.com>
References: <CACyNnZNJssSL+UWOXYmWk9xy07WRT_z+Fk9Kjwfws9JRfWoNEQ@mail.gmail.com>
	<CACyNnZManY_k3SB1-p4mQ8Z1+9B=VAdfXU7bWsFVHDsHV6KyUQ@mail.gmail.com>
	<20130817130204.GA30769@thunk.org>
	<CACyNnZONOUy0+OeDriZaSt4OQrR6LzpyJz4Sj8XvMHvxr2u_Xg@mail.gmail.com>
	<20130819050803.GA10882@gmail.com>
	<CACyNnZN4z_mHq86+FPOaGpzjwBVmmsKNjnd45s53o2LdQjxEsg@mail.gmail.com>
	<20130820103956.GA7846@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:39912 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab3HUMQF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Aug 2013 08:16:05 -0400
Received: by mail-pd0-f178.google.com with SMTP id w10so379232pde.9
        for <linux-ext4@vger.kernel.org>; Wed, 21 Aug 2013 05:16:04 -0700 (PDT)
In-Reply-To: <20130820103956.GA7846@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Ok, thanks a lot. I cloned the git repo, built everything, created my
partition, and started studying inline_data =)

So, the wiki says that files up to 60 bytes are stucked into i_block
and that goes OK was easy to implement

But I am having problems with " If the rest of the file would fit
inside the extended attribute space, then it might be found as the
extended attribute "system.data". This of course constrains the amount
of extended attributes one can attach to an inode."

I have some questions about this =)

1> Up to how many bytes exactly will the extended attribute be used?

2> Are the extended attribute space always used up to this limit of bytes?

3> There is no per-inode setting of the inlining, right? For example,
for extents I check for ext4_inode.i_flags if there is EXT4_EXTENTS_FL
inside it. I couldn't find an equivalent EXT4_*_FL for inlining or
does it exist?

4> Do all inodes contain extended attributes? If one didn't previously
contain any the disk saving would not happen I guess.

thanks a lot,
-- 
Felipe Monteiro de Carvalho
