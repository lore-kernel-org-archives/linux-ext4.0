From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [PATCH 2/3] jbd2: replace potentially false assertion with if block
Date: Sat, 8 Mar 2008 18:37:08 +0000
Message-ID: <e9e943910803081037w5e7a8743p449b999001b94281@mail.gmail.com>
References: <5e28cd633c71f6354a203a43000cbe5fef045589.1204844851.git.duaneg@dghda.com>
	 <48afbb3a44aa24dc1e31835c14e86c3c6c1c3b0a.1204844851.git.duaneg@dghda.com>
	 <20080307212336.GE1881@webber.adilger.int>
	 <20080308150229.GA22430@infradead.org>
	 <e9e943910803080840u251ade36j92612f6150de6cf9@mail.gmail.com>
	 <20080308164258.GA30512@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Andreas Dilger" <adilger@sun.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, "Theodore Tso" <tytso@mit.edu>,
	sct@redhat.com, akpm@linux-foundation.org
To: "Christoph Hellwig" <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:15691 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbYCHShL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Mar 2008 13:37:11 -0500
Received: by wf-out-1314.google.com with SMTP id 28so1062794wff.4
        for <linux-ext4@vger.kernel.org>; Sat, 08 Mar 2008 10:37:08 -0800 (PST)
In-Reply-To: <20080308164258.GA30512@infradead.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/03/2008, Christoph Hellwig <hch@infradead.org> wrote:
>
> That text above was in reply to Andreas comment about checking it in
>  journal_load.  Your fix obviously does make sense althrough doing it
>  differently as in my reply to your first series would be even better.

Sorry if I'm missing something here, but I think the caches do need to
be checked. If jbd/ext3 are not modular then even if initialisation
fails the journal code may still be called later. I noticed this when
testing the failure modes after making my original fix.

I have some patches ready to go to address this, which I'll send after
this. It turns out journal_load is actually too late to check, though:
journal_init_common is called prior to that and will also blow up if
the caches are uninitialised. I've taken Andreas' suggestion and
attempted to initialise the caches again at that point before failing.

I've modified my changes to match the way you suggested doing things
in your earlier reply (and thanks for the review, BTW). If you would
prefer I'll rework my changes as a separate patch on top. Just let me
know.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
