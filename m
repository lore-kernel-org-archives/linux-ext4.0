Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61347C433B4
	for <linux-ext4@archiver.kernel.org>; Tue, 11 May 2021 10:43:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CB996144F
	for <linux-ext4@archiver.kernel.org>; Tue, 11 May 2021 10:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhEKKoi (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 11 May 2021 06:44:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:36364 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231312AbhEKKoh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 11 May 2021 06:44:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6FB22B02C;
        Tue, 11 May 2021 10:43:28 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id AFA861F2B6D; Tue, 11 May 2021 12:43:27 +0200 (CEST)
Date:   Tue, 11 May 2021 12:43:27 +0200
From:   Jan Kara <jack@suse.cz>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Gabriel Krisman Bertazi <krisman@collabora.com>,
        Theodore Tso <tytso@mit.edu>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>,
        David Howells <dhowells@redhat.com>,
        Khazhismel Kumykov <khazhy@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Ext4 <linux-ext4@vger.kernel.org>, kernel@collabora.com
Subject: Re: [PATCH RFC 00/15] File system wide monitoring
Message-ID: <20210511104327.GI24154@quack2.suse.cz>
References: <20210426184201.4177978-1-krisman@collabora.com>
 <CAOQ4uxi3yigb2gUjXHJQOVbPHR3RFDeyKc5i0X-k8CSLwurejg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi3yigb2gUjXHJQOVbPHR3RFDeyKc5i0X-k8CSLwurejg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue 27-04-21 07:11:49, Amir Goldstein wrote:
> The ring buffer functionality for fsnotify is interesting and it may be
> useful on its own, but IMO, its too big of a hammer for the problem
> at hand.
> 
> The question that you should be asking yourself is what is the
> expected behavior in case of a flood of filesystem corruption errors.
> I think it has already been expressed by filesystem maintainers on
> one your previous postings, that a flood of filesystem corruption
> errors is often noise and the only interesting information is the first error.
> 
> For this reason, I think that FS_ERROR could be implemented
> by attaching an fsnotify_error_info object to an fsnotify_sb_mark:
> 
> struct fsnotify_sb_mark {
>         struct fsnotify_mark fsn_mark;
>         struct fsnotify_error_info info;
> }
> 
> Similar to fd sampled errseq, there can be only one error report
> per sb-group pair (i.e. fsnotify_sb_mark) and the memory needed to store
> the error report can be allocated at the time of setting the filesystem mark.
> 
> With this, you will not need the added complexity of the ring buffer
> and you will not need to limit FAN_ERROR reporting to a group that
> is only listening for FAN_ERROR, which is an unneeded limitation IMO.

Seeing that this 'single error per mark' idea is gathering some support I'd
like to add my 2c: Probably we don't want fsnotify_error_info attached to
every fsnotify_mark, I guess we can have:

struct fanotify_mark {
	struct fsnotify_mark fsn_mark;
	struct fanotify_error_event *event;
};

and 'event' will be normally NULL and if we add FAN_ERROR to mark's mask,
we will allocate event (also containing error info) to use when generating
error event. And then the handling will be somewhat similar to how we
handle overflow events.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
