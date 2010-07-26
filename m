From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 4/8] Add test of quota accounting using fsx
Date: Mon, 26 Jul 2010 16:46:17 -0500
Message-ID: <4C4E0229.5040002@sandeen.net>
References: <1274710459-11446-1-git-send-email-jack@suse.cz>	<1274710459-11446-5-git-send-email-jack@suse.cz>	<4C0FD43D.3040803@sandeen.net> <20100615095505.GB3347@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: hch@infradead.org, xfs@oss.sgi.com,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab0GZVqj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Jul 2010 17:46:39 -0400
In-Reply-To: <20100615095505.GB3347@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/15/2010 04:55 AM, Jan Kara wrote:
> On Wed 09-06-10 12:49:49, Eric Sandeen wrote:
>> Jan Kara wrote:
>>> Run fsx (and also several fsx threads in parallel) and verify that
>>> quota accounting is correct after they finish.
>>
>> Jan, I'm having trouble with this one on XFS for some reason, with our 
>> RHEL6 kernel and quota-3.17...
>   OK, attached is an improvement to the XFSQA tests after which all quota
> tests pass for XFS just fine.
>   The second patch is just minor general improvement of _require_scratch
> macro.
>   Could they be added to XFSQA repository? Thanks.

Jan, I've got some ext4 failures reported on these, although I can't hit
them, so not quite sure what's going on.

In 231:

+< fsgqa     --     760       0       0              3     0     0
+---
+> fsgqa     --     764       0       0              3     0     0
+14c14
+< fsgqa     --     760       0       0              3     0     0
+---
+> fsgqa     --     764       0       0              3     0     0

after the quotacheck & repquota we have 4 more blocks.  Maybe this
is due to my accounting of metadata blocks at write time, and not
before ... would it be reasonable to put a sync call as the first
line of check_usage() ?

Also in 233:

+< #501      --   15392       0       0            998     0     0
+< #501      --   15392   32000   32000            998  1000  1000
+---
+> #501      +-   32084   32000   32000  7days     998  1000  1000
+> #501      --   32084       0       0            998     0     0

"7days" magically appeared after the quotacheck.  Not sure what's going
on there...

Thanks,
-Eric
