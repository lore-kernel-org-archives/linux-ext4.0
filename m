From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] default max mount count to unused
Date: Fri, 22 Jan 2010 11:42:38 -0600
Message-ID: <4B59E38E.906@redhat.com>
References: <4B5785A5.2010505@redhat.com> <F348497E-C9B1-49D3-920B-5AF98CBDDD98@sun.com> <20100122013735.GB21263@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Bill Nottingham <notting@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>,
	LVM Mailing List <linux-lvm@redhat.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383Ab0AVRmt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jan 2010 12:42:49 -0500
In-Reply-To: <20100122013735.GB21263@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu wrote:
> On Thu, Jan 21, 2010 at 05:22:55PM -0700, Andreas Dilger wrote:
>> Alasdair, any chance you can include this script into the LVM package?
>>
>> Ted, this should really be added to e2fsprogs, and the e2croncheck
>> script removed.  The existing e2croncheck script is broken in a
>> number of ways (e.g. the force check timestamp 19000101 is invalid,
>> the email reporting doesn't work because "$RPT-EMAIL" is never set)
>> and is less functional in other ways (it doesn't remove stale
>> snapshots in case of an interrupted script, it doesn't check
>> multiple LVs, etc).
> 
> Sure, I'd be happy to include this to e2fsprogs.  I'm not sure which
> distro package should be installing it, but we can leave that up to
> the distro maintainers.
> 
> 					- Ted


Last time around, we all seemed to think it should be in the lvm
tools (though I don't remember exactly why - probably because it's
really not ext*-specific at all)

It got forwarded to the LVM list, agk asked if anyone wanted to
clean it up & take ownership of it, and that was the end.  :(

-Eric
