Return-Path: <SRS0=CWHP=2Q=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C684BC2D0DA
	for <linux-ext4@archiver.kernel.org>; Thu, 26 Dec 2019 15:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1C3520740
	for <linux-ext4@archiver.kernel.org>; Thu, 26 Dec 2019 15:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbfLZPHY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 26 Dec 2019 10:07:24 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:42495 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726336AbfLZPHY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Dec 2019 10:07:24 -0500
Received: from callcc.thunk.org (96-72-84-49-static.hfc.comcastbusiness.net [96.72.84.49] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xBQF6f7O015992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Dec 2019 10:06:42 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id D103E420485; Thu, 26 Dec 2019 10:06:40 -0500 (EST)
Date:   Thu, 26 Dec 2019 10:06:40 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     jack@suse.cz, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, mbobrowski@mbobrowski.org,
        joseph.qi@linux.alibaba.com
Subject: Re: [PATCHv5 0/3] Fix inode_lock sequence to scale performance of
 DIO mixed R/W workload
Message-ID: <20191226150640.GD3158@mit.edu>
References: <20191212055557.11151-1-riteshh@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212055557.11151-1-riteshh@linux.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Thanks, I've applied this to the ext4 git tree.

	     	     	     	  - Ted
