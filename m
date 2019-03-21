Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E285DC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 20:23:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF79F218D3
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 20:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbfCUUX7 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 16:23:59 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:52177 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728744AbfCUUX7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2019 16:23:59 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2LKNdwO016451
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Mar 2019 16:23:40 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 8FF18420AA8; Thu, 21 Mar 2019 16:23:39 -0400 (EDT)
Date:   Thu, 21 Mar 2019 16:23:39 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        darrick.wong@oracle.com
Subject: Re: [PATCH 8/9] e2scrub_all: refactor device probe loop
Message-ID: <20190321202339.GI9434@mit.edu>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-8-tytso@mit.edu>
 <20190321102742.k2oos4epoj6fyjao@work>
 <20190321174811.GF9434@mit.edu>
 <20190321194901.44eeu6l7mxsd7k4j@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321194901.44eeu6l7mxsd7k4j@work>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 21, 2019 at 08:49:01PM +0100, Lukas Czerner wrote:
> I wish I knew. I think that for workstation users it's the defaults that
> matters the most so I would not expect thin LV's to be used much there.
> Qubes OS being most notable exception I think.

Yeah, especially since the lvcreate command is so complicated.  Even
if there's only one thinpool in a VG, you have to specify it
explicitly:

	lvcreate -V 5G --thinpool mythinpool -n thinlv lambda

Even though mythinpool is the only possible thinpool to use in VG
lambda, and even though it's clear that a thinLV is desired due to the
-V option, you still have to pass in the --thinpool option, and there
is no convenient short option character for it.  :-(

Given that the devicemapper people are saying that thick snapshots are
legacy and deprecated, and everyone should be using the new coolness,
I'm pretty sure most users haven't gotten the message....

    	   	     	   	   	  - Ted
