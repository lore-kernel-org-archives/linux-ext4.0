Return-Path: <SRS0=y8r3=S3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71446C43218
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 15:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BADA520878
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 15:58:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbfDYP55 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 25 Apr 2019 11:57:57 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:45564 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726626AbfDYP55 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Apr 2019 11:57:57 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x3PFvkcD006799
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Apr 2019 11:57:47 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id D37DC420EEC; Thu, 25 Apr 2019 11:57:45 -0400 (EDT)
Date:   Thu, 25 Apr 2019 11:57:45 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Barret Rhoden <brho@google.com>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        syzbot+f584efa0ac7213c226b7@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext4: fix use-after-free race with
 debug_want_extra_isize
Message-ID: <20190425155745.GB4739@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
        Barret Rhoden <brho@google.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        syzbot+f584efa0ac7213c226b7@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190415211945.27343-1-brho@google.com>
 <20190418155937.164947-1-brho@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190418155937.164947-1-brho@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Apr 18, 2019 at 11:59:37AM -0400, Barret Rhoden wrote:
> When remounting with debug_want_extra_isize, we were not performing the
> same checks that we do during a normal mount.  That allowed us to set a
> value for s_want_extra_isize that reached outside the s_inode_size.
> 
> Reported-by: syzbot+f584efa0ac7213c226b7@syzkaller.appspotmail.com
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Barret Rhoden <brho@google.com>
> Cc: stable@vger.kernel.org # 4.14.111

Applied, thanks.

					- Ted
