Return-Path: <SRS0=fczw=RS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FAABC43381
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 04:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63E082186A
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 04:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbfCOEYI (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 15 Mar 2019 00:24:08 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:38520 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725857AbfCOEYH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Mar 2019 00:24:07 -0400
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2F4Nwt8001831
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Mar 2019 00:23:58 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 1582B420AA8; Fri, 15 Mar 2019 00:23:58 -0400 (EDT)
Date:   Fri, 15 Mar 2019 00:23:58 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ext4: Report real fs size after failed resize
Message-ID: <20190315042357.GH11334@mit.edu>
References: <20190305105400.4960-1-lczerner@redhat.com>
 <20190305105400.4960-2-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190305105400.4960-2-lczerner@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Mar 05, 2019 at 11:54:00AM +0100, Lukas Czerner wrote:
> Currently when the file system resize using ext4_resize_fs() fails it
> will report into log that "resized filesystem to <requested block
> count>". However this may not be true in the case of failure. Use the
> current block count as returned by ext4_blocks_count() to report the
> block count.
> Additionally report to log that "error occurred during file system
> resize"
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied with one minor change.  In call to ext4_warning(), I
changed it to include error code so the warning message will be more
useful:

> +	if (err)
> +		ext4_warning(sb, "error occurred during file system resize");

is now

+       if (err)
+               ext4_warning(sb, "error (%d) occurred during "
+                            "file system resize", err);

  				 		 - Ted
