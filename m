Return-Path: <SRS0=EsIP=Z7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25908C3F68F
	for <linux-ext4@archiver.kernel.org>; Mon,  9 Dec 2019 00:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03AF7206F4
	for <linux-ext4@archiver.kernel.org>; Mon,  9 Dec 2019 00:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfLIAnD (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 8 Dec 2019 19:43:03 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37026 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726653AbfLIAnD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 8 Dec 2019 19:43:03 -0500
Received: from callcc.thunk.org (ec2-52-55-121-20.compute-1.amazonaws.com [52.55.121.20])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xB90gJMj007912
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 8 Dec 2019 19:42:57 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 35BCD421A48; Sun,  8 Dec 2019 19:42:09 -0500 (EST)
Date:   Sun, 8 Dec 2019 19:42:09 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] ext4: Check for directory entries too close to block
 end
Message-ID: <20191209004209.GB9343@mit.edu>
References: <20191202170213.4761-1-jack@suse.cz>
 <20191202170213.4761-3-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202170213.4761-3-jack@suse.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Dec 02, 2019 at 06:02:13PM +0100, Jan Kara wrote:
> ext4_check_dir_entry() currently does not catch a case when a directory
> entry ends so close to the block end that the header of the next
> directory entry would not fit in the remaining space. This can lead to
> directory iteration code trying to access address beyond end of current
> buffer head leading to oops.
> 
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
