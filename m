Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B593CC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 14:27:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9116E218D8
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 14:27:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbfCUO1P (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 10:27:15 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:44575 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725985AbfCUO1P (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2019 10:27:15 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2LEQw8i016534
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Mar 2019 10:26:59 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 5852E420AA8; Thu, 21 Mar 2019 10:26:58 -0400 (EDT)
Date:   Thu, 21 Mar 2019 10:26:58 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        darrick.wong@oracle.com
Subject: Re: [PATCH 7/9] e2scrub_all: make sure there's enough free space for
 a snapshot
Message-ID: <20190321142658.GA9434@mit.edu>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-7-tytso@mit.edu>
 <20190321111856.gsbdc6gv3bfehion@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321111856.gsbdc6gv3bfehion@work>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 21, 2019 at 12:18:56PM +0100, Lukas Czerner wrote:
> 
> So you're going to be calling vgs for every lvs even though you can have
> a whole bunch of them in the same vg. That's not very efficient.
> 
> You can just filter it out with the lvs at the start of the loop by
> adding the proper select string.
> 
> -S vg_free\>${snap_size_mb}

Good point.  BTW, that's why I had ignored one of your other
suggestions --- I needed LVM_VG_NAME, which means I needed more than
one output from lvs, so I use the output directly as you suggested.

        	   	     	  - Ted
			  
