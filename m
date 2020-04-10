Return-Path: <SRS0=y2Es=52=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87F51C2BA2B
	for <linux-ext4@archiver.kernel.org>; Fri, 10 Apr 2020 16:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66DC320857
	for <linux-ext4@archiver.kernel.org>; Fri, 10 Apr 2020 16:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgDJQQj (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 10 Apr 2020 12:16:39 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:57519 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726009AbgDJQQj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Apr 2020 12:16:39 -0400
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 03AGGZ2n017854
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Apr 2020 12:16:36 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 5162242013D; Fri, 10 Apr 2020 12:16:35 -0400 (EDT)
Date:   Fri, 10 Apr 2020 12:16:35 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] e2scrub: Remove PATH setting from the scripts
Message-ID: <20200410161635.GP45598@mit.edu>
References: <20200402134716.3725-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402134716.3725-1-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Apr 02, 2020 at 03:47:16PM +0200, Lukas Czerner wrote:
> We don't want to override system setting by changing the PATH. This
> should remain under administrator/user control.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

The reason why the PATH was added is because most users don't have
/sbin or /usr/sbin in their PATH, and if they run "sudo e2scrub",
finding commands like lvcreate, lvremove, et. al., wouldn't be there.

I suppose we could do something like

PATH=$PATH:/sbin:/usr/sbin

instead, but otherwise, users will see some unexpected failures.

	     		      	       	    	       - Ted
