Return-Path: <SRS0=jPnt=6G=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADF7EC55185
	for <linux-ext4@archiver.kernel.org>; Wed, 22 Apr 2020 16:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ECA920774
	for <linux-ext4@archiver.kernel.org>; Wed, 22 Apr 2020 16:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgDVQKc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 22 Apr 2020 12:10:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:36312 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgDVQKb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 22 Apr 2020 12:10:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A134AAED7;
        Wed, 22 Apr 2020 16:10:29 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id BA3291E0E56; Wed, 22 Apr 2020 18:10:29 +0200 (CEST)
Date:   Wed, 22 Apr 2020 18:10:29 +0200
From:   Jan Kara <jack@suse.cz>
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com, stable@kernel.org,
        syzbot+bca9799bf129256190da@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: reject mount options not supported when remounting
 in handle_mount_opt()
Message-ID: <20200422161029.GD20756@quack2.suse.cz>
References: <to=00000000000098a5d505a34d1e48@google.com>
 <20200415174839.461347-1-tytso@mit.edu>
 <20200415202537.GA2309605@iweiny-DESK2.sc.intel.com>
 <20200415220752.GA5187@mit.edu>
 <20200416052352.GK2309605@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416052352.GK2309605@iweiny-DESK2.sc.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed 15-04-20 22:23:52, Ira Weiny wrote:
> On Wed, Apr 15, 2020 at 06:07:52PM -0400, Theodore Y. Ts'o wrote:
> > On Wed, Apr 15, 2020 at 01:25:37PM -0700, Ira Weiny wrote:
> > > This fundamentally changes the behavior from forcing the dax mode to be the
> > > same across the remount to only failing if we are going from non-dax to dax,
> > > adding -o dax on the remount?
> > > 
> > > But going from -o dax to 'not -o dax' would be ok?
> > > 
> > > FWIW after thinking about it some I _think_ it would be ok to allow the dax
> > > mode to change on a remount and let the inodes in memory stay in the mode they
> > > are at.  And newly loaded inodes would get the new mode...  Unfortunately
> > > without the STATX patch I have proposed the user does not have any way of
> > > knowing which files are in which mode.
> > 
> > We don't currently support mount -o nodax.
> 
> But we do support not supplying the option which means 'nodax' right?

Yeah, I second what Ira wrote. The new code does not seem to properly
detect a case when enabled mount option is removed for remount and thus the
feature would get disabled during remount as a result...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
