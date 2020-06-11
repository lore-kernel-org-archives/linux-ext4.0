Return-Path: <SRS0=jwhx=7Y=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD58C433DF
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Jun 2020 15:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E62DB2075E
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Jun 2020 15:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgFKPEQ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 11 Jun 2020 11:04:16 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:48131 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728419AbgFKPEP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Jun 2020 11:04:15 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 05BF3eIm026407
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Jun 2020 11:03:40 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 0903E4200DD; Thu, 11 Jun 2020 11:03:40 -0400 (EDT)
Date:   Thu, 11 Jun 2020 11:03:40 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Ritesh Harjani <riteshh@linux.ibm.com>, linux-ext4@vger.kernel.org,
        jack@suse.com, Hillf Danton <hdanton@sina.com>,
        linux-fsdevel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        syzbot+82f324bb69744c5f6969@syzkaller.appspotmail.com
Subject: Re: [PATCHv2 1/1] ext4: mballoc: Use this_cpu_read instead of
 this_cpu_ptr
Message-ID: <20200611150340.GP1347934@mit.edu>
References: <534f275016296996f54ecf65168bb3392b6f653d.1591699601.git.riteshh@linux.ibm.com>
 <20200610062538.GA24975@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610062538.GA24975@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Jun 09, 2020 at 11:25:38PM -0700, Christoph Hellwig wrote:
> On Tue, Jun 09, 2020 at 04:23:10PM +0530, Ritesh Harjani wrote:
> > Simplify reading a seq variable by directly using this_cpu_read API
> > instead of doing this_cpu_ptr and then dereferencing it.
> > 
> > This also avoid the below kernel BUG: which happens when
> > CONFIG_DEBUG_PREEMPT is enabled
> 
> I see this warning all the time with ext4 using tests VMs, so lets get
> this fixed ASAP before -rc1:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks, applied.

						- Ted
