Return-Path: <SRS0=o0xn=S6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F862C43219
	for <linux-ext4@archiver.kernel.org>; Sun, 28 Apr 2019 20:43:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15BCF206BF
	for <linux-ext4@archiver.kernel.org>; Sun, 28 Apr 2019 20:43:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfD1Un5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 28 Apr 2019 16:43:57 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37091 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725982AbfD1Un5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Apr 2019 16:43:57 -0400
Received: from callcc.thunk.org (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x3SKho3p027374
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 28 Apr 2019 16:43:52 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 9113A420023; Sun, 28 Apr 2019 16:43:49 -0400 (EDT)
Date:   Sun, 28 Apr 2019 16:43:49 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] nls: Update to Unicode 12.1.0
Message-ID: <20190428204349.GA3789@mit.edu>
References: <20190413054317.7388-7-krisman@collabora.com>
 <20190416201344.27122-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416201344.27122-1-krisman@collabora.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Apr 16, 2019 at 04:13:44PM -0400, Gabriel Krisman Bertazi wrote:
> Hi Ted,
> 
> Like the kernel version, here is the unicode 12.1 update I promissed.
> Feel free to squash it into the Unicode 12.0 update.
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>

Thanks, I squashed this into the Unicode 12.0.0 update.

	  	   	     	 - Ted
