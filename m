Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD10C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 17:48:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDCC021902
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 17:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbfCURs3 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 13:48:29 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:43348 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728069AbfCURs3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2019 13:48:29 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2LHmCSG021729
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Mar 2019 13:48:12 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 0B04D420AA8; Thu, 21 Mar 2019 13:48:12 -0400 (EDT)
Date:   Thu, 21 Mar 2019 13:48:11 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        darrick.wong@oracle.com
Subject: Re: [PATCH 8/9] e2scrub_all: refactor device probe loop
Message-ID: <20190321174811.GF9434@mit.edu>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-8-tytso@mit.edu>
 <20190321102742.k2oos4epoj6fyjao@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321102742.k2oos4epoj6fyjao@work>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 21, 2019 at 11:27:42AM +0100, Lukas Czerner wrote:
> 
> Snapshot of a thinspanshot is allowed though, so we might want to
> include those. Not sure if it's wise to do it by default, but regardless
> it's probably something for a separate change.

Yeah, it's definitely a separate change.  One potential design
question is that for a thin volume, you can do both a thin or a think
snapshot, and in some cases one might succeed while the other will
fail.  So do we make this choice be a parameter that we set in the
config file, or do we try to see if there is sufficient spare
freespace for a thick snapshot (and then do that), or a thin snapshot
(and then do that) --- and which should use prefer?

The other thing I'll note is that in order for us to tell whether
something is a thin or thick LV, we're going to to need to ask lvs to
return multiple parameters, so the optimization of using:

	for NAME in $(lvs -o lv_path --noheadings -S...) ; do
	    ...
	done

will no longer work.  (Or we end up calling lvs a second time, which
is less efficient.)

Just curious --- do we know how commonly thin LV's are being used by
customers of various distros?  I assume enterprise distro users will
be the most conservative, but how common is the uptake of thin LV's by
Fedora and OpenSuSE users?

						- Ted
