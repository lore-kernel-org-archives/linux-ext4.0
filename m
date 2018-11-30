Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:60440 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbeLAF6r (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2018 00:58:47 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v3 08/12] ext2fs: nls: Support UTF-8 11.0 with NFKD normalization
References: <20181126221949.12172-1-krisman@collabora.com>
        <20181126221949.12172-9-krisman@collabora.com>
        <20181130165317.GC3512@thunk.org>
Date: Fri, 30 Nov 2018 13:48:31 -0500
In-Reply-To: <20181130165317.GC3512@thunk.org> (Theodore Y. Ts'o's message of
        "Fri, 30 Nov 2018 11:53:17 -0500")
Message-ID: <87h8fy1jwg.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Theodore Y. Ts'o" <tytso@mit.edu> writes:

> One more thought.  Is there any test cases we can add here?  I assume
> the SGI folks must have had some test code that they used when they
> were developing their trie code.  Was any of that released?
>
> Maybe there is some Unicode normalization and case folding test
> vectors we can grab?

Since these file are generated and imported from the kernel code, I added
the tests there instead.  Should I duplicate or move them to here?


-- 
Gabriel Krisman Bertazi
