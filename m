Return-Path: <SRS0=cCbn=46=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E03C10DCE
	for <linux-ext4@archiver.kernel.org>; Fri, 13 Mar 2020 20:17:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61A7220637
	for <linux-ext4@archiver.kernel.org>; Fri, 13 Mar 2020 20:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgCMURM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 13 Mar 2020 16:17:12 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:34518 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727325AbgCMURM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Mar 2020 16:17:12 -0400
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 02DKGs0o003689
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Mar 2020 16:16:54 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id D540A420E5E; Fri, 13 Mar 2020 16:16:53 -0400 (EDT)
Date:   Fri, 13 Mar 2020 16:16:53 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     linux-ext4@vger.kernel.org, jack@suse.cz, adilger.kernel@dilger.ca,
        linux-fsdevel@vger.kernel.org, darrick.wong@oracle.com,
        hch@infradead.org, cmaiolino@redhat.com, david@fromorbit.com
Subject: Re: [PATCHv5 3/6] ext4: Move ext4 bmap to use iomap infrastructure.
Message-ID: <20200313201653.GJ225435@mit.edu>
References: <cover.1582880246.git.riteshh@linux.ibm.com>
 <8bbd53bd719d5ccfecafcce93f2bf1d7955a44af.1582880246.git.riteshh@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bbd53bd719d5ccfecafcce93f2bf1d7955a44af.1582880246.git.riteshh@linux.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Feb 28, 2020 at 02:56:56PM +0530, Ritesh Harjani wrote:
> ext4_iomap_begin is already implemented which provides ext4_map_blocks,
> so just move the API from generic_block_bmap to iomap_bmap for iomap
> conversion.
> 
> Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
