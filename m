From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH -V2 4/5] ext4: Use both hi and lo bits of the group desc
 values.
Date: Fri, 21 Nov 2008 11:29:49 -0600
Message-ID: <4926F00D.6030403@redhat.com>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:36289 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbYKURaN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Nov 2008 12:30:13 -0500
In-Reply-To: <1227285875-18011-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> Rename the lower bits with suffix _lo and add helper
> to access the values. Also rename bg_itable_unused_hi
> to bg_pad as in e2fsprogs. bg_itable_unused_hi is never
> used before

Maybe you can add info about under which circumstances (what sort of
fielsystem geometry) the hi bits are needed?  And the failure mode when
we don't use them, if that's known?

Sorry, I'm being nitpicky about commitlogs today :)

-Eric
