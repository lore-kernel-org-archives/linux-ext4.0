From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: can we simplify the quota matrix in ext4?
Date: Tue, 21 Jun 2011 15:58:37 -0500
Message-ID: <4E0105FD.9090401@redhat.com>
References: <4E00E6DE.9060208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab1FUU6j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jun 2011 16:58:39 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5LKwdgU008085
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jun 2011 16:58:39 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p5LKwbGo000828
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jun 2011 16:58:38 -0400
In-Reply-To: <4E00E6DE.9060208@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/21/11 1:45 PM, Eric Sandeen wrote:
> I was looking at 
> 
> 62d2b5f2dcd3707b070efb16bbfdf6947c38c194 ext4: Always journal quota file modifications
> 
> and was thinking - if we always journal, why do we still have all the mount options etc for journaled quota?
> 
> I guess without -o usrjquota=foo we don't journal right from mount time, and there are a few other paths that get skipped, but those seem like details...
> 
> It seems that ideally - and perhaps this is hindsight - ext4 should have defaulted to journaled, QFMT_VFS_V1 quotas only... is there any reason not to?
> 
> I'm still not very well versed in vfs quota, but does it seem possible to move in this direction?  It seems odd that we should still be supporting unjournaled, vfsold-format quotas in ext4 these days.  What's the point?
> 
> If it seems possible to move in this direction within the exiting quota framework I'd be interested in trying to get it done.

I was hoping that perhaps newer quota tools would only write newer quota formats to a fresh filesystem, and that would make things simpler, since only newer quota tools can understand ext4 in any case.

Sadly, no: "quotacheck -F vfsold" will happily write the old format quota file on an ext4 filesystem, even if that's not the default it'd choose.

So I guess a deprecation period would need to be endured on the formats.

And without knowing the format in use, we can't know the quota filename(?) so we can't do journaled quota on mount, either, I think, at least without the -o jqfmt=blah?  Unless we look up both quota.user and aquota.user?  But what if both are there?  Bleah.

-Eric

> Thanks,
> -Eric
