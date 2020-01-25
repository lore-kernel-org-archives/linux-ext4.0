Return-Path: <SRS0=qwWH=3O=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE9FEC35241
	for <linux-ext4@archiver.kernel.org>; Sat, 25 Jan 2020 07:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90ADA2077C
	for <linux-ext4@archiver.kernel.org>; Sat, 25 Jan 2020 07:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgAYHD3 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 25 Jan 2020 02:03:29 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:48018 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726145AbgAYHD3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Jan 2020 02:03:29 -0500
Received: from callcc.thunk.org (rrcs-67-53-201-206.west.biz.rr.com [67.53.201.206])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 00P73Jcd021484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 25 Jan 2020 02:03:21 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 5E95B42014A; Sat, 25 Jan 2020 02:03:18 -0500 (EST)
Date:   Sat, 25 Jan 2020 02:03:18 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Dmitry Monakhov <dmonakhov@gmail.com>
Cc:     linux-ext4@vger.kernel.org, darrick.wong@oracle.com
Subject: Re: [PATCH 1/2] ext4: fix symbolic enum printing in trace output
Message-ID: <20200125070318.GC1108497@mit.edu>
References: <20191114200147.1073-1-dmonakhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191114200147.1073-1-dmonakhov@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Nov 14, 2019 at 08:01:46PM +0000, Dmitry Monakhov wrote:
> Trace's macro __print_flags() produce raw event's decraration w/o knowing actual
> flags value
> 
> cat /sys/kernel/debug/tracing/events/ext4/ext4_ext_map_blocks_exit/format
> ..
> __print_flags(REC->mflags, "", { (1 << BH_New),
> 
> For that reason we have to explicitly define it via special macro TRACE_DEFINE_ENUM()
> Also add missed EXTENT_STATUS_REFERENCED flag.
> 
> #Before patch
> ext4:ext4_ext_map_blocks_exit: dev 253,0 ino 2 flags  lblk 0 pblk 4177 len 1 mflags 0x20 ret 1
> ext4:ext4_ext_map_blocks_exit: dev 253,0 ino 12 flags CREATE lblk 0 pblk 34304 len 1 mflags 0x60 ret 1
> 
> #With patch
> ext4:ext4_ext_map_blocks_exit: dev 253,0 ino 2 flags  lblk 0 pblk 4177 len 1 mflags M ret 1
> ext4:ext4_ext_map_blocks_exit: dev 253,0 ino 12 flags CREATE lblk 0 pblk 34816 len 1 mflags NM ret 1
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@gmail.com>

Thanks, applied.

					- Ted
