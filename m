From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsck: don't check/clone duplicate xattr blocks in fs
 without xattr feature
Date: Mon, 23 May 2011 12:52:10 -0500
Message-ID: <4DDA9ECA.8000708@redhat.com>
References: <4D52DFE7.4050301@redhat.com> <4D77EAAC.3010208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462Ab1EWRwM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 May 2011 13:52:12 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p4NHqB4U008805
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 23 May 2011 13:52:11 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p4NHqAnd030445
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 23 May 2011 13:52:11 -0400
In-Reply-To: <4D77EAAC.3010208@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/9/11 3:01 PM, Eric Sandeen wrote:
> On 2/9/11 12:41 PM, Eric Sandeen wrote:
>> I had an extremely corrupted customer filesystem which, after thousands
>> of lines of e2fsck output, found one more problem on an immediately
>> subsequent e2fsck.  In short, a file had had its i_file_acl block
>> cloned due to being a duplicate.  That ultimately got cleared
>> because the fs did not have the xattr feature, and the inode
>> was subsequently removed due to invalid mode.
>>
>> The 2nd e2fsck pass found the cloned xattr block as in use, but
>> not owned by any file, and had to fix up the block bitmaps.
>>
>> Simply skipping the processing of duplicate xattr blocks on a
>> non-xattr filesystem seems reasonable, since they will be cleared
>> later in any case.
>>
>> (also fix existing brace misalignment)
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Ted, ping on this one?  Would like to get it upstream before
> pushing it to RHEL, because as we all know now, that's how
> we roll at Red Hat.  :)

Ping again, for review and/or merge of this one, it's approaching 4 months old now...

Thanks,
-Eric
