Return-Path: <SRS0=fczw=RS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1036C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 08:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A40F121872
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 08:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbfCOIns (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 15 Mar 2019 04:43:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52442 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727123AbfCOInr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 15 Mar 2019 04:43:47 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BB85730832D0;
        Fri, 15 Mar 2019 08:43:47 +0000 (UTC)
Received: from work (ovpn-204-205.brq.redhat.com [10.40.204.205])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D5A1C60F89;
        Fri, 15 Mar 2019 08:43:46 +0000 (UTC)
Date:   Fri, 15 Mar 2019 09:43:43 +0100
From:   Lukas Czerner <lczerner@redhat.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ext4: Report real fs size after failed resize
Message-ID: <20190315084343.odt3mug7ffb6pwno@work>
References: <20190305105400.4960-1-lczerner@redhat.com>
 <20190305105400.4960-2-lczerner@redhat.com>
 <20190315042357.GH11334@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190315042357.GH11334@mit.edu>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 15 Mar 2019 08:43:47 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Mar 15, 2019 at 12:23:58AM -0400, Theodore Ts'o wrote:
> On Tue, Mar 05, 2019 at 11:54:00AM +0100, Lukas Czerner wrote:
> > Currently when the file system resize using ext4_resize_fs() fails it
> > will report into log that "resized filesystem to <requested block
> > count>". However this may not be true in the case of failure. Use the
> > current block count as returned by ext4_blocks_count() to report the
> > block count.
> > Additionally report to log that "error occurred during file system
> > resize"
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> Thanks, applied with one minor change.  In call to ext4_warning(), I
> changed it to include error code so the warning message will be more
> useful:
> 
> > +	if (err)
> > +		ext4_warning(sb, "error occurred during file system resize");
> 
> is now
> 
> +       if (err)
> +               ext4_warning(sb, "error (%d) occurred during "
> +                            "file system resize", err);

Yeah, that's better.

Thanks!
-Lukas

> 
>   				 		 - Ted
