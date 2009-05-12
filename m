From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 3/3] vfs: Add BUG_ON for delayed and unwritten	extentsin
 submit_bh
Date: Tue, 12 May 2009 08:25:30 -0500
Message-ID: <4A0978CA.4040904@redhat.com>
References: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1241692770-22547-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1241692770-22547-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090512031709.GJ21518@mit.edu> <20090512045210.GC6753@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:36980 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbZELNZt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 May 2009 09:25:49 -0400
In-Reply-To: <20090512045210.GC6753@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Mon, May 11, 2009 at 11:17:09PM -0400, Theodore Tso wrote:
>> On Thu, May 07, 2009 at 04:09:30PM +0530, Aneesh Kumar K.V wrote:
>>> We should not do submit_bh for delayed and unwritten extents. So
>>> add a BUG_ON on them.
>> Hmm, maybe we should add a BUG_ON(buffer_new(bh)) here to?  That flag
>> should never leak out to submit_bh as well, right?
>>
> 
> Yes . But since BH_New is used by all the filesystems we need to
> verify them and make sure other filesystems gets it right. IIUC BH_Delay and
> BH_Unwritten are only used by ext4, xfs and btrfs
> 
> -aneesh

I have confirmed that xfs won't care what we do in submit_bh... so
BUG_ONs here related to delay/unwritten won't worry xfs.

-Eric
