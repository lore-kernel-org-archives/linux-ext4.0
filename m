Return-Path: <SRS0=/gtt=RH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C514BC43381
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Mar 2019 20:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 937E9206DD
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Mar 2019 20:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbfCDUuM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 4 Mar 2019 15:50:12 -0500
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:60856 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726087AbfCDUuM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Mar 2019 15:50:12 -0500
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail03.adl6.internode.on.net with ESMTP; 05 Mar 2019 07:20:08 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1h0uXG-0006oX-Qq; Tue, 05 Mar 2019 07:50:06 +1100
Date:   Tue, 5 Mar 2019 07:50:06 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc:     Wang Shilong <wangshilong1991@gmail.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, lixi@ddn.com,
        Andreas Dilger <adilger@dilger.ca>,
        Wang Shilong <wshilong@ddn.com>,
        linux-man <linux-man@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] statx.2: add project support update
Message-ID: <20190304205006.GX23020@dastard>
References: <1551449184-7942-1-git-send-email-wshilong1991@gmail.com>
 <1551449184-7942-3-git-send-email-wshilong1991@gmail.com>
 <CAKgNAkitiDEYSZDnJ5iQ6coaE=q45BHxnG2z_bZtWs=kk+2g3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgNAkitiDEYSZDnJ5iQ6coaE=q45BHxnG2z_bZtWs=kk+2g3w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Mar 04, 2019 at 02:52:59PM +0100, Michael Kerrisk (man-pages) wrote:
> Hello Wang Shilong,
> 
> On Fri, 1 Mar 2019 at 15:06, Wang Shilong <wangshilong1991@gmail.com> wrote:
> >
> > From: Wang Shilong <wshilong@ddn.com>
> 
> I take it that these patches relate to some API changes that are not
> yet merged into the kernel, right?
> 
> Also, I think we need some accompanying info to describe project IDs.
> Can you point me at any documents/resources?

Probably "best" documented in the man pages that ship with xfsprogs.
Basically, it's just another quota ID that can be used to account
for files/directories in arbitrary admin defined groups. i.e. quotas
that aren't bound by user/group identities.

$ man 8 xfs_quota
$ man 5 projects
$ man 5 projid

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
