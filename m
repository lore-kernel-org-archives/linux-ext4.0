Return-Path: <SRS0=FgUg=7X=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19200C433DF
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Jun 2020 22:07:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE9EC2072E
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Jun 2020 22:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgFJWHY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 10 Jun 2020 18:07:24 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:35631 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726374AbgFJWHY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Jun 2020 18:07:24 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 05AM7AbM007155
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Jun 2020 18:07:11 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 4D7B14200DD; Wed, 10 Jun 2020 18:07:10 -0400 (EDT)
Date:   Wed, 10 Jun 2020 18:07:10 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     syzbot <syzbot+bca9799bf129256190da@syzkaller.appspotmail.com>
Cc:     adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        dan.j.williams@intel.com, jack@suse.cz, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 generic_perform_write (2)
Message-ID: <20200610220710.GL1347934@mit.edu>
References: <00000000000016a67305a33a11f7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000016a67305a33a11f7@google.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

#syz test: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git 5749fe5af3db176659978718ddaecebb450cdb6b
