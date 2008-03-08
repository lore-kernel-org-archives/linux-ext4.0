From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [PATCH 2/3] jbd2: replace potentially false assertion with if block
Date: Sat, 8 Mar 2008 16:40:46 +0000
Message-ID: <e9e943910803080840u251ade36j92612f6150de6cf9@mail.gmail.com>
References: <5e28cd633c71f6354a203a43000cbe5fef045589.1204844851.git.duaneg@dghda.com>
	 <48afbb3a44aa24dc1e31835c14e86c3c6c1c3b0a.1204844851.git.duaneg@dghda.com>
	 <20080307212336.GE1881@webber.adilger.int>
	 <20080308150229.GA22430@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Andreas Dilger" <adilger@sun.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, "Theodore Tso" <tytso@mit.edu>,
	sct@redhat.com, akpm@linux-foundation.org
To: "Christoph Hellwig" <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:16747 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbYCHQkt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Mar 2008 11:40:49 -0500
Received: by wf-out-1314.google.com with SMTP id 28so1019930wff.4
        for <linux-ext4@vger.kernel.org>; Sat, 08 Mar 2008 08:40:46 -0800 (PST)
In-Reply-To: <20080308150229.GA22430@infradead.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/03/2008, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Mar 07, 2008 at 02:23:36PM -0700, Andreas Dilger wrote:
>
> > It would probably be prudent to verify that these caches are initialized
>  > at journal_load() time and either re-try to create the cache, and/or report
>  > an error in that case and refuse to continue mounting.
>
> That doesn't make any sense.  They're initialized in module_init and
>  destoryed in module_exit.  They can never be zero at journal_load time
>  unless you get random memory corruption overwriting exactly that pointer
>  with zero.

If jbd is a module, sure, but not if it is statically linked in. I
have the stacktraces to prove it :)

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
