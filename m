Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F39C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 14:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 671D220830
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 14:41:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728221AbfCUOlI (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 10:41:08 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:47912 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726551AbfCUOlH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2019 10:41:07 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2LEetCR021659
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Mar 2019 10:40:55 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id DC860420AA8; Thu, 21 Mar 2019 10:40:54 -0400 (EDT)
Date:   Thu, 21 Mar 2019 10:40:54 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        darrick.wong@oracle.com
Subject: Re: [PATCH 9/9] e2scrub,e2scrub_all: print a (more understandable)
 error if not run as root
Message-ID: <20190321144054.GD9434@mit.edu>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-9-tytso@mit.edu>
 <20190321113638.qazrsuaob4rsnh5m@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321113638.qazrsuaob4rsnh5m@work>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 21, 2019 at 12:36:38PM +0100, Lukas Czerner wrote:
> 
> EUID is bashism and might not be available in a different shell. But I
> am sure we're using a lot of those and we have "#!/bin/bash".
> 
> It's just somehting to consider, because I am not sure if we say
> anywhere that those scripts will require bash. Personally I do not care
> too much, but I am using bash exclusively :)

Bash is considered "essential" by Debian so it's guaranteed to be
installed.  So I haven't really considered it high priority to try to
make it work on dash or pdksh or mksh or some other nitpicky POSIX.2
shell.

I assume that the right place to state this is in the RPM spec file
(it isn't not needed for debian/control since bash is an essential
package).

Shrug; I'd accept clean patches that allowed the use of a strict
POSIX.2-only shell, especially if there were distributions who cared
about this.  But I find it hard to get excited about it, personally.  :-)

					- Ted
