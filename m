Return-Path: <SRS0=dM+b=ZG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F9BDC432C3
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Nov 2019 22:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 013DB2070E
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Nov 2019 22:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfKNW7w (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Nov 2019 17:59:52 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:42895 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726319AbfKNW7w (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Nov 2019 17:59:52 -0500
Received: from callcc.thunk.org (guestnat-104-133-0-98.corp.google.com [104.133.0.98] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xAEMxfSo032538
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Nov 2019 17:59:42 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 096DD4202FD; Thu, 14 Nov 2019 17:59:41 -0500 (EST)
Date:   Thu, 14 Nov 2019 17:59:40 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     Olof Johansson <olof@lixom.net>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fs: ext4: remove unused variable warning in
 parse_options()
Message-ID: <20191114225940.GE4579@mit.edu>
References: <20191111022523.34256-1-olof@lixom.net>
 <20191112162341.E3F334204C@d06av24.portsmouth.uk.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112162341.E3F334204C@d06av24.portsmouth.uk.ibm.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Nov 12, 2019 at 09:53:39PM +0530, Ritesh Harjani wrote:
> 
> 
> On 11/11/19 7:55 AM, Olof Johansson wrote:
> > Commit c33fbe8f673c5 ("ext4: Enable blocksize < pagesize for
> > dioread_nolock") removed the only user of 'sbi' outside of the ifdef,
> > so it caused a new warning:
> > 
> > fs/ext4/super.c:2068:23: warning: unused variable 'sbi' [-Wunused-variable]
> > 
> > Fixes: c33fbe8f673c5 ("ext4: Enable blocksize < pagesize for dioread_nolock")
> > Signed-off-by: Olof Johansson <olof@lixom.net>
> 
> hmm, I see that I had CONFIG_QUOTA enabled, so missed this.
> Thanks for the patch.
> 
> You may add:
> Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>

Thanks, applied.

					- Ted
