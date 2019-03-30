Return-Path: <SRS0=QItb=SB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09CE2C43381
	for <linux-ext4@archiver.kernel.org>; Sat, 30 Mar 2019 18:15:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE27A218FD
	for <linux-ext4@archiver.kernel.org>; Sat, 30 Mar 2019 18:15:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731003AbfC3SPN (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 30 Mar 2019 14:15:13 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:40190 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730769AbfC3SPN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Mar 2019 14:15:13 -0400
Received: from callcc.thunk.org (96-72-102-169-static.hfc.comcastbusiness.net [96.72.102.169] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2UIEdF3012667
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 30 Mar 2019 14:14:41 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 6B26A421A03; Sat, 30 Mar 2019 14:14:39 -0400 (EDT)
Date:   Sat, 30 Mar 2019 14:14:39 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     liu.song11@zte.com.cn
Cc:     adilger@dilger.ca, jack@suse.cz, fishland@aliyun.com,
        jack@suse.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd2: do not start commit when t_updates does not back
 tozero
Message-ID: <20190330181439.GE15757@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, liu.song11@zte.com.cn,
        adilger@dilger.ca, jack@suse.cz, fishland@aliyun.com, jack@suse.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <AE779190-182F-472B-8E91-678ABEFF8506@dilger.ca>
 <201903301524441962443@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201903301524441962443@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Mar 30, 2019 at 03:24:44PM +0800, liu.song11@zte.com.cn wrote:
> 
> When we unzipped bunch of files under ext4, sometimes got hungtask warning
> which indicate process was waiting on "j_wait_transaction_locked".

Can you give a clean repro of this?  What sort of storage device are
you using, and what sort of file systems and mount options are you
using?  I unzip files under ext4 all the time w/o any problems....

	  	      	    	     - Ted
