From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: ext4_fallocate
Date: Wed, 4 Jul 2012 10:36:34 +0800
Message-ID: <20120704023634.GB16947@gmail.com>
References: <4FE9F9F4.7010804@zoho.com>
 <4FEA0DD1.8080403@gmail.com>
 <4FEA1415.8040809@redhat.com>
 <4FEA1F18.6010206@redhat.com>
 <20120627193034.GA3198@thunk.org>
 <4FEB9115.6090309@redhat.com>
 <20120702031611.GB2406@gmail.com>
 <4FF1CD5D.8010904@redhat.com>
 <20120702174421.GM6679@quack.suse.cz>
 <4FF39924.7070602@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>, Fredrick <fjohnber@zoho.com>,
	Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@dilger.ca>, wenqing.lz@taobao.com
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57272 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745Ab2GDC2T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jul 2012 22:28:19 -0400
Received: by pbbrp8 with SMTP id rp8so10235570pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 03 Jul 2012 19:28:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4FF39924.7070602@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Phillip,

On Tue, Jul 03, 2012 at 09:15:16PM -0400, Phillip Susi wrote:
> On 07/02/2012 01:44 PM, Jan Kara wrote:
> >   Yes, that option is broken and basically unfixable for data=ordered mode
> > (see http://comments.gmane.org/gmane.comp.file-systems.ext4/30727). For
> > data=writeback it works fine AFAICT.
> 
> Does data=writeback with barriers fix this fallocate problem?

If we only use data=writeback without 'journal_async_commit', it won't
fix this problem according to my test. :-(

> 
> I can see that writing small random bits into a very large uninitialized file would cause a lot of updates to the extent tree, but with a sufficiently large cache, shouldn't many of the small, random writes become coalesced into fewer, larger extent updates that are done at delayed flush time?  Are you sure that the extent tree updates are not being done right away and blocking the writing application, instead of being delayed?

Actually the workload needs to flush the data after writting a small
random bits.  This workload is met in our product system at Taobao.
Thus, the application has to wait this write to be done.  Certainly if
we don't flush the data, the problem won't happen but there is a risk
that we could loss our data.

Regards,
Zheng
