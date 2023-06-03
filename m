Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F69EC7EE32
	for <linux-ext4@archiver.kernel.org>; Sat,  3 Jun 2023 04:31:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbjFCEbF (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 3 Jun 2023 00:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbjFCEbE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Jun 2023 00:31:04 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF58135
        for <linux-ext4@vger.kernel.org>; Fri,  2 Jun 2023 21:31:00 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-119-27.bstnma.fios.verizon.net [173.48.119.27])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 3534UTOG025754
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 3 Jun 2023 00:30:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1685766632; bh=9g29hcQMYlOi1UnsGeiipDa7HpF1GkhixP7H7lVhEYE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=F5jEaF8XoP0TKPSjy64K3XslrdbRXk7oeT4qyGfIHw4qpdFSWUNJH4Nr5kaEZCozK
         BgOuEa0hKtkMhUcV3dLiMqjoyiM04B93gpzLGJZjGVn2RvtiG/r367KvKLZ+57xhzn
         m33aReiHJaNGK3KF/+wIIcNLobqX76CxB2l4si0gsDFxzmZxfAUX56DlODeraWsFmY
         5VTaIQdgu4sHeVOfvtkrvzqABKUMxc8VdkhpzGZS2turdn0cy4r/zFZMWFB2suMc1U
         DaL/H6BFqCuupqMvJ8daTXWy4kmikTsXpaGehx1ZpE3BM2BJYnA8KjRx9bDWqwxd05
         3+aBgOB2IzjxQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 6EE0115C02EE; Sat,  3 Jun 2023 00:30:28 -0400 (EDT)
Date:   Sat, 3 Jun 2023 00:30:28 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Baokun Li <libaokun1@huawei.com>
Cc:     syzbot <syzbot+list5ea887c46d22b2acf805@syzkaller.appspotmail.com>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yangerkun <yangerkun@huawei.com>
Subject: Re: [syzbot] Monthly ext4 report (May 2023)
Message-ID: <20230603043028.GE1128875@mit.edu>
References: <000000000000834af205fce87c00@google.com>
 <df5e7e7d-875c-8e5d-1423-82ec58299b1b@huawei.com>
 <20230602210639.GA1154817@mit.edu>
 <d9be3fbf-023c-ac55-5097-ea3f43a946b4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9be3fbf-023c-ac55-5097-ea3f43a946b4@huawei.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Jun 03, 2023 at 10:05:44AM +0800, Baokun Li wrote:
> 
> There are many sources of syzkaller issues, and the patches I send out
> to fix syzkaller issues add Reported-by to all but the ones that fix issues
> reported by our internal syzbot.
> However, there may be multiple syzbot reports for the same issue.

Yes, that happens a lot especially for Lockdep reports; depending on
how the reproducer triggers the locks in which order, there can often
be multiple different lockdep signatures, and Syzkaller can't tell
that they are all the same thing.

I tend to focus on syzbot reproducers on the upstream Linux instance,
rather than the Android-5.15 syzkaller instance.  And that allows me
to use the ext4 subsystem dashboard available at:

	https://syzkaller.appspot.com/upstream/s/ext4

It's against this list of reports that the Monthly ext4 report is
generated.  So if people who are submitting fixes against syzkaller
reports, it would be nice if they were to check the ext4 dashboard
above to look for syzbot reports that might be also relevant to your
patch.

Thanks,

					- Ted
