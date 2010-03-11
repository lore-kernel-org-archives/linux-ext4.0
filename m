From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/5] quota: Implement project id support for generic quota
Date: Thu, 11 Mar 2010 16:17:53 +0300
Message-ID: <87d3zbj8u6.fsf@openvz.org>
References: <1267727677-11956-1-git-send-email-dmonakhov@openvz.org>
	<1267727677-11956-2-git-send-email-dmonakhov@openvz.org>
	<1267727677-11956-3-git-send-email-dmonakhov@openvz.org>
	<20100311120334.GB4706@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:59229 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab0CKNR6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Mar 2010 08:17:58 -0500
In-Reply-To: <20100311120334.GB4706@infradead.org> (Christoph Hellwig's
	message of "Thu, 11 Mar 2010 07:03:34 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Christoph Hellwig <hch@infradead.org> writes:

> On Thu, Mar 04, 2010 at 09:34:34PM +0300, Dmitry Monakhov wrote:
>>  		case GRPQUOTA:
>>  			return in_group_p(dquot->dq_id);
>> +		case PRJQUOTA:
>> +			/* XXX: Currently there is no way to understand
>> +			   which project_id this task belonges to, So print
>> +			   a warn message unconditionally. -dmon */
>> +			return 1;
>
> Note that this is different from the XFS behaviour, which neve warns
> for project quota.  In fact project quota in XFS traditionally doesn't
> even return EDQUOT but ENOSPC instead, as it's not a traditional quota
> mechanism but filesystem containerization.
Yes, i know, but imho it is better to return true EDQUOT to understand
what is really happen.
>
> Otherwise the patch looks good except for the ifdef mess already comment
> on in the previous patch.
