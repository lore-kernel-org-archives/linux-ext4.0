Return-Path: <SRS0=kheP=DI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A07C4727E
	for <linux-ext4@archiver.kernel.org>; Thu,  1 Oct 2020 20:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38A4020754
	for <linux-ext4@archiver.kernel.org>; Thu,  1 Oct 2020 20:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgJAU45 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 1 Oct 2020 16:56:57 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:40337 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726515AbgJAU45 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Oct 2020 16:56:57 -0400
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 091KuhHO027258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 1 Oct 2020 16:56:45 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 16AEA42003C; Thu,  1 Oct 2020 16:56:43 -0400 (EDT)
Date:   Thu, 1 Oct 2020 16:56:43 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     darrick.wong@oracle.com, ira.weiny@intel.com, ebiggers@kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2] chattr/lsattr: Support dax attribute
Message-ID: <20201001205643.GA656789@mit.edu>
References: <20200728053321.12892-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728053321.12892-1-yangx.jy@cn.fujitsu.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Jul 28, 2020 at 01:33:21PM +0800, Xiao Yang wrote:
> Use the letter 'x' to set/get dax attribute on a directory/file.
> 
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.  Apologies for the delay.

		  	    	    - Ted
