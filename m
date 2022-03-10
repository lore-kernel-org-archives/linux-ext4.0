Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C304C433F5
	for <linux-ext4@archiver.kernel.org>; Thu, 10 Mar 2022 16:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239706AbiCJQHB (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 10 Mar 2022 11:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240541AbiCJQG6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Mar 2022 11:06:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BB2186469;
        Thu, 10 Mar 2022 08:05:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48F1261A97;
        Thu, 10 Mar 2022 16:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F57C340E8;
        Thu, 10 Mar 2022 16:05:54 +0000 (UTC)
Date:   Thu, 10 Mar 2022 11:05:53 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 00/10] ext4: Improve FC trace events
Message-ID: <20220310110553.431cc997@gandalf.local.home>
In-Reply-To: <cover.1646922487.git.riteshh@linux.ibm.com>
References: <cover.1646922487.git.riteshh@linux.ibm.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, 10 Mar 2022 21:28:54 +0530
Ritesh Harjani <riteshh@linux.ibm.com> wrote:

> Note:- I still couldn't figure out how to expose EXT4_FC_REASON_MAX in patch-2
> which (I think) might be (only) needed by trace-cmd or perf record for trace_ext4_fc_stats.
> But it seems "cat /sys/kernel/debug/tracing/trace_pipe" gives the right output
> for ext4_fc_stats trace event (as shown below).
> 
> So with above reasoning, do you think we should take these patches in?
> And we can later see how to provide EXT4_FC_REASON_MAX definition available to
> libtraceevent?

I don't see EXT4_FC_REASON_MAX being used in the TP_printk(). If it isn't
used there, it doesn't need to be exposed. Or did I miss something?

-- Steve
