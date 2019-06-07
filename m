Return-Path: <SRS0=uYfF=UG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85753C2BCA1
	for <linux-ext4@archiver.kernel.org>; Fri,  7 Jun 2019 13:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6557C20B7C
	for <linux-ext4@archiver.kernel.org>; Fri,  7 Jun 2019 13:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbfFGNdI (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 7 Jun 2019 09:33:08 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56901 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728071AbfFGNdI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Jun 2019 09:33:08 -0400
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x57DWtcB018463
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 7 Jun 2019 09:32:56 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id BD29F420481; Fri,  7 Jun 2019 09:32:55 -0400 (EDT)
Date:   Fri, 7 Jun 2019 09:32:55 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Gabriel Krisman Bertazi <krisman@collabora.com>,
        fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        "Lakshmipathi.G" <lakshmipathi.ganapathi@collabora.co.uk>
Subject: Re: [PATCH v2 2/2] ext4/036: Add tests for filename casefolding
 feature
Message-ID: <20190607133255.GB19820@mit.edu>
References: <20190606193138.25852-1-krisman@collabora.com>
 <20190606193138.25852-2-krisman@collabora.com>
 <20190607052331.GA19838@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607052331.GA19838@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jun 06, 2019 at 10:23:31PM -0700, Christoph Hellwig wrote:
> On Thu, Jun 06, 2019 at 03:31:38PM -0400, Gabriel Krisman Bertazi wrote:
> > 
> > For now, let it live in ext4 and we move to shared/ or generic/ when
> > other filesystems supporting this feature start to pop up.
> 
> Please keep it in shared/ from the start.  There isn't really anything
> ext4 specific.  In fact xfs already supports CI file systems, just
> without utf8 tables for now.

Agreed; the only things which are fs specific are things which you've
already done a great job abstracting away in common/casefold.

      	  	      	       	       - Ted
