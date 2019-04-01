Return-Path: <SRS0=tO+/=SD=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D95C43381
	for <linux-ext4@archiver.kernel.org>; Mon,  1 Apr 2019 13:20:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7A602086C
	for <linux-ext4@archiver.kernel.org>; Mon,  1 Apr 2019 13:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfDANUS (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 1 Apr 2019 09:20:18 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37063 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726473AbfDANUS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Apr 2019 09:20:18 -0400
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x31DJi3h024119
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 1 Apr 2019 09:19:45 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 065F3421A03; Mon,  1 Apr 2019 09:19:43 -0400 (EDT)
Date:   Mon, 1 Apr 2019 09:19:43 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     liu.song11@zte.com.cn
Cc:     adilger@dilger.ca, jack@suse.cz, fishland@aliyun.com,
        jack@suse.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd2: do not start commit when t_updates does not
 backtozero
Message-ID: <20190401131943.GA2979@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, liu.song11@zte.com.cn,
        adilger@dilger.ca, jack@suse.cz, fishland@aliyun.com, jack@suse.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190330181439.GE15757@mit.edu>
 <201904011035044343324@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201904011035044343324@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Apr 01, 2019 at 10:35:04AM +0800, liu.song11@zte.com.cn wrote:
> 
> Our device is CF card(TS8GCF300), mount options are very general(rw,dirsync,
> relatime,data=ordered).
> The hung problem appears under ext4, but the reason is related to the way 
> of use. In our system, there are many RT tasks, which make normal priority 
> tasks survived in harsh environments, such as syslogd. The syslog record is 
> also under the same device, which is really a stumbling block.
> We moved the location of the syslog record to another device and the hungtask 
> problem was solved.

So the general advice which is going to be true for all file systems
is (a) don't try to do any file I/O from real-time tasks, and (b) if
you must do file I/O from a real-time task, be prepared to be willing
to accept your real-time time tasks blocking behind device I/O, thus
destroying your real-time guarantees, and (c) make sure any kernel
threads used by the file system (e.g., such as the jbd2 kernel thread
for ext4) is also given real-time priority.

Was syslogd being run with real-time priority?  If not, you're going
to not really have real-time performance unles you make sure syslog(3)
calls don't block waiting for syslogd to acknowledge the write.  See
syslog-async as referenced here[1].

[1] https://stackoverflow.com/questions/208098/can-syslog-performance-be-improved

What I suspect was happening was you were using standard syslog(3)
which was blocking for syslogd to respond, syslog was by default
trying to fsync every single log entry before returning success (this
can changed by making the appropriate change to syslog.conf; that's a
different change suggested by [1] above), and so your real-time task
that was calling syslog was blocking.  Since it was a real-time task,
and the jbd2 kernel thread was not a real time thread, this caused a
deadlock.

There are multiple things you can try to optimize (and with real-time
systems, getting configuration right is really, REALLY, critical), but
it sounds like the real root cause is you have a real-time task using
syslog(3).  Don't do that.  It will probably cause you problems in
multiple dimensions.

						- Ted

P.S.  Especially don't try using syslog in real-time tasks if said
real-time system is going to be used in commercial aviation.  It might
cause scandals ala the 737 MAX.  :-)
