Return-Path: <SRS0=Vv4O=SE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A579FC4360F
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 10:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78DC22082C
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 10:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbfDBKQP (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 2 Apr 2019 06:16:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:60552 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726436AbfDBKQO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 2 Apr 2019 06:16:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A291FAC4A;
        Tue,  2 Apr 2019 10:16:13 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 7179D1E42C7; Tue,  2 Apr 2019 12:16:13 +0200 (CEST)
Date:   Tue, 2 Apr 2019 12:16:13 +0200
From:   Jan Kara <jack@suse.cz>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [Bug 203107] New: Bad page map in process during boot
Message-ID: <20190402101613.GF12133@quack2.suse.cz>
References: <bug-203107-13602@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-203107-13602@https.bugzilla.kernel.org/>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Switching to email...

On Fri 29-03-19 20:46:22, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=203107
> 
>             Bug ID: 203107
>            Summary: Bad page map in process during boot
>            Product: File System
>            Version: 2.5
>     Kernel Version: 5.0.5
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: ext4
>           Assignee: fs_ext4@kernel-bugs.osdl.org
>           Reporter: echto1@gmail.com
>         Regression: No
> 
> Error occurs randomly at boot after upgrading kernel from 5.0.0 to 5.0.4.
> 
> https://justpaste.it/387uf

I don't think this is an ext4 error. Sure this is an error in file mapping
of libblkid.so.1.1.0 (which is handled by ext4) but the filesystem has very
little to say wrt how or which PTEs are installed. And the problem is that
invalid PTE (dead000000000100) is present in page tables. So this looks
more like a problem in MM itself. Adding MM guys to CC.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
