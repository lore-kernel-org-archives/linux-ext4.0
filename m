From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [PATCH] ext3: handle corrupted orphan list at mount
Date: Tue, 24 Jun 2008 01:09:19 +0100
Message-ID: <e9e943910806231709jec5056ta7494858b420b6a9@mail.gmail.com>
References: <20080607121940.8ee6044a.akpm@linux-foundation.org>
	 <1214258200-16623-1-git-send-email-duaneg@dghda.com>
	 <20080623223238.GA8802@vipunen.hut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com
To: "Sami Liedes" <sliedes@cc.hut.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:52740 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbYFXAJT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jun 2008 20:09:19 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2229354wfd.4
        for <linux-ext4@vger.kernel.org>; Mon, 23 Jun 2008 17:09:19 -0700 (PDT)
In-Reply-To: <20080623223238.GA8802@vipunen.hut.fi>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2008/6/23 Sami Liedes <sliedes@cc.hut.fi>:
> You people working hard to fix bugs and implement great filesystems
> almost makes me feel bad for trying to break your code :)

Not at all, it gives me something productive to do with my time! ;)

> Here I get (on x86 gcc 4.3.1):
>
> fs/ext3/ialloc.c: In function 'ext3_orphan_get':
> fs/ext3/ialloc.c:701: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'unsigned int'
>
> So it probably should be %u or something.

Thanks, fixed for the next version.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
