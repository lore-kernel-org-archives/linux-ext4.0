From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: ext4_fallocate
Date: Wed, 4 Jul 2012 11:48:33 +0800
Message-ID: <20120704034833.GA17268@gmail.com>
References: <4FEA1415.8040809@redhat.com>
 <4FEA1F18.6010206@redhat.com>
 <20120627193034.GA3198@thunk.org>
 <4FEB9115.6090309@redhat.com>
 <20120702031611.GB2406@gmail.com>
 <4FF1CD5D.8010904@redhat.com>
 <20120702174421.GM6679@quack.suse.cz>
 <4FF39924.7070602@ubuntu.com>
 <20120704023634.GB16947@gmail.com>
 <4FF3B352.3040707@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>, Fredrick <fjohnber@zoho.com>,
	Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@dilger.ca>, wenqing.lz@taobao.com
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34975 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab2GDDkX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jul 2012 23:40:23 -0400
Received: by pbbrp8 with SMTP id rp8so10328073pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 03 Jul 2012 20:40:23 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4FF3B352.3040707@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 03, 2012 at 11:06:58PM -0400, Phillip Susi wrote:
> Ohh, I see now... you want lots of small, random, synchronous writes.  Then I think the only way to avoid the metadata overhead is with the unsafe stale data patch.  More importantly, this workload is going to have terrible performance no matter what the fs does, because even with all of the blocks initialized, you're still doing lots of seeking and not allowing the IO elevator to help.  Maybe the application can be redesigned so that it does not generate such pathological IO?

Yes, I agree with you that the application should be re-designed but we
cannot control it.  So we have to use this big hammer. :-(

> 
> Or is this another case of userspace really needing access to barriers rather than using the big hammer of fsync?

Maybe Google meets the same problem.

> 
> Is there any technical reason why a barrier flag can't be added to the aio interface?

Sorry, I am not very familiar with it.

Regards,
Zheng
