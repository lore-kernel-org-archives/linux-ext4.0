Return-Path: <SRS0=pnrD=AA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6178C433E0
	for <linux-ext4@archiver.kernel.org>; Fri, 19 Jun 2020 17:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87CEB214DB
	for <linux-ext4@archiver.kernel.org>; Fri, 19 Jun 2020 17:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731027AbgFSRQr (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 19 Jun 2020 13:16:47 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:54862 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729842AbgFSRQq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Jun 2020 13:16:46 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 05JHGfWZ015662
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Jun 2020 13:16:42 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id A859042026D; Fri, 19 Jun 2020 13:16:41 -0400 (EDT)
Date:   Fri, 19 Jun 2020 13:16:41 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Alex Zhuravlev <azhuravlev@whamcloud.com>
Cc:     =?utf-8?B?0JHQu9Cw0LPQvtC00LDRgNC10L3QutC+INCQ0YDRgtGR0Lw=?= 
        <artem.blagodarenko@gmail.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 1/2] ext4:  mballoc - prefetching for bitmaps
Message-ID: <20200619171641.GA3963397@mit.edu>
References: <262A2973-9B2D-4DBE-8752-67E91D52C632@whamcloud.com>
 <90289086-E2DD-469A-86E2-3BB72CAC59E0@gmail.com>
 <895DB4D0-0F00-4467-A87F-33222443615A@whamcloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <895DB4D0-0F00-4467-A87F-33222443615A@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, May 30, 2020 at 05:01:40AM +0000, Alex Zhuravlev wrote:
> 
> Hi
> 
> > On 29 May 2020, at 19:19, Благодаренко Артём <artem.blagodarenko@gmail.com> wrote:
> > 
> > Also, we have encountered directory creating rate drop with this (not exact this, but Lustre FS version) patch. From 70-80K to 30-40K.
> > Excluding this patch restore rates to the original values.
> > I am investigating it now. Alex, do you expect this optimisation has impact to names creation?
> > Is plenty of files and directories creation corner case for this optimisation?
> 
> Noticed as well, the last version posted to the list should have this problem fixed.

I'm not seeing any newer version of this patch since the one on this
thread, posted on May 15th.

Am I missing something?   What's the latest version of this patch that you have?

     	     		  	     	    - Ted
