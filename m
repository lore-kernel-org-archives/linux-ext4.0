Return-Path: <SRS0=afbN=SJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.4 required=3.0 tests=DATE_IN_PAST_03_06,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1DBAC282DA
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 02:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B1E6213A2
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 02:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfDGCOB (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 6 Apr 2019 22:14:01 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:49758 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726184AbfDGCOB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Apr 2019 22:14:01 -0400
Received: from callcc.thunk.org (225.sub-174-209-4.myvzw.com [174.209.4.225])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x372Dl0Q018864
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 6 Apr 2019 22:13:50 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 8F989421A19; Sat,  6 Apr 2019 19:03:52 -0400 (EDT)
Date:   Sat, 6 Apr 2019 19:03:52 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc:     linux-ext4@vger.kernel.org, jack@suse.cz, renzhen@linux.alibaba.com
Subject: Re: [PATCH v2] jbd2: check superblock mapped prior to committing
Message-ID: <20190406230352.GG18897@mit.edu>
References: <20190328100750.71045-1-jiufei.xue@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328100750.71045-1-jiufei.xue@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 28, 2019 at 06:07:50PM +0800, Jiufei Xue wrote:
> We hit a BUG at fs/buffer.c:3057 if we detached the nbd device
> before unmounting ext4 filesystem.
> 
> The typical chain of events leading to the BUG:
> jbd2_write_superblock
>   submit_bh
>     submit_bh_wbc
>       BUG_ON(!buffer_mapped(bh));
> 
> The block device is removed and all the pages are invalidated. JBD2
> was trying to write journal superblock to the block device which is
> no longer present.
> 
> Fix this by checking the journal superblock's buffer head prior to
> submitting.

Thanks, applied.

					- Ted
