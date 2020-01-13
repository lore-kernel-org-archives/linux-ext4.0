Return-Path: <SRS0=Aflh=3C=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE729C33CA9
	for <linux-ext4@archiver.kernel.org>; Mon, 13 Jan 2020 21:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A302020CC7
	for <linux-ext4@archiver.kernel.org>; Mon, 13 Jan 2020 21:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgAMVmf (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 13 Jan 2020 16:42:35 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:51170 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726488AbgAMVmf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Jan 2020 16:42:35 -0500
Received: from callcc.thunk.org (guestnat-104-133-0-111.corp.google.com [104.133.0.111] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 00DLgM8R018639
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jan 2020 16:42:23 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id E0D074207DF; Mon, 13 Jan 2020 16:42:21 -0500 (EST)
Date:   Mon, 13 Jan 2020 16:42:21 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     Ritesh Harjani <riteshh@linux.ibm.com>, linux-ext4@vger.kernel.org,
        ebiggers@kernel.org
Subject: Re: [PATCH 1/1] ext4: remove unused macro MPAGE_DA_EXTENT_TAIL
Message-ID: <20200113214221.GJ76141@mit.edu>
References: <20191231180444.46586-1-ebiggers@kernel.org>
 <20200101095137.25656-1-riteshh@linux.ibm.com>
 <20200107095551.GD26849@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107095551.GD26849@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Jan 07, 2020 at 10:55:51AM +0100, Jan Kara wrote:
> On Wed 01-01-20 15:21:37, Ritesh Harjani wrote:
> > Remove unused macro MPAGE_DA_EXTENT_TAIL which
> > is no more used after below commit
> > 4e7ea81d ("ext4: restructure writeback path")
> > 
> > Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
> 
> Looks good to me. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
