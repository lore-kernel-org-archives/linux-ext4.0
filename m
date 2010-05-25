From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/2] ext4: Clear the EXT4_EOFBLOCKS_FL flag only when warranted
Date: Tue, 25 May 2010 17:19:01 +0400
Message-ID: <87bpc4ktkq.fsf@openvz.org>
References: <20100525041737.GB5556@thunk.org>
	<1274761117-26560-2-git-send-email-tytso@mit.edu>
	<87zkzola0r.fsf@openvz.org> <20100525130331.GC5556@thunk.org>
	<87fx1gktvf.fsf@openvz.org> <20100525131544.GE5556@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:25034 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab0EYNTI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 May 2010 09:19:08 -0400
Received: by fg-out-1718.google.com with SMTP id d23so2327401fga.1
        for <linux-ext4@vger.kernel.org>; Tue, 25 May 2010 06:19:05 -0700 (PDT)
In-Reply-To: <20100525131544.GE5556@thunk.org> (tytso@mit.edu's message of
	"Tue, 25 May 2010 09:15:44 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu writes:

> On Tue, May 25, 2010 at 05:12:36PM +0400, Dmitry Monakhov wrote:
>> Yes but changes was requested, so i've prepared new version.
>> I'll post it against Jan's xfsqa quota branch.
>
> Is there a reason you don't just base it against the xfstests mainline
> and send the patch directly to xfs@oss.sgi.com?  Your patch isn't
> related to quota or has any dependency on other changes that might be
> in Jan's branch, right?  Or am I missing something?
They are related because test number always increasing, and i want to
use the test to run with and w/o quota enabled.
