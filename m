Return-Path: <SRS0=hrf1=5O=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46797C43331
	for <linux-ext4@archiver.kernel.org>; Sun, 29 Mar 2020 02:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23D6A206DB
	for <linux-ext4@archiver.kernel.org>; Sun, 29 Mar 2020 02:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgC2CRf (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 28 Mar 2020 22:17:35 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:47340 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726463AbgC2CRf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 28 Mar 2020 22:17:35 -0400
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 02T2HSRZ019673
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 28 Mar 2020 22:17:28 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 0B447420EBA; Sat, 28 Mar 2020 22:17:28 -0400 (EDT)
Date:   Sat, 28 Mar 2020 22:17:28 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH] ext4: Don't set dioread_nolock by default for blocksize
 < pagesize
Message-ID: <20200329021728.GI53396@mit.edu>
References: <87pndagw7s.fsf@linux.ibm.com>
 <20200327200744.12473-1-riteshh@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327200744.12473-1-riteshh@linux.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Mar 28, 2020 at 01:37:44AM +0530, Ritesh Harjani wrote:
> Currently on calling echo 3 > drop_caches on host machine, we see
> FS corruption in the guest. This happens on Power machine where
> blocksize < pagesize.
> 
> So as a temporary workaound don't enable dioread_nolock by default
> for blocksize < pagesize until we identify the root cause.
> 
> Also emit a warning msg in case if this mount option is manually
> enabled for blocksize < pagesize.
> 
> Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>

Thanks, applied.

					- Ted
